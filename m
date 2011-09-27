Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8R1l8P2242536 for <xfs@oss.sgi.com>; Mon, 26 Sep 2011 20:47:09 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 86A3D1C45D8C
	for <xfs@oss.sgi.com>; Mon, 26 Sep 2011 18:47:06 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	55ptNOJ3V9EB5Oqw for <xfs@oss.sgi.com>;
	Mon, 26 Sep 2011 18:47:06 -0700 (PDT)
Date: Tue, 27 Sep 2011 11:47:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS binary code size
Message-ID: <20110927014702.GC3159@dastard>
References: <4E8106ED.9040909@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E8106ED.9040909@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Mon, Sep 26, 2011 at 06:12:45PM -0500, Stan Hoeppner wrote:
> I'm curious about the footprint of the XFS binary code, specifically
> for 32 bit systems, but knowing the 64 bit case would be educational
> as well for comparison.  I don't use kernel modules or I'd already
> have a rough answer.  My last build was 2.6.38.6 but I'm sure the
> size hasn't changed much in more recent kernels.  My XFS build
> options were:
> 
> $ grep -i xfs .config
> CONFIG_XFS_FS=y
> # CONFIG_XFS_QUOTA is not set
> # CONFIG_XFS_POSIX_ACL is not set
> # CONFIG_XFS_RT is not set
> 
> My resulting kernel image is:
> $ la /boot/vmlinuz-2.6.38.6
> -rw-r--r--  1 root root 1.6M May 17 23:55 vmlinuz-2.6.38.6
> 
> How much of that 1.6MB is XFS?

That's the compressed image that is 1.6MB, so the uncompressed
kernel will be quite a bit bigger than that. As it is, the XFs
binary size can be found from your source tree via:

$ size fs/xfs/xfs.ko
   text    data     bss     dec     hex filename
 468288   59632    1400  529320   813a8 fs/xfs/xfs.ko
$

So for my current kernel build on x86-64 with these options:

CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_DEBUG is not set

the XFS binary footprint is around 520kB. Yours will be smaller
given you don't have RT, ACL and quota configured, but it will still
probably be the largest single code block in your kernel...

> Also, what is the size of the hot
> path code that we want to stay in L1 during heavy IO?

Simple answer: it will stay in the L2 cache if we are lucky and
userspace doesn't trash the L2 cache between syscalls.

More complex answer: run perf w/ sampling on L1/L2 cache misses and
have a look for yourself.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
