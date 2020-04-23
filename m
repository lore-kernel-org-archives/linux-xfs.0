Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FAE7C54FCB
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 14:36:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A5132098B
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 14:36:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XL2G4dKP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbgDWOgq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 10:36:46 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31167 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726430AbgDWOgp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 10:36:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587652603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=85yKKmYu76betGJoVgrd+9gJAiUtIu+suyH4MhSl2oE=;
        b=XL2G4dKPRTsbOALgoxVwGB2uHqr2T7vQJjuaNenq5Y2mncBm4EeyeFOkmgbyRr5U1oSbA5
        8VxcFv61+gnT+xVWsGwceoLWgoFBKm4/xs6cxLHDkX+skb0fGg24wHe0pCtAbhfu4cTBuL
        fehS8lacnFslimlr/ipnKuTV36kBtVE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-gfudK-KVNp-dHiBfs9hegA-1; Thu, 23 Apr 2020 10:36:41 -0400
X-MC-Unique: gfudK-KVNp-dHiBfs9hegA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DB0C10CE782;
        Thu, 23 Apr 2020 14:36:40 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D34B35D70A;
        Thu, 23 Apr 2020 14:36:39 +0000 (UTC)
Date:   Thu, 23 Apr 2020 10:36:37 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 08/13] xfs: elide the AIL lock on log item failure
 tracking
Message-ID: <20200423143637.GC43557@bfoster>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-9-bfoster@redhat.com>
 <20200423055919.GO27860@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423055919.GO27860@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 23, 2020 at 03:59:19PM +1000, Dave Chinner wrote:
> On Wed, Apr 22, 2020 at 01:54:24PM -0400, Brian Foster wrote:
> > The log item failed flag is used to indicate a log item was flushed
> > but the underlying buffer was not successfully written to disk. If
> > the error configuration allows for writeback retries, xfsaild uses
> > the flag to resubmit the underlying buffer without acquiring the
> > flush lock of the item.
> > 
> > The flag is currently set and cleared under the AIL lock and buffer
> > lock in the ->iop_error() callback, invoked via ->b_iodone() at I/O
> > completion time. The flag is checked at xfsaild push time under AIL
> > lock and cleared under buffer lock before resubmission. If I/O
> > eventually succeeds, the flag is cleared in the _done() handler for
> > the associated item type, again under AIL lock and buffer lock.
> 
> Actually, I think you've missed the relevant lock here: the item's
> flush lock. The XFS_LI_FAILED flag is item flush state, and flush
> state is protected by the flush lock. When the item has been flushed
> and attached to the buffer for completion callbacks, the flush lock
> context gets handed to the buffer.
> 
> i.e. the buffer owns the flush lock and so while that buffer is
> locked for IO we know that the item flush state (and hence the
> XFS_LI_FAILED flag) is exclusively owned by the holder of the buffer
> lock.
> 

Right..

> (Note: this is how xfs_ifree_cluster() works - it grabs the buffer
> lock then walks the items on the buffer and changes the callback
> functions because those items are flush locked and hence holding the
> buffer lock gives exclusive access to the flush state of those
> items....)
> 
> > As far as I can tell, the only reason for holding the AIL lock
> > across sets/clears is to manage consistency between the log item
> > bitop state and the temporary buffer pointer that is attached to the
> > log item. The bit itself is used to manage consistency of the
> > attached buffer, but is not enough to guarantee the buffer is still
> > attached by the time xfsaild attempts to access it.
> 
> Correct. The guarantee that the buffer is still attached to the log
> item is what the AIL lock provides us with.
> 
> > However since
> > failure state is always set or cleared under buffer lock (either via
> > I/O completion or xfsaild), this particular case can be handled at
> > item push time by verifying failure state once under buffer lock.
> 
> In theory, yes, but there's a problem before you get that buffer
> lock. That is: what serialises access to lip->li_buf?
> 

That's partly what I was referring to above by the push time changes.
This patch was an attempt to replace reliance on ail_lock with a push
time sequence that would serialize access to a failed buffer
(essentially relying on the failed bit). Whether it's correct or not is
another matter... ;)

