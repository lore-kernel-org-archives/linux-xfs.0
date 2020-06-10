Return-Path: <SRS0=2CQE=7X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 765CFC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Jun 2020 13:08:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C10E206F4
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Jun 2020 13:08:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CZ6bEMtg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbgFJNIn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Jun 2020 09:08:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39359 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728844AbgFJNIm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jun 2020 09:08:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591794520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ac0bmf3eUabA/iKQgTW8GkTBJTijLOSVKc9r0FJpxAA=;
        b=CZ6bEMtg8uu4H17aoa3+BM+5Kn041nsadVfjj1ehUHg8eJyN9yivciBmhXnlZAmNG/xVVN
        NGqrSRKfqAdTf3+h44onV9iGP6GNlppgp16G7ASNB+DnGcOkHQvm+z9mjAR6dkUQDxPTjl
        Wlr/OsYFwTLIkn3jhAjbuTgpcTbTnOI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-n0odbhRLP7uAapIc8gbgJw-1; Wed, 10 Jun 2020 09:08:36 -0400
X-MC-Unique: n0odbhRLP7uAapIc8gbgJw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB40D107ACF4;
        Wed, 10 Jun 2020 13:08:35 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 30D567BA10;
        Wed, 10 Jun 2020 13:08:35 +0000 (UTC)
Date:   Wed, 10 Jun 2020 09:08:33 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/30] xfs: factor xfs_iflush_done
Message-ID: <20200610130833.GB50747@bfoster>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-30-david@fromorbit.com>
 <20200609131249.GC40899@bfoster>
 <20200609221431.GK2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609221431.GK2040@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 10, 2020 at 08:14:31AM +1000, Dave Chinner wrote:
