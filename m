Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5ED3429DFD
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 09:14:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 58D138F8066
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 07:14:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XsGQTN8vi9VIkRLC for
	<xfs@oss.sgi.com>; Tue, 17 Jun 2014 07:14:36 -0700 (PDT)
Date: Tue, 17 Jun 2014 10:14:31 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: require 64-bit sector_t
Message-ID: <20140617141431.GA8905@bfoster.bfoster>
References: <1402937045-31103-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1402937045-31103-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Mon, Jun 16, 2014 at 06:44:05PM +0200, Christoph Hellwig wrote:
> Trying to support tiny disks only and saving a bit memory might have
> made sense on an SGI O2 15 years ago, but is pretty pointless today.
> 
> Remove the rarely tested codepath that uses various smaller in-memory
> types to reduce our test matrix and make the codebase a little bit
> smaller and less complicated.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Ben Myers <bpm@sgi.com>
> ---
>  fs/xfs/Kconfig          |    1 +
>  fs/xfs/xfs_bmap.c       |    8 ++---
>  fs/xfs/xfs_bmap_btree.c |   89 +++--------------------------------------------
>  fs/xfs/xfs_bmap_util.c  |    2 +-
>  fs/xfs/xfs_btree.c      |   32 ++++++++---------
>  fs/xfs/xfs_btree.h      |    2 +-
>  fs/xfs/xfs_da_btree.c   |    2 +-
>  fs/xfs/xfs_dir2_sf.c    |   45 +++++-------------------
>  fs/xfs/xfs_format.h     |   14 +-------
>  fs/xfs/xfs_fs.h         |    4 +--
>  fs/xfs/xfs_inode_fork.c |    4 +--
>  fs/xfs/xfs_inum.h       |    4 ---
>  fs/xfs/xfs_linux.h      |   12 -------
>  fs/xfs/xfs_log_format.h |    4 +--
>  fs/xfs/xfs_mount.c      |    6 +---
>  fs/xfs/xfs_rtalloc.c    |    4 +--
>  fs/xfs/xfs_sb.h         |    8 ++---
>  fs/xfs/xfs_super.c      |    8 -----
>  fs/xfs/xfs_super.h      |   11 ------
>  fs/xfs/xfs_types.h      |   29 ++-------------
>  20 files changed, 50 insertions(+), 239 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
> index bbe3d15..31f757c 100644
> --- a/fs/xfs/xfs_super.h
> +++ b/fs/xfs/xfs_super.h
> @@ -44,16 +44,6 @@ extern void xfs_qm_exit(void);
>  # define XFS_REALTIME_STRING
>  #endif
>  
> -#if XFS_BIG_BLKNOS
> -# if XFS_BIG_INUMS
> -#  define XFS_BIGFS_STRING	"large block/inode numbers, "
> -# else
> -#  define XFS_BIGFS_STRING	"large block numbers, "
> -# endif
> -#else
> -# define XFS_BIGFS_STRING
> -#endif
> -
>  #ifdef DEBUG
>  # define XFS_DBG_STRING		"debug"
>  #else
> @@ -64,7 +54,6 @@ extern void xfs_qm_exit(void);
>  #define XFS_BUILD_OPTIONS	XFS_ACL_STRING \
>  				XFS_SECURITY_STRING \
>  				XFS_REALTIME_STRING \
> -				XFS_BIGFS_STRING \

Given that the existence of the string indicates large block/inode
numbers, shouldn't we leave it to avoid any confusion? That aside, the
rest of the patch looks fine to me.

Brian

>  				XFS_DBG_STRING /* DBG must be last */
>  
>  struct xfs_inode;
> diff --git a/fs/xfs/xfs_types.h b/fs/xfs/xfs_types.h
> index 65c6e66..b79dc66 100644
> --- a/fs/xfs/xfs_types.h
> +++ b/fs/xfs/xfs_types.h
> @@ -38,43 +38,18 @@ typedef	__int32_t	xfs_tid_t;	/* transaction identifier */
>  typedef	__uint32_t	xfs_dablk_t;	/* dir/attr block number (in file) */
>  typedef	__uint32_t	xfs_dahash_t;	/* dir/attr hash value */
>  
> -/*
> - * These types are 64 bits on disk but are either 32 or 64 bits in memory.
> - * Disk based types:
> - */
> -typedef __uint64_t	xfs_dfsbno_t;	/* blockno in filesystem (agno|agbno) */
> -typedef __uint64_t	xfs_drfsbno_t;	/* blockno in filesystem (raw) */
> -typedef	__uint64_t	xfs_drtbno_t;	/* extent (block) in realtime area */
> -typedef	__uint64_t	xfs_dfiloff_t;	/* block number in a file */
> -typedef	__uint64_t	xfs_dfilblks_t;	/* number of blocks in a file */
> -
> -/*
> - * Memory based types are conditional.
> - */
> -#if XFS_BIG_BLKNOS
>  typedef	__uint64_t	xfs_fsblock_t;	/* blockno in filesystem (agno|agbno) */
>  typedef __uint64_t	xfs_rfsblock_t;	/* blockno in filesystem (raw) */
>  typedef __uint64_t	xfs_rtblock_t;	/* extent (block) in realtime area */
> -typedef	__int64_t	xfs_srtblock_t;	/* signed version of xfs_rtblock_t */
> -#else
> -typedef	__uint32_t	xfs_fsblock_t;	/* blockno in filesystem (agno|agbno) */
> -typedef __uint32_t	xfs_rfsblock_t;	/* blockno in filesystem (raw) */
> -typedef __uint32_t	xfs_rtblock_t;	/* extent (block) in realtime area */
> -typedef	__int32_t	xfs_srtblock_t;	/* signed version of xfs_rtblock_t */
> -#endif
>  typedef __uint64_t	xfs_fileoff_t;	/* block number in a file */
> -typedef __int64_t	xfs_sfiloff_t;	/* signed block number in a file */
>  typedef __uint64_t	xfs_filblks_t;	/* number of blocks in a file */
>  
> +typedef	__int64_t	xfs_srtblock_t;	/* signed version of xfs_rtblock_t */
> +typedef __int64_t	xfs_sfiloff_t;	/* signed block number in a file */
>  
>  /*
>   * Null values for the types.
>   */
> -#define	NULLDFSBNO	((xfs_dfsbno_t)-1)
> -#define	NULLDRFSBNO	((xfs_drfsbno_t)-1)
> -#define	NULLDRTBNO	((xfs_drtbno_t)-1)
> -#define	NULLDFILOFF	((xfs_dfiloff_t)-1)
> -
>  #define	NULLFSBLOCK	((xfs_fsblock_t)-1)
>  #define	NULLRFSBLOCK	((xfs_rfsblock_t)-1)
>  #define	NULLRTBLOCK	((xfs_rtblock_t)-1)
> -- 
> 1.7.10.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
