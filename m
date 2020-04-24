Return-Path: <SRS0=lEGq=6I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D650C2BA1A
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 11:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2552420736
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 11:14:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KdUPSMLj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgDXLO3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Apr 2020 07:14:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22074 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726614AbgDXLO3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Apr 2020 07:14:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587726866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cSaI+5jjLRCdCG4JkGak6n59PLKAptw/kV6ddFHV3bA=;
        b=KdUPSMLj3gA1v+Czdw+po14CIwtHt+lNWSpN68PqAr1xsBOM2vxiaAI6HDWIDdqT0qaJE2
        JEYRkl+uKZU+jW88eykCnQEeQWXRxBF5+hkvk0rUPX4iXqpRM+aJ7DZQUV4ZulOcXctncX
        2E3n/UumRrSD+tBEBCERrq87tOnamGQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-f5rcfjO2NYCljIQz0v54og-1; Fri, 24 Apr 2020 07:14:25 -0400
X-MC-Unique: f5rcfjO2NYCljIQz0v54og-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C6B81895A28;
        Fri, 24 Apr 2020 11:14:24 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AF8D45D9CC;
        Fri, 24 Apr 2020 11:14:23 +0000 (UTC)
Date:   Fri, 24 Apr 2020 07:14:21 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 08/13] xfs: elide the AIL lock on log item failure
 tracking
Message-ID: <20200424111421.GB53325@bfoster>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-9-bfoster@redhat.com>
 <20200423055919.GO27860@dread.disaster.area>
 <20200423143637.GC43557@bfoster>
 <20200423213839.GQ27860@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423213839.GQ27860@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 24, 2020 at 07:38:39AM +1000, Dave Chinner wrote:
> On Thu, Apr 23, 2020 at 10:36:37AM -0400, Brian Foster wrote:
> > On Thu, Apr 23, 2020 at 03:59:19PM +1000, Dave Chinner wrote:
> > > On Wed, Apr 22, 2020 at 01:54:24PM -0400, Brian Foster wrote:
> > > > The log item failed flag is used to indicate a log item was flushed
> > > > but the underlying buffer was not successfully written to disk. If
> > > > the error configuration allows for writeback retries, xfsaild uses
> > > > the flag to resubmit the underlying buffer without acquiring the
> > > > flush lock of the item.
> > > > 
> > > > The flag is currently set and cleared under the AIL lock and buffer
> > > > lock in the ->iop_error() callback, invoked via ->b_iodone() at I/O
> > > > completion time. The flag is checked at xfsaild push time under AIL
> > > > lock and cleared under buffer lock before resubmission. If I/O
> > > > eventually succeeds, the flag is cleared in the _done() handler for
> > > > the associated item type, again under AIL lock and buffer lock.
> > > 
> > > Actually, I think you've missed the relevant lock here: the item's
> > > flush lock. The XFS_LI_FAILED flag is item flush state, and flush
> > > state is protected by the flush lock. When the item has been flushed
> > > and attached to the buffer for completion callbacks, the flush lock
> > > context gets handed to the buffer.
> > > 
> > > i.e. the buffer owns the flush lock and so while that buffer is
> > > locked for IO we know that the item flush state (and hence the
> > > XFS_LI_FAILED flag) is exclusively owned by the holder of the buffer
> > > lock.
> > > 
> > 
> > Right..
> > 
> > > (Note: this is how xfs_ifree_cluster() works - it grabs the buffer
> > > lock then walks the items on the buffer and changes the callback
> > > functions because those items are flush locked and hence holding the
> > > buffer lock gives exclusive access to the flush state of those
> > > items....)
> > > 
> > > > As far as I can tell, the only reason for holding the AIL lock
> > > > across sets/clears is to manage consistency between the log item
> > > > bitop state and the temporary buffer pointer that is attached to the
> > > > log item. The bit itself is used to manage consistency of the
> > > > attached buffer, but is not enough to guarantee the buffer is still
> > > > attached by the time xfsaild attempts to access it.
> > > 
> > > Correct. The guarantee that the buffer is still attached to the log
> > > item is what the AIL lock provides us with.
> > > 
> > > > However since
> > > > failure state is always set or cleared under buffer lock (either via
> > > > I/O completion or xfsaild), this particular case can be handled at
> > > > item push time by verifying failure state once under buffer lock.
> > > 
> > > In theory, yes, but there's a problem before you get that buffer
> > > lock. That is: what serialises access to lip->li_buf?
> > > 
> > 
> > That's partly what I was referring to above by the push time changes.
> > This patch was an attempt to replace reliance on ail_lock with a push
> > time sequence that would serialize access to a failed buffer
> > (essentially relying on the failed bit). Whether it's correct or not is
> > another matter... ;)
> > 
> > > The xfsaild does not hold a reference to the buffer and, without the
> > > AIL lock to provide synchronisation, the log item reference to the
> > > buffer can be dropped asynchronously by buffer IO completion. Hence
> > > the buffer could be freed between the xfsaild reading lip->li_buf
> > > and calling xfs_buf_trylock(bp). i.e. this introduces a
> > > use-after-free race condition on the initial buffer access.
> > > 
> > 
> > Hmm.. the log item holds a temporary reference to the buffer when the
> > failed state is set. On submission, xfsaild queues the failed buffer
> > (new ref for the delwri queue), clears the failed state and drops the
> > failure reference of every failed item that is attached. xfsaild is also
> > the only task that knows how to process LI_FAILED items, so I don't
> > think we'd ever race with a failed buffer becoming "unfailed" from
> > xfsaild (which is the scenario where a buffer could disappear from I/O
> > completion).
> 
> Sure we can. every inode on the buffer has XFS_LI_FAILED set on it,
> so the first inode in the AIL triggers the resubmit and starts the
> IO. the AIL runs again, coming across another inode on the buffer
> further into the AIL. That inode has been modified in memory while
> the flush was in progress, so it no longer gets removed from the AIL
> by the IO completion. Instead, xfs_clear_li_failed() is called from
> xfs_iflush_done() and the buffer is removed from the logitem and the
> reference dropped.
> 

