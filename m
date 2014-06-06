Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EF0907F3F
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 12:34:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8A776AC004
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 10:34:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id IVzgqC7G8307mpMT for
	<xfs@oss.sgi.com>; Fri, 06 Jun 2014 10:33:57 -0700 (PDT)
Date: Fri, 6 Jun 2014 13:33:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs; fix xfs_da_args sparse warning in xfs_readdir
Message-ID: <20140606173353.GC3048@laptop.bfoster>
References: <1402042701-26173-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1402042701-26173-1-git-send-email-david@fromorbit.com>
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

On Fri, Jun 06, 2014 at 06:18:21PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The kbuild test robot reported:
> 
> >> fs/xfs/xfs_dir2_readdir.c:672:41: sparse: Using plain integer as NULL pointer
> 
> Fix it.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_dir2_readdir.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index ca1f43c..48e99af 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -669,7 +669,7 @@ xfs_readdir(
>  	struct dir_context	*ctx,
>  	size_t			bufsize)
>  {
> -	struct xfs_da_args	args = {0};
> +	struct xfs_da_args	args = { NULL };
>  	int			rval;
>  	int			v;
>  	uint			lock_mode;
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
