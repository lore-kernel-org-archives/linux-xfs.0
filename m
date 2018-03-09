Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52126 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751096AbeCIPrF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Mar 2018 10:47:05 -0500
Date: Fri, 9 Mar 2018 10:47:04 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: handle inconsistent log item formatting state
 correctly
Message-ID: <20180309154704.GB3445@bfoster.bfoster>
References: <20180301223527.28626-1-david@fromorbit.com>
 <20180305144001.GA6135@bfoster.bfoster>
 <20180305221857.GF18129@dastard>
 <20180306123155.GB10982@bfoster.bfoster>
 <20180306221441.GK18129@dastard>
 <20180307011602.GA19337@bfoster.bfoster>
 <20180307021245.GV18989@magnolia>
 <20180308044017.GR18129@dastard>
 <20180308191113.GA2725@dhcp-41-192.bos.redhat.com>
 <20180308221038.GS18129@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180308221038.GS18129@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Fri, Mar 09, 2018 at 09:10:38AM +1100, Dave Chinner wrote:
> On Thu, Mar 08, 2018 at 02:11:13PM -0500, Brian Foster wrote:
> > On Thu, Mar 08, 2018 at 03:40:17PM +1100, Dave Chinner wrote:
> > > On Tue, Mar 06, 2018 at 06:12:45PM -0800, Darrick J. Wong wrote:
> > > > On Tue, Mar 06, 2018 at 08:16:02PM -0500, Brian Foster wrote:
> > > > > On Wed, Mar 07, 2018 at 09:14:41AM +1100, Dave Chinner wrote:
> > > > > > On Tue, Mar 06, 2018 at 07:31:56AM -0500, Brian Foster wrote:
> > > > > My argument is not that it's not possible. My argument is that the
> > > > > semantics of XFS_LID_DIRTY suggest the transaction modified the object
> > > > > in memory. Today, that means we log a range of the object, log an
> > > > > invalidation or order a buffer. E.g., we modify an actual metadata
> > > > > object, dirty the item (log or order), dirty the lidp and dirty the
> > > > > transaction. If we didn't ever modify a particular object, then there's
> > > > > no reason to dirty it that I can see. Failing to log/order the object
> > > > > properly doesn't justify assuming it hasn't been modified IMO, we don't
> > > > > really know either way.
> > > > > 
> > > > > The way the flag is used seems to bear that out. It's set when an object
> > > > > has been modified by a transaction. The way the flag alters behavior
> > > > > suggests the same. Objects that have been dirtied by a transaction
> > > > > cannot be released from that transaction and a cancel of a transaction
> > > > > with a dirty lidp causes fs shutdown (because we dirty the transaction
> > > > > once we dirty a lidp).
> > > 
> > > I'll point out that I've just stumbled onto a series of bugs where
> > > log items are multiply joined to a single transaction, in which case
> > > the lidp state may not reflect the current state of the log item
> > > because the log item no longer points to the lidp in question.
> > > 
> > > This also raises questions about what happens when we process a log
> > > item twice in the cil commit infrastructure - two formatting passes,
> > > multiple inserts into the CIL list, multiple calls to
> > > iop_committing/iop_unlock when the transaction is freed, etc.
> > > There's lots of shit that could go wrong as a result of this type of
> > > bug...
> > > 
> > > > > A cancel of that same transaction would shutdown the fs because it
> > > > > dirtied (i.e., presumably modified) an object. So we can't cancel the
> > > > > transaction for risk of corruption, we can't release the object from the
> > > > > transaction, yet this patch proposes behavior where a commit of that
> > > > > transaction can silently undirty the lidp, commit whatever else might be
> > > > > in the transaction and carry on as if nothing were wrong.
> > > > > 
> > > > > At the very least, this is inconsistent with how this flag is used
> > > > > everywhere else. How do you explain that?
> > > > 
> > > > So the state "li dirty, lip !ordered, niovecs == 0" is an invalid state,
> > > > and this patch proposes that if we ever see this invalid state then we
> > > > decide that no the buffer isn't dirty since there are zero iovecs.  This
> > > > prevents the log from allocating anything for this item since there's no
> > > > evidence of anything being dirty.
> > > 
> > > Essentially. The log item dirty state is the thing we trust right
> > > through the log item life cycle. It's fundamental to the relogging
> > > algorithm we use to keep dirty metadata moving forwards through the
> > > log.
> > > 
> > > The log item descriptor, OTOH, was just an abstraction that allowed
> > > the transaction commit to couple the log item formatting to the
> > > xlog_write() vector calls, which is something that went away with
> > > delayed logging about 8 years ago. The only piece of the log item
> > > descriptor that remained was the dirty flag, and the issue here
> > > boils down to one simple question: which dirty state do we trust -
> > > the log item or the descriptor?
> > > 
> > > That, as an architectural question, is a no brainer. It's the log
> > > item state that matters. The log item descriptor is an abstraction
> > > long past it's use-by date, so I'm going to resolve this problem
> > > simply by removing it (if you are wondering how I found the
> > > mulitply-joined log item bugs...).
> > > 
> > 
> > Ooh, we're in danger of making some progress here... :P
> > 
> > So this all suggests to me that you see the lidp dirty state as
> > duplicative with the log item dirty state.
> 
> Well, sort of.
> 
> > That is quite different from
> > the perception I have from reading the code (a perception which I tried
> > my best to describe so you, or somebody, could set me straight if
> > necessary). Then again...
> 
> The log item descriptor used to link the transaction to the log item
> as it passed though the journal. Transactions used to be freed on
> log IO completion - their life cycle changed drastically with
> delayed logging, such that they are now freed by xfs_trans_commit(),
> rather than being attached to the iclogbuf (as the CIL checkpoint
> transaction now is) and freed on log IO completion. i.e. their
> functionality was effective replaced by the xfs_log_vec that we now
> allocate and format during transaction commit.
> 

