Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 28 Mar 2007 17:33:13 -0700 (PDT)
Received: from ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2T0X96p029987
	for <xfs@oss.sgi.com>; Wed, 28 Mar 2007 17:33:09 -0700
Message-ID: <460B068C.6060903@tlinx.org>
Date: Wed, 28 Mar 2007 17:21:32 -0700
From: Linda Walsh <lkml@tlinx.org>
MIME-Version: 1.0
Subject: Re: Corrupt XFS -Filesystems on new Hardware and Kernel
References: <46094344.4090007@j-o-a.de> <20070328113141.GQ32597093@melbourne.sgi.com> <460A6298.4040702@j-o-a.de> <460A821B.4080308@sandeen.net> <460AC857.6040305@j-o-a.de>
In-Reply-To: <460AC857.6040305@j-o-a.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Oliver Joa <oliver@j-o-a.de>
Cc: Eric Sandeen <sandeen@sandeen.net>, David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>

Oliver Joa wrote:
>> eason or another, xfs has detected a corrupted on-disk inode format 
>> which it cannot recognize, and shuts down.  It is likely the result 
>> of something which has gone wrong previously.  xfs_repair should fix 
>> it.  Are there other non-xfs messages in your logs indicating other 
>> problems prior to this?
> i sent already the dmesg output to the list. there is nothing else.
> I made a xfs_repair. Now I have some Files in lost+found.
> So I tried it again with a new cable:
---
    I doubt it has changed significantly, but xfs was designed for
stable hardware.  That doesn't mean you can't pull the plug, but if
you are getting SATA resets, you may be getting some writes aborted,
with subsequent writes going through (speculation).  I know when
I had a flakey SCSI disk problem (was cable or connector in my
case), I'd get a rare XFS corruption (out of ~10 years of XFS use,
maybe 2-3 corruptions, all caused by loose connections, cables, etc).

    I'd strongly suggest you get to the bottom of the SATA reset
problem.  After that is fixed, then try to clean up your XFS disks (or
restore from backups).  Sometimes, after some intermittent hardware
problems, my xfs file system was too corrupt for me to repair (at
least with default xfs_repair options).  Doesn't mean it was irreparable,
just, I didn't know how to proceed and it was easier to restore from
a daily backup than attempt to manually repair the damage.

    The above is based solely on my own experience.  I use xfs
with max(8?) logbuffs, and noatime/nodiratime, and find it to have among
the best performance characteristics of any file system (overall;
lowest performance aspect was file delete).
    XFS has a low fragmentation rate, due to how it allocates
space and can delay writes.  Even so, it is also one of the few
file systems (only?) that comes with a "defragmenter"
(xfs_fsr (file system reorganizer)).

Sgi used to ship systems with xfs_fsr configured to run
weekly to "watch out for" rare, degenerate cases (important for some
real-time video apps).  My cron runs it nightly,  but often it
will pass through all file systems making no changes.

Fix the flakey hw -- then see if your xfs probs don't "magically"
go away...however, YMMV...

Linda
