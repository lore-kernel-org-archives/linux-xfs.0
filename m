Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F85DC4363D
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 07:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BF822072E
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 07:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgJBHSl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Oct 2020 03:18:41 -0400
Received: from verein.lst.de ([213.95.11.211]:51316 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbgJBHSk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Oct 2020 03:18:40 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3FC2067357; Fri,  2 Oct 2020 09:18:38 +0200 (CEST)
Date:   Fri, 2 Oct 2020 09:18:38 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de,
        bfoster@redhat.com
Subject: Re: [PATCH 3/5] xfs: proper replay of deferred ops queued during
 log recovery
Message-ID: <20201002071838.GB9900@lst.de>
References: <160140139198.830233.3093053332257853111.stgit@magnolia> <160140141157.830233.8230232141442784711.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160140141157.830233.8230232141442784711.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 29, 2020 at 10:43:31AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we replay unfinished intent items that have been recovered from the
> log, it's possible that the replay will cause the creation of more
> deferred work items.  As outlined in commit 509955823cc9c ("xfs: log
> recovery should replay deferred ops in order"), later work items have an
> implicit ordering dependency on earlier work items.  Therefore, recovery
> must replay the items (both recovered and created) in the same order
> that they would have been during normal operation.
> 
> For log recovery, we enforce this ordering by using an empty transaction
> to collect deferred ops that get created in the process of recovering a
> log intent item to prevent them from being committed before the rest of
> the recovered intent items.  After we finish committing all the
> recovered log items, we allocate a transaction with an enormous block
> reservation, splice our huge list of created deferred ops into that
> transaction, and commit it, thereby finishing all those ops.
> 
> This is /really/ hokey -- it's the one place in XFS where we allow
> nested transactions; the splicing of the defer ops list is is inelegant
> and has to be done twice per recovery function; and the broken way we
> handle inode pointers and block reservations cause subtle use-after-free
> and allocator problems that will be fixed by this patch and the two
> patches after it.
> 
> Therefore, replace the hokey empty transaction with a structure designed
> to capture each chain of deferred ops that are created as part of
> recovering a single unfinished log intent.  Finally, refactor the loop
> that replays those chains to do so using one transaction per chain.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c  |   89 +++++++++++++++++++++++++++++++--
>  fs/xfs/libxfs/xfs_defer.h  |   19 +++++++
>  fs/xfs/xfs_bmap_item.c     |   16 +-----
>  fs/xfs/xfs_extfree_item.c  |    7 +--
>  fs/xfs/xfs_log_recover.c   |  118 +++++++++++++++++++++++++-------------------
>  fs/xfs/xfs_refcount_item.c |   16 +-----
>  fs/xfs/xfs_rmap_item.c     |    7 +--
>  fs/xfs/xfs_trans.h         |    3 +
>  8 files changed, 184 insertions(+), 91 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 36c103c14bc9..85c371d29e8d 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -549,14 +549,89 @@ xfs_defer_move(
>   *
>   * Create and log intent items for all the work that we're capturing so that we
>   * can be assured that the items will get replayed if the system goes down
> - * before log recovery gets a chance to finish the work it put off.  Then we
> - * move the chain from stp to dtp.
> + * before log recovery gets a chance to finish the work it put off.  The entire
> + * deferred ops state is transferred to the capture structure and the
> + * transaction is then ready for the caller to commit it.  If there are no
> + * intent items to capture, this function returns NULL.
> + */
> +static struct xfs_defer_capture *
> +xfs_defer_ops_capture(
> +	struct xfs_trans		*tp)
> +{
> +	struct xfs_defer_capture	*dfc;
> +
> +	if (list_empty(&tp->t_dfops))
> +		return NULL;

Nit: keeping the list_empty check in the caller would seems more obvious
to me.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
