Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EFB487F50
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 09:20:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 814CBAC001
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 07:20:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EGIFdO3BwKqGHu8c for
	<xfs@oss.sgi.com>; Thu, 30 May 2013 07:20:33 -0700 (PDT)
Message-ID: <51A75F83.90500@redhat.com>
Date: Thu, 30 May 2013 10:17:39 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 8/9] xfs: add fsgeom flag for v5 superblock support.
References: <1369636707-15150-1-git-send-email-david@fromorbit.com>
	<1369636707-15150-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1369636707-15150-9-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 05/27/2013 02:38 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently userspace has no way of determining that a filesystem is
> CRC enabled. Add a flag to the XFS_IOC_FSGEOMETRY ioctl output to
> indicate that the filesystem has v5 superblock support enabled.
> This will allow xfs_info to correctly report the state of the
> filesystem.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_fs.h    |    1 +
>  fs/xfs/xfs_fsops.c |    4 +++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
> index 6dda3f9..d046955 100644
> --- a/fs/xfs/xfs_fs.h
> +++ b/fs/xfs/xfs_fs.h
> @@ -236,6 +236,7 @@ typedef struct xfs_fsop_resblks {
>  #define XFS_FSOP_GEOM_FLAGS_PROJID32	0x0800  /* 32-bit project IDs	*/
>  #define XFS_FSOP_GEOM_FLAGS_DIRV2CI	0x1000	/* ASCII only CI names	*/
>  #define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x4000	/* lazy superblock counters */
> +#define XFS_FSOP_GEOM_FLAGS_V5SB	0x8000	/* version 5 superblock */
>  
>  
>  /*
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 87595b2..3c3644e 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -99,7 +99,9 @@ xfs_fs_geometry(
>  			(xfs_sb_version_hasattr2(&mp->m_sb) ?
>  				XFS_FSOP_GEOM_FLAGS_ATTR2 : 0) |
>  			(xfs_sb_version_hasprojid32bit(&mp->m_sb) ?
> -				XFS_FSOP_GEOM_FLAGS_PROJID32 : 0);
> +				XFS_FSOP_GEOM_FLAGS_PROJID32 : 0) |
> +			(xfs_sb_version_hascrc(&mp->m_sb) ?
> +				XFS_FSOP_GEOM_FLAGS_V5SB : 0);
>  		geo->logsectsize = xfs_sb_version_hassector(&mp->m_sb) ?
>  				mp->m_sb.sb_logsectsize : BBSIZE;
>  		geo->rtsectsize = mp->m_sb.sb_blocksize;
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
