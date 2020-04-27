Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22FC5C54FD0
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 11:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E70992063A
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 11:11:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BDqDK6E8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgD0LL1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 07:11:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31350 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726907AbgD0LL1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 07:11:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587985884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O5I4q1B8ads2SiGlD93fDUH6To6GL2Dsd408UydHEQ4=;
        b=BDqDK6E8jbjU62jyX88FNvaLLB1DCo3Axr1bWpRvM8GQ21UiA3Y/RUzLdU4xPjuYyWFSKc
        A13FeXcq6ZCaGR1gnuBEftEfKKSNt/gpcXZ7j2Hjc0/b4Taiu5hbfor5jS3u2MGDLX6/st
        MYLoawCGPaaCz6sRgCsUE/YetBJr9yY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-PJy1wZI-Ol6wo8KzWQi_5Q-1; Mon, 27 Apr 2020 07:11:23 -0400
X-MC-Unique: PJy1wZI-Ol6wo8KzWQi_5Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2253E107ACCA;
        Mon, 27 Apr 2020 11:11:22 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A4C5719C4F;
        Mon, 27 Apr 2020 11:11:21 +0000 (UTC)
Date:   Mon, 27 Apr 2020 07:11:19 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 05/13] xfs: ratelimit unmount time per-buffer I/O
 error message
Message-ID: <20200427111119.GA4577@bfoster>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-6-bfoster@redhat.com>
 <20200423044604.GI27860@dread.disaster.area>
 <20200423142958.GB43557@bfoster>
 <20200423211437.GP27860@dread.disaster.area>
 <20200424111232.GA53325@bfoster>
 <20200424220823.GD2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424220823.GD2040@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 25, 2020 at 08:08:23AM +1000, Dave Chinner wrote:
> On Fri, Apr 24, 2020 at 07:12:32AM -0400, Brian Foster wrote:
> > On Fri, Apr 24, 2020 at 07:14:37AM +1000, Dave Chinner wrote:
> > > On Thu, Apr 23, 2020 at 10:29:58AM -0400, Brian Foster wrote:
> > > > On Thu, Apr 23, 2020 at 02:46:04PM +1000, Dave Chinner wrote:
> > > > > On Wed, Apr 22, 2020 at 01:54:21PM -0400, Brian Foster wrote:
> > > > > > At unmount time, XFS emits a warning for every in-core buffer that
> > > > > > might have undergone a write error. In practice this behavior is
> > > > > > probably reasonable given that the filesystem is likely short lived
> > > > > > once I/O errors begin to occur consistently. Under certain test or
> > > > > > otherwise expected error conditions, this can spam the logs and slow
> > > > > > down the unmount.
> > > > > > 
> > > > > > We already have a ratelimit state defined for buffers failing
> > > > > > writeback. Fold this state into the buftarg and reuse it for the
> > > > > > unmount time errors.
> > > > > > 
> > > > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > > 
> > > > > Looks fine, but I suspect we both missed something here:
> > > > > xfs_buf_ioerror_alert() was made a ratelimited printk in the last
> > > > > cycle:
> > > > > 
> > > > > void
> > > > > xfs_buf_ioerror_alert(
> > > > >         struct xfs_buf          *bp,
> > > > >         xfs_failaddr_t          func)
> > > > > {
> > > > >         xfs_alert_ratelimited(bp->b_mount,
> > > > > "metadata I/O error in \"%pS\" at daddr 0x%llx len %d error %d",
> > > > >                         func, (uint64_t)XFS_BUF_ADDR(bp), bp->b_length,
> > > > >                         -bp->b_error);
> > > > > }
> > > > > 
> > > > 
> > > > Yeah, I hadn't noticed that.
> > > > 
> > > > > Hence I think all these buffer error alerts can be brought under the
> > > > > same rate limiting variable. Something like this in xfs_message.c:
> > > > > 
> > > > 
> > > > One thing to note is that xfs_alert_ratelimited() ultimately uses
> > > > the DEFAULT_RATELIMIT_INTERVAL of 5s. The ratelimit we're generalizing
> > > > here uses 30s (both use a burst of 10). That seems reasonable enough to
> > > > me for I/O errors so I'm good with the changes below.
> > > > 
> > > > FWIW, that also means we could just call xfs_buf_alert_ratelimited()
> > > > from xfs_buf_item_push() if we're also Ok with using an "alert" instead
> > > > of a "warn." I'm not immediately aware of a reason to use one over the
> > > > other (xfs_wait_buftarg() already uses alert) so I'll try that unless I
> > > > hear an objection.
> > > 
> > > SOunds fine to me.
> > > 
> > > > The xfs_wait_buftarg() ratelimit presumably remains
> > > > open coded because it's two separate calls and we probably don't want
> > > > them to individually count against the limit.
> > > 
> > > That's why I suggested dropping the second "run xfs_repair" message
> > > and triggering a shutdown after the wait loop. That way we don't
> > > issue "run xfs_repair" for every single failed buffer (largely
> > > noise!), and we get a non-rate-limited common "run xfs-repair"
> > > message once we processed all the failed writes.
> > > 
> > 
> > Sorry, must have missed that in the last reply. I don't think we want to
> > shut down here because XBF_WRITE_FAIL only reflects that the internal
> > async write retry (e.g. the one historically used to mitigate transient
> > I/O errors) has occurred on the buffer, not necessarily that the
> > immediately previous I/O has failed.
> 
> I think this is an incorrect reading of how XBF_WRITE_FAIL
> functions. XBF_WRITE_FAIL is used to indicate that the previous
> write failed, not that a historic write failed. The flag is cleared
> at buffer submission time - see xfs_buf_delwri_submit_buffers() and
> xfs_bwrite() - and so it is only set on buffers whose previous IO
> failed and hence is still dirty and has not been flushed back to
> disk.
> 

