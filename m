Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA3B0C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 16:44:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8975A61963
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 16:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhCSQoY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Mar 2021 12:44:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230041AbhCSQnz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Mar 2021 12:43:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC2B161940;
        Fri, 19 Mar 2021 16:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616172234;
        bh=eo6HaL6jcO0lwF8a0K7vypkm/EAieEVH2jjWz2rs6tI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u8rUMCiHIklP7eBNZJWrR3P449F28aYHUUlRzQQF2W0CsMUgP6zN8AYAuuq06w0Aw
         xFJMutTwqZ8Vraxo/2qHx+DUroPuEqD7zzw4LmRRc9WM9QVi6fY9HxAifJCIqZtEGB
         upND7ZtCNgTALzcxyqX/fX3ujJ28KOQ0rsiUzCN1kGThT3GvFarusEOIEowVcv2mXZ
         jEytF3uOGH6dhnxziAcYhhpPZyoe/UMiuUDn1seWUoJ73is43jZ6JwhWt1s665q0fp
         dla38usED2M9XAyueTGIgRJRLz43b4TjJ1tDbwJpjvLzk2DF1zJrL7PQjmqp/9d9UO
         TvaJ9dSUVIbig==
Date:   Fri, 19 Mar 2021 09:43:54 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: remove tag parameter from xfs_inode_walk{,_ag}
Message-ID: <20210319164354.GQ22100@magnolia>
References: <161610681966.1887634.12780057277967410395.stgit@magnolia>
 <161610682523.1887634.9689710010549931486.stgit@magnolia>
 <20210319062501.GC955126@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319062501.GC955126@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 19, 2021 at 06:25:01AM +0000, Christoph Hellwig wrote:
> On Thu, Mar 18, 2021 at 03:33:45PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > It turns out that there is a 1:1 mapping between the execute and tag
> > parameters that are passed to xfs_inode_walk_ag:
> > 
> > 	xfs_dqrele_inode => XFS_ICI_NO_TAG
> > 	xfs_blockgc_scan_inode => XFS_ICI_BLOCKGC_TAG
> > 
> > The radix tree tags are an implementation detail of the inode cache,
> > which means that callers outside of xfs_icache.c have no business
> > passing in radix tree tags.  Since we're about to get rid of the
> > indirect calls in the BLOCKGC case, eliminate the extra argument in
> > favor of computing the ICI tag from the execute argument passed into the
> > function.
> 
> This seems backwards to me.  I'd rather deduce the function from the
> talk, which seems like a more sensible pattern.

Fair enough.

> That being said, the quota inode walk is a little different in that it
> doesn't use any tags, so switching it to a plain list_for_each_entry_safe
> on sb->s_inodes would seems more sensible, something like this untested
> patch:

Hmm, well, I look forward to hearing the results of your testing. :)

I /think/ this will work, since quotaoff doesn't touch inodes that can't
be igrabbed (i.e. their VFS state is gone), so walking sb->s_inodes
/should/ be the same.  The only thing I'm not sure about is that the vfs
removes the inode from the sb list before clear_inode sets I_FREEING
(to prevent further igrab), which /could/ introduce a behavioral change?
Though I think even if quotaoff ends up racing with evict_inodes, the
xfs_fs_destroy_inode call will inactivate the inode and drop the dquots
(before the next patchset) or queue the inode for inactivation and
detach the dquots.

One thing that occurs to me -- do the quota and rt metadata inodes end
up on the sb inode list?  The rt metadata inodes definitely contribute
to the root dquot's inode counts.

--D

> ---
> From 9ae07b6bf8c6b1337a627c8f0ad619c56511b343 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Fri, 19 Mar 2021 07:16:31 +0100
> Subject: xfs: use s_inodes in xfs_qm_dqrele_all_inodes
> 
> Using xfs_inode_walk in xfs_qm_dqrele_all_inodes is complete overkill,
> given that function simplify wants to iterate all live inodes known
> to the VFS.  Just iterate over the s_inodes list.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_qm_syscalls.c | 50 +++++++++++++++++++++++-----------------
>  1 file changed, 29 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 11f1e2fbf22f44..4e33919ed04b56 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -748,41 +748,27 @@ xfs_qm_scall_getquota_next(
>  	return error;
>  }
>  
> -STATIC int
> +static void
>  xfs_dqrele_inode(
>  	struct xfs_inode	*ip,
> -	void			*args)
> +	uint			flags)
>  {
> -	uint			*flags = args;
> -
> -	/* skip quota inodes */
> -	if (ip == ip->i_mount->m_quotainfo->qi_uquotaip ||
> -	    ip == ip->i_mount->m_quotainfo->qi_gquotaip ||
> -	    ip == ip->i_mount->m_quotainfo->qi_pquotaip) {
> -		ASSERT(ip->i_udquot == NULL);
> -		ASSERT(ip->i_gdquot == NULL);
> -		ASSERT(ip->i_pdquot == NULL);
> -		return 0;
> -	}
> -
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	if ((*flags & XFS_UQUOTA_ACCT) && ip->i_udquot) {
> +	if ((flags & XFS_UQUOTA_ACCT) && ip->i_udquot) {
>  		xfs_qm_dqrele(ip->i_udquot);
>  		ip->i_udquot = NULL;
>  	}
> -	if ((*flags & XFS_GQUOTA_ACCT) && ip->i_gdquot) {
> +	if ((flags & XFS_GQUOTA_ACCT) && ip->i_gdquot) {
>  		xfs_qm_dqrele(ip->i_gdquot);
>  		ip->i_gdquot = NULL;
>  	}
> -	if ((*flags & XFS_PQUOTA_ACCT) && ip->i_pdquot) {
> +	if ((flags & XFS_PQUOTA_ACCT) && ip->i_pdquot) {
>  		xfs_qm_dqrele(ip->i_pdquot);
>  		ip->i_pdquot = NULL;
>  	}
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -	return 0;
>  }
>  
> -
>  /*
>   * Go thru all the inodes in the file system, releasing their dquots.
>   *
> @@ -794,7 +780,29 @@ xfs_qm_dqrele_all_inodes(
>  	struct xfs_mount	*mp,
>  	uint			flags)
>  {
> +	struct super_block	*sb = mp->m_super;
> +	struct inode		*inode, *old_inode = NULL;
> +
>  	ASSERT(mp->m_quotainfo);
> -	xfs_inode_walk(mp, XFS_INODE_WALK_INEW_WAIT, xfs_dqrele_inode,
> -			&flags, XFS_ICI_NO_TAG);
> +
> +	spin_lock(&sb->s_inode_list_lock);
> +	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> +		struct xfs_inode	*ip = XFS_I(inode);
> +
> +		if (xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
> +			continue;
> +		if (!igrab(inode))
> +			continue;
> +		spin_unlock(&sb->s_inode_list_lock);
> +
> +		iput(old_inode);
> +		old_inode = inode;
> +
> +		xfs_dqrele_inode(ip, flags);
> +
> +		spin_lock(&sb->s_inode_list_lock);
> +	}
> +	spin_unlock(&sb->s_inode_list_lock);
> +
> +	iput(old_inode);
>  }
> -- 
> 2.30.1
> 
