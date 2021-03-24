Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DD65C433EC
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6952D61A23
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237714AbhCXSi7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:38:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237692AbhCXSiw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 14:38:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F0D161A1E;
        Wed, 24 Mar 2021 18:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616611132;
        bh=0ZBulXlzpCu5BhHJ255pVKWtwsWr8R/gH6AbblJI4/o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f81yIxqLzNgJ3v1E4xlrpFnp67H8IN+AUDFesM0RnS32mMlqJ2iDPuWj/puoCGarw
         EY7h85u7dEA4t3aQACb7ckemQBwpKmr4M0kKpqPElNPKnRNB/dQo8MZLLgRPRrSH0Y
         vz9GlC6G/4L+CWjU2MjmYW0Dj4tO/M1REkug6ub/kK+TDrySqTiA0nJwd/74Oqwjte
         R3cZrVnQuWUlMNX0tx1J96Qm3fna6cuLFNEWVXBvzu08jvf/sfTE345TMjKSmkCAaP
         Zq6S/0Ek5o0qAJHivsf1j1+tbftqHogLfx8V3uU/i2pTcwSz7WSngPxbr6KlhyLaeG
         3HGicOads/QPw==
Date:   Wed, 24 Mar 2021 11:38:51 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/18] xfs: move the di_crtime field to struct xfs_inode
Message-ID: <20210324183851.GR22100@magnolia>
References: <20210324142129.1011766-1-hch@lst.de>
 <20210324142129.1011766-19-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324142129.1011766-19-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 03:21:29PM +0100, Christoph Hellwig wrote:
> In preparation of removing the historic icinode struct, move the crtime
> field into the containing xfs_inode structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_format.h      |  5 ++---
>  fs/xfs/libxfs/xfs_inode_buf.c   |  6 ++----
>  fs/xfs/libxfs/xfs_inode_buf.h   | 10 ----------
>  fs/xfs/libxfs/xfs_trans_inode.c |  2 +-
>  fs/xfs/xfs_inode.c              |  2 +-
>  fs/xfs/xfs_inode.h              |  3 +--
>  fs/xfs/xfs_inode_item.c         |  3 +--
>  fs/xfs/xfs_iops.c               |  2 +-
>  fs/xfs/xfs_itable.c             |  7 ++-----
>  9 files changed, 11 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 630388b72dbe3f..c73378a4f8624d 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -955,9 +955,8 @@ static inline time64_t xfs_bigtime_to_unix(uint64_t ondisk_seconds)
>   * attribute use the XFS_DFORK_DPTR, XFS_DFORK_APTR, and XFS_DFORK_PTR macros
>   * below.
>   *
> - * There is a very similar struct icdinode in xfs_inode which matches the
> - * layout of the first 96 bytes of this structure, but is kept in native
> - * format instead of big endian.
> + * There is a very similar struct xfs_log_inode which matches the layout of the

