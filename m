Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Apr 2008 18:11:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m321Aoh2014887
	for <xfs@oss.sgi.com>; Tue, 1 Apr 2008 18:11:11 -0700
Date: Wed, 2 Apr 2008 09:24:06 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [Patch] Per iclog callback chain lock
Message-ID: <20080401232406.GX103491721@sgi.com>
References: <20080401231348.GT103491721@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401231348.GT103491721@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Apr 02, 2008 at 09:13:48AM +1000, David Chinner wrote:
> Introduce an iclog callback chain lock.
> 
> Rather than use the icloglock for protecting the iclog completion
> callback chain, use a new per-iclog lock so that walking the
> callback chain doesn't require holding a global lock.
> 
> This reduces contention on the icloglock during log buffer I/O
> completion as the callback chain lock is take for every callback
> that is issued.

This is not accurate - the callback chain is removed in bulk
then walked without the lock, but will loop over the iclog
chain in case callbacks were added while processing the chain
(not sure if that can even happen, though).

[mental note - don't write patch descriptions before first coffee
completion occurs.]

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
