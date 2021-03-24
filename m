Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B6DC433C1
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CED3061A1E
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237511AbhCXSbx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:31:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237540AbhCXSbb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 14:31:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44DE4619B4;
        Wed, 24 Mar 2021 18:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616610691;
        bh=J+ZHyl5wQP8lfeWf5WtEdvjwEzhJG/Hhv2SGHhUVjJ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mZPIhnEepx572h1Q7wp7el36hyQ/k2QGbWc81La34FrxpNGwVRMlyfieSEo/gBalY
         1uBZE+BttOBp435rBkV+ucQHA81fci90p5j7+qeA8VADaXa3fspeI3t1cKXo39R5yO
         nWDelWD4QuyNd1D0rhNx1P7aMfApoJalNqhI1B1+zPupzt+tXgbD1aKYysZuaj4Nu2
         sjxRBETYSvrmlKP8gvAjIc9Qnbv0fcffodHdvSgqjVuBMxKJbWl/NvTbzMBTcTVlVh
         peIVjm/aTANsWs4umYjxuElQ/N0Uma2e2bZO6am/QHzo2uTSLhnoj9i5pO6pHEPhGx
         aGaymn0dgxFCQ==
Date:   Wed, 24 Mar 2021 11:31:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/18] xfs: move the di_cowextsize field to struct
 xfs_inode
Message-ID: <20210324183130.GJ22100@magnolia>
References: <20210324142129.1011766-1-hch@lst.de>
 <20210324142129.1011766-12-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324142129.1011766-12-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 03:21:22PM +0100, Christoph Hellwig wrote:
