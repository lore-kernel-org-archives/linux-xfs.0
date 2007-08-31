Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 31 Aug 2007 08:11:12 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7VFB84p004290
	for <xfs@oss.sgi.com>; Fri, 31 Aug 2007 08:11:10 -0700
Message-ID: <46D82F9A.9090606@sandeen.net>
Date: Fri, 31 Aug 2007 10:11:22 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Increase lockdep MAX_LOCK_DEPTH
References: <46D79C62.1010304@sandeen.net> <1188542389.6112.44.camel@twins>	 <20070831135042.GD422459@sgi.com> <1188570831.6112.64.camel@twins>	 <20070831150511.GA734179@sgi.com> <1188572961.6112.72.camel@twins>
In-Reply-To: <1188572961.6112.72.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Chinner <dgc@sgi.com>, linux-kernel Mailing List <linux-kernel@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>, Ingo Molnar <mingo@elte.hu>

Peter Zijlstra wrote:
> On Sat, 2007-09-01 at 01:05 +1000, David Chinner wrote:
> 
>>> Trouble is, we'd like to have a sane upper bound on the amount of held
>>> locks at any one time, obviously this is just wanting, because a lot of
>>> lock chains also depend on the number of online cpus...
>> Sure - this is an obvious case where it is valid to take >30 locks at
>> once in a single thread. In fact, worst case here we are taking twice this
>> number of locks - we actually take 2 per inode (ilock and flock) so a
>> full 32 inode cluster free would take >60 locks in the middle of this
>> function and we should be busting this depth couter limit all the
>> time. 
> 
> I think this started because jeffpc couldn't boot without XFS busting
> lockdep :-)
> 
>> Do semaphores (the flush locks) contribute to the lock depth
>> counters? 
> 
> No, alas, we cannot handle semaphores in lockdep.

That explains why 40 was enough for me, I guess :)

-Eric
