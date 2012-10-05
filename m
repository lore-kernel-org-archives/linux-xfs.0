Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9508eu2242228 for <xfs@oss.sgi.com>; Thu, 4 Oct 2012 19:08:40 -0500
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id okOEoOVEB3kZGeGn (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Oct 2012 17:10:05 -0700 (PDT)
Message-ID: <506E2558.2050003@tlinx.org>
Date: Thu, 04 Oct 2012 17:10:00 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: xfs_freeze same as umount?   How is that helpful?
References: <506DAB8C.9000601@tlinx.org>
	<CAGpXXZJuWRAMnJfZKJMZ3N=0EwcfYOEwX+iteyk9hY7ojWA+XA@mail.gmail.com>
	<506E1025.8050605@tlinx.org> <20121004233204.GB23644@dastard>
In-Reply-To: <20121004233204.GB23644@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Thu, Oct 04, 2012 at 03:39:33PM -0700, Linda Walsh wrote:
>> Greg Freemyer wrote:
>>> Conceptually it is typically:
>>> - quiesce system
>> ----
>> 	Um... it seems that this is equivalent to being
>> able to umount the disk?
> 
> NO, it's not. freeze intentionally leaves the log dirty, whereas
> unmount leaves it clean.
----
	That's what I thought!


> 
>> When I tried xfs_freeze / fs_freeze got fs-busy -- same as I would
>> if I tried to umount it.
> 
> Of course - it's got to write all the dirty data andmetadata in
> memory to disk. Freeze is about providing a stable, consistent disk
> image of the filesystem, so it must flush dirty objects from memory
> to disk to provide that.
----
	But it says the freeze failed.... huh.

Just tried it again .. ( first time after reboot.. froze it no
messages or complaints) ?!?!  I don't get it.


It gave me a file system busy message before and as near as I could tell --
it wouldn't allow me to xfs_freeze it.

Trying the same thing now -- no prob.

(though I am ALSO on a newer kernel -- had another problem I solved
in looking through the logs for hints about the freeze.


> 
>> I thought the point of xfs_freeze was to allow it to be brought to
>> a consistent state without unmounting it?
> 
> Exactly.
> 
>> Coincidentally, after trying a few freezes, the system froze.
> 
> Entirely possible if you froze the root filesystem and something you
> rely on tried to write to the filesystem.
---
	Nep... "/home", and running as root, in root partition with
/home elements removed from PATH.   trying to be careful.  Notice
I did say   'Coincidentally' -- (w no/quotes in original).  If I was
thought there might be a connection or problem, at the very least I would
have put 'coincidentally' in quotes.. :-)..


> 
> Anyway, a one-line "it froze" report doesn't tell us anything about
> the problem you saw. So:
----
	Wasn't sure what I saw or that it was related -- exactly...

A possible theory... but nothing I'd blaim on xfs,  -- last message in log was:


Oct  4 13:52:50 Ishtar kernel: [985735.911825] INFO: task fetchmail:25872 blocke
d for more than 120 seconds.
Oct  4 13:52:50 Ishtar kernel: [985735.918777] "echo 0 > /proc/sys/kernel/hung_t
ask_timeout_secs" disables this message.


My kernel *was* setup to panic on a hung task.... instead it just froze...
but why fetchmail hung... well if the xfs_freeze "partly took" and just issued
the error "because", then that process might have froze trying to write log messages
to /home partition.... but 120 secs?  seems like it might have been going down 
before
I tried anything with xfs_freeze...


But not sure what to report now, as it's not doing the same things.

Was running 3.2.29, am running 3.5.4 now.... but 3.2.29 had been up for over 10
days... so maybe something else was going on there...

Sorry, when I said corrupt... mis-statement on my part... dirty was what
I meant -- but corrupt from the standpoint that the data lacked sufficient integrity
for a blockget type operation.  But dirty would be more accurate in FS-lingo.

(still had my data-integrity hat on)...

So if I xfs-freeze something, then take a snapshot, -- I don't see that any of that
would help in doing an xfs_blockget o get a dump of inodes->blocks, as it sounds
like it would still be dirty...

Hey, I think xfs walks on water, so don't think I'm complaining...just
trying to figure things out.   It's been a good fs for me for over 10 years on
my home systems.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
