Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q28LY3b0087868 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 15:34:03 -0600
Date: Thu, 8 Mar 2012 15:34:10 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 01/10] xfs: clean up minor sparse warnings
Message-ID: <20120308213410.GZ7762@sgi.com>
References: <1331095828-28742-1-git-send-email-david@fromorbit.com>
	<1331095828-28742-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1331095828-28742-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Mar 07, 2012 at 03:50:19PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Ben Myers <bpm@sgi.com>

...

> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index ab30253..2601d6b 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -103,12 +103,15 @@ xfs_mark_inode_dirty(
>  }
>  
>  
> -int xfs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
> -		   void *fs_info)
> +static int
> +xfs_initxattrs(
> +	struct inode		*inode,
> +	const struct xattr	*xattr_array,
> +	void			*fs_info)
>  {
> -	const struct xattr *xattr;
> -	struct xfs_inode *ip = XFS_I(inode);
> -	int error = 0;
> +	const struct xattr	*xattr;
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	int			error = 0;

I didn't see a sparse warning which this fixes... FWICS all you've done
here is make it static and fix the formatting.

This still looks good..  ;)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
