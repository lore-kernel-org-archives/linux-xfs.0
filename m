Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 971D829E15
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 16:54:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 161B2AC004
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 14:54:50 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	GHGKT5DfGTU37cGh for <xfs@oss.sgi.com>;
	Wed, 18 Sep 2013 14:54:49 -0700 (PDT)
Date: Thu, 19 Sep 2013 07:54:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: add the inode directory type support to
	XFS_IOC_FSGEOM
Message-ID: <20130918215445.GA9901@dastard>
References: <20130917144721.917667018@sgi.com>
	<20130917144733.819109222@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130917144733.819109222@sgi.com>
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

On Tue, Sep 17, 2013 at 09:47:22AM -0500, Mark Tinguely wrote:
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
>  fs/xfs/xfs_fs.h    |   32 ++++++++++++++++----------------
>  fs/xfs/xfs_fsops.c |    4 +++-
>  2 files changed, 19 insertions(+), 17 deletions(-)
> 
> Index: b/fs/xfs/xfs_fs.h
> ===================================================================
> --- a/fs/xfs/xfs_fs.h
> +++ b/fs/xfs/xfs_fs.h
> @@ -222,22 +222,22 @@ typedef struct xfs_fsop_resblks {
>  
>  #define XFS_FSOP_GEOM_VERSION	0
>  
> -#define XFS_FSOP_GEOM_FLAGS_ATTR	0x0001	/* attributes in use	*/
> -#define XFS_FSOP_GEOM_FLAGS_NLINK	0x0002	/* 32-bit nlink values	*/
> -#define XFS_FSOP_GEOM_FLAGS_QUOTA	0x0004	/* quotas enabled	*/
> -#define XFS_FSOP_GEOM_FLAGS_IALIGN	0x0008	/* inode alignment	*/
> -#define XFS_FSOP_GEOM_FLAGS_DALIGN	0x0010	/* large data alignment */
> -#define XFS_FSOP_GEOM_FLAGS_SHARED	0x0020	/* read-only shared	*/
> -#define XFS_FSOP_GEOM_FLAGS_EXTFLG	0x0040	/* special extent flag	*/
> -#define XFS_FSOP_GEOM_FLAGS_DIRV2	0x0080	/* directory version 2	*/
> -#define XFS_FSOP_GEOM_FLAGS_LOGV2	0x0100	/* log format version 2	*/
> -#define XFS_FSOP_GEOM_FLAGS_SECTOR	0x0200	/* sector sizes >1BB	*/
> -#define XFS_FSOP_GEOM_FLAGS_ATTR2	0x0400	/* inline attributes rework */
> -#define XFS_FSOP_GEOM_FLAGS_PROJID32	0x0800  /* 32-bit project IDs	*/
> -#define XFS_FSOP_GEOM_FLAGS_DIRV2CI	0x1000	/* ASCII only CI names	*/
> -#define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x4000	/* lazy superblock counters */
> -#define XFS_FSOP_GEOM_FLAGS_V5SB	0x8000	/* version 5 superblock */
> -
> +#define XFS_FSOP_GEOM_FLAGS_ATTR	0x00001	/* attributes in use	*/
> +#define XFS_FSOP_GEOM_FLAGS_NLINK	0x00002	/* 32-bit nlink values	*/
> +#define XFS_FSOP_GEOM_FLAGS_QUOTA	0x00004	/* quotas enabled	*/
> +#define XFS_FSOP_GEOM_FLAGS_IALIGN	0x00008	/* inode alignment	*/
> +#define XFS_FSOP_GEOM_FLAGS_DALIGN	0x00010	/* large data alignment */
> +#define XFS_FSOP_GEOM_FLAGS_SHARED	0x00020	/* read-only shared	*/
> +#define XFS_FSOP_GEOM_FLAGS_EXTFLG	0x00040	/* special extent flag	*/
> +#define XFS_FSOP_GEOM_FLAGS_DIRV2	0x00080	/* directory version 2	*/
> +#define XFS_FSOP_GEOM_FLAGS_LOGV2	0x00100	/* log format version 2	*/
> +#define XFS_FSOP_GEOM_FLAGS_SECTOR	0x00200	/* sector sizes >1BB	*/
> +#define XFS_FSOP_GEOM_FLAGS_ATTR2	0x00400	/* inline attributes rework */
> +#define XFS_FSOP_GEOM_FLAGS_PROJID32	0x00800 /* 32-bit project IDs	*/
> +#define XFS_FSOP_GEOM_FLAGS_DIRV2CI	0x01000	/* ASCII only CI names	*/
> +#define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x04000	/* lazy superblock counters */
> +#define XFS_FSOP_GEOM_FLAGS_V5SB	0x08000	/* version 5 superblock */
> +#define XFS_FSOP_GEOM_FLAGS_FTYPE	0x10000	/* inode directory types */

There is no need to do this. Can you drop these hunks as this simply
adds more work to synchronise with userspace.

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

That looks good - can you post the patches to userspace that use
this so we can test it properly?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
