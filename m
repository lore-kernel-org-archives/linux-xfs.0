Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:58520 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727492AbeGSVVb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Jul 2018 17:21:31 -0400
Date: Thu, 19 Jul 2018 16:36:43 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 00/14] xfs: embed dfops in the transaction
Message-ID: <20180719203643.GJ29404@bfoster>
References: <20180719134919.29939-1-bfoster@redhat.com>
 <20180719200557.GK6558@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719200557.GK6558@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 19, 2018 at 01:05:57PM -0700, Christoph Hellwig wrote:
> On Thu, Jul 19, 2018 at 09:49:05AM -0400, Brian Foster wrote:
> > return a clean transaction. Other things to consider might be to do away
> > with support for external dfops and the ->t_dfops pointer indirection,
> > or perhaps even consider going the other direction: allocate dfops from
> > a separate zone to save some memory on non-permanent transactions (note
> > that 16 of 28 transactions use a permanent log res. last I looked, so it
> > may not be worth it atm).
> 
> The defer_ops aren't really that big, and allocations are relatively
> costly, so I don't think a separate allocation is a good idea.  If we
> really want to optimize the non-permanent transaction case we could do
> something like:
> 
> struct xfs_trans {
> 	...
> 	struct xfs_defer_ops dfops[];
> };
> 
> and then have two caches for the with an without dfops case.  But
> I can't believe that would be worth it, especially in face of...
> 
> 
> > I know Christoph also had thoughts around condensing some of the items
> > joined to the dfops to those with the transaction.
> 
> ... this.
> 

Yeah. I was actually poking around today after writing this up and
thought that we might be able to replace both dop_inodes/dop_bufs with
checks in the transaction item list for either held buffers or inode
items where lock_flags == 0. I _think_ both of those states may be
essentially equivalent to joined dfops items, but I have to verify that.
If so, we can probably make the dfops inode/buf relogging "automatic,"
drop both pointer lists and the whole memory thing becomes kind of moot.

> > I have yet to think
> > about that one, but I do have an RFC quality patch laying around that
> > replaces the ->dop_low flag with a transaction flag (->t_flags),
> > eliminating the need for that extra byte in xfs_defer_ops. The one quirk
> > associated with that is the question of whether we want to preserve the
> > behavior where low mode remains active across the series of transactions
> > associated with the traditional (on-stack) dfops or is reset on
> > transaction roll (a la firstblock). I'll post that RFC separately for a
> > more proper discussion..
> 
> That sounds like a good enough start.  For now I'd keep the existing
> behavior because it really is deep magic and needs a deep audit.  I
> had started on that a long time ago but dropped the ball, but mixing
> it with this work is probably not helpful.

That sounds reasonable to me. We can always change behavior in a
subsequent patch. IIRC the only issue is that intent recovery code has
no way to carry dop_low mode around without a transaction. It currently
passes around a dfops for each intent. Hmm, perhaps we can have the
caller just allocate a transaction, pass it to the recovery helpers for
reservation and then just keep rolling it rather than have each helper
allocate a transaction anew. I'll look into it, or let me know if you
have any other thoughts/ideas.

Brian
