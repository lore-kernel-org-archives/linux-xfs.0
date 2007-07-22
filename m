Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Jul 2007 16:37:37 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6MNbWbm001880
	for <xfs@oss.sgi.com>; Sun, 22 Jul 2007 16:37:34 -0700
Date: Mon, 23 Jul 2007 09:37:23 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 7/7] - remove unused variable from locking macros
Message-ID: <20070722233723.GI31489@sgi.com>
References: <46A03631.7060604@sandeen.net> <20070720073023.GE29295@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720073023.GE29295@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Fri, Jul 20, 2007 at 08:30:23AM +0100, Christoph Hellwig wrote:
> On Thu, Jul 19, 2007 at 11:12:33PM -0500, Eric Sandeen wrote:
> > The "s" in these locking macros used to be used like flags
> > in spin_lock_irqsave; but in the xfs codebase today it's 
> > never used.
> > 
> > gcc optimizes it away, but still, why keep it around?
> 
> If we change away from the IRIX compatible signatures we could just
> kill the lock wrappers aswell..

Hmmm - decisions, decisions... ;)

I think killing the wrappers entirely is probably the correct thing
to do. stuff like AIL_LOCK and GRANT_LOCK have long just been a
wrapper around a spinlock with no other purpose except to shout at
you.

If we are going to kill the spl return from the spinlocks, then
lets just churn this once. I'll sit on this one for a bit....

FWIW, Eric, if you do decide to modify the patch to kill all the
wrappers, can you send them as a patch-per-wrapper, just to make
it easy to review?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
