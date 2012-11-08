Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA8N5Lcs032206 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 17:05:21 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	HLo51MtaErHOHvos for <xfs@oss.sgi.com>;
	Thu, 08 Nov 2012 15:07:19 -0800 (PST)
Date: Fri, 9 Nov 2012 10:06:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 1/2] xfs: xfs_tosspages() bug
Message-ID: <20121108230649.GU6434@dastard>
References: <20121108222315.505370321@sgi.com>
	<20121108222315.626928496@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121108222315.626928496@sgi.com>
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
To: Andrew Dahl <adahl@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Nov 08, 2012 at 04:23:16PM -0600, Andrew Dahl wrote:
> xfs_tosspages() takes a closed interval as an argument, take 
> this into account when rounding down to the last byte of the
> last complete page. If the request consists of a single 
> partial page, there will be nothing to toss. 
> 
> Signed-off-by: Andrew Dahl <adahl@sgi.com>
> 
> ---
> 
> Index: xfs/fs/xfs/xfs_fs_subr.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_fs_subr.c
> +++ xfs/fs/xfs/xfs_fs_subr.c
> @@ -32,9 +32,17 @@ xfs_tosspages(
>  	xfs_off_t	last,
>  	int		fiopt)
>  {
> -	/* can't toss partial tail pages, so mask them out */
> -	last &= ~(PAGE_SIZE - 1);
> -	truncate_inode_pages_range(VFS_I(ip)->i_mapping, first, last - 1);
> +	/*
> +	 * Can't toss partial tail pages, so mask them out.  If the only
> +	 * page to toss was a partial tail, there will be nothing left
> +	 * to do.
> +	 */
> +	if (last != -1) {
> +	        last = ((last + 1) & PAGE_MASK) - 1;
> +	        if (last < first)
> +	                return;
> +	}
> +	truncate_inode_pages_range(VFS_I(ip)->i_mapping, first, last);

Ok, lets look at critical ranges:

		passed to truncate_inode_pages_range
first,last	current		patched
0,4095		0,0xffffffff	0,4095
0,4096		0,4095		0,4095
0,4097		0,4095		0,4095

Yup, that's needed.

0,1		0,0xffffffff	aborts (0,0xffffffff)

Big assumption: xfs_off_t is signed.

0xfffffffe	0xffffefff	0xfffeffff
0xffffffff	0xffffefff	0xffffffff

So the change is good.

However, there's a bigger issue here. We've planned to remove these
wrappers for a long time, just never got around to doing it. Seeing
as there is a bug in this wrapper and it needs to be fixed, now
seems like the right time to remove it.

Hence I'd suggest that fixing this particular bug should just
remove xfs_tosspages() and call truncate_inode_pages_range()
directly. There are only two calls to this function, so it should be
a simple conversion.  That can then be followed up with more patches
to remove the other wrappers in xfs_fs_subr.c and hence remove the
file completely...

>  int
> Index: xfs/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_vnodeops.c
> +++ xfs/fs/xfs/xfs_vnodeops.c
> @@ -2172,7 +2172,7 @@ xfs_change_file_space(
>  	switch (cmd) {
>  	case XFS_IOC_ZERO_RANGE:
>  		prealloc_type |= XFS_BMAPI_CONVERT;
> -		xfs_tosspages(ip, startoffset, startoffset + bf->l_len, 0);
> +		xfs_tosspages(ip, startoffset, bf->l_len ? startoffset + llen : -1, 0);
>  		/* FALLTHRU */
>  	case XFS_IOC_RESVSP:
>  	case XFS_IOC_RESVSP64:

What's this hunk for? Indeed, one of the first things that the
xfs_alloc_file_space() checks is this:

        if (len <= 0)
		return XFS_ERROR(EINVAL);

xfs_free_file_space() does the same check, so it is invalid to pass
a bf_len <= 0 for any of these specific functions. Hence this change
is wrong regardless of what the comment on the struct xfs_flock64_t
says - preallocation and hole punch operations must have a positive
length associated with them.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
