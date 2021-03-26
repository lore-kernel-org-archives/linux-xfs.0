Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2BC1C433C1
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 06:49:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAAE861A3F
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 06:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhCZGsz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Mar 2021 02:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhCZGsg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Mar 2021 02:48:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D80C0613AA
        for <linux-xfs@vger.kernel.org>; Thu, 25 Mar 2021 23:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1iFexuTb85eRcd7SLKhYKxUhWQJ6OxpgSTqLfIcg9pY=; b=oVjV1JOfJQvLwRH81VdaD27Jy5
        P+mReRYx0W7Hd/ES2xmdR047JkNZ+AS64kS0xWQp9fih2HnV5bhZOQ0+bJEBUb2tdnhVT3YD1SK+d
        w/nEJJidSgryQ7neaI95rzSERwYFLvBVsxElmaP0/gW9yxDhIB3Z4V8kcW6dXzs+8p2v+JbGxnO8X
        QADMdnHMz0dXdo0t01XH2qHVUDFubnP80XZFZ2KUOVg7giWD7lubm/oIsDIl6fqczFCe8UM5DGoXh
        itbgW2QkHhU194aG7+OO4bs7yD1c3kIthZMg15T3RMRnspfbjwuzhCs+zncZlzLNhKSOFgsw/2Ess
        u5pTmN2w==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lPgGP-00EPxs-CF; Fri, 26 Mar 2021 06:48:12 +0000
Date:   Fri, 26 Mar 2021 06:48:09 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 6/6] xfs: refactor per-AG inode tagging functions
Message-ID: <20210326064809.GG3421955@infradead.org>
References: <161671807287.621936.13471099564526590235.stgit@magnolia>
 <161671810634.621936.14531357513724748267.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161671810634.621936.14531357513724748267.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 25, 2021 at 05:21:46PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In preparation for adding another incore inode tree tag, refactor the
> code that sets and clears tags from the per-AG inode tree and the tree
> of per-AG structures, and remove the open-coded versions used by the
> blockgc code.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_icache.c |  127 ++++++++++++++++++++++++---------------------------
>  fs/xfs/xfs_icache.h |    2 -
>  fs/xfs/xfs_super.c  |    2 -
>  fs/xfs/xfs_trace.h  |    6 +-
>  4 files changed, 65 insertions(+), 72 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 2b25fe679b0e..4c124bc98f39 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -29,6 +29,7 @@
>  /* Forward declarations to reduce indirect calls */
>  static int xfs_blockgc_scan_inode(struct xfs_inode *ip,
>  		struct xfs_eofblocks *eofb);
> +static inline void xfs_blockgc_queue(struct xfs_perag *pag);
>  static bool xfs_reclaim_inode_grab(struct xfs_inode *ip);
>  static void xfs_reclaim_inode(struct xfs_inode *ip, struct xfs_perag *pag);
>  
> @@ -163,46 +164,78 @@ xfs_reclaim_work_queue(
>  	rcu_read_unlock();
>  }
>  
> +/* Set a tag on both the AG incore inode tree and the AG radix tree. */
>  static void
> +xfs_perag_set_ici_tag(
> +	struct xfs_perag	*pag,
> +	xfs_agino_t		agino,
> +	unsigned int		tag)

Looking at the callers - I think the logic to lookup the pag and set the
inode flag should also go in here.  Currently only xfs_inode_destroy
nests i_Flags log inside the pag_ici_lock, but I don't see how that
would harm the xfs_blockgc_set_iflag case.  I suspect the unlocked
check in xfs_blockgc_set_iflag would harm in the reclaim case either.

>  void
> +xfs_inode_destroy(

I find this new name a little confusing.  What about
xfs_inode_mark_reclaimable?

But overall this new scheme looks nice to me.
