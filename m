Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 17 May 2008 11:37:33 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4HIbSNW014144
	for <xfs@oss.sgi.com>; Sat, 17 May 2008 11:37:29 -0700
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7BEFC1B95BD0
	for <xfs@oss.sgi.com>; Sat, 17 May 2008 11:38:17 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [140.211.169.13]) by cuda.sgi.com with ESMTP id u0ZS5CnYEdRkAJ3V for <xfs@oss.sgi.com>; Sat, 17 May 2008 11:38:17 -0700 (PDT)
Date: Sat, 17 May 2008 11:37:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: XFS/md/blkdev warning (was Re: Linux 2.6.26-rc2)
In-Reply-To: <200805171922.56272.alistair@devzero.co.uk>
Message-ID: <alpine.LFD.1.10.0805171131000.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805120731480.3188@woody.linux-foundation.org> <alpine.LFD.1.10.0805120933310.3019@woody.linux-foundation.org> <20080512164920.GE16217@kernel.dk> <200805171922.56272.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>, xfs@oss.sgi.com, Neil Brown <neilb@suse.de>, Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org



On Sat, 17 May 2008, Alistair John Strachan wrote:
>
> My guess is that when the kernel runs out of MemFree and starts reclaiming the 
> cache, something is deadlocking somewhere. Just doing a:
> 
> cat /dev/zero >/path/to/file

Do this on the console (and having a serial console or working netconsole 
is a wonderful thing to log it, because otherwise it will generally just 
scroll off the screen), and trigger SysRQ-w. That dumps all blocked tasks 
to the screen.

You may need to do

	echo 1 > /proc/sys/kernel/sysrq 

before that to enable it.

(Or if you have some things still running because they haevn't hit the 
lock that causes the deadlock, you can try

	echo w > /proc/sysrq-trigger

rather than the key combination).

			Linus
