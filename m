Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DB7157CA0
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 08:34:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 669D6AC002
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 06:34:20 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lrgIHWiUs4M6CgNZ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 18 Jul 2016 06:34:19 -0700 (PDT)
Date: Mon, 18 Jul 2016 09:34:17 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 045/119] xfs: add rmap btree geometry feature flag
Message-ID: <20160718133416.GD27380@bfoster.bfoster>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612656051.12839.8811990871879453367.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612656051.12839.8811990871879453367.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>

On Thu, Jun 16, 2016 at 06:22:40PM -0700, Darrick J. Wong wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> So xfs_info and other userspace utilities know the filesystem is
> using this feature.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_fs.h |    1 +
>  fs/xfs/xfs_fsops.c     |    4 +++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index f5ec9c5..7945505 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -206,6 +206,7 @@ typedef struct xfs_fsop_resblks {
>  #define XFS_FSOP_GEOM_FLAGS_FTYPE	0x10000	/* inode directory types */
>  #define XFS_FSOP_GEOM_FLAGS_FINOBT	0x20000	/* free inode btree */
>  #define XFS_FSOP_GEOM_FLAGS_SPINODES	0x40000	/* sparse inode chunks	*/
> +#define XFS_FSOP_GEOM_FLAGS_RMAPBT	0x80000	/* Reverse mapping btree */
>  
>  /*
>   * Minimum and maximum sizes need for growth checks.
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 3772f6c..5980d5c 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -105,7 +105,9 @@ xfs_fs_geometry(
>  			(xfs_sb_version_hasfinobt(&mp->m_sb) ?
>  				XFS_FSOP_GEOM_FLAGS_FINOBT : 0) |
>  			(xfs_sb_version_hassparseinodes(&mp->m_sb) ?
> -				XFS_FSOP_GEOM_FLAGS_SPINODES : 0);
> +				XFS_FSOP_GEOM_FLAGS_SPINODES : 0) |
> +			(xfs_sb_version_hasrmapbt(&mp->m_sb) ?
> +				XFS_FSOP_GEOM_FLAGS_RMAPBT : 0);
>  		geo->logsectsize = xfs_sb_version_hassector(&mp->m_sb) ?
>  				mp->m_sb.sb_logsectsize : BBSIZE;
>  		geo->rtsectsize = mp->m_sb.sb_blocksize;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
