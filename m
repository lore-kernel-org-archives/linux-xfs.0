Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 17 May 2008 11:40:48 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4HIejaM014731
	for <xfs@oss.sgi.com>; Sat, 17 May 2008 11:40:46 -0700
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F26416DFCE2
	for <xfs@oss.sgi.com>; Sat, 17 May 2008 11:41:33 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [140.211.169.13]) by cuda.sgi.com with ESMTP id Pze1DTxfKNnJ4Sme for <xfs@oss.sgi.com>; Sat, 17 May 2008 11:41:33 -0700 (PDT)
Date: Sat, 17 May 2008 11:41:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: XFS/md/blkdev warning (was Re: Linux 2.6.26-rc2)
In-Reply-To: <alpine.LFD.1.10.0805171131000.3020@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805171139120.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805120731480.3188@woody.linux-foundation.org> <alpine.LFD.1.10.0805120933310.3019@woody.linux-foundation.org> <20080512164920.GE16217@kernel.dk> <200805171922.56272.alistair@devzero.co.uk>
 <alpine.LFD.1.10.0805171131000.3020@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>, xfs@oss.sgi.com, Neil Brown <neilb@suse.de>, Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org



On Sat, 17 May 2008, Linus Torvalds wrote:
> 
> Do this on the console (and having a serial console or working netconsole 
> is a wonderful thing to log it, because otherwise it will generally just 
> scroll off the screen), and trigger SysRQ-w. That dumps all blocked tasks 
> to the screen.

Another thing to try is to enable lock debugging, and have

	CONFIG_DEBUG_SPINLOCK=y
	CONFIG_DEBUG_MUTEXES=y
	CONFIG_DEBUG_LOCK_ALLOC=y
	CONFIG_PROVE_LOCKING=y
	CONFIG_LOCKDEP=y
	CONFIG_DEBUG_LOCKDEP=y

in your kernel .config file. It has performance implications, of course, 
but it can help debug incorrect locking much more quickly.

		Linus
