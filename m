Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 08:04:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9MF4TkF016224
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 08:04:30 -0700
Received: from saeurebad.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0BB6510C887E
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 08:06:14 -0700 (PDT)
Received: from saeurebad.de (saeurebad.de [85.214.36.134]) by cuda.sgi.com with ESMTP id vJk4IKDW9fiqYeAV for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 08:06:14 -0700 (PDT)
From: Johannes Weiner <hannes@saeurebad.de>
Subject: Re: BUG: sleeping function called from invalid context at kernel/rwsem.c:131 XFS?
References: <20081017165738.GA20818@infradead.org>
	<a4423d670810171013g5bc19c1cm3f7d9c014ee70349@mail.gmail.com>
	<20081017203710.GA27187@infradead.org>
	<20081017135510.7127c4e7@infradead.org>
	<a4423d670810200758m3cea3841h40988afc8eaf81@mail.gmail.com>
	<20081020163327.GA15651@infradead.org>
	<a4423d670810201013w6448cb38w402771799cefb5f5@mail.gmail.com>
	<20081020223549.GA21152@disturbed>
	<a4423d670810210442y51b62fc2naf6cb649e6b26942@mail.gmail.com>
	<20081022075838.GK18495@disturbed> <20081022082550.GM18495@disturbed>
Date: Wed, 22 Oct 2008 17:06:02 +0200
In-Reply-To: <20081022082550.GM18495@disturbed> (Dave Chinner's message of
	"Wed, 22 Oct 2008 19:25:50 +1100")
Message-ID: <87y70gk6ud.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: lachlan@sgi.com, Christoph Hellwig <hch@infradead.org>, Arjan van de Ven <arjan@infradead.org>, xfs@oss.sgi.com, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

Dave Chinner <david@fromorbit.com> writes:

> On Wed, Oct 22, 2008 at 06:58:38PM +1100, Dave Chinner wrote:
>> On Tue, Oct 21, 2008 at 03:42:16PM +0400, Alexander Beregalov wrote:
>> > Bisected to:
>> > dd509097cb0b76d3836385f80d6b2d6fd3b97757 is first bad commit
>> > commit dd509097cb0b76d3836385f80d6b2d6fd3b97757
>> > Author: Lachlan McIlroy <lachlan@sgi.com>
>> > Date:   Mon Sep 29 14:56:40 2008 +1000
>> > 
>> >     [XFS] Unlock inode before calling xfs_idestroy()
>> > 
>> >     Lock debugging reported the ilock was being destroyed without being
>> >     unlocked. We don't need to lock the inode until we are going to insert it
>> >     into the radix tree.
>> 
>> Ah, OK, I see the problem, though I don't understand why I'm not
>> seeing the might_sleep() triggering all the time given that I always
>> build with:
>> 
>> $ grep SLEEP .config
>> CONFIG_DEBUG_SPINLOCK_SLEEP=y
>> 
>> Basically the above commit moved xfs_ilock() inside
>> radix_tree_preload()/radix_tree_preload_end(), which means we are
>> taking a rwsem() while we have an elevated preempt count. I'll
>> get a patch out to fix it.
>
> Patch below (against the xfs master/linux-next branch) should fix the
> regression. I've just started QA on it. Can you please check that
> it works for you, Alexander?

Ran into the same problem, the fix worked for me.

Thank you.

	Hannes
