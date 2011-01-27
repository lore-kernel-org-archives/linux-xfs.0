Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0R0X4MB174589 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 18:33:05 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A3F444D5F70
	for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 16:35:26 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	qaAfr6ggREEYec8g for <xfs@oss.sgi.com>;
	Wed, 26 Jan 2011 16:35:26 -0800 (PST)
Date: Thu, 27 Jan 2011 11:35:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/8] xfs: fix efi item leak on forced shutdown
Message-ID: <20110127003523.GB21311@dastard>
References: <1295945444-29488-1-git-send-email-david@fromorbit.com>
	<1295945444-29488-3-git-send-email-david@fromorbit.com>
	<20110125235354.GA3832@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110125235354.GA3832@infradead.org>
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

On Tue, Jan 25, 2011 at 06:53:54PM -0500, Christoph Hellwig wrote:
> On Tue, Jan 25, 2011 at 07:50:38PM +1100, Dave Chinner wrote:
> > diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> > index 75f2ef6..effbb41 100644
> > --- a/fs/xfs/xfs_extfree_item.c
> > +++ b/fs/xfs/xfs_extfree_item.c
> > @@ -138,7 +138,6 @@ xfs_efi_item_unpin(
> >  
> >  	if (remove) {
> >  		ASSERT(!(lip->li_flags & XFS_LI_IN_AIL));
> > -		xfs_trans_del_item(lip);
> >  		xfs_efi_item_free(efip);
> >  		return;
> >  	}
> 
> >  STATIC void
> >  xfs_trans_uncommit(
> >  	struct xfs_trans	*tp,
> >  	uint			flags)
> >  {
> > -	struct xfs_log_item_desc *lidp;
> > +	struct xfs_log_item_desc *lidp, *n;
> >  
> > -	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
> > +	list_for_each_entry_safe(lidp, n, &tp->t_items, lid_trans) {
> >  		/*
> >  		 * Unpin all but those that aren't dirty.
> >  		 */
> > -		if (lidp->lid_flags & XFS_LID_DIRTY)
> > +		if (lidp->lid_flags & XFS_LID_DIRTY) {
> > +			xfs_trans_del_item(lidp->lid_item);
> >  			IOP_UNPIN(lidp->lid_item, 1);
> > +		}
> 
> This part of the patch isn't explained in the changelog, and I suspect
> it should be a separate patch from the addition of the IOP_UNPIN with
> remove call to the CIL error path.

Doing xfs_trans_del_item() inside IOP_UNPIN() during CIl commit
faliure processing causes a panic - there is not descriptior or
trransaction attached to the item at that point. Hence it is simply
not safe to call IOP_UNPIN(aborted) from outside a transaction
context if we allow xfs_trans_del_item() to be run inside the
IOP_UNPIN() call.

Further, if we do xfs_trans_del_item() inside the IOP_UNPIN(aborted)
path, we corrupt the list walk in xfs_trans_uncommit() case. Hence
it needs to be an list_for_each_entry_safe() walk, and must do
explicit removal of the item from the transaction because the item
can be freed in IOP_UNPIN(aborted).

> Moving the xfs_trans_del_item from the IOP_UNPIN implementation into
> the caller seems sane to me, but:
> 
>  - why is the call to xfs_trans_del_item left in xfs_buf_item_unpin

Because I didn't notice it. It never triggers in the
xfs_trans_uncommit() case as there are two references on the buf
item - one for the pin, and one for the lock. We call IOP_UNPIN()
first, so it never goes down the (freed && stale) path in this case.

As to why it hasn't triggered from a iclog write completion or CIL
checkpoint failure after the IOP_UNLOCK() has been run and dropped
that reference - just luck I guess....

>  - why did xfs_buf_item_unpin get away only calling it for the stale
>    case, and the other log item implementations completely without
>    it

The stale buffer case is special - it has a different lifecycle to
all other buffer items (and all other log item types, for that
matter). Basically a stale buffer never enters the AIL on
transaction commit, so on the last reference going away it needs to
be freed rather than continuing to live while being tracked in the
AIL.

> I suspect the answer lies in xfs_trans_free_items opencoding the
> call to xfs_trans_del_item, thus avoiding any leak of log item
> descriptors or log items on the transaction list.

Actually, I don't think it does handle this case - we've already
removed all the dirty items from the transaction, so it appears to
me like they just get leaked.

> By adding the
> call of xfs_trans_del_item to xfs_trans_uncommit we thus skip
> the calls to IOP_UNLOCK for dirty log items, which is a large
> change in behaviour for the existing log items that didn't have
> the xfs_trans_del_item calls, and at least for the dquot and
> inode items seems incorrect.

You are right, it does break xfs_trans_free_items() and the way it
calls IOP_UNLOCK(). I'm surprised that it didn't cause any noticable
leaks of locked buffers....

----

Effectively, we've got a situation where we need to allow
xfs_trans_del_item() to be called in IOP_UNPIN(aborted) iff there is
a log item descriptor attached to the log item. That requires
xfs_trans_uncommit() to do a safe list traversal and both the efi
and buf items to check for a valid lidp before calling
xfs_trans_del_item(). I'll change the fix and commment it better in
the code and changelog.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
