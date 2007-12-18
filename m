Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Dec 2007 06:30:34 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBIEUQeD006596
	for <linux-xfs@oss.sgi.com>; Tue, 18 Dec 2007 06:30:27 -0800
Received: from mallaury.nerim.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C9B44971C1
	for <linux-xfs@oss.sgi.com>; Tue, 18 Dec 2007 06:30:34 -0800 (PST)
Received: from mallaury.nerim.net (smtp-102-tuesday.noc.nerim.net [62.4.17.102]) by cuda.sgi.com with ESMTP id KwHMKe13OoEWEblC for <linux-xfs@oss.sgi.com>; Tue, 18 Dec 2007 06:30:34 -0800 (PST)
From: Damien Wyart <damien.wyart@free.fr>
Subject: Re: Important regression with XFS update for 2.6.24-rc6
References: <20071218112804.GA3069@localhost.localdomain>
	<20071218122445.GJ4396912@sgi.com>
Date: Tue, 18 Dec 2007 15:30:31 +0100
In-Reply-To: <20071218122445.GJ4396912@sgi.com> (David Chinner's message of
	"Tue, 18 Dec 2007 23:24:45 +1100")
Message-ID: <877ijckrco.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Lachlan McIlroy <lachlan@sgi.com>, Peter Leckie <pleckie@sgi.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>

* David Chinner <dgc@sgi.com> [071218 13:24]:
> Ok. I haven't noticed anything wrong with directories up to about
> 250,000 files in the last few days. The ls -l I just did on
> a directory with 15000 entries (btree format) used about 5MB of RAM.
> extent format directories appear to work fine as well (tested 500
> entries).

Ok, nice to know the problem is not so frequent.

> Can you:

> 	a) isolate the problem to one patch or the other. My guess
> 	   would be the directory mod, but.....

Yes, it is indeed the directory patch. But even if I still sometimes get
huge memory usage with ls (using the patched kernel), this is quite
rare, and the problem is now mainly getting entries in the listing
repeated, and the ls process taking longer than without the patch. But
this is mainly after booting. I guess the cache plays a role and even
using drop_caches, I can't reproduce the problem. Only on fresh reboot
do I get it systematically, but much less often the memory problem. And
as said earlier, after fresh boot on rc5-git5 without the directory
patch, the ls -l goes normal (no repeated entries).

> 	b) show your working ;)

Sorry, I forgot this part in my initial report.

> 		- what platform (i386, x86_64, etc)

i386.

> 		- what debug options

Nothing special, the kernel has 4K stacks, and xfs partitions are
mounted with noatime,nodiratime.

> 		- commands and output that shows the problem

It is mainly "ls -l" in a quite crowded directory.

> 		- strace of ls -l going bad
> 		- xfs_info from filesystem in question

I have put the files at http://damien.wyart.free.fr/xfs/

strace_xfs_problem.1.gz and strace_xfs_problem.2.gz have been created
with the problematic kernel, and are quite bigger than
strace_xfs_problem.normal.gz, which has been created with the vanilla
rc5-git5. There is also xfs_info.


I can provide further details if needed (maybe kernel config, but
nothing special on the xfs side), but I confirm the behavior is
different with and without the directory patch
(041388b54ed95cd169546bd83bacd08ee32bd7ea on oss.sgi), and doesn't look
normal with the patch.

-- 
Damien Wyart
