Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DEC737CA4
	for <xfs@oss.sgi.com>; Tue, 26 Jul 2016 11:36:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A5FF08F8037
	for <xfs@oss.sgi.com>; Tue, 26 Jul 2016 09:36:12 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pDAQGumrXk3JPMa1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 26 Jul 2016 09:36:11 -0700 (PDT)
Date: Tue, 26 Jul 2016 12:36:07 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 04/47] xfs: fix locking of the rt bitmap/summary inodes
Message-ID: <20160726163607.GB31917@bfoster.bfoster>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907698690.25461.7316591529865921141.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146907698690.25461.7316591529865921141.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Wed, Jul 20, 2016 at 09:56:26PM -0700, Darrick J. Wong wrote:
> When we're deleting realtime extents, we need to lock the summary
> inode in case we need to update the summary info to prevent an assert
> on the rsumip inode lock on a debug kernel.  While we're at it, fix
> the locking annotations so that we avoid triggering lockdep warnings.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

I haven't tried the rt stuff in quite some time (and even then never
really played with it much). What's the assert that fails?

Brian

>  fs/xfs/libxfs/xfs_bmap.c |    4 +++-
>  fs/xfs/xfs_bmap_util.c   |    4 ++--
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 2f2c85c..c5981f4 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5179,8 +5179,10 @@ xfs_bunmapi(
>  		/*
>  		 * Synchronize by locking the bitmap inode.
>  		 */
> -		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
> +		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL|XFS_ILOCK_RTBITMAP);
>  		xfs_trans_ijoin(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
> +		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL|XFS_ILOCK_RTSUM);
> +		xfs_trans_ijoin(tp, mp->m_rsumip, XFS_ILOCK_EXCL);
>  	}
>  
>  	extno = 0;
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index cd4a850..998c3e6 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -214,9 +214,9 @@ xfs_bmap_rtalloc(
>  	/*
>  	 * Lock out modifications to both the RT bitmap and summary inodes
>  	 */
> -	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
> +	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL|XFS_ILOCK_RTBITMAP);
>  	xfs_trans_ijoin(ap->tp, mp->m_rbmip, XFS_ILOCK_EXCL);
> -	xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL);
> +	xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL|XFS_ILOCK_RTSUM);
>  	xfs_trans_ijoin(ap->tp, mp->m_rsumip, XFS_ILOCK_EXCL);
>  
>  	/*
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
