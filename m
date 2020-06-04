Return-Path: <SRS0=uikP=7R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A134C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 14:03:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D5BB207D0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 14:03:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JkQ9PpWz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728782AbgFDODv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Jun 2020 10:03:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41584 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728496AbgFDODv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jun 2020 10:03:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591279429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kZ6zT4IZS4W7M1GSzWAzJF0poY9ZXDDFwnumelzyf+Y=;
        b=JkQ9PpWzXM8pFMgBJvpfoFf44vd4e4HrEauEJhcdX9MV7fcU9esXfh4Lzv9zz8dHblf4da
        RUernG0zoe30Q0ArTKKN4p5iD8boAvRB5FbOBX/C5DSrKuJc1pWDFXrf/AcBVpIBtCxqs0
        pzRcNhAwqLDm5FGL8Q3X/lnGXTxcXLI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-02R2rwI9MeOVcgTyOCX0OQ-1; Thu, 04 Jun 2020 10:03:47 -0400
X-MC-Unique: 02R2rwI9MeOVcgTyOCX0OQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B3AA80B724;
        Thu,  4 Jun 2020 14:03:46 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EDEC77CCCE;
        Thu,  4 Jun 2020 14:03:45 +0000 (UTC)
Date:   Thu, 4 Jun 2020 10:03:44 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/30] xfs: pin inode backing buffer to the inode log item
Message-ID: <20200604140344.GA17815@bfoster>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-17-david@fromorbit.com>
 <20200603185812.GB13399@bfoster>
 <20200603221531.GP2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603221531.GP2040@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 04, 2020 at 08:15:31AM +1000, Dave Chinner wrote:
