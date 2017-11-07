Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56676 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965011AbdKGKWo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Nov 2017 05:22:44 -0500
Date: Tue, 7 Nov 2017 11:22:41 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH for-4.14] xfs: fix AIM7 regression
Message-ID: <20171107102241.GE4359@quack2.suse.cz>
References: <20171019074705.24827-1-hch@lst.de>
 <20171019113848.GA8911@bfoster.bfoster>
 <20171019131407.GA20645@lst.de>
 <20171019224431.GO4755@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171019224431.GO4755@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, x86@kernel.org

On Thu 19-10-17 15:44:31, Darrick J. Wong wrote:
> On Thu, Oct 19, 2017 at 03:14:07PM +0200, Christoph Hellwig wrote:
> > On Thu, Oct 19, 2017 at 07:38:48AM -0400, Brian Foster wrote:
> > > On Thu, Oct 19, 2017 at 09:47:05AM +0200, Christoph Hellwig wrote:
> > > > Apparently our current rwsem code doesn't like doing the trylock, then
> > > > lock for real scheme.  So change our read/write methods to just do the
> > > > trylock for the RWF_NOWAIT case.  This fixes a ~25% regression in
> > > > AIM7.
> > > > 
> > > 
> > > The code looks fine, but this seems really strange. If the trylock
> > > fails, then wouldn't the blocking lock have slept anyways if done
> > > initially? Is there any more background info available on this, or
> > > perhaps a theory on why there is such a significant regression..?
> > 
> > No, unfortunately I don't have a theory, but I agree it is odd
> > behavior in the rwsem code.
> 
> <shrug> I want to know a little more about why there's a performance hit
> in the down_read_trylock -> down_read case.  Are we getting penalized
> for that?  Is it some weird interaction with lockdep?

At least on x86, __down_read_trylock() is implemented very much differently
from __down_read(). In particular if there's heavy contention on the
semaphore from readers, __down_read_trylock() implementation seems to be
prone to going through cmpxchg loop several times which could explain
observed performance data. But I'm just guessing... Adding some x86 people
to CC just in case they have more to say.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
