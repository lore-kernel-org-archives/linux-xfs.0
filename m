Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9FCBC29DF8
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 20:40:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 378E6AC001
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 18:40:14 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	dVWM7zBm8kgOlond for <xfs@oss.sgi.com>;
	Thu, 03 Jul 2014 18:40:12 -0700 (PDT)
Date: Fri, 4 Jul 2014 11:40:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Got "Internal error XFS_WANT_CORRUPTED_GOTO". Filesystem needs
	reformatting to correct issue.
Message-ID: <20140704014008.GI9508@dastard>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<20140702120441.GA51757@bfoster.bfoster>
	<alpine.LSU.2.11.1407030057310.9881@Telcontar.valinor>
	<20140703094347.GU4453@dastard>
	<alpine.LSU.2.11.1407040113340.9881@Telcontar.valinor>
	<20140704000426.GX4453@dastard>
	<alpine.LSU.2.11.1407040317120.9881@Telcontar.valinor>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1407040317120.9881@Telcontar.valinor>
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
To: "Carlos E. R." <carlos.e.r@opensuse.org>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Fri, Jul 04, 2014 at 03:29:31AM +0200, Carlos E. R. wrote:
> On Friday, 2014-07-04 at 10:04 +1000, Dave Chinner wrote:
> >On Fri, Jul 04, 2014 at 01:34:52AM +0200, Carlos E. R. wrote:
> >>Ok, true, there is no formal "Oops".
> >>
> >>But no, the system does not remains fine, I had to hit the hardware
> >>reset or power off button to get out.
> >
> >That usually only happens when the root filesystem is shut down and
> >you can't access any of the binaries needed to run the system. Is
> >the filesystem that is shutting down the root?
> 
> No, it is not. Root is separate and using ext4. The problematic one
> is /home.
> 
> 
> What I did, as far I remember, was, when I noticed that home had
> failed and was read only, to switch to runlevel 1, umount /home
> (killing the apps that were still using it), then tried to mount it
> again to replay the log, prior to using xfs-repair on it. Mount
> hung. ctrl-alt-supr failed, or appeared to fail. So reset button...

That's a completely different issue to having a shutdown filesystem
hang your system. That's a mount problem, and likely a known issue.
You need to be specific when describing a problem, otherwise we
waste time going down the wrong paths.

> >>No, the on disk filesystem is not healthy. If I continue using it,
> >>after reboot and using "xfs_repair" several times, it fails again
> >>within a day.
> >
> >After at least one hibernation and thaw cycle, right?
> 
> Yes. 3, I think.

Then hibernation has caused the corruption. It may take some time
for the corruption to be detected, but there isn't any doubt in my
mind that hibernation is the cause of your problems.

So, until we have kernel fixes, you'd do best to turn off
hibernation. If you can't live with leaving your machine powered up
or switching it off, then use suspend-to-ram rather than
suspend-to-disk to avoid the problematic snapshot/restore
situation....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
