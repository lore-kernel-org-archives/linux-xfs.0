Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 958837F73
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 08:22:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1618AAC001
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 06:22:27 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Y9eB4pi9T1Ub3rAM for <xfs@oss.sgi.com>;
	Thu, 03 Sep 2015 06:22:24 -0700 (PDT)
Subject: Re: xfs corruption
References: <CAC=x_0hAQR9Ynmnqohv1R8xv3TBot5wmn7DODx6GbKU7tYv2sA@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <55E8498F.8090508@sandeen.net>
Date: Thu, 3 Sep 2015 08:22:23 -0500
MIME-Version: 1.0
In-Reply-To: <CAC=x_0hAQR9Ynmnqohv1R8xv3TBot5wmn7DODx6GbKU7tYv2sA@mail.gmail.com>
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
To: Danny Shavit <danny@zadarastorage.com>, xfs@oss.sgi.com
Cc: Alex Lyakas <alex@zadarastorage.com>

On 9/3/15 6:09 AM, Danny Shavit wrote:
> Hi Dave,
> 
> We couple of more xfs corruption that we would like to share:

On the same box as the one that seemed to be experiencing some
bit-flips in your earlier email?

As a general note: You are not providing enough information for
us to effectively help you.

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Kernel version?  xfsprogs version?  At a bare minimum...

Your dmesg snippets are edited.  You've provided what you feel is
important, omitting the parts that may actually be important or
informational.

You haven't described the sequence of events that led to these issues.

You haven't made clear what these attachments are; which repair log goes
with which kernel event?

Etc...

> 1. This is an interesting one, since xfs reported corruption but when
> running xfs_repair, no error was found. Attached is the kernel log
> section regarding the corruption (6458). Does xfs_repair explicitly
> read data from the disk? In such case it might be a memory
> corruption. Are you familiar with such cases?

Yes, xfs_repair opens the block device O_DIRECT.

your 6485-kernel.log shows a failure in xfs_allocbt_verify(), right
after the allocation btree is read from disk.  i.e. this is an in-kernel
metadata consistency check that is failing.

It also shows:

kworker/0:1H Tainted: GF       W 

So it's tainted:

  2: 'F' if any module was force loaded by "insmod -f", ' ' if all
     modules were loaded normally.

 10: 'W' if a warning has previously been issued by the kernel.
     (Though some warnings may set more specific taint flags.)

You force-loaded a module?  And previous warnings were emitted (though we
can't see them in your edited dmesg).  
All bets are off.  If you had included the full dmesg, we might know 
more about what's going on, at least.

> 2. xfs corruption occurred suddenly with no apparent external event.
>  Attached are xfs_repair and kernel logs are. Xfs dump can be found
> in: https://zadarastorage-public.s3.amazonaws.com/xfs/82.metadump.gz

Your 6442-82-xfs_repair.log is from an xfs_repair -L, so of course it
is finding corruption, and the output is more or less meaningless
from a triage POV.  Repair said:

> Note that destroying the log may cause corruption -- please attempt a mount
> of the filesystem before doing this.

Why did you run it with -L? Did mount fail? If so how?

dm-82-kernel.log also shows a failing verifier, this time xfs_bmbt_verify,
when reading metadata from disk.

You've truncated other parts, though:

Aug 22 23:24:48 vsa-00000110-vc-0 kernel: [4194599.685353] ffff88010ec36000: ea bb 12 3a 5f 44 01 a8 b9 2a 80 10 b3 a7 d5 af  ...:_D...*
......

so there's not a ton to go on, just hints that there is more information
that's not provided.


-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
