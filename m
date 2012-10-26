Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9QDcvLa229502 for <xfs@oss.sgi.com>; Fri, 26 Oct 2012 08:38:57 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id y8UCpJSQP1Lc8VYW for
	<xfs@oss.sgi.com>; Fri, 26 Oct 2012 06:40:43 -0700 (PDT)
Date: Fri, 26 Oct 2012 11:40:38 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: silence uninitialised f.file warning.
Message-ID: <20121026134037.GA20848@andromeda.usersys.redhat.com>
References: <1351146150-19113-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1351146150-19113-1-git-send-email-david@fromorbit.com>
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
Cc: viro@ZenIV.linux.org.uk, xfs@oss.sgi.com

On Thu, Oct 25, 2012 at 05:22:30PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Uninitialised variable build warning introduced by 2903ff0 ("switch
> simple cases of fget_light to fdget"), gcc is not smart enough to
> work out that the variable is not used uninitialised, and the commit
> removed the initialisation at declaration that the old variable had.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_ioctl.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 8305f2a..c1df3c6 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -70,7 +70,7 @@ xfs_find_handle(
>  	int			hsize;
>  	xfs_handle_t		handle;
>  	struct inode		*inode;
> -	struct fd		f;
> +	struct fd		f = {0};
>  	struct path		path;
>  	int			error;
>  	struct xfs_inode	*ip;
> -- 
> 1.7.10
> 
Looks good,

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
