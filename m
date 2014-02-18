Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A7FFD7FB3
	for <xfs@oss.sgi.com>; Mon, 17 Feb 2014 22:51:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8E0588F8039
	for <xfs@oss.sgi.com>; Mon, 17 Feb 2014 20:51:46 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	vMACahd8WTHfuvSA for <xfs@oss.sgi.com>;
	Mon, 17 Feb 2014 20:51:44 -0800 (PST)
Date: Tue, 18 Feb 2014 15:51:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] xfs: Add support for FALLOC_FL_ZERO_RANGE
Message-ID: <20140218045138.GI13997@dastard>
References: <1392649703-10772-1-git-send-email-lczerner@redhat.com>
	<1392649703-10772-7-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1392649703-10772-7-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, tytso@mit.edu, xfs@oss.sgi.com

On Mon, Feb 17, 2014 at 04:08:23PM +0100, Lukas Czerner wrote:
> Introduce new FALLOC_FL_ZERO_RANGE flag for fallocate. This has the same
> functionality as xfs ioctl XFS_IOC_ZERO_RANGE.
> 
> We can also preallocate blocks past EOF in the same was as with
> fallocate. Flag FALLOC_FL_KEEP_SIZE will cause the inode size to remain
> the same even if we preallocate blocks past EOF.
> 
> It uses the same code to zero range as it is used by the
> XFS_IOC_ZERO_RANGE ioctl.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/xfs/xfs_file.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 64b48ea..aec5f64 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -823,7 +823,8 @@ xfs_file_fallocate(
>  
>  	if (!S_ISREG(inode->i_mode))
>  		return -EINVAL;
> -	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> +	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
> +		     FALLOC_FL_ZERO_RANGE))
>  		return -EOPNOTSUPP;
>  
>  	xfs_ilock(ip, XFS_IOLOCK_EXCL);
> @@ -840,8 +841,11 @@ xfs_file_fallocate(
>  				goto out_unlock;
>  		}
>  
> -		error = xfs_alloc_file_space(ip, offset, len,
> -					     XFS_BMAPI_PREALLOC);
> +		if (mode & FALLOC_FL_ZERO_RANGE)
> +			error = xfs_zero_file_space(ip, offset, len);
> +		else
> +			error = xfs_alloc_file_space(ip, offset, len,
> +						     XFS_BMAPI_PREALLOC);
>  		if (error)
>  			goto out_unlock;
>  	}

Looks OK.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