Right, but the flag is only ever cleared in those particular submission
paths (which doesn't include the resubmit path). The point being
overlooked here is that it is never cleared on successful I/O
completion. That means if an I/O fails, we set the flag and resubmit. If
the resubmitted I/O succeeds, the flag remains set on the buffer until
the next time it is written, but there's no guarantee the buffer is
dirtied again before we unmount. Therefore, it's possible to have
XBF_WRITE_FAIL set on clean/consistent buffers at unmount time without
any underlying inconsistency.

> If we hit this in xfs_buftarg_wait() after we've pushed the AIL in
> xfs_log_quiesce() on unmount, then we've got write failures that
> could not be resolved by repeated retries, and the filesystem is, at
> this instant in time, inconsistent on disk.
> 
> That's a shutdown error condition...
> 

Yes, but XBF_WRITE_FAIL does not reflect that condition with certainty.

> > For that reason I've kind of looked
> > at this particular instance as more of a warning that I/O errors have
> > occurred in the past and the user might want to verify it didn't result
> > in unexpected damage. FWIW, I've observed plenty of these messages long
> > after I've disabled error injection and allowed I/O to proceed and the
> > fs to unmount cleanly.
> 
> Right. THat's the whole point of the flag - the buffer has been
> dirtied and it hasn't been able to be written back when we are
> purging the buffer cache at the end of unmount. i.e. When
> xfs_buftarg_wait() is called, all buffers should be clean because we
> are about to write an unmount record to mark the log clean once all
> the logged metadata is written back.
> 
> What we do right now - write an unmount record after failing metadta
> writeback - is actually a bug, and that is one of the
> reasons why I suggested a shutdown should be done. i.e. we should
> not be writing an unmount record to mark the log clean if we failed
> to write back metadata. That metadata is still valid in the journal,
> and so it should remain valid in the journal to allow it to be
> replayed on the next mount. i.e. retry the writes from log recovery
> after the hardware failure has been addressed and the IO errors have
> gone away.
> 
> Tossing the dirty buffers unmount and then marking the journal
> clean is actually making the buffer write failure -worse-. Doing this
> guarantees the filesystem is inconsistent on disk (by updating the
> journal to indicate those writes actually succeeded) and absolutely
> requires xfs_repair to fix as a result.
> 
> If we shut down on XBF_WRITE_FAIL buffers in xfs_buftarg_wait(), we
> will not write an unmount record and so give the filesystem a chance
> to recover on next mount (e.g. after a power cycle to clear whatever
> raid hardware bug was being hit) and write that dirty metadata back
> without failure.  If recovery fails with IO errors, then the user
> really does need to run repair.  However, the situation at this
> point is still better than if we write a clean unmount record after
> write failures...
> 

I agree with all of this when we are actually tossing dirty buffers. ;)
See above that I'm referring to how this state can persist after error
injection is disabled and I/O errors have ceased. Also note that the
error handling code already shuts down the filesystem in the completion
handling path of any buffer undergoing retries at unmount time (see
XFS_MOUNT_UNMOUNTING). IIRC this was introduced to prevent hanging
unmount on fs' configured with infinite retries, but it ensures the fs
is shut down if dirty buffers have failed to write back before we get to
xfs_wait_buftarg(). So there isn't a functional bug from what I can see
if XBF_WRITE_FAIL does happen to reflect a failed+dirty buffer in
xfs_wait_buftarg().

It's pretty clear that the implementation of XBF_WRITE_FAIL is
unnecessarily fragile and confusing. Aside from not being able to
establish the meaning of the xfs_wait_buftarg() warning message between
the two of us (good luck, users ;P), I'm guessing it's also not obvious
that there's an internal retry associated with each xfsaild submitted
write, even for buffers that persistently fail. For example, xfsaild
submits a buffer, I/O fails, we set XBF_WRITE_FAIL and resubmit, I/O
fails again, XBF_WRITE_FAIL is already set and retries are configured so
we unlock the buffer, xfsaild comes around again and requeues, delwri
submit clears XBF_WRITE_FAIL and we start over from the beginning.

Perhaps a better solution would be to clear XBF_WRITE_FAIL on successful
I/O completion. That way we only issue the internal retry once since the
last time a buffer was successfully written and xfs_wait_buftarg() can
legitimately warn about tossing dirty buffers and shut down. I do think
it makes sense to shut down from there in that scenario as well,
provided the logic is correct, simply because the dependency on error
configuration shutdown behavior is not obvious. Thoughts?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

