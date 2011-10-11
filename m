Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9B25v8c220119 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 21:05:58 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 518551B7B3D
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 19:05:55 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	MiQNLYuRqx7ox722 for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 19:05:55 -0700 (PDT)
Date: Tue, 11 Oct 2011 13:05:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: TRIM on XFS
Message-ID: <20111011020552.GY3159@dastard>
References: <201110071352.20135@zmi.at> <20111007233450.GK3159@dastard>
	<201110100829.45823@zmi.at>
	<CAGpXXZJs8kjZaSp248rA+-d=gpwWe=oK0xtUUirv+zgE3Vq3kA@mail.gmail.com>
	<4E936BFB.5060907@mnsu.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E936BFB.5060907@mnsu.edu>
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
To: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
Cc: xfs@oss.sgi.com

On Mon, Oct 10, 2011 at 05:04:43PM -0500, Jeffrey Hundstad wrote:
> On 10/10/2011 03:28 PM, Greg Freemyer wrote:
> >fitrim is the batch mode.
> >
> >To enable realtime discard, add --discard to your mount options.
> >
> >Documented athttp://lxr.linux.no/#linux+v3.0.4/Documentation/filesystems/xfs.txt
> >
> >To invoke batch mode, simply use fstrim from user space.
> 
> Hello,
> 
> I'm also trying to use FITRIM on a simple XFS partition on a
> spinning magnetic hard drive (remember those).  I haven't had much
> luck.  I'm doing this just to get used to the commands when using
> this against a thinly provisioned disk.  I have no idea if this
> should work in this configuration.
> 
> On a Debian system with Linux 3.0.0-2-amd64 when I issue:
> # fstrim /
> 
> I receive:
> fstrim: /: FITRIM ioctl failed: Operation not supported
> 
> With an strace this looks like:
> open("/", O_RDONLY)                     = 3
> ioctl(3, 0xc0185879, 0x7fff4ea851b0)    = -1 EOPNOTSUPP (Operation
> not supported)

It means the block device underneath the filesystem doesn't support
the TRIM operation. Check /sys/block/<dev>/queue/discard_max_bytes -
if the value is zero then your device doesn't support discard
operations.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