> On Tue, Jun 09, 2020 at 09:12:49AM -0400, Brian Foster wrote:
> > On Thu, Jun 04, 2020 at 05:46:05PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > xfs_iflush_done() does 3 distinct operations to the inodes attached
> > > to the buffer. Separate these operations out into functions so that
> > > it is easier to modify these operations independently in future.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/xfs_inode_item.c | 154 +++++++++++++++++++++-------------------
> > >  1 file changed, 81 insertions(+), 73 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > > index dee7385466f83..3894d190ea5b9 100644
> > > --- a/fs/xfs/xfs_inode_item.c
> > > +++ b/fs/xfs/xfs_inode_item.c
> > > @@ -640,101 +640,64 @@ xfs_inode_item_destroy(
> > >  
> > >  
> > >  /*
> > > - * This is the inode flushing I/O completion routine.  It is called
> > > - * from interrupt level when the buffer containing the inode is
> > > - * flushed to disk.  It is responsible for removing the inode item
> > > - * from the AIL if it has not been re-logged, and unlocking the inode's
> > > - * flush lock.
> > > - *
> > > - * To reduce AIL lock traffic as much as possible, we scan the buffer log item
> > > - * list for other inodes that will run this function. We remove them from the
> > > - * buffer list so we can process all the inode IO completions in one AIL lock
> > > - * traversal.
> > > - *
> > > - * Note: Now that we attach the log item to the buffer when we first log the
> > > - * inode in memory, we can have unflushed inodes on the buffer list here. These
> > > - * inodes will have a zero ili_last_fields, so skip over them here.
> > > + * We only want to pull the item from the AIL if it is actually there
> > > + * and its location in the log has not changed since we started the
> > > + * flush.  Thus, we only bother if the inode's lsn has not changed.
> > >   */
> > >  void
> > > -xfs_iflush_done(
> > > -	struct xfs_buf		*bp)
> > > +xfs_iflush_ail_updates(
> > > +	struct xfs_ail		*ailp,
> > > +	struct list_head	*list)
> > >  {
> > > -	struct xfs_inode_log_item *iip;
> > > -	struct xfs_log_item	*lip, *n;
> > > -	struct xfs_ail		*ailp = bp->b_mount->m_ail;
> > > -	int			need_ail = 0;
> > > -	LIST_HEAD(tmp);
> > > +	struct xfs_log_item	*lip;
> > > +	xfs_lsn_t		tail_lsn = 0;
> > >  
> > > -	/*
> > > -	 * Pull the attached inodes from the buffer one at a time and take the
> > > -	 * appropriate action on them.
> > > -	 */
> > > -	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
> > > -		iip = INODE_ITEM(lip);
> > > +	/* this is an opencoded batch version of xfs_trans_ail_delete */
> > > +	spin_lock(&ailp->ail_lock);
> > > +	list_for_each_entry(lip, list, li_bio_list) {
> > > +		xfs_lsn_t	lsn;
> > >  
> > > -		if (xfs_iflags_test(iip->ili_inode, XFS_ISTALE)) {
> > > -			xfs_iflush_abort(iip->ili_inode);
> > > +		if (INODE_ITEM(lip)->ili_flush_lsn != lip->li_lsn) {
> > > +			clear_bit(XFS_LI_FAILED, &lip->li_flags);
> > >  			continue;
> > >  		}
> > 
> > That seems like strange logic. Shouldn't we clear LI_FAILED regardless?
> 
> It's the same logic as before this patch series:
> 
>                        if (INODE_ITEM(blip)->ili_logged &&
>                             blip->li_lsn == INODE_ITEM(blip)->ili_flush_lsn) {
>                                 /*
>                                  * xfs_ail_update_finish() only cares about the
>                                  * lsn of the first tail item removed, any
>                                  * others will be at the same or higher lsn so
>                                  * we just ignore them.
>                                  */
>                                 xfs_lsn_t lsn = xfs_ail_delete_one(ailp, blip);
>                                 if (!tail_lsn && lsn)
>                                         tail_lsn = lsn;
>                         } else {
>                                 xfs_clear_li_failed(blip);
>                         }
> 
> I've just re-ordered it to check for relogged inodes first instead
> of handling that in the else branch.
> 

Hmm.. I guess I'm confused why the logic seems to be swizzled around. An
earlier patch lifted the bit clear outside of this check, then we seem
to put it back in place in a different order for some reason..?

> i.e. we do clear XFS_LI_FAILED always: xfs_ail_delete_one() does it
> for the log items that are being removed from the AIL....
> 
> > > +/*
> > > + * Inode buffer IO completion routine.  It is responsible for removing inodes
> > > + * attached to the buffer from the AIL if they have not been re-logged, as well
> > > + * as completing the flush and unlocking the inode.
> > > + */
> > > +void
> > > +xfs_iflush_done(
> > > +	struct xfs_buf		*bp)
> > > +{
> > > +	struct xfs_log_item	*lip, *n;
> > > +	LIST_HEAD(flushed_inodes);
> > > +	LIST_HEAD(ail_updates);
> > > +
> > > +	/*
> > > +	 * Pull the attached inodes from the buffer one at a time and take the
> > > +	 * appropriate action on them.
> > > +	 */
> > > +	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
> > > +		struct xfs_inode_log_item *iip = INODE_ITEM(lip);
> > > +
> > > +		if (xfs_iflags_test(iip->ili_inode, XFS_ISTALE)) {
> > > +			xfs_iflush_abort(iip->ili_inode);
> > > +			continue;
> > > +		}
> > > +		if (!iip->ili_last_fields)
> > > +			continue;
> > > +
> > > +		/* Do an unlocked check for needing the AIL lock. */
> > > +		if (iip->ili_flush_lsn == lip->li_lsn ||
> > > +		    test_bit(XFS_LI_FAILED, &lip->li_flags))
> > > +			list_move_tail(&lip->li_bio_list, &ail_updates);
> > > +		else
> > > +			list_move_tail(&lip->li_bio_list, &flushed_inodes);
> > 
> > Not sure I see the point of having two lists here, particularly since
> > this is all based on lockless logic.
> 
> It's not lockless - it's all done under the buffer lock which
> protects the buffer log item list...
> 
> > At the very least it's a subtle
> > change in AIL processing logic and I don't think that should be buried
> > in a refactoring patch.
> 
> I don't think it changes logic at all - what am I missing?
> 

I'm referring to the fact that we no longer check the lsn of each
(flushed) log item attached to the buffer under the ail lock. Note that
I am not saying it's necessarily wrong, but rather that IMO it's too
subtle a change to silently squash into a refactoring patch.

> FWIW, I untangled the function this way because the "track dirty
> inodes by ordered buffers" patchset completely removes the AIL stuff
> - the ail_updates list and the xfs_iflush_ail_updates() function go
> away completely and the rest of the refactoring remains unchanged.
> i.e.  as the commit messages says, this change makes follow-on
> patches much easier to understand...
> 

The general function breakdown seems fine to me. I find the multiple
list processing to be a bit overdone, particularly if it doesn't serve a
current functional purpose. If the purpose is to support a future patch
series, I'd suggest to continue using the existing logic of moving all
flushed inodes to a single list and leave the separate list bits to the
start of the series where it's useful so it's possible to review with
the associated context (or alternatively just defer the entire patch).

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