> On Wed, Jun 03, 2020 at 02:58:12PM -0400, Brian Foster wrote:
> > On Tue, Jun 02, 2020 at 07:42:37AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > When we dirty an inode, we are going to have to write it disk at
> > > some point in the near future. This requires the inode cluster
> > > backing buffer to be present in memory. Unfortunately, under severe
> > > memory pressure we can reclaim the inode backing buffer while the
> > > inode is dirty in memory, resulting in stalling the AIL pushing
> > > because it has to do a read-modify-write cycle on the cluster
> > > buffer.
> > > 
> > > When we have no memory available, the read of the cluster buffer
> > > blocks the AIL pushing process, and this causes all sorts of issues
> > > for memory reclaim as it requires inode writeback to make forwards
> > > progress. Allocating a cluster buffer causes more memory pressure,
> > > and results in more cluster buffers to be reclaimed, resulting in
> > > more RMW cycles to be done in the AIL context and everything then
> > > backs up on AIL progress. Only the synchronous inode cluster
> > > writeback in the the inode reclaim code provides some level of
> > > forwards progress guarantees that prevent OOM-killer rampages in
> > > this situation.
> > > 
> > > Fix this by pinning the inode backing buffer to the inode log item
> > > when the inode is first dirtied (i.e. in xfs_trans_log_inode()).
> > > This may mean the first modification of an inode that has been held
> > > in cache for a long time may block on a cluster buffer read, but
> > > we can do that in transaction context and block safely until the
> > > buffer has been allocated and read.
> > > 
> > > Once we have the cluster buffer, the inode log item takes a
> > > reference to it, pinning it in memory, and attaches it to the log
> > > item for future reference. This means we can always grab the cluster
> > > buffer from the inode log item when we need it.
> > > 
> > > When the inode is finally cleaned and removed from the AIL, we can
> > > drop the reference the inode log item holds on the cluster buffer.
> > > Once all inodes on the cluster buffer are clean, the cluster buffer
> > > will be unpinned and it will be available for memory reclaim to
> > > reclaim again.
> > > 
> > > This avoids the issues with needing to do RMW cycles in the AIL
> > > pushing context, and hence allows complete non-blocking inode
> > > flushing to be performed by the AIL pushing context.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_inode_buf.c   |  3 +-
> > >  fs/xfs/libxfs/xfs_trans_inode.c | 53 +++++++++++++++++++++---
> > >  fs/xfs/xfs_buf_item.c           |  4 +-
> > >  fs/xfs/xfs_inode_item.c         | 73 +++++++++++++++++++++++++++------
> > >  fs/xfs/xfs_trans_ail.c          |  8 +++-
> > >  5 files changed, 117 insertions(+), 24 deletions(-)
> > > 
> > ...
> > > diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> > > index fe6c2e39be85d..1e7147b90725e 100644
> > > --- a/fs/xfs/libxfs/xfs_trans_inode.c
> > > +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> > ...
> > > @@ -132,6 +140,39 @@ xfs_trans_log_inode(
> > >  	spin_lock(&iip->ili_lock);
> > >  	iip->ili_fsync_fields |= flags;
> > >  
> > > +	if (!iip->ili_item.li_buf) {
> > > +		struct xfs_buf	*bp;
> > > +		int		error;
> > > +
> > > +		/*
> > > +		 * We hold the ILOCK here, so this inode is not going to be
> > > +		 * flushed while we are here. Further, because there is no
> > > +		 * buffer attached to the item, we know that there is no IO in
> > > +		 * progress, so nothing will clear the ili_fields while we read
> > > +		 * in the buffer. Hence we can safely drop the spin lock and
> > > +		 * read the buffer knowing that the state will not change from
> > > +		 * here.
> > > +		 */
> > > +		spin_unlock(&iip->ili_lock);
> > > +		error = xfs_imap_to_bp(ip->i_mount, tp, &ip->i_imap, NULL,
> > > +					&bp, 0);
> > > +		if (error) {
> > > +			xfs_force_shutdown(ip->i_mount, SHUTDOWN_META_IO_ERROR);
> > > +			return;
> > > +		}
> > 
> > It's slightly unfortunate to shutdown on a read error, but I'd guess
> > many of these cases would have a dirty transaction already. Perhaps
> > something worth cleaning up later..?
> 
> All of these cases will a dirty transaction - the inode has been
> modified in memory before it was logged and hence we cannot undo
> what has already been done. If we return an error here, we will need
> to cancel the transaction, and xfs_trans_cancel() will do a shutdown
> anyway. Doing it here just means we don't have to return an error
> and add error handling to the ~80 callers of xfs_trans_log_inode()
> just to trigger a shutdown correctly.
> 

Yes, I'm not suggesting doing that. That doesn't change the fact that
historically such a read error doesn't translate to a permanent
filesystem error because it wasn't tied to a dirty transaction.
Technically we could get around that by acquiring the cluster buffer
earlier in the transaction, but I'm not suggesting we do that either for
similar reasons around the amount of churn involved in all of the
codepaths that log an inode.

Granted, it could still be the case that the impact of this is minimal
because in the event of persistent I/O errors, we would have had to read
the buffer to get the in-core inode at some point and likely would have
failed more gracefully earlier anyways. Either way, I'm just positing
that it's worth thinking about if we happen to come up with something
more simple/clever down the line to avoid the shutdown vector.

> > > @@ -450,6 +453,12 @@ xfs_inode_item_pin(
> > >   * item which was previously pinned with a call to xfs_inode_item_pin().
> > >   *
> > >   * Also wake up anyone in xfs_iunpin_wait() if the count goes to 0.
> > > + *
> > > + * Note that unpin can race with inode cluster buffer freeing marking the buffer
> > > + * stale. In that case, flush completions are run from the buffer unpin call,
> > > + * which may happen before the inode is unpinned. If we lose the race, there
> > > + * will be no buffer attached to the log item, but the inode will be marked
> > > + * XFS_ISTALE.
> > >   */
> > >  STATIC void
> > >  xfs_inode_item_unpin(
> > > @@ -459,6 +468,7 @@ xfs_inode_item_unpin(
> > >  	struct xfs_inode	*ip = INODE_ITEM(lip)->ili_inode;
> > >  
> > >  	trace_xfs_inode_unpin(ip, _RET_IP_);
> > > +	ASSERT(lip->li_buf || xfs_iflags_test(ip, XFS_ISTALE));
> > >  	ASSERT(atomic_read(&ip->i_pincount) > 0);
> > >  	if (atomic_dec_and_test(&ip->i_pincount))
> > >  		wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
> > 
> > So I was wondering what happens to the attached buffer hold if shutdown
> > occurs after the inode is logged (i.e. transaction aborts or log write
> > fails).
> 
> Hmmm. Good question. 
> 
> There may be no other inodes on the buffer and it this inode may not
> be in the AIL, so there's no trigger for xfs_iflush_abort() to be
> run from buffer IO completion. So, yes, we could leave an inode
> attached to the buffer here....
> 
> 
> > I see there's an assert for the buffer being cleaned up before
> > the ili is freed, so presumably that case is handled. It looks like we
> > unconditionally abort a flush on inode reclaim if the fs is shutdown,
> > regardless of whether the inode is dirty and we drop the buffer from
> > there..?
> 
> Yes, that's where this shutdown race condition has always been
> handled. i.e. we know that inodes that are dirty in memory can be
> left dangling by the shutdown, and if it's a log IO error they may
> even still be pinned. Hence reclaim has to ensure that they are
> properly aborted before reclaim otherwise various "reclaiming dirty
> inode" asserts will fire.
> 

Makes sense.

> As it is, in the next patchset the cluster buffer is always inserted
> into the AIL as an ordered buffer so it is always committed in the
> same transaction as the inode. Hence the abort/unpin call on the
> buffer runs the inode IO done processing, it will get removed from
> the list and we aren't directly reliant on inode reclaim running a
> flush abort to do that for us.
> 

That sounds more preferable. While I see why we need the current code
and ultimately it looks correct, it seems a bit of indirect "clean up
the broken mess" logic due to lack of handling in more direct codepaths.

> > > @@ -629,10 +639,15 @@ xfs_inode_item_init(
> > >   */
> > >  void
> > >  xfs_inode_item_destroy(
> > > -	xfs_inode_t	*ip)
> > > +	struct xfs_inode	*ip)
> > >  {
> > > -	kmem_free(ip->i_itemp->ili_item.li_lv_shadow);
> > > -	kmem_cache_free(xfs_ili_zone, ip->i_itemp);
> > > +	struct xfs_inode_log_item *iip = ip->i_itemp;
> > > +
> > > +	ASSERT(iip->ili_item.li_buf == NULL);
> > > +
> > > +	ip->i_itemp = NULL;
> > > +	kmem_free(iip->ili_item.li_lv_shadow);
> > > +	kmem_cache_free(xfs_ili_zone, iip);
> > >  }
> > >  
> > >  
> > > @@ -647,6 +662,13 @@ xfs_inode_item_destroy(
> > >   * list for other inodes that will run this function. We remove them from the
> > >   * buffer list so we can process all the inode IO completions in one AIL lock
> > >   * traversal.
> > > + *
> > > + * Note: Now that we attach the log item to the buffer when we first log the
> > > + * inode in memory, we can have unflushed inodes on the buffer list here. These
> > > + * inodes will have a zero ili_last_fields, so skip over them here. We do
> > > + * this check -after- we've checked for stale inodes, because we're guaranteed
> > > + * to have XFS_ISTALE set in the case that dirty inodes are in the CIL and have
> > > + * not yet had their dirtying transactions committed to disk.
> > >   */
> > >  void
> > >  xfs_iflush_done(
> > > @@ -670,14 +692,16 @@ xfs_iflush_done(
> > >  			continue;
> > >  		}
> > >  
> > > +		if (!iip->ili_last_fields)
> > > +			continue;
> > > +
> > 
> > Hmm.. reading the comment above, do we actually attach the log item to
> > the buffer any earlier? ISTM we attach the buffer to the log item via a
> > hold, but that's different from getting the ili on ->b_li_list such that
> > it's available here. Hm?
> 
> I think I've probably just put the comment and this check in the
> wrong patch when I split this all up. A later patch in the series
> moves the inode attachment to the buffer to the
> xfs_trans_log_inode() call, and that's when this situation arises
> and the check is needed.
> 

Ok, that makes much more sense.

> 
> > > @@ -706,14 +730,29 @@ xfs_iflush_done(
> > >  	 * them is safely on disk.
> > >  	 */
> > >  	list_for_each_entry_safe(lip, n, &tmp, li_bio_list) {
> > > +		bool	drop_buffer = false;
> > > +
> > >  		list_del_init(&lip->li_bio_list);
> > >  		iip = INODE_ITEM(lip);
> > >  
> > >  		spin_lock(&iip->ili_lock);
> > > +
> > > +		/*
> > > +		 * Remove the reference to the cluster buffer if the inode is
> > > +		 * clean in memory. Drop the buffer reference once we've dropped
> > > +		 * the locks we hold.
> > > +		 */
> > > +		ASSERT(iip->ili_item.li_buf == bp);
> > > +		if (!iip->ili_fields) {
> > > +			iip->ili_item.li_buf = NULL;
> > > +			drop_buffer = true;
> > > +		}
> > >  		iip->ili_last_fields = 0;
> > > +		iip->ili_flush_lsn = 0;
> > 
> > This also seems related to the behavior noted in the comment above.
> > Presumably we have to clear the flush lsn if clean inodes remain
> > attached to the buffer.. (but does that actually happen yet)?
> 
> I think I added that here when debugging an issue as a mechanism
> to check that the flush_lsn was only set while a flush was in
> progress. It's all hazy now because I had to rebase the parts of the
> patchset that change this section of code soooo many times I kinda
> lost track of where and why of the little details...
> 

Heh. I guess it's not clear to me if this is functional or defensive
logic, but I am obviously still working my way through the series..

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

