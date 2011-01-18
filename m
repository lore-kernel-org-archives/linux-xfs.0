Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0INVWhF165169 for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 17:31:32 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 98F412700F2
	for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 15:33:49 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	lQPtHBLexDDKYy9S for <xfs@oss.sgi.com>;
	Tue, 18 Jan 2011 15:33:49 -0800 (PST)
Date: Wed, 19 Jan 2011 10:33:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: fix efi item leak on forced shutdown
Message-ID: <20110118233346.GA28803@dastard>
References: <1295010430-12495-1-git-send-email-david@fromorbit.com>
	<1295010430-12495-3-git-send-email-david@fromorbit.com>
	<20110118124625.GB12516@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110118124625.GB12516@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Jan 18, 2011 at 07:46:25AM -0500, Christoph Hellwig wrote:
> On Sat, Jan 15, 2011 at 12:07:10AM +1100, Dave Chinner wrote:
> > The cause of the leak is that the "remove" parameter of IOP_UNPIN()
> > is never set when a CIL push is aborted. This means that the EFI
> > item is never freed if it was in the push being cancelled. The
> > problem is specific to delayed logging.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_trans.c |   10 ++++++++++
> >  1 files changed, 10 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index f80a067..e66ce5e 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -1472,6 +1472,16 @@ xfs_trans_committed_bulk(
> >  		if (XFS_LSN_CMP(item_lsn, (xfs_lsn_t)-1) == 0)
> >  			continue;
> >  
> > +		/*
> > +		 * if we are aborting the operation, no point in inserting the
> > +		 * object into the AIL as we areee in a shutdown situation.
> 
> that's a few 'e' too much.
> 
> > +		 */
> > +		if (aborted) {
> > +			ASSERT(XFS_FORCED_SHUTDOWN(ailp->xa_mount));
> > +			IOP_UNPIN(lip, aborted);
> > +			continue;
> > +		}
> 
> Hmm, this is not symmetric with the non-delaylog path.
> xfs_trans_item_committed never sets the remove flag to IOP_UNPIN,
> even if the transaction commit was aborted.

Right, because the delaylog and non-delaylog paths are not symmetric
w.r.t. log write failures.

> It seems like the CIL code is missing an equivalent to
> xfs_trans_uncommit for the case that xfs_log_write or xfs_log_done
> fail.

There isn't an equivalent. In the delaylog case, we don't have a
transaction to "uncommit" when a log write failure occurs - we are
aborting the checkpoint of the CIL, not a transaction. As the items
have already gone through IOP_COMMITTING and IOP_UNLOCK, we have to
treat the failures like they came from the log IO completion
handler.

In the case of non-delaylog, neither IOP_COMMITTING or IOP_UNLOCK
has been called on the items when the xfs_log_write() fails. They
are still linked into the xfs_trans structure, so they can be
handled by xfs_trans_uncommit() which simply needs to walk the items
in the transaction and  IOP_UNPIN(lip, abort), IOP_UNLOCK and free
the items.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
