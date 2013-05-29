Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C99717F37
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 10:10:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A72F38F804B
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 08:10:15 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id n22DrzBeFNHNLdxy for <xfs@oss.sgi.com>;
	Wed, 29 May 2013 08:10:13 -0700 (PDT)
Message-ID: <51A61A55.1000306@sandeen.net>
Date: Wed, 29 May 2013 10:10:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
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

On 5/27/13 1:38 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently userspace has no way of determining that a filesystem is
> CRC enabled. Add a flag to the XFS_IOC_FSGEOMETRY ioctl output to
> indicate that the filesystem has v5 superblock support enabled.
> This will allow xfs_info to correctly report the state of the
> filesystem.


Looks fine,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Ben, having this in place for for the next point release will let
userspace work & testing proceed w/o the need for a patched
kernel... if you could consider pulling it in that'd be great.

Dave, just out of curiosity, most other features sort of match between
the "_has_*" and the flag names, is there a reason for the
crc <-> sbv5 difference?  Just semantics, but just curious.

(i.e. xfs_sb_version_hasprojid32bit checks XFS_SB_VERSION2_PROJID32BIT,
but xfs_sb_version_hascrc checks XFS_SB_VERSION_5)

Answering my own question maybe, I guess SB_VERSION_5 was conceived
with crc already in place, so there's no need for a feature flag on
top of the sb version, right...?

-Eric 

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
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
