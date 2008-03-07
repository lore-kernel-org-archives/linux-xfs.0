Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 07 Mar 2008 15:47:00 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m27NkdQC011216
	for <xfs@oss.sgi.com>; Fri, 7 Mar 2008 15:46:40 -0800
Date: Sat, 8 Mar 2008 00:46:40 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: INFO: task mount:11202 blocked for more than 120 seconds
In-Reply-To: <20080307224040.GV155259@sgi.com>
Message-ID: <alpine.DEB.1.00.0803080032020.7723@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <20080307224040.GV155259@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Sat, 8 Mar 2008, David Chinner wrote:
> Well, if that is hung there, something else must be holding on to
> the iolock it's waiting on. What are the other D state processes in the
> machine?

I have 7 processes in D state so far:

$ ps auxww [....]
root      9844  0.0  0.0      0     0 ?   D    Mar06   0:22 [pdflush]
root      2697  0.0  0.0   4712   460 ?   D    Mar07   0:00 sync
root      8342  0.0  0.0   1780   440 ?   D    Mar07   0:01 /bin/rm -rf /data/md1/stuff
root     12494  0.0  0.0  11124  1228 ?   D    Mar07   0:14 /usr/bin/rsync 
root     15008  0.0  0.0   4712   460 ?   D    Mar07   0:00 sync
root     11202  0.0  0.0   5012   764 ?   D    Mar07   0:00 mount -o remount,ro /data/md1
root     15936  0.0  0.0   4712   460 ?   D    Mar07   0:00 sync

At one point I did a sysrq-D and put the results in:
http://nerdbynature.de/bits/2.6.25-rc4/hung_task/kern.log.gz
(grep for "SysRq : Show Locks Held" and "SysRq : Show Blocked State")

> Also, the iolock can be held across I/O so it's possible you've lost an I/O.
> Any I/O errors in the syslog?

No, no I/O errors at all. See the kern.log above, I could even do dd(1) 
from the md1 (dm-crypt on raid1), no errors either.

thanks,
Christian.
-- 
BOFH excuse #233:

TCP/IP UDP alarm threshold is set too low.
