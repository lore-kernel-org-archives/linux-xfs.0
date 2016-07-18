Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 72A0E7CA0
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 08:34:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 464628F8033
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 06:34:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tGCNXL3m8fLsImHH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 18 Jul 2016 06:34:41 -0700 (PDT)
Date: Mon, 18 Jul 2016 09:34:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 049/119] xfs: enable the rmap btree functionality
Message-ID: <20160718133439.GH27380@bfoster.bfoster>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612658581.12839.14068666392735480433.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612658581.12839.14068666392735480433.stgit@birch.djwong.org>
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

On Thu, Jun 16, 2016 at 06:23:05PM -0700, Darrick J. Wong wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add the feature flag to the supported matrix so that the kernel can
> mount and use rmap btree enabled filesystems
> 
> v2: Move the EXPERIMENTAL message to fill_super so it only prints once.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> [darrick.wong@oracle.com: move the experimental tag]
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_format.h |    3 ++-
>  fs/xfs/xfs_super.c         |    4 ++++
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 6efc7a3..1b08237 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -457,7 +457,8 @@ xfs_sb_has_compat_feature(
>  #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
>  #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
>  #define XFS_SB_FEAT_RO_COMPAT_ALL \
> -		(XFS_SB_FEAT_RO_COMPAT_FINOBT)
> +		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
> +		 XFS_SB_FEAT_RO_COMPAT_RMAPBT)
>  #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
>  static inline bool
>  xfs_sb_has_ro_compat_feature(
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index a8300e4..9328821 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1571,6 +1571,10 @@ xfs_fs_fill_super(
>  		xfs_alert(mp,
>  	"EXPERIMENTAL sparse inode feature enabled. Use at your own risk!");
>  
> +	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> +		xfs_alert(mp,
> +	"EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!");
> +
>  	error = xfs_mountfs(mp);
>  	if (error)
>  		goto out_filestream_unmount;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