Ok, that makes sense. Pre-CIL is before my time, but we essentially
disconnected the transaction from the full lifecycle up through log I/O
completion and replaced it with the log vector, so we can reformat items
that are relogged before the vectors are written out during a
checkpoint.

> IOWs, if we can't/don't create a xfs_log_vec that will be written to
> the log during formatting, then it doesn't matter what the lid says
> - there's nothing to write to the log, so we don't add the object to
> the CIL....
> 

Yes, there is no point in adding a physically unlogged log item to the
CIL. My question is bigger picture than the CIL..

> > > In doing this, we no longer have the question of which one to trust
> > > - all the "dirty in transaction" state is carried on the log item
> > > itself and is valid only during the life of a transaction.  At
> > > which point, there should be no possibility of the log item dirty
> > > flag getting out of step with it's dirty state, and we can simply
> > > add asserts in the write place to validate this.
> > > 
> > 
> > This more describes the lidp object as duplicative, while the dirty
> > state it supports may still be unique with respect to the lip dirty
> > state (which is what I thought to begin with). In other words, we still
> > need to differentiate between a dirty lip that might be in the log
> > pipeline and a log item that is "dirty in a transaction," because afaict
> > it's still possible to have a dirty log item in a clean transaction.
> 
> Yes, that is possible. In which case, it doesn't get formatted again
> by the current transaction commit because it's already been
> formatted and tracked by the CIL/AIL correctly. It's essentially
> just an optimisation to avoid redundant relogging of log items.
> 

Ok, that's pretty much how I understood it. Thanks for describing some
of this background/viewpoint. At the very least this starts to isolate
where we are looking at this differently.

> > So which of the above is more accurate? If the latter, doesn't the
> > "dirty in transaction" state we'd move over to the lip reflect the same
> > meaning as XFS_LID_DIRTY today? If so, ISTM that we should still not
> > expect to have a "dirty in transaction" log item unless the log item
> > itself is dirty. Hm?
> 
> Yup, but now it's all held in the one object and there's no
> possibility of getting that out of sync anymore as the state is
> managed directly when the log item is either dirtied or removed
> from the transaction. We're not reliant on managing lids correctly
> for it to be correct.
> 

Ok. FWIW, I think you're completely missing the point I'm trying to make
with regard to this patch. It really has nothing to do with the CIL or
the log item, or really the lidp for that matter if we think about in
terms of the extra lidp background you've documented. Just assume the
lidp is gone.. all that matters here are the fundamental "log item
dirty" and "log item dirty in transaction" states and the distinction
between them.

The point is that if we have a transaction that holds an item "dirty in
the transaction" but the item itself is not dirty, we should probably
consider that the in-core metadata had been modified and treat the
transaction as inconsistent because we only dirty an item in a
transaction when it's associated metadata has been physically modified.
Of course, we don't know that for sure in this "shouldn't currently
happen" case, but we do already consider it an error to cancel a dirty
transaction clearing the "dirty in transaction" state from a particular
item is logically equivalent to cancelling that subset of the
transaction.

I completely agree that we should not insert that log vector in the CIL.
That part seems obvious to me. I'm simply suggesting that rather than
being so focused on skipping the particular lidp/lip, we probably
shouldn't commit the entire transaction. Rather, force it into the error
path that is analogous to a cancel (i.e., shutdown the fs).

This is technically a trivial change to the current patch so I'm quite
curious what drives resistance to the point of motivating elimination of
the lidp. Of course all that work might be independently
correct/overdue/worthwhile, but it's presented here as if it washes away
the fundamental discrepancy I'm describing. In reality, so long as we
maintain distinct "dirty log item" and "dirty in transaction" states, it
doesn't change the point.

Brian

P.S., IOW, fold something like the appended into the original patch. As
easy as it is to add, it can just as easily be removed if "dirty in tx"
+ "clean item" turns into an explicitly handled state in the future. In
the meantime, this turns potential bugs like the symlink bug in the buf
log range patch into a shutdown that prevents the silent corruption that
would occur if the transaction had committed.

--- 8< ---

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index f190d1b84c0d..d5d8b88a8aaa 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -170,6 +170,15 @@ xlog_cil_alloc_shadow_bufs(
 		}
 
 		/*
+		 * If the transaction dirtied an item but didn't tell us how to
+		 * log it, something is seriously wrong. We have to assume the
+		 * associated in-core metadata was modified. Don't risk
+		 * corruption by committing the transaction.
+		 */
+		if (!niovecs && !ordered)
+			xfs_force_shutdown(log->l_mp, SHUTDOWN_CORRUPT_INCORE);
+
+		/*
 		 * We 64-bit align the length of each iovec so that the start
 		 * of the next one is naturally aligned.  We'll need to
 		 * account for that slack space here. Then round nbytes up
@@ -352,6 +361,7 @@ xlog_cil_insert_format_items(
 		 * added to the CIL by mistake.
 		 */
 		if (!shadow->lv_niovecs && !ordered) {
+			ASSERT(XFS_FORCED_SHUTDOWN(log->l_mp));
 			lidp->lid_flags &= ~XFS_LID_DIRTY;
 			continue;
 		}
