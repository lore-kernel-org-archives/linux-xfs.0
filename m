Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p220010J225867 for <xfs@oss.sgi.com>; Tue, 1 Mar 2011 18:00:03 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C4B8157ACC3
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2011 16:02:46 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	i0JZBOlAii24Ztl6 for <xfs@oss.sgi.com>;
	Tue, 01 Mar 2011 16:02:46 -0800 (PST)
Date: Wed, 2 Mar 2011 11:02:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, V3 (sort of)] xfs: zero proper structure size for
	geometry calls
Message-ID: <20110302000244.GB4905@dastard>
References: <4D6C28A5.60905@mnsu.edu> <4D6C4DEE.6020902@sandeen.net>
	<4D6C9958.2040607@sandeen.net> <1298984132.32568.3.camel@dan>
	<4D6D128C.6010503@mnsu.edu> <4D6D157B.9070800@sandeen.net>
	<1299001800.2381.10.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1299001800.2381.10.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>, Eric Sandeen <sandeen@sandeen.net>, Dan Rosenberg <drosenberg@vsecurity.com>, Eugene Teo <eugeneteo@kernel.org>, xfs@oss.sgi.com

On Tue, Mar 01, 2011 at 11:50:00AM -0600, Alex Elder wrote:
> I'm sorry to muddy the waters with this.  But I think the
> proposed patch fixes the wrong problem.  Having xfs_fs_geometry()
> zero its argument is fine--it defines an interface and honors
> it.  The real problem lies in xfs_ioc_fsgeometry_v1(), which
> violates that interface by passing the address of an object
> that's not the right size.  So below is an alternative to
> Eric's solution which just fixes this one caller instead.
> 
> Eric has already told me this makes more sense.  It would
> be nice if Jeffrey would re-test this fix, and Dan would
> sign off on it as well.
> 
> 					-Alex
> 
> Commit 493f3358cb289ccf716c5a14fa5bb52ab75943e5 added this call to
> xfs_fs_geometry() in order to avoid passing kernel stack data back
> to user space:
> 
> +       memset(geo, 0, sizeof(*geo)); 
> 
> Unfortunately, one of the callers of that function passes the
> address of a smaller data type, cast to fit the type that
> xfs_fs_geometry() requires.  As a result, this can happen:
> 
> Kernel panic - not syncing: stack-protector: Kernel stack is corrupted
> in: f87aca93
> 
> Pid: 262, comm: xfs_fsr Not tainted 2.6.38-rc6-493f3358cb2+ #1
> Call Trace:
> 
> [<c12991ac>] ? panic+0x50/0x150
> [<c102ed71>] ? __stack_chk_fail+0x10/0x18
> [<f87aca93>] ? xfs_ioc_fsgeometry_v1+0x56/0x5d [xfs]
> 
> 
> Fix this by fixing that one caller to pass the right type and then
> copy out the subset it is interested in.
> 
> Note: This patch is an alternative to one originally proposed by
> Eric Sandeen.
> 
> Reported-by: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
> Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> ---
>  fs/xfs/linux-2.6/xfs_ioctl.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> Index: b/fs/xfs/linux-2.6/xfs_ioctl.c
> ===================================================================
> --- a/fs/xfs/linux-2.6/xfs_ioctl.c
> +++ b/fs/xfs/linux-2.6/xfs_ioctl.c
> @@ -695,14 +695,19 @@ xfs_ioc_fsgeometry_v1(
>         xfs_mount_t             *mp,
>         void                    __user *arg)
>  {
> -       xfs_fsop_geom_v1_t      fsgeo;
> +       xfs_fsop_geom_t         fsgeo;
>         int                     error;
> 
> -       error = xfs_fs_geometry(mp, (xfs_fsop_geom_t *)&fsgeo, 3);
> +       error = xfs_fs_geometry(mp, &fsgeo, 3);
>         if (error)
>                 return -error;
> 
> -       if (copy_to_user(arg, &fsgeo, sizeof(fsgeo)))
> +       /*
> +        * Caller should have passed an argument of type
> +        * xfs_fsop_geom_v1_t.  This is a proper subset of the
> +        * xfs_fsop_geom_t that xfs_fs_geometry() fills in.
> +        */
> +       if (copy_to_user(arg, &fsgeo, sizeof (xfs_fsop_geom_v1_t)))
>                 return -XFS_ERROR(EFAULT);

Minor thing: "sizeof(foo)", not "sizeof (foo)"....

Cheers,,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
