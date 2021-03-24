Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C6EDC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FFDB61A25
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237409AbhCXSSW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:18:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237176AbhCXSSA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 14:18:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACEA361A1E;
        Wed, 24 Mar 2021 18:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616609879;
        bh=QWO4q8PuEkCVm5/AKLZOsXNRQ8fMlsYgkvn3vTu/h/8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cmZKWZqckerGGkYSc0SBUw2XE0kjrbJ8gmWmvw5/qQXML/bCFuvr88FPc8mmqGnel
         13nAVL9hqVOhJavxDfYdHe9SVt5fl0qzgiPzkqqeAx2GDAJmQl/y1Dv95gAhLyhCgJ
         bKalwjNAbb00YsEA4CDeu2wMfPCQ1l0ixg15X1GtzubWW0ItXEYiR80hqs0t5BEBw+
         1wOAo7cdTj8IIN+VAJf52tX9fNLzfrvV2ZM6ai53sSKlqjuQQO6xxNaSyl14uBq9C5
         u+x8ZxwPGcg6motVX8eSne88cO3ITtnVmtO46+jg/daO4SYvrMzlgi+WvedmlFFtSR
         BTcOeL+ze9QBA==
Date:   Wed, 24 Mar 2021 11:17:59 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/18] xfs: remove the di_dmevmask and di_dmstate fields
 from struct xfs_icdinode
Message-ID: <20210324181429.GD22100@magnolia>
References: <20210324142129.1011766-1-hch@lst.de>
 <20210324142129.1011766-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324142129.1011766-6-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 03:21:16PM +0100, Christoph Hellwig wrote:
> The legacy DMAPI fields were never set by upstream Linux XFS, and have no
> way to be read using the kernel APIs.  So instead of bloating the in-core
> inode for them just copy them from the on-disk inode into the log when
> logging the inode.  The only caveat is that we need to make sure to zero
> the fields for newly read or deleted inodes, which is solved using a new
> flag in the inode.

How long ago /did/ non-upstream XFS have DMAPI support?  Does it still
have it now?  What's the cost of zeroing the fields?

(Really what I'm saying is that I have so little clue of what dmevmask
and dmstate do that I don't really know what Magic Smoke comes out if
these fields get zeroed by an upstream kernel.)

> Signed-off-by: Christoph Hellwig <hch@lst.de>
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
> index af5ee8bd7e6ac9..062157dcfdfcd3 100644
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
> +		xfs_iflags_set(ip, XFS_IDMAPI);

My prefix-happy brain sees this as IDMAP-I, not I-DMAPI.

ISAVEDMAPI?  No... I-SAVED-MAPI makes no sense...

I_PRESERVE_DMAPI?

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
> index 093689996f06f3..0954ad0d12ec48 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -839,8 +839,6 @@ xfs_init_new_inode(
>  	inode->i_ctime = tv;
>  
>  	ip->i_d.di_extsize = 0;
> -	ip->i_d.di_dmevmask = 0;
> -	ip->i_d.di_dmstate = 0;
>  	ip->i_d.di_flags = 0;
>  
>  	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
> @@ -2591,9 +2589,10 @@ xfs_ifree(
>  	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
>  	ip->i_d.di_flags = 0;
>  	ip->i_d.di_flags2 = ip->i_mount->m_ino_geo.new_diflags2;
> -	ip->i_d.di_dmevmask = 0;
>  	ip->i_d.di_forkoff = 0;		/* mark the attr fork not in use */
>  	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
> +	if (xfs_iflags_test(ip, XFS_IDMAPI))
> +		xfs_iflags_clear(ip, XFS_IDMAPI);
>  
>  	/* Don't attempt to replay owner changes for a deleted inode */
>  	spin_lock(&iip->ili_lock);
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 88ee4c3930ae70..e97957f5309281 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -212,6 +212,7 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
>  #define XFS_IRECLAIM		(1 << 0) /* started reclaiming this inode */
>  #define XFS_ISTALE		(1 << 1) /* inode has been staled */
>  #define XFS_IRECLAIMABLE	(1 << 2) /* inode can be reclaimed */
> +#define XFS_IDMAPI		(1 << 4) /* has legacy DMAPI fields set */
>  #define __XFS_INEW_BIT		3	 /* inode has just been allocated */
>  #define XFS_INEW		(1 << __XFS_INEW_BIT)
>  #define XFS_ITRUNCATED		(1 << 5) /* truncated down so flush-on-close */
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 17e20a6d8b4e27..4c3d1d829753b2 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -317,6 +317,33 @@ xfs_inode_to_log_dinode_ts(
>  	return its;
>  }
>  
> +/*
> + * The legacy DMAPI fields are only present in the on-disk and in-log inodes,
> + * but in the in-memory one.  But we are guaranteed to have an inode buffer in

"but not in" ?

--D

> + * memory when logging an inode, so we can just copy it from the on-disk inode
> + * to the in-log inode here so that recovery of file system with these fields
> + * set to non-zero values doesn't lose them.  For all other cases we zero the
> + * fields.
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
> +	if (xfs_iflags_test(ip, XFS_IDMAPI)) {
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
> index 31348e660cd65b..507c31f6b1a8be 100644
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
