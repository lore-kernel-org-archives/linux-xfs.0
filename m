Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Apr 2008 01:24:32 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m378NEwp021312
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 01:23:15 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6721A94CEA9
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2008 01:23:47 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id PkKytF5rSRz8ZDVb for <xfs@oss.sgi.com>; Mon, 07 Apr 2008 01:23:47 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m377u6F3002559
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 09:56:06 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m377u6pI002557
	for xfs@oss.sgi.com; Mon, 7 Apr 2008 09:56:06 +0200
Date: Mon, 7 Apr 2008 09:56:06 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/3] split xfs_icsb_sync_counters_flags
Message-ID: <20080407075606.GA2317@lst.de>
References: <20080319204501.GB23644@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080319204501.GB23644@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

ping?  (for the whole patch series)

On Wed, Mar 19, 2008 at 09:45:01PM +0100, Christoph Hellwig wrote:
> Add a new xfs_icsb_sync_counters_locked for the case where m_sb_lock
> is already taken and add a flags argument to xfs_icsb_sync_counters so
> that xfs_icsb_sync_counters_flags is not needed.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/xfs_fsops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_fsops.c	2008-02-22 04:44:13.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/xfs_fsops.c	2008-03-04 18:26:19.000000000 +0100
> @@ -462,7 +462,7 @@ xfs_fs_counts(
>  	xfs_mount_t		*mp,
>  	xfs_fsop_counts_t	*cnt)
>  {
> -	xfs_icsb_sync_counters_flags(mp, XFS_ICSB_LAZY_COUNT);
> +	xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
>  	spin_lock(&mp->m_sb_lock);
>  	cnt->freedata = mp->m_sb.sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
>  	cnt->freertx = mp->m_sb.sb_frextents;
> @@ -524,7 +524,7 @@ xfs_reserve_blocks(
>  	 */
>  retry:
>  	spin_lock(&mp->m_sb_lock);
> -	xfs_icsb_sync_counters_flags(mp, XFS_ICSB_SB_LOCKED);
> +	xfs_icsb_sync_counters_locked(mp, 0);
>  
>  	/*
>  	 * If our previous reservation was larger than the current value,
> Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2008-03-03 16:12:34.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2008-03-04 18:26:19.000000000 +0100
> @@ -54,7 +54,6 @@ STATIC void	xfs_unmountfs_wait(xfs_mount
>  STATIC void	xfs_icsb_destroy_counters(xfs_mount_t *);
>  STATIC void	xfs_icsb_balance_counter(xfs_mount_t *, xfs_sb_field_t,
>  						int, int);
> -STATIC void	xfs_icsb_sync_counters(xfs_mount_t *);
>  STATIC int	xfs_icsb_modify_counters(xfs_mount_t *, xfs_sb_field_t,
>  						int64_t, int);
>  STATIC int	xfs_icsb_disable_counter(xfs_mount_t *, xfs_sb_field_t);
> @@ -63,7 +62,6 @@ STATIC int	xfs_icsb_disable_counter(xfs_
>  
>  #define xfs_icsb_destroy_counters(mp)			do { } while (0)
>  #define xfs_icsb_balance_counter(mp, a, b, c)		do { } while (0)
> -#define xfs_icsb_sync_counters(mp)			do { } while (0)
>  #define xfs_icsb_modify_counters(mp, a, b, c)		do { } while (0)
>  
>  #endif
> @@ -1374,7 +1372,7 @@ xfs_log_sbcount(
>  	if (!xfs_fs_writable(mp))
>  		return 0;
>  
> -	xfs_icsb_sync_counters(mp);
> +	xfs_icsb_sync_counters(mp, 0);
>  
>  	/*
>  	 * we don't need to do this if we are updating the superblock
> @@ -2252,38 +2250,33 @@ xfs_icsb_enable_counter(
>  }
>  
>  void
> -xfs_icsb_sync_counters_flags(
> +xfs_icsb_sync_counters_locked(
>  	xfs_mount_t	*mp,
>  	int		flags)
>  {
>  	xfs_icsb_cnts_t	cnt;
>  
> -	/* Pass 1: lock all counters */
> -	if ((flags & XFS_ICSB_SB_LOCKED) == 0)
> -		spin_lock(&mp->m_sb_lock);
> -
>  	xfs_icsb_count(mp, &cnt, flags);
>  
> -	/* Step 3: update mp->m_sb fields */
>  	if (!xfs_icsb_counter_disabled(mp, XFS_SBS_ICOUNT))
>  		mp->m_sb.sb_icount = cnt.icsb_icount;
>  	if (!xfs_icsb_counter_disabled(mp, XFS_SBS_IFREE))
>  		mp->m_sb.sb_ifree = cnt.icsb_ifree;
>  	if (!xfs_icsb_counter_disabled(mp, XFS_SBS_FDBLOCKS))
>  		mp->m_sb.sb_fdblocks = cnt.icsb_fdblocks;
> -
> -	if ((flags & XFS_ICSB_SB_LOCKED) == 0)
> -		spin_unlock(&mp->m_sb_lock);
>  }
>  
>  /*
>   * Accurate update of per-cpu counters to incore superblock
>   */
> -STATIC void
> +void
>  xfs_icsb_sync_counters(
> -	xfs_mount_t	*mp)
> +	xfs_mount_t	*mp,
> +	int		flags)
>  {
> -	xfs_icsb_sync_counters_flags(mp, 0);
> +	spin_lock(&mp->m_sb_lock);
> +	xfs_icsb_sync_counters_locked(mp, flags);
> +	spin_unlock(&mp->m_sb_lock);
>  }
>  
>  /*
> Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2008-03-03 16:12:34.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2008-03-04 18:26:19.000000000 +0100
> @@ -211,12 +211,13 @@ typedef struct xfs_icsb_cnts {
>  
>  extern int	xfs_icsb_init_counters(struct xfs_mount *);
>  extern void	xfs_icsb_reinit_counters(struct xfs_mount *);
> -extern void	xfs_icsb_sync_counters_flags(struct xfs_mount *, int);
> +extern void	xfs_icsb_sync_counters(struct xfs_mount *, int);
> +extern void	xfs_icsb_sync_counters_locked(struct xfs_mount *, int);
>  
>  #else
>  #define xfs_icsb_init_counters(mp)	(0)
>  #define xfs_icsb_reinit_counters(mp)	do { } while (0)
> -#define xfs_icsb_sync_counters_flags(mp, flags)	do { } while (0)
> +#define xfs_icsb_sync_counters(mp, flags)	do { } while (0)
>  #endif
>  
>  typedef struct xfs_ail {
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-03-03 04:57:21.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-03-04 18:26:19.000000000 +0100
> @@ -1182,7 +1182,7 @@ xfs_fs_statfs(
>  	statp->f_fsid.val[0] = (u32)id;
>  	statp->f_fsid.val[1] = (u32)(id >> 32);
>  
> -	xfs_icsb_sync_counters_flags(mp, XFS_ICSB_LAZY_COUNT);
> +	xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
>  
>  	spin_lock(&mp->m_sb_lock);
>  	statp->f_bsize = sbp->sb_blocksize;
---end quoted text---
