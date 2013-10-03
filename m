Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 66C2D29DFC
	for <xfs@oss.sgi.com>; Thu,  3 Oct 2013 09:37:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 34CE1304059
	for <xfs@oss.sgi.com>; Thu,  3 Oct 2013 07:37:36 -0700 (PDT)
Date: Thu, 3 Oct 2013 11:37:30 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: add the inode directory type support to
	XFS_IOC_FSGEOM
Message-ID: <20131003143729.GB27654@orion.maiolino.org>
References: <20131002210035.940755811@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131002210035.940755811@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

Looks good,

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

On Wed, Oct 02, 2013 at 04:00:06PM -0500, Mark Tinguely wrote:
> Add the inode type directory type support to XFS_IOC_FSGEOM
> so that xfs_repair/xfs_info knows if the superblock v4 filesystem
> enabled the feature.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
>  v2 remove the extra 0 in the XFS_FSOP_GEOM_FLAGS_xxx entries.
> 
> fs/xfs/xfs_fs.h    |   32 ++++++++++++++++----------------
>  fs/xfs/xfs_fs.h    |    4 ++--
>  fs/xfs/xfs_fsops.c |    4 +++-
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> Index: b/fs/xfs/xfs_fs.h
> ===================================================================
> --- a/fs/xfs/xfs_fs.h
> +++ b/fs/xfs/xfs_fs.h
> @@ -233,11 +233,11 @@ typedef struct xfs_fsop_resblks {
>  #define XFS_FSOP_GEOM_FLAGS_LOGV2	0x0100	/* log format version 2	*/
>  #define XFS_FSOP_GEOM_FLAGS_SECTOR	0x0200	/* sector sizes >1BB	*/
>  #define XFS_FSOP_GEOM_FLAGS_ATTR2	0x0400	/* inline attributes rework */
> -#define XFS_FSOP_GEOM_FLAGS_PROJID32	0x0800  /* 32-bit project IDs	*/
> +#define XFS_FSOP_GEOM_FLAGS_PROJID32	0x0800	/* 32-bit project IDs	*/
>  #define XFS_FSOP_GEOM_FLAGS_DIRV2CI	0x1000	/* ASCII only CI names	*/
>  #define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x4000	/* lazy superblock counters */
>  #define XFS_FSOP_GEOM_FLAGS_V5SB	0x8000	/* version 5 superblock */
> -
> +#define XFS_FSOP_GEOM_FLAGS_FTYPE	0x10000	/* inode directory types */
>  
>  /*
>   * Minimum and maximum sizes need for growth checks.
> Index: b/fs/xfs/xfs_fsops.c
> ===================================================================
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -101,7 +101,9 @@ xfs_fs_geometry(
>  			(xfs_sb_version_hasprojid32bit(&mp->m_sb) ?
>  				XFS_FSOP_GEOM_FLAGS_PROJID32 : 0) |
>  			(xfs_sb_version_hascrc(&mp->m_sb) ?
> -				XFS_FSOP_GEOM_FLAGS_V5SB : 0);
> +				XFS_FSOP_GEOM_FLAGS_V5SB : 0) |
> +			(xfs_sb_version_hasftype(&mp->m_sb) ?
> +				XFS_FSOP_GEOM_FLAGS_FTYPE : 0);
>  		geo->logsectsize = xfs_sb_version_hassector(&mp->m_sb) ?
>  				mp->m_sb.sb_logsectsize : BBSIZE;
>  		geo->rtsectsize = mp->m_sb.sb_blocksize;
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
