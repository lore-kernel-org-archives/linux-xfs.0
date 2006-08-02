Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Aug 2006 07:23:21 -0700 (PDT)
Received: from apple.cjx.com (37.233.187.81.in-addr.arpa [81.187.233.37])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k72EN5DW010265
	for <linux-xfs@oss.sgi.com>; Wed, 2 Aug 2006 07:23:10 -0700
Received: from [10.0.1.8] (mac.cjx.com [10.0.1.8])
	(authenticated bits=0)
	by apple.cjx.com (8.12.11/8.12.11) with ESMTP id k72D3Hmf024295
	for <linux-xfs@oss.sgi.com>; Wed, 2 Aug 2006 14:03:17 +0100
Message-ID: <44D0A296.9020307@cjx.com>
Date: Wed, 02 Aug 2006 14:03:18 +0100
From: Chris Allen <chris@cjx.com>
MIME-Version: 1.0
Subject: XFS stack space crashes - current status?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

I have a box running XFS over md (raid5) over Fedora core5 2.6.17-1 kernel.

The box contains 16x750GB SATA drives combined into a single 11TB raid5
partition using md, and this partition contains a single XFS filesystem.

I can consistently crash the box within about ten minutes with a simple
perl script that spawns 25 processes each of which loop writing random
files to the filesystem.

The only message I get on the console is something like this:

do_IRQ: stack overflow: 492
 <c0406460>

Once crashed, the box requires a hard reboot to rescue it (and needs to 
resync
the RAID array).


As the box is to be used for a production upload fileserver receiving 
several hundred
simultaneous uploads, I would most likely be seeing this problem lots.

So..... questions:

1. How much is known about this problem? Seeing as it is 100% reproducible,
is there any active development underway to fix it?

2. I have seen postings that say compiling a kernel with 8K stacks will 
fix the
problem. Is this the case? Or will I be able to trigger it again by 
running 100 or
200 simultaneous writes?

3. Any suggestions as to what I should try? At present it looks like I 
am stuck between
finding a fix for XFS and splitting the box into 2 or 3 EXT3 partitions 
(which I really don't
want to do). I have tried ReiserFS (max FS size is 8TB even though the 
FAQ says 16), and
JFS (jfs_fsck segfaults which doesn't fill me with confidence).


Many thanks for any suggestions,

Chris Allen.
