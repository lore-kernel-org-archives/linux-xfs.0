Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DA0777F78
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 07:00:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C7E1A8F8049
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 05:00:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id c6mSlojTCUJtQiYE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 05:00:04 -0700 (PDT)
Date: Wed, 1 Oct 2014 07:59:59 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: only set extent size hint when asked
Message-ID: <20141001115959.GB53779@bfoster.bfoster>
References: <1412041565-18873-1-git-send-email-david@fromorbit.com>
	<1412041565-18873-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1412041565-18873-3-git-send-email-david@fromorbit.com>
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
Cc: iusty@k1024.org, xfs@oss.sgi.com

On Tue, Sep 30, 2014 at 11:46:05AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently the extent size hint is set unconditionally in
> xfs_ioctl_setattr(), even when the FSX_EXTSIZE flag is not set. This
> means we can set values from uninitialised stack variables. Hence
> only set the extent size hint from userspace when both the mask
> falg is set and the inode has the XFS_DIFLAG_EXTSIZE flag set to
> indicate that we should have an extent size hint set on the inode.
> 

I'm not sure what you mean here by FSX_EXTSIZE not being checked. It
looks like FSX_EXTSIZE is checked before and after the patch.

Regardless, the fix looks Ok to me...

Reviewed-by: Brian Foster <bfoster@redhat.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_ioctl.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 87c3bd1..24c926b 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1231,13 +1231,25 @@ xfs_ioctl_setattr(
>  
>  	}
>  
> -	if (mask & FSX_EXTSIZE)
> -		ip->i_d.di_extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
>  	if (mask & FSX_XFLAGS) {
>  		xfs_set_diflags(ip, fa->fsx_xflags);
>  		xfs_diflags_to_linux(ip);
>  	}
>  
> +	/*
> +	 * Only set the extent size hint if we've already determined that the
> +	 * extent size hint should be set on the inode. If no extent size flags
> +	 * are set on the inode then unconditionally clear the extent size hint.
> +	 */
> +	if (mask & FSX_EXTSIZE) {
> +		int	extsize = 0;
> +
> +		if (ip->i_d.di_flags &
> +				(XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT))
> +			extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
> +		ip->i_d.di_extsize = extsize;
> +	}
> +
>  	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