> In preparation of removing the historic icinode struct, move the
> cowextsize field into the containing xfs_inode structure.  Also
> switch to use the xfs_extlen_t instead of a uint32_t.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 4 ++--
>  fs/xfs/libxfs/xfs_inode_buf.h | 1 -
>  fs/xfs/xfs_file.c             | 2 +-
>  fs/xfs/xfs_inode.c            | 6 +++---
>  fs/xfs/xfs_inode.h            | 1 +
>  fs/xfs/xfs_inode_item.c       | 2 +-
>  fs/xfs/xfs_ioctl.c            | 8 +++-----
>  fs/xfs/xfs_itable.c           | 2 +-
>  fs/xfs/xfs_reflink.c          | 2 +-
>  9 files changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index fa21fb84c2d232..9f208d2c8ddb4d 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -240,7 +240,7 @@ xfs_inode_from_disk(
>  					   be64_to_cpu(from->di_changecount));
>  		to->di_crtime = xfs_inode_from_disk_ts(from, from->di_crtime);
>  		to->di_flags2 = be64_to_cpu(from->di_flags2);
> -		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
> +		ip->i_cowextsize = be32_to_cpu(from->di_cowextsize);
>  	}
>  
>  	error = xfs_iformat_data_fork(ip, from);
> @@ -319,7 +319,7 @@ xfs_inode_to_disk(
>  		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
>  		to->di_crtime = xfs_inode_to_disk_ts(ip, from->di_crtime);
>  		to->di_flags2 = cpu_to_be64(from->di_flags2);
> -		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
> +		to->di_cowextsize = cpu_to_be32(ip->i_cowextsize);
>  		to->di_ino = cpu_to_be64(ip->i_ino);
>  		to->di_lsn = cpu_to_be64(lsn);
>  		memset(to->di_pad2, 0, sizeof(to->di_pad2));
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 6bc78856373e31..77d250dbe96848 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -21,7 +21,6 @@ struct xfs_icdinode {
>  	uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
>  
>  	uint64_t	di_flags2;	/* more random flags */
> -	uint32_t	di_cowextsize;	/* basic cow extent size for file */
>  
>  	struct timespec64 di_crtime;	/* time created */
>  };
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 4c930078f45d82..d755fbf3640bee 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1162,7 +1162,7 @@ xfs_file_remap_range(
>  	    (src->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) &&
>  	    pos_out == 0 && len >= i_size_read(inode_out) &&
>  	    !(dest->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
> -		cowextsize = src->i_d.di_cowextsize;
> +		cowextsize = src->i_cowextsize;
>  
>  	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize,
>  			remap_flags);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index ccd179900f21cf..b8f38423f8c451 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -81,7 +81,7 @@ xfs_get_cowextsz_hint(
>  
>  	a = 0;
>  	if (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
> -		a = ip->i_d.di_cowextsize;
> +		a = ip->i_cowextsize;
>  	b = xfs_get_extsz_hint(ip);
>  
>  	a = max(a, b);
> @@ -754,7 +754,7 @@ xfs_inode_inherit_flags2(
>  {
>  	if (pip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
>  		ip->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
> -		ip->i_d.di_cowextsize = pip->i_d.di_cowextsize;
> +		ip->i_cowextsize = pip->i_cowextsize;
>  	}
>  	if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
>  		ip->i_d.di_flags2 |= XFS_DIFLAG2_DAX;
> @@ -843,7 +843,7 @@ xfs_init_new_inode(
>  
>  	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
>  		inode_set_iversion(inode, 1);
> -		ip->i_d.di_cowextsize = 0;
> +		ip->i_cowextsize = 0;
>  		ip->i_d.di_crtime = tv;
>  	}
>  
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 84cc2e74ba1961..36eb33d9bcbdcc 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -58,6 +58,7 @@ typedef struct xfs_inode {
>  	xfs_rfsblock_t		i_nblocks;	/* # of direct & btree blocks */
>  	uint32_t		i_projid;	/* owner's project id */
>  	xfs_extlen_t		i_extsize;	/* basic/minimum extent size */
> +	xfs_extlen_t		i_cowextsize;	/* basic cow extent size */
>  
>  	struct xfs_icdinode	i_d;		/* most of ondisk inode */
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 8a1411effd327d..44902fd513eb0b 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -388,7 +388,7 @@ xfs_inode_to_log_dinode(
>  		to->di_changecount = inode_peek_iversion(inode);
>  		to->di_crtime = xfs_inode_to_log_dinode_ts(ip, from->di_crtime);
>  		to->di_flags2 = from->di_flags2;
> -		to->di_cowextsize = from->di_cowextsize;
> +		to->di_cowextsize = ip->i_cowextsize;
>  		to->di_ino = ip->i_ino;
>  		to->di_lsn = lsn;
>  		memset(to->di_pad2, 0, sizeof(to->di_pad2));
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index ec769219e435e9..e45bce9b11082c 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1121,8 +1121,7 @@ xfs_fill_fsxattr(
>  
>  	simple_fill_fsxattr(fa, xfs_ip2xflags(ip));
>  	fa->fsx_extsize = ip->i_extsize << ip->i_mount->m_sb.sb_blocklog;
> -	fa->fsx_cowextsize = ip->i_d.di_cowextsize <<
> -			ip->i_mount->m_sb.sb_blocklog;
> +	fa->fsx_cowextsize = ip->i_cowextsize << ip->i_mount->m_sb.sb_blocklog;

/me wonders if you wouldn't mind converting these open coded shifts to
XFS_FSB_TO_B and XFS_B_TO_FSBT as a new patch at the end of this series?

This patch looks good to me, so
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


>  	fa->fsx_projid = ip->i_projid;
>  	if (ifp && (ifp->if_flags & XFS_IFEXTENTS))
>  		fa->fsx_nextents = xfs_iext_count(ifp);
> @@ -1524,10 +1523,9 @@ xfs_ioctl_setattr(
>  		ip->i_extsize = 0;
>  	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
>  	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
> -		ip->i_d.di_cowextsize = fa->fsx_cowextsize >>
> -				mp->m_sb.sb_blocklog;
> +		ip->i_cowextsize = fa->fsx_cowextsize >> mp->m_sb.sb_blocklog;
>  	else
> -		ip->i_d.di_cowextsize = 0;
> +		ip->i_cowextsize = 0;
>  
>  	error = xfs_trans_commit(tp);
>  
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index ce95cb1a9bc9f5..43f8a89c9786c7 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -114,7 +114,7 @@ xfs_bulkstat_one_int(
>  		buf->bs_btime = dic->di_crtime.tv_sec;
>  		buf->bs_btime_nsec = dic->di_crtime.tv_nsec;
>  		if (dic->di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
> -			buf->bs_cowextsize_blks = dic->di_cowextsize;
> +			buf->bs_cowextsize_blks = ip->i_cowextsize;
>  	}
>  
>  	switch (ip->i_df.if_format) {
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 306f13dfbfd856..d8735b3ee0f807 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -934,7 +934,7 @@ xfs_reflink_update_dest(
>  	}
>  
>  	if (cowextsize) {
> -		dest->i_d.di_cowextsize = cowextsize;
> +		dest->i_cowextsize = cowextsize;
>  		dest->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
>  	}
>  
> -- 
> 2.30.1
> 
