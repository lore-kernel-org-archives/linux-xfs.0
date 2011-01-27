Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0R3RqcW183358 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 21:27:53 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E1058148F393
	for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 19:30:14 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	6N625qkLrTfpkOe2 for <xfs@oss.sgi.com>;
	Wed, 26 Jan 2011 19:30:14 -0800 (PST)
Date: Thu, 27 Jan 2011 14:30:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: very slow after mount, very slow at umount
Message-ID: <20110127033011.GH21311@dastard>
References: <4D40C8D1.8090202@teksavvy.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D40C8D1.8090202@teksavvy.com>
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
To: Mark Lord <kernel@teksavvy.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, Linux Kernel <linux-kernel@vger.kernel.org>, Alex Elder <aelder@sgi.com>

[Please cc xfs@oss.sgi.com on XFS bug reports. Added.]

On Wed, Jan 26, 2011 at 08:22:25PM -0500, Mark Lord wrote:
> Alex / Christoph,
> 
> My mythtv box here uses XFS on a 2TB drive for storing recordings and videos.
> It is behaving rather strangely though, and has gotten worse recently.
> Here is what I see happening:
> 
> The drive mounts fine at boot, but the very first attempt to write a new file
> to the filesystem suffers from a very very long pause, 30-60 seconds, during which
> time the disk activity light is fully "on".

Please post the output of xfs_info <mtpt> so we can see what you
filesystem configuration is.

> This happens only on the first new file write after mounting.
> From then on, the filesystem is fast and responsive as expected.
> If I umount the filesystem, and then mount it again,
> the exact same behaviour can be observed.

I can't say I've seen this. Can you capture a blktrace of the IO so
we can see what IO is actually being done, and perhaps also record
an XFS event trace as well (i.e. of all the events in
/sys/kernel/debug/tracing/events/xfs).

> This of course screws up mythtv, as it causes me to lose the first 30-60
> seconds of the first recording it attempts after booting.  So as a workaround
> I now have a startup script to create, sync, and delete a 64MB file before
> starting mythtv.  This still takes 30-60 seconds, but it all happens and
> finishes before mythtv has a real-time need to write to the filesystem.
> 
> The 2TB drive is fine -- zero errors, no events in the SMART logs,
> and I've disabled the silly WD head-unload logic on it.
> 
> What's happening here?  Why the big long burst of activity?
> I've only just noticed this behaviour in the past few weeks,
> running 2.6.35 and more recently 2.6.37.

Can you be a bit more precise? what were you running before 2.6.35
when you didn't notice this?

> * * *
> 
> The other issue is something I notice at umount time.
> I have a second big drive used as a backup device for the drive discussed above.
> I use "mirrordir" (similar to rsync) to clone directories/files from the main
> drive to the backup drive.  After mirrordir finishes, I then "umount /backup".
> The umount promptly hangs, disk light on solid, for 30-60 seconds, then finishes.

Same again - blktrace and event traces for the different cases.

Also, how many files are you syncing? how much data, number of
inodes, etc...

> If I type "sync" just before doing the umount, sync takes about 1 second,
> and the umount finishes instantly.
> 
> Huh? What's happening there?

Sounds like something is broken w.r.t. writeback during unmount.
Perhaps also adding the writeback events to the trace would help
understand what is happening here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
