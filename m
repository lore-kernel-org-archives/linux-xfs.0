Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9B00bA9204691 for <xfs@oss.sgi.com>; Wed, 10 Oct 2012 19:00:37 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 7f3u7gp8laeRgAhs for <xfs@oss.sgi.com>;
	Wed, 10 Oct 2012 17:02:09 -0700 (PDT)
Message-ID: <50760C80.3030105@sandeen.net>
Date: Wed, 10 Oct 2012 19:02:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: report projid32bit feature in geometry call
References: <507476F1.3080503@redhat.com>
In-Reply-To: <507476F1.3080503@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 10/9/12 2:11 PM, Eric Sandeen wrote:
> When xfs gained the projid32bit feature, it was never added to
> the FSGEOMETRY ioctl feature flags, so it's not queryable without
> this patch.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

SGI, can you please add a :

Cc: stable@vger.kernel.org

when this is committed?  New stuff will be depending on this and it'd be good to get it munged into stable kernels as well.


> ---
> 
> note1: is there a reason we had gaps in the flags?
> note2: I don't *think* this requires a new version for the ioctl
> 
> diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
> index c13fed8..0948c04 100644
> --- a/fs/xfs/xfs_fs.h
> +++ b/fs/xfs/xfs_fs.h
> @@ -233,7 +233,8 @@ typedef struct xfs_fsop_resblks {
>  #define XFS_FSOP_GEOM_FLAGS_LOGV2	0x0100	/* log format version 2	*/
>  #define XFS_FSOP_GEOM_FLAGS_SECTOR	0x0200	/* sector sizes >1BB	*/
>  #define XFS_FSOP_GEOM_FLAGS_ATTR2	0x0400	/* inline attributes rework */
> -#define XFS_FSOP_GEOM_FLAGS_DIRV2CI	0x1000	/* ASCII only CI names */
> +#define XFS_FSOP_GEOM_FLAGS_PROJID32	0x0800  /* 32-bit project IDs	*/
> +#define XFS_FSOP_GEOM_FLAGS_DIRV2CI	0x1000	/* ASCII only CI names	*/
>  #define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x4000	/* lazy superblock counters */
>  
>  
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index c25b094..89ad847 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -97,7 +97,9 @@ xfs_fs_geometry(
>  			(xfs_sb_version_haslazysbcount(&mp->m_sb) ?
>  				XFS_FSOP_GEOM_FLAGS_LAZYSB : 0) |
>  			(xfs_sb_version_hasattr2(&mp->m_sb) ?
> -				XFS_FSOP_GEOM_FLAGS_ATTR2 : 0);
> +				XFS_FSOP_GEOM_FLAGS_ATTR2 : 0) |
> +			(xfs_sb_version_hasprojid32bit(&mp->m_sb) ?
> +				XFS_FSOP_GEOM_FLAGS_PROJID32 : 0);
>  		geo->logsectsize = xfs_sb_version_hassector(&mp->m_sb) ?
>  				mp->m_sb.sb_logsectsize : BBSIZE;
>  		geo->rtsectsize = mp->m_sb.sb_blocksize;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
