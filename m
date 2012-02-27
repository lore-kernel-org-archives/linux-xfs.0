Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1R0n7S9009047 for <xfs@oss.sgi.com>; Sun, 26 Feb 2012 18:49:07 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	qIRL5RVDqWqQanmU for <xfs@oss.sgi.com>;
	Sun, 26 Feb 2012 16:49:05 -0800 (PST)
Date: Mon, 27 Feb 2012 11:49:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: mount: Structure needs cleaning
Message-ID: <20120227004902.GQ3592@dastard>
References: <33393100.post@talk.nabble.com>
	<4F49B693.4080309@hardwarefreak.com>
	<33393429.post@talk.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <33393429.post@talk.nabble.com>
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
To: MikeJeezy <forums@mgaccess.net>
Cc: xfs@oss.sgi.com

On Sat, Feb 25, 2012 at 11:22:29PM -0800, MikeJeezy wrote:
> 
> 
> On 02/25/2012 10:35pm, Stan Hoeppner wrote:
> >Can you run xfs_check on the filesystem to determine if a freespace
> >tree is corrupted (post the output if it is), then run xfs_repair
> >to rebuild them?"
> 
> Thank you for responding.  This is a 24/7 production server and I did not
> anticipate getting a response this late on a Saturday, so I panicked quite
> frankly, and went ahead and ran "xfs_repair -L" on both volumes.

The only reason for running xfs-repair -L is if you cannot mount the
filesystem to replay the log. i.e. on a shutdown like this, the
usual process is:

<shutdown>
umount <dev>
mount <dev>
umount <dev>
xfs_repair <dev>

The only reason for needing to run "xfs-repair -L <dev>" is if the
mount after the shutdown fails to run log recovery.

> I can now
> mount the volumes and everything looks okay as far as I can tell.  There
> were only 2 files in the "lost+found" directory after the repair.  Does that
> mean only two files were lost?  Is there any way to tell how many files were
> lost?

YOu can only find out by looking at what the output of xfs_repair
told you about trashing inodes/directories.

> >This corruption could have happened a long time ago in the past, and
> >it may simply be coincidental that you've tripped over this at
> >roughly the same time you upgraded the kernel.
> 
> It would be nice to find out why this happened.  I suspect it is as you
> suggested, previous corruption and not a hardware issue, because I have
> other volumes mounted to other VM's that are attached to the same SAN
> controller / RAID6 Array... and they did not have any issues - only this one
> VM.
> 
> >So, run "xfs_check /dev/sde1" and post the output here.  Then await
> >further instructions.  
> 
> Can I still do this (or anything) to help uncover any causes or is it too
> late?  I have also run yum update on the server because it was out of date.

Too late. As it is, xfs-check is deprecated. use "xfs_repair -n
<dev>" to check a filesystem for errors without modifying/fixing
anything.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
