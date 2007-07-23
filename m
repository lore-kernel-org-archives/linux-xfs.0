Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jul 2007 06:55:13 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6NDt6bm019320
	for <xfs@oss.sgi.com>; Mon, 23 Jul 2007 06:55:08 -0700
Message-ID: <46A4B33C.7060404@sandeen.net>
Date: Mon, 23 Jul 2007 08:55:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 7/7] - remove unused variable from locking macros
References: <46A03631.7060604@sandeen.net> <20070720073023.GE29295@infradead.org> <20070722233723.GI31489@sgi.com>
In-Reply-To: <20070722233723.GI31489@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> On Fri, Jul 20, 2007 at 08:30:23AM +0100, Christoph Hellwig wrote:
>> On Thu, Jul 19, 2007 at 11:12:33PM -0500, Eric Sandeen wrote:
>>> The "s" in these locking macros used to be used like flags
>>> in spin_lock_irqsave; but in the xfs codebase today it's 
>>> never used.
>>>
>>> gcc optimizes it away, but still, why keep it around?
>> If we change away from the IRIX compatible signatures we could just
>> kill the lock wrappers aswell..
> 
> Hmmm - decisions, decisions... ;)
> 
> I think killing the wrappers entirely is probably the correct thing
> to do. stuff like AIL_LOCK and GRANT_LOCK have long just been a
> wrapper around a spinlock with no other purpose except to shout at
> you.
> 
> If we are going to kill the spl return from the spinlocks, then
> lets just churn this once. I'll sit on this one for a bit....
> 
> FWIW, Eric, if you do decide to modify the patch to kill all the
> wrappers, can you send them as a patch-per-wrapper, just to make
> it easy to review?

Ok...

Russell suggested "xfs_spinlock"  ;-)  I assume you want to just use the
linux native locking calls?

-Eric