> The xfsaild does not hold a reference to the buffer and, without the
> AIL lock to provide synchronisation, the log item reference to the
> buffer can be dropped asynchronously by buffer IO completion. Hence
> the buffer could be freed between the xfsaild reading lip->li_buf
> and calling xfs_buf_trylock(bp). i.e. this introduces a
> use-after-free race condition on the initial buffer access.
> 

Hmm.. the log item holds a temporary reference to the buffer when the
failed state is set. On submission, xfsaild queues the failed buffer
(new ref for the delwri queue), clears the failed state and drops the
failure reference of every failed item that is attached. xfsaild is also
the only task that knows how to process LI_FAILED items, so I don't
think we'd ever race with a failed buffer becoming "unfailed" from
xfsaild (which is the scenario where a buffer could disappear from I/O
completion). In some sense, clearing LI_FAILED of an item is essentially
retaking ownership of the item flush lock and hold of the underlying
buffer, but the existing code is certainly not written that way.

The issue I was wrestling with wrt to this patch was primarily
maintaining consistency between the bit and the assignment of the
pointer on a failing I/O. E.g., the buffer pointer is set by the task
that sets the bit, but xfsaild checking the bit doesn't guarantee the
pointer had been set yet. I did add a post-buffer lock LI_FAILED check
as well, but that probably could have been an assert.

> IOWs, the xfsaild cannot access lip->li_buf safely unless the
> set/clear operations are protected by the same lock the xfsaild
> holds. The xfsaild holds neither the buffer lock, a buffer reference
> or an item flush lock, hence it's the AIL lock or nothing...
> 

Yeah, that was my impression from reading the code. I realize from this
discussion that this doesn't actually simplify the logic. That was the
primary goal, so I think I need to revisit the approach here. Even if
this is correct (which I'm still not totally sure of), it's fragile in
the sense that it partly relies on single-threadedness of xfsaild. I
initially thought about adding a log item spinlock for this kind of
thing, but it didn't (and still doesn't) seem appropriate to burden
every log item in the system with a spinlock for the rare case of buffer
I/O errors.

I mentioned in an earlier patch that it would be nice to consider
removing ->li_buf entirely but hadn't thought it through. That might
alleviate the need to serialize the pointer and the state in the first
place as well as remove the subtle ordering requirement from the
resubmit code to manage the buffer reference. Suppose we relied on
LI_FAILED to represent the buffer hold + flush lock, and then relied on
the hold to facilitate an in-core lookup from xfsaild. For example:

xfs_set_li_failed(lip, bp)
{
	/* keep the backing buffer in-core so long as the item is failed */
	if (!test_and_set_bit(XFS_LI_FAILED, &lip->li_flags))
		xfs_buf_hold(bp);
}

xfs_clear_li_failed(lip, bp)
{
	if (test_and_clear_bit(XFS_LI_FAILED, &lip->li_flags))
		xfs_buf_rele(bp);
}

/*
 * helper to get a mapping from a buffer backed log item and use it to
 * find an in-core buf
 */
xfs_item_to_bp(lip)
{
	if (inode item) {
		...
		blk = ip->imap->im_blkno;
		len = ip->imap->im_len;
	} else if (dquot item) {
		...
		blk = dqp->q_blkno;
		len = mp->m_quotainfo->qi_dqchunklen;
	}

	return xfs_buf_incore(blk, len, XBF_TRYLOCK);
}

xfsaild_resubmit_item(lip)
{
	...

	bp = xfs_item_to_bp(lip);
	if (!bp)
		return XFS_ITEM_LOCKED;
	if (!test_bit(XFS_LI_FAILED, &lip->li_flags))
		goto out_unlock;

	/* drop all failure refs */
	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
		xfs_clear_li_failed(lip, bp);

	xfs_buf_delwri_queue(...);

	xfs_buf_relse(bp);
	return XFS_ITEM_SUCCESS;
}

I think that would push everything under the buffer lock (and remove
->li_buf) with the caveat that we'd have to lock the inode/dquot to get
the buffer. Any thoughts on something like that? Note that at this point
I might drop this patch from the series regardless due to the complexity
mismatch and consider it separately.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

