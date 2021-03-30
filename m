Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55742C433C1
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 15:29:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DF146196A
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 15:29:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbhC3P22 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 11:28:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232101AbhC3P2M (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 11:28:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC9CD6187E;
        Tue, 30 Mar 2021 15:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617118092;
        bh=q7pMrc2J4D6HiMGJUmEOpxvGhlQS059mx/xBxD9ou2M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IyuK5aFPg9IWIgo2XktrIeBCgi3srVn+XlEBcG+qyR+7AZpK6iUz8ZGcnsKXGhy1/
         QB/g9q7bs6nSfa2auIYjy63GP4I+vCLaLzWdGcDm2ShKdB77bT0Nl37LYdYesJssxJ
         /Zqr7QsnmtdGCKv8ZiNlOawHlKZnVRdI6Kgk6DFgBHnzVHpELdtmHnTRgV1/5VGvpo
         NJzp+zMYG1Ide+SQ4Rgh5N8dMCSDrr1TSUI+1wLJ1VmbFZQvqvzUM6WUQsj7fMvrsJ
         WxIJqh8N8j1eME1YCWZfK/9MYOGDD53D3WL2V/5zTiAAi5cngUrWqQ9tpe4NrvRW6J
         SbdpQdKwnzFVg==
Date:   Tue, 30 Mar 2021 08:28:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/20] xfs: remove the di_dmevmask and di_dmstate fields
 from struct xfs_icdinode
Message-ID: <20210330152811.GQ4090233@magnolia>
References: <20210329053829.1851318-1-hch@lst.de>
 <20210329053829.1851318-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329053829.1851318-6-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 29, 2021 at 07:38:14AM +0200, Christoph Hellwig wrote:
> The legacy DMAPI fields were never set by upstream Linux XFS, and have no
> way to be read using the kernel APIs.  So instead of bloating the in-core
> inode for them just copy them from the on-disk inode into the log when
> logging the inode.  The only caveat is that we need to make sure to zero
> the fields for newly read or deleted inodes, which is solved using a new
> flag in the inode.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Do you want to put dmevmask/dmstate preservation on the deprecated list
too, seeing as the only (out of tree) user wrote in on the last
submission to say that they're not supporting it past 2022 and have
never supported mounting those XFSes with upstream kernels?

Granted, the difficulty there is how do you deprecate something that
isn't there? 8)

