Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Aug 2006 13:21:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k72KKoDW014481
	for <linux-xfs@oss.sgi.com>; Wed, 2 Aug 2006 13:20:50 -0700
Message-ID: <44D0F61A.5070200@sandeen.net>
Date: Wed, 02 Aug 2006 13:59:38 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS stack space crashes - current status?
References: <44D0A296.9020307@cjx.com>
In-Reply-To: <44D0A296.9020307@cjx.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Allen <chris@cjx.com>
Cc: linux-xfs@oss.sgi.com

Chris Allen wrote:

> So..... questions:
> 
> 1. How much is known about this problem? Seeing as it is 100% reproducible,
> is there any active development underway to fix it?

XFS is a lot less stack-heavy than it used to be, but if you put enough 
IO code between sys_write and your disks, it can all add up to a problem.

> 2. I have seen postings that say compiling a kernel with 8K stacks will 
> fix the
> problem. Is this the case? Or will I be able to trigger it again by 
> running 100 or
> 200 simultaneous writes?

More threads probably won't matter.

> 3. Any suggestions as to what I should try? At present it looks like I 
> am stuck between
> finding a fix for XFS and splitting the box into 2 or 3 EXT3 partitions 
> (which I really don't
> want to do). I have tried ReiserFS (max FS size is 8TB even though the 
> FAQ says 16), and
> JFS (jfs_fsck segfaults which doesn't fill me with confidence).

If you can run w/ 8k stacks you will probably be in better shape.

If you want to do a bit of testing, go into do_IRQ() and change the 
warning threshold (STACK_WARN) to something slightly bigger, so that 
you'll get the warning message earlier, and you should also get a 
backtrace that tells you how you got there.

-Eric

> 
> Many thanks for any suggestions,
> 
> Chris Allen.
> 
> 
> 
> 
