Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 28 Sep 2008 19:57:38 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8T2vZBE021672
	for <xfs@oss.sgi.com>; Sun, 28 Sep 2008 19:57:35 -0700
Message-ID: <48E046A3.3040607@sgi.com>
Date: Mon, 29 Sep 2008 13:08:19 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH v2] Use atomic_t and wait_event to track dquot pincount
References: <48D9C1DD.6030607@sgi.com> <48D9EB8F.1070104@sgi.com> <48D9EF6E.8010505@sgi.com> <20080924074604.GK5448@disturbed> <48D9F718.4010905@sgi.com> <20080925010318.GB27997@disturbed> <48DB4F3F.8040307@sgi.com> <48DC3682.2030602@sgi.com> <20080926112833.GB3287@infradead.org>
In-Reply-To: <20080926112833.GB3287@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Leckie <pleckie@sgi.com>, xfs@oss.sgi.com, xfs-dev@sgi.com

Christoph Hellwig wrote:
> On Fri, Sep 26, 2008 at 11:10:26AM +1000, Lachlan McIlroy wrote:
>> Good work Pete.  We should also consider replacing all calls to
>> wake_up_process() with wake_up() and a wait queue so we don't go
>> waking up threads when we shouldn't be.
> 
> No.  The daemons should not block anyway in these places, and using
> a waitqueue just causes additional locking overhead.
> 
> 

The daemons shouldn't block anymore in the code we are going to fix
but what about somewhere else?  Maybe in a memory allocation, semaphore,
mutex, etc... ?  Can you guarantee that there is no other code that does
not correctly handle waking up prematurely?

Just as it is prudent to be defensive and add a loop around the sv_wait()
we should also be prudent by not potentially causing this same problem in
some other buggy code somewhere else.  Using wait queues may add additional
locking overhead but if we are waking up threads that shouldn't be woken
up then we're wasting cycles on unnecessary context switches anyway.

Our customers wont notice if they lose a couple of cycles here or there but
they will notice deadlocks, corruption or panics.  And I would feel at ease
knowing this problem wont happen again.