Anyway this series got through the first and second rounds of fstesting
so I guess it's good to go.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c |  7 +++----
>  fs/xfs/libxfs/xfs_inode_buf.h |  2 --
>  fs/xfs/xfs_inode.c            |  5 ++---
>  fs/xfs/xfs_inode.h            |  1 +
>  fs/xfs/xfs_inode_item.c       | 31 +++++++++++++++++++++++++++++--
>  fs/xfs/xfs_log_recover.c      |  6 ------
>  6 files changed, 35 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index af5ee8bd7e6ac9..917a41828ffbe3 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -230,10 +230,11 @@ xfs_inode_from_disk(
>  	to->di_nblocks = be64_to_cpu(from->di_nblocks);
>  	to->di_extsize = be32_to_cpu(from->di_extsize);
>  	to->di_forkoff = from->di_forkoff;
> -	to->di_dmevmask	= be32_to_cpu(from->di_dmevmask);
> -	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
>  	to->di_flags	= be16_to_cpu(from->di_flags);
>  
> +	if (from->di_dmevmask || from->di_dmstate)
> +		xfs_iflags_set(ip, XFS_IPRESERVE_DM_FIELDS);
> +
>  	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
>  		inode_set_iversion_queried(inode,
>  					   be64_to_cpu(from->di_changecount));
> @@ -311,8 +312,6 @@ xfs_inode_to_disk(
>  	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
>  	to->di_forkoff = from->di_forkoff;
>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
> -	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
> -	to->di_dmstate = cpu_to_be16(from->di_dmstate);
>  	to->di_flags = cpu_to_be16(from->di_flags);
>  
>  	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index b3097ea8b53366..d7a019df05d647 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -22,8 +22,6 @@ struct xfs_icdinode {
>  	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
>  	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
>  	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
> -	uint32_t	di_dmevmask;	/* DMIG event mask */
> -	uint16_t	di_dmstate;	/* DMIG state info */
>  	uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
>  
>  	uint64_t	di_flags2;	/* more random flags */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 8c164fe621548b..9c8fd11a53622a 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -840,8 +840,6 @@ xfs_init_new_inode(
>  	inode->i_ctime = tv;
>  
>  	ip->i_d.di_extsize = 0;
> -	ip->i_d.di_dmevmask = 0;
> -	ip->i_d.di_dmstate = 0;
>  	ip->i_d.di_flags = 0;
>  
>  	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
> @@ -2615,9 +2613,10 @@ xfs_ifree(
>  	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
>  	ip->i_d.di_flags = 0;
>  	ip->i_d.di_flags2 = ip->i_mount->m_ino_geo.new_diflags2;
> -	ip->i_d.di_dmevmask = 0;
>  	ip->i_d.di_forkoff = 0;		/* mark the attr fork not in use */
>  	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
> +	if (xfs_iflags_test(ip, XFS_IPRESERVE_DM_FIELDS))
> +		xfs_iflags_clear(ip, XFS_IPRESERVE_DM_FIELDS);
>  
>  	/* Don't attempt to replay owner changes for a deleted inode */
>  	spin_lock(&iip->ili_lock);
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 13f4cd2e1f4fc5..d3369c0bcd9de7 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -220,6 +220,7 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
>  #define XFS_IRECLAIM		(1 << 0) /* started reclaiming this inode */
>  #define XFS_ISTALE		(1 << 1) /* inode has been staled */
>  #define XFS_IRECLAIMABLE	(1 << 2) /* inode can be reclaimed */
> +#define XFS_IPRESERVE_DM_FIELDS	(1 << 4) /* has legacy DMAPI fields set */
>  #define __XFS_INEW_BIT		3	 /* inode has just been allocated */
>  #define XFS_INEW		(1 << __XFS_INEW_BIT)
>  #define XFS_ITRUNCATED		(1 << 5) /* truncated down so flush-on-close */
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 17e20a6d8b4e27..16e758a689217e 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -317,6 +317,33 @@ xfs_inode_to_log_dinode_ts(
>  	return its;
>  }
>  
> +/*
> + * The legacy DMAPI fields are only present in the on-disk and in-log inodes,
> + * but not in the in-memory one.  But we are guaranteed to have an inode buffer
> + * in memory when logging an inode, so we can just copy it from the on-disk
> + * inode to the in-log inode here so that recovery of file system with these
> + * fields set to non-zero values doesn't lose them.  For all other cases we zero
> + * the fields.
> + */
> +static void
> +xfs_copy_dm_fields_to_log_dinode(
> +	struct xfs_inode	*ip,
> +	struct xfs_log_dinode	*to)
> +{
> +	struct xfs_dinode	*dip;
> +
> +	dip = xfs_buf_offset(ip->i_itemp->ili_item.li_buf,
> +			     ip->i_imap.im_boffset);
> +
> +	if (xfs_iflags_test(ip, XFS_IPRESERVE_DM_FIELDS)) {
> +		to->di_dmevmask = be32_to_cpu(dip->di_dmevmask);
> +		to->di_dmstate = be16_to_cpu(dip->di_dmstate);
> +	} else {
> +		to->di_dmevmask = 0;
> +		to->di_dmstate = 0;
> +	}
> +}
> +
>  static void
>  xfs_inode_to_log_dinode(
>  	struct xfs_inode	*ip,
> @@ -349,10 +376,10 @@ xfs_inode_to_log_dinode(
>  	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
>  	to->di_forkoff = from->di_forkoff;
>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
> -	to->di_dmevmask = from->di_dmevmask;
> -	to->di_dmstate = from->di_dmstate;
>  	to->di_flags = from->di_flags;
>  
> +	xfs_copy_dm_fields_to_log_dinode(ip, to);
> +
>  	/* log a dummy value to ensure log structure is fully initialised */
>  	to->di_next_unlinked = NULLAGINO;
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 42a8c7da492aa8..e5dd1c0c2f03c4 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2696,12 +2696,6 @@ xlog_recover_process_one_iunlink(
>  	agino = be32_to_cpu(dip->di_next_unlinked);
>  	xfs_buf_relse(ibp);
>  
> -	/*
> -	 * Prevent any DMAPI event from being sent when the reference on
> -	 * the inode is dropped.
> -	 */
> -	ip->i_d.di_dmevmask = 0;
> -
>  	xfs_irele(ip);
>  	return agino;
>  
> -- 
> 2.30.1
> 
