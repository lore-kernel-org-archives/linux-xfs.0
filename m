Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C7F1A7F55
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2014 00:58:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8C7B38F8033
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 22:58:33 -0700 (PDT)
Received: from mail-wi0-f170.google.com (mail-wi0-f170.google.com
	[209.85.212.170]) by cuda.sgi.com with ESMTP id
	kAdFs7OzIQ5o9T2O (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Sep 2014 22:58:32 -0700 (PDT)
Received: by mail-wi0-f170.google.com with SMTP id n3so784680wiv.3
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 22:58:30 -0700 (PDT)
Date: Tue, 30 Sep 2014 07:58:29 +0200
From: Iustin Pop <iusty@k1024.org>
Subject: Re: [PATCH 2/2] xfs: only set extent size hint when asked
Message-ID: <20140930055829.GB15186@teal.hq.k1024.org>
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
Cc: xfs@oss.sgi.com

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

Quick question: this sounds sane, but it will have the following effect
(if I understand things correctly): updating other flags on the inode
(e.g. XFS_XFLAG_NOATIME) might change the recorded extent size. True, it
will correct the size if not appropriate and it will have a noop impact,
but still it will be an unrelated inode change. Would it make sense to
document this in the xfsctl man page then?

thanks,
iustin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