When xfsaild encounters the first failed item, the buffer resubmit path
(xfsaild_resubmit_item(), as of this series) calls xfs_clear_li_failed()
on every inode attached to the buffer. AFAICT, that means xfsaild will
see any associated inode as FLUSHING (or PINNED, if another in-core
modification has come through) once the buffer is requeued.

> > In some sense, clearing LI_FAILED of an item is essentially
> > retaking ownership of the item flush lock and hold of the underlying
> > buffer, but the existing code is certainly not written that way.
> 
> Only IO completion clears the LI_FAILED state of the item, not the
> xfsaild. IO completion already owns the flush lock - the xfsaild
> only holds it long enough to flush an inode to the buffer and then
> give the flush lock to the buffer.
> 
> Also, we clear LI_FAILED when removing the item from the AIL under
> the AIL lock, so the only case here that we are concerned about is
> the above "inode was relogged while being flushed" situation. THis
> situation is rare, failed buffers are rare, and so requiring the AIL
> lock to be held is a performance limiting factor here...
> 

Yep, though because of the above I think I/O completion clearing the
failed state might require a more subtle dance between xfsaild and
another submission context, such as if reclaim happens to flush an inode
that wasn't already attached to a previously failed buffer (for
example).

Eh, it doesn't matter that much in any event because..

> > The issue I was wrestling with wrt to this patch was primarily
> > maintaining consistency between the bit and the assignment of the
> > pointer on a failing I/O. E.g., the buffer pointer is set by the task
> > that sets the bit, but xfsaild checking the bit doesn't guarantee the
> > pointer had been set yet. I did add a post-buffer lock LI_FAILED check
> > as well, but that probably could have been an assert.
> 
> SO you've been focussing on races that may occur when the setting of
> the li_buf, but I'm looking at races involving the clearing of the
> li_buf pointer. :)
> 
> > > IOWs, the xfsaild cannot access lip->li_buf safely unless the
> > > set/clear operations are protected by the same lock the xfsaild
> > > holds. The xfsaild holds neither the buffer lock, a buffer reference
> > > or an item flush lock, hence it's the AIL lock or nothing...
> > > 
> > 
> > Yeah, that was my impression from reading the code. I realize from this
> > discussion that this doesn't actually simplify the logic. That was the
> > primary goal, so I think I need to revisit the approach here. Even if
> > this is correct (which I'm still not totally sure of), it's fragile in
> > the sense that it partly relies on single-threadedness of xfsaild. I
> > initially thought about adding a log item spinlock for this kind of
> > thing, but it didn't (and still doesn't) seem appropriate to burden
> > every log item in the system with a spinlock for the rare case of buffer
> > I/O errors.
> 
> I feel this is all largely a moot, because my patches result in this
> this whole problem of setting/clearing the li_buf for failed buffers
> go away altogether. Hence I would suggest that this patch gets
> dropped for now, because getting rid of the AIL lock is much less
> troublesome once LI_FAILED is no long dependent on the inode/dquot
> log item taking temporary references to the underlying buffer....
> 

... I'm good with that. ;) This was intended to be a low level cleanup
to eliminate a fairly minor ail_lock abuse. Working around the ->li_buf
thing is the primary challenge, so if you have a broader rework that
addresses that as a side effect then that presumably makes things
easier.  I'll revisit this if necessary once your work is further
along...

Brian

> > 
> > I mentioned in an earlier patch that it would be nice to consider
> > removing ->li_buf entirely but hadn't thought it through.
> 
> I'm going the opposite way entirely, such that LI_FAILED doesn't
> have any special state associated with it at all...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

