Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15248 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751632AbeEJNxV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 May 2018 09:53:21 -0400
Date: Thu, 10 May 2018 09:53:19 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/12] xfs: bmap debugging should never panic the system
Message-ID: <20180510135318.GA69384@bfoster.bfoster>
References: <152537075334.16676.10600900179473864298.stgit@magnolia>
 <152537075974.16676.4678069099698404803.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152537075974.16676.4678069099698404803.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 03, 2018 at 11:05:59AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't panic() the system if the bmap records are garbage, just call
> ASSERT which gives us the same backtrace but enables developers to
> control if the system goes down or not.  This makes debugging with
> generic/388 much easier because it won't reboot the machine midway
> through a run just because btree_read_bufl returns EIO when the fs has
> already shut down.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 6a7c2f03ea11..393b4e2c63ad 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -312,8 +312,10 @@ xfs_check_block(
>  				xfs_warn(mp, "%s: thispa(%d) == pp(%d) %Ld",
>  					__func__, j, i,
>  					(unsigned long long)be64_to_cpu(*thispa));
> -				panic("%s: ptrs are equal in node\n",
> +				xfs_err(mp, "%s: ptrs are equal in node\n",
>  					__func__);
> +				ASSERT(XFS_FORCED_SHUTDOWN(mp));
> +				xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);

Why the assert if we're just going to shutdown? At minimum, it looks a
bit funny to assert that the fs is shutdown just prior to issuing a
shutdown. Can we just shutdown and let the error level dictate whether
we want a backtrace?

Brian

>  			}
>  		}
>  	}
> @@ -483,7 +485,9 @@ xfs_bmap_check_leaf_extents(
>  error_norelse:
>  	xfs_warn(mp, "%s: BAD after btree leaves for %d extents",
>  		__func__, i);
> -	panic("%s: CORRUPTED BTREE OR SOMETHING", __func__);
> +	xfs_err(mp, "%s: CORRUPTED BTREE OR SOMETHING", __func__);
> +	ASSERT(XFS_FORCED_SHUTDOWN(mp));
> +	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  	return;
>  }
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
