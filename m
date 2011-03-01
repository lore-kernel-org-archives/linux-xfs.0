Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p212uxGT171060 for <xfs@oss.sgi.com>; Mon, 28 Feb 2011 20:56:59 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D50751579DCA
	for <xfs@oss.sgi.com>; Mon, 28 Feb 2011 18:59:47 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	pXFUWg3E4MIGTLP0 for <xfs@oss.sgi.com>;
	Mon, 28 Feb 2011 18:59:47 -0800 (PST)
Date: Tue, 1 Mar 2011 13:59:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: zero proper structure size for geometry calls
Message-ID: <20110301025944.GG3087@dastard>
References: <4D6C28A5.60905@mnsu.edu>
 <4D6C4DEE.6020902@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D6C4DEE.6020902@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>, Dan Rosenberg <drosenberg@vsecurity.com>, Eugene Teo <eugeneteo@kernel.org>, xfs@oss.sgi.com

On Mon, Feb 28, 2011 at 07:37:50PM -0600, Eric Sandeen wrote:
> commit 493f3358cb289ccf716c5a14fa5bb52ab75943e5 added:
> 
> +       memset(geo, 0, sizeof(*geo)); 
> 
> but unfortunately we're dealing with a cast pointer here, and
> the caller may actually have a smaller structure on the stack.
> Zeroing out more leads to stack corruption traps:
> 
> Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: f87aca93
> 
> Pid: 262, comm: xfs_fsr Not tainted 2.6.38-rc6-493f3358cb2+ #1
> Call Trace:
> 
> [<c12991ac>] ? panic+0x50/0x150
> [<c102ed71>] ? __stack_chk_fail+0x10/0x18
> [<f87aca93>] ? xfs_ioc_fsgeometry_v1+0x56/0x5d [xfs] 
> 
> Fix this by zeroing out the structure in the callers, where we know
> the actual size.
> 
> Reported-by: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
> index f5e2a19..34e401f 100644
> --- a/fs/xfs/linux-2.6/xfs_ioctl.c
> +++ b/fs/xfs/linux-2.6/xfs_ioctl.c
> @@ -698,6 +698,7 @@ xfs_ioc_fsgeometry_v1(
>  	xfs_fsop_geom_v1_t	fsgeo;
>  	int			error;
>  
> +	memset(&fsgeo, 0, sizeof(xfs_fsop_geom_v1_t));

I'd prefer that sizeof(fsgeo) is used here. That means if the type
is changed, then memset doesn't need to be. Same for all the rest
of the memset calls.

Otherwise,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
