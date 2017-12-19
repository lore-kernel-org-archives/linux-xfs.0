Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751128AbdLSROf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Dec 2017 12:14:35 -0500
Message-ID: <1513703670.20392.21.camel@kernel.org>
Subject: Re: [PATCH v3 19/19] fs: handle inode->i_version more efficiently
From: Jeff Layton <jlayton@kernel.org>
Date: Tue, 19 Dec 2017 12:14:30 -0500
In-Reply-To: <20171219092947.GC2277@quack2.suse.cz>
References: <20171218151156.14565-1-jlayton@kernel.org>
         <20171218151156.14565-20-jlayton@kernel.org>
         <20171218163418.GF30350@quack2.suse.cz>
         <1513617740.3422.30.camel@kernel.org>
         <20171219092947.GC2277@quack2.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com

On Tue, 2017-12-19 at 10:29 +0100, Jan Kara wrote:
> On Mon 18-12-17 12:22:20, Jeff Layton wrote:
> > On Mon, 2017-12-18 at 17:34 +0100, Jan Kara wrote:
> > > On Mon 18-12-17 10:11:56, Jeff Layton wrote:
> > > >  static inline bool
> > > >  inode_maybe_inc_iversion(struct inode *inode, bool force)
> > > >  {
> > > > -	atomic64_t *ivp = (atomic64_t *)&inode->i_version;
> > > > +	u64 cur, old, new;
> > > >  
> > > > -	atomic64_inc(ivp);
> > > > +	cur = (u64)atomic64_read(&inode->i_version);
> > > > +	for (;;) {
> > > > +		/* If flag is clear then we needn't do anything */
> > > > +		if (!force && !(cur & I_VERSION_QUERIED))
> > > > +			return false;
> > > 
> > > The fast path here misses any memory barrier. Thus it seems this query
> > > could be in theory reordered before any store that happened to modify the
> > > inode? Or maybe we could race and miss the fact that in fact this i_version
> > > has already been queried? But maybe there's some higher level locking that
> > > makes sure this is all a non-issue... But in that case it would deserve
> > > some comment I guess.
> > > 
> > 
> > There's no higher-level locking. Getting locking out of this codepath is
> > a good thing IMO. The larger question here is whether we really care
> > about ordering this with anything else.
> > 
> > The i_version, as implemented today, is not ordered with actual changes
> > to the inode. We only take the i_lock today when modifying it, not when
> > querying it. It's possible today that you could see the results of a
> > change and then do a fetch of the i_version that doesn't show an
> > increment vs. a previous change.
> 
> Yeah, so I don't suggest that you should fix unrelated issues but original
> i_lock protection did actually provide memory barriers (although
> semi-permeable, but in practice they are very often enough) and your patch
> removing those could have changed a theoretical issue to a practical
> problem. So at least preserving that original acquire-release semantics
> of i_version handling would be IMHO good.
> 

Agreed. I've no objection to memory barriers here and I'm looking at
that, I just need to go over Dave's comments and memory-barriers.txt
(again!) to make sure I get them right.

> > It'd be nice if this were atomic with the actual changes that it
> > represents, but I think that would be prohibitively expensive. That may
> > be something we need to address. I'm not sure we really want to do it as
> > part of this patchset though.
> > 
> > > > +
> > > > +		/* Since lowest bit is flag, add 2 to avoid it */
> > > > +		new = (cur & ~I_VERSION_QUERIED) + I_VERSION_INCREMENT;
> > > > +
> > > > +		old = atomic64_cmpxchg(&inode->i_version, cur, new);
> > > > +		if (likely(old == cur))
> > > > +			break;
> > > > +		cur = old;
> > > > +	}
> > > >  	return true;
> > > >  }
> > > >  
> > > 
> > > ...
> > > 
> > > >  static inline u64
> > > >  inode_query_iversion(struct inode *inode)
> > > >  {
> > > > -	return inode_peek_iversion(inode);
> > > > +	u64 cur, old, new;
> > > > +
> > > > +	cur = atomic64_read(&inode->i_version);
> > > > +	for (;;) {
> > > > +		/* If flag is already set, then no need to swap */
> > > > +		if (cur & I_VERSION_QUERIED)
> > > > +			break;
> > > > +
> > > > +		new = cur | I_VERSION_QUERIED;
> > > > +		old = atomic64_cmpxchg(&inode->i_version, cur, new);
> > > > +		if (old == cur)
> > > > +			break;
> > > > +		cur = old;
> > > > +	}
> > > 
> > > Why not just use atomic64_or() here?
> > > 
> > 
> > If the cmpxchg fails, then either:
> > 
> > 1) it was incremented
> > 2) someone flagged it QUERIED
> > 
> > If an increment happened then we don't need to flag it as QUERIED if
> > we're returning an older value. If we use atomic64_or, then we can't
> > tell if an increment happened so we'd end up potentially flagging it
> > more than necessary.
> > 
> > In principle, either outcome is technically OK and we don't have to loop
> > if the cmpxchg doesn't work. That said, if we think there might be a
> > later i_version available, then I think we probably want to try to query
> > it again so we can return as late a one as possible.
> 
> OK, makes sense. I'm just a bit vary of cmpxchg loops as they tend to
> behave pretty badly in contended cases but I guess i_version won't be
> hammered *that* hard.
> 

That's the principle I'm operating under here, and I think it's valid
for almost all workloads. Incrementing the i_version on parallel writes
should be mostly uncontended now, whereas they at had to serialize on
the i_lock before.

The pessimal case here, I think is parallel increments and queries. We
may see that sort of workload under knfsd, but I'm fine with giving
knfsd a small performance hit to help performance on other workloads.

While we're on the subject of looping here, should I add a cpu_relax()
into these loops?

Thanks for the review so far!
-- 
Jeff Layton <jlayton@kernel.org>