struct xfs_log_dinode ?

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> + * this structure, but is kept in native format instead of big endian.
>   *
>   * Note: di_flushiter is only used by v1/2 inodes - it's effectively a zeroed
>   * padding field for v3 inodes.
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index f3df60e3452e1e..36d6d46be8e7d4 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -173,7 +173,6 @@ xfs_inode_from_disk(
>  	struct xfs_inode	*ip,
>  	struct xfs_dinode	*from)
>  {
> -	struct xfs_icdinode	*to = &ip->i_d;
>  	struct inode		*inode = VFS_I(ip);
>  	int			error;
>  	xfs_failaddr_t		fa;
> @@ -239,7 +238,7 @@ xfs_inode_from_disk(
>  	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
>  		inode_set_iversion_queried(inode,
>  					   be64_to_cpu(from->di_changecount));
> -		to->di_crtime = xfs_inode_from_disk_ts(from, from->di_crtime);
> +		ip->i_crtime = xfs_inode_from_disk_ts(from, from->di_crtime);
>  		ip->i_diflags2 = be64_to_cpu(from->di_flags2);
>  		ip->i_cowextsize = be32_to_cpu(from->di_cowextsize);
>  	}
> @@ -286,7 +285,6 @@ xfs_inode_to_disk(
>  	struct xfs_dinode	*to,
>  	xfs_lsn_t		lsn)
>  {
> -	struct xfs_icdinode	*from = &ip->i_d;
>  	struct inode		*inode = VFS_I(ip);
>  
>  	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
> @@ -318,7 +316,7 @@ xfs_inode_to_disk(
>  	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
>  		to->di_version = 3;
>  		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
> -		to->di_crtime = xfs_inode_to_disk_ts(ip, from->di_crtime);
> +		to->di_crtime = xfs_inode_to_disk_ts(ip, ip->i_crtime);
>  		to->di_flags2 = cpu_to_be64(ip->i_diflags2);
>  		to->di_cowextsize = cpu_to_be32(ip->i_cowextsize);
>  		to->di_ino = cpu_to_be64(ip->i_ino);
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 2f6015acfda81b..7f865bb4df840b 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -9,16 +9,6 @@
>  struct xfs_inode;
>  struct xfs_dinode;
>  
> -/*
> - * In memory representation of the XFS inode. This is held in the in-core struct
> - * xfs_inode and represents the current on disk values but the structure is not
> - * in on-disk format.  That is, this structure is always translated to on-disk
> - * format specific structures at the appropriate time.
> - */
> -struct xfs_icdinode {
> -	struct timespec64 di_crtime;	/* time created */
> -};
> -
>  /*
>   * Inode location information.  Stored in the inode and passed to
>   * xfs_imap_to_bp() to get a buffer and dinode for a given inode.
> diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> index 102920303454df..78324e043e2572 100644
> --- a/fs/xfs/libxfs/xfs_trans_inode.c
> +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> @@ -70,7 +70,7 @@ xfs_trans_ichgtime(
>  	if (flags & XFS_ICHGTIME_CHG)
>  		inode->i_ctime = tv;
>  	if (flags & XFS_ICHGTIME_CREATE)
> -		ip->i_d.di_crtime = tv;
> +		ip->i_crtime = tv;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 28d57353bdfa57..21765ddc329861 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -842,7 +842,7 @@ xfs_init_new_inode(
>  	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
>  		inode_set_iversion(inode, 1);
>  		ip->i_cowextsize = 0;
> -		ip->i_d.di_crtime = tv;
> +		ip->i_crtime = tv;
>  	}
>  
>  	flags = XFS_ILOG_CORE;
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 8fb87d3d98d174..767da7eaf696d0 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -66,8 +66,7 @@ typedef struct xfs_inode {
>  	uint8_t			i_forkoff;	/* attr fork offset >> 3 */
>  	uint16_t		i_diflags;	/* XFS_DIFLAG_... */
>  	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
> -
> -	struct xfs_icdinode	i_d;		/* most of ondisk inode */
> +	struct timespec64	i_crtime;	/* time created */
>  
>  	/* VFS inode */
>  	struct inode		i_vnode;	/* embedded VFS inode */
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 912c453b6fe46d..a79a3c52d105b0 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -350,7 +350,6 @@ xfs_inode_to_log_dinode(
>  	struct xfs_log_dinode	*to,
>  	xfs_lsn_t		lsn)
>  {
> -	struct xfs_icdinode	*from = &ip->i_d;
>  	struct inode		*inode = VFS_I(ip);
>  
>  	to->di_magic = XFS_DINODE_MAGIC;
> @@ -386,7 +385,7 @@ xfs_inode_to_log_dinode(
>  	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
>  		to->di_version = 3;
>  		to->di_changecount = inode_peek_iversion(inode);
> -		to->di_crtime = xfs_inode_to_log_dinode_ts(ip, from->di_crtime);
> +		to->di_crtime = xfs_inode_to_log_dinode_ts(ip, ip->i_crtime);
>  		to->di_flags2 = ip->i_diflags2;
>  		to->di_cowextsize = ip->i_cowextsize;
>  		to->di_ino = ip->i_ino;
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index df958611e854af..1bf4f37dc78806 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -567,7 +567,7 @@ xfs_vn_getattr(
>  	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
>  		if (request_mask & STATX_BTIME) {
>  			stat->result_mask |= STATX_BTIME;
> -			stat->btime = ip->i_d.di_crtime;
> +			stat->btime = ip->i_crtime;
>  		}
>  	}
>  
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 1f33f13d33a901..39a2352428626b 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -60,7 +60,6 @@ xfs_bulkstat_one_int(
>  	struct xfs_bstat_chunk	*bc)
>  {
>  	struct user_namespace	*sb_userns = mp->m_super->s_user_ns;
> -	struct xfs_icdinode	*dic;		/* dinode core info pointer */
>  	struct xfs_inode	*ip;		/* incore inode pointer */
>  	struct inode		*inode;
>  	struct xfs_bulkstat	*buf = bc->buf;
> @@ -81,8 +80,6 @@ xfs_bulkstat_one_int(
>  	ASSERT(ip->i_imap.im_blkno != 0);
>  	inode = VFS_I(ip);
>  
> -	dic = &ip->i_d;
> -
>  	/* xfs_iget returns the following without needing
>  	 * further change.
>  	 */
> @@ -111,8 +108,8 @@ xfs_bulkstat_one_int(
>  	buf->bs_version = XFS_BULKSTAT_VERSION_V5;
>  
>  	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
> -		buf->bs_btime = dic->di_crtime.tv_sec;
> -		buf->bs_btime_nsec = dic->di_crtime.tv_nsec;
> +		buf->bs_btime = ip->i_crtime.tv_sec;
> +		buf->bs_btime_nsec = ip->i_crtime.tv_nsec;
>  		if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
>  			buf->bs_cowextsize_blks = ip->i_cowextsize;
>  	}
> -- 
> 2.30.1
> 
