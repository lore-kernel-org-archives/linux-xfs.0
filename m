Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF125C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 06:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BACC64F40
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 06:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbhCSF7h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Mar 2021 01:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233818AbhCSF7a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Mar 2021 01:59:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4E6C06174A
        for <linux-xfs@vger.kernel.org>; Thu, 18 Mar 2021 22:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NGWM77YjheC6XyIhVm1NW5GWOYqamHggoxBh77pDYNs=; b=P0S2TUtIamTnmULIkNVCXGV+yr
        zytH4kADPEOceCQ4e0uSEXStEvpk3KqjTzDS0xI+rvwuQzcPg3foJtkv2mFjxjvt3kYFzSLtKVmq1
        srSY9WG+YImeQe5o2gOXH6ZRFxZDIyojDp3XRbP7kGzPJ1ZUSL6KFiPh/Zox3ly/IJVn1jfCLi38S
        4n6TLkUY4rcF65iLFCDNAbjBTngwU/MdOqbBg/6l17iHDX+OZjgmfEsdkq+L83y3WPZCMFo1x5P6x
        GdyeaX/9dW01xBIcAWVgiPxvFMLgx+fzXOtuIN1A3/DoAonxaML0/TiLTGFKTvJ5nChff2Qu0xf7l
        TAG/KgSw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lN8A7-0041CP-Tw; Fri, 19 Mar 2021 05:59:10 +0000
Date:   Fri, 19 Mar 2021 05:59:07 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/2] xfs: move the check for post-EOF mappings into
 xfs_can_free_eofblocks
Message-ID: <20210319055907.GB955126@infradead.org>
References: <161610680641.1887542.10509468263256161712.stgit@magnolia>
 <161610681767.1887542.5197301352012661570.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161610681767.1887542.5197301352012661570.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 18, 2021 at 03:33:37PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix the weird split of responsibilities between xfs_can_free_eofblocks
> and xfs_free_eofblocks by moving the chunk of code that looks for any
> actual post-EOF space mappings from the second function into the first.
> 
> This clears the way for deferred inode inactivation to be able to decide
> if an inode needs inactivation work before committing the released inode
> to the inactivation code paths (vs. marking it for reclaim).
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_bmap_util.c |  148 +++++++++++++++++++++++++-----------------------
>  1 file changed, 78 insertions(+), 70 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index e7d68318e6a5..d4ceba5370c7 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -597,8 +597,17 @@ xfs_bmap_punch_delalloc_range(
>   * regular files that are marked preallocated or append-only.
>   */
>  bool
> -xfs_can_free_eofblocks(struct xfs_inode *ip, bool force)
> +xfs_can_free_eofblocks(
> +	struct xfs_inode	*ip,
> +	bool			force)
>  {
> +	struct xfs_bmbt_irec	imap;
> +	struct xfs_mount	*mp = ip->i_mount;
> +	xfs_fileoff_t		end_fsb;
> +	xfs_fileoff_t		last_fsb;
> +	int			nimaps = 1;
> +	int			error;

Should we have an assert here that this is called under the iolock?
Or can't the reclaim be expressed nicely?

> +/*
> + * This is called to free any blocks beyond eof. The caller must hold
> + * IOLOCK_EXCL unless we are in the inode reclaim path and have the only
> + * reference to the inode.
> + */

Same thing here, usually asserts are better than comments..  That being
said can_free_eofblocks would benefit from at least a comment if the
assert doesn't work.

Otherwise this looks good.
