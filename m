Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 62E6C7CA7
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 18:57:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1B8708F8040
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 16:57:52 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id jTWhHG47QfTGUG6b (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Sep 2016 16:57:49 -0700 (PDT)
Date: Tue, 6 Sep 2016 16:57:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/71] xfs: defer should allow ->finish_item to request a
	new transaction
Message-ID: <20160906235717.GB26927@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
	<147216794133.867.4063030531885190227.stgit@birch.djwong.org>
	<20160906063815.GA11411@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160906063815.GA11411@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Sep 05, 2016 at 11:38:15PM -0700, Christoph Hellwig wrote:
> On Thu, Aug 25, 2016 at 04:32:21PM -0700, Darrick J. Wong wrote:
> > When xfs_defer_finish calls ->finish_item, it's possible that
> > (refcount) won't be able to finish all the work in a single
> > transaction.  When this happens, the ->finish_item handler should
> > shorten the log done item's list count, update the work item to
> > reflect where work should continue, and return -EAGAIN so that
> > defer_finish knows to retain the pending item on the pending list,
> > roll the transaction, and restart processing where we left off.
> > 
> > Plumb in the code and document how this mechanism is supposed to work.
> 
> I've voiced this before, and I will again:  I think the whole xfs_defer
> mechanism is a major, major mistake.  All three users look somewhat
> similar, but actually are different underneath

I agree with you that the four users are different underneath, and that
shoehorning all four through the same xfs_defer has its risks.  I'm not
sure specifically what's making you nervous, so I'll write a little
about how I arrived at the xfs_defer_ops design, and hopefully that'll
be enough of a jumping off point to discuss from there?

Reworking the existing xfs_bmap_free_t code was unsettling in the usual
sense of "am I really grokking this thing?"  The refcount item code
requiring the ability to roll a transaction midway through finishing the
item is not something the other three items care about.  There's an
additional question about the interaction between extent free and busy,
which I'll get to further down.

That said, prior to writing the xfs_defer code (that I submitted for
4.8), I *did* iterate through various designs, all of which eventually
failed.  The problem I'm dealing with here is this -- in the new world
of rmap and refcount, a data block mapping transaction can cause an
intense storm of metadata updates.  In the old days we only had to deal
with (in the free case):

1) update extent map,
2) alloc/free bmbt block,
3) free data extent

Now that process expands (explodes?) to:

1) update extent map,
2) bmbt block alloc/free,
3) bmbt rmap update,
4) rmapbt shape changes,
5) freeing(?) rmapbt blocks,
6) data block rmapbt update,
7) rmapbt shape change for bmbt update,
8) freeing(?) rmapbt blocks,
9) refcountbt update, 
A) rmapbt shape change for refcountbt update,
B) freeing(?) rmapbt blocks,
C) data block freeing,

In the bad first implementation I simply tried to cram all of these
updates into a single big transaction, which lead to reservation
blowouts and deadlocks when we have to perform multiple allocations for
data blocks and bmbt blocks.

The next design left the old xfs_bmap_free code mostly intact and
provided separate handlers for the rmap/refcount/bmap updates as you
suggested during the rmap review, with just enough of a defer_ops to
point to the four types of deferred ops that could go with each
transaction.  Each metadata update type was logged in order of type;
this proved insufficient because the various metadata updates are
interdependent -- for example, if adding an rmapbt record causes an
rmapbt block to be freed, we have to ensure that the rmap update and RUD
commit before we start working on the extent freeing.  Were this order
not maintained, we could crash after the EFD gets logged but before the
rmap update commits, and replay would retry the rmap update and free the
block again.  So, separately maintained lists of deferred operations
didn't work.

This resulted in the third (and current) deferred ops design.  Central
coordination between deferred ops is stronger than it was before.
Deferred operations are tracked in the order that they're added to the
defer_ops, and the intent items are logged in that order so that
recovery happens in (more or less) the same way that they would during a
successful transaction commit.  That required defer_ops to shoulder a
larger burden of state tracking, at which point it made more sense to
make extent freeing another defer_ops client.

However, there's also the question of how does this new defer_ops thing
interact with the extent busy code?  AFAIK, the extent busy code
prevents XFS from reusing a freed block for data until the transaction
that frees it has committed so that log recover cannot replay updates to
a block that has already been rewritten with file data (i.e.
xlog_cil_committed() has run to completion).  The deferred ops system
will roll the transaction repeatedly until all the ops are finished, but
there's nothing about it that changes that guarantee.  Metadata blocks
being freed are still put in the busy-extent rbtree where they remain
until the CIL commits and clears them (or they get reused for other
metadata) which prevents premature reuse.  In other words, extent
freeing should behave the same as before, even in the presence of the
new pieces.

> Especially the extent free case is a lot simpler than all others, and
> we now place the burden of a complex abstraction onto code that would
> otherwise be fairly easily understandable.

Right, it would be nice to be able to keep using the old bmap_free code
when we don't need the complex operations.  I guess you could make the
public xfs_defer.c functions short-circuit to the bmap_free code if
!rmap && !reflink.

> Also it adds a memory allocation to the extent free code,

The second memory allocation could be eliminated by kmem_alloc'ing more
bytes in xfs_defer_add and changing xfs_defer_add to take a pointer to a
work item buffer that would be copied into the extra space.  I'm not
sure how much we'd gain since there are already plenty of allocations
in that path anyway.

> and gets in the way of merging the freed extent and extent busy
> structures, something I prototyped a while ago.

I searched my email spool back to 9/2012 but didn't find any patches,
so I don't really know how to respond to this.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
