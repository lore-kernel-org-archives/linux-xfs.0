Return-Path: <SRS0=lEGq=6I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A6C0C55191
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 11:12:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73DA820728
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 11:12:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dM7rOZBu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgDXLMp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Apr 2020 07:12:45 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60338 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726289AbgDXLMo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Apr 2020 07:12:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587726762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FwgcNjW7QwERI5Oqwj9M58zeoFdJ7IQ2ei6/6fnrIBY=;
        b=dM7rOZBudIUmkanwF/5UjZCG4X5rJwYdcne78yCDqPaml72GOESy8ZyYYB0c/+jMJLAfzl
        Ak7lSVwpBxedWYVg8RsIeyT8gWGc3tTYOSwYtZWLBhh8fYrkSrrHQ17n9/pHjj4f1Cg5Nq
        cdORVH1YVdEBuzcebKtj5vyr3A/m8bg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-Z3LMS6XUMeKfVJJneNozhw-1; Fri, 24 Apr 2020 07:12:36 -0400
X-MC-Unique: Z3LMS6XUMeKfVJJneNozhw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 083851005510;
        Fri, 24 Apr 2020 11:12:35 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D70B5C1D2;
        Fri, 24 Apr 2020 11:12:34 +0000 (UTC)
Date:   Fri, 24 Apr 2020 07:12:32 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 05/13] xfs: ratelimit unmount time per-buffer I/O
 error message
Message-ID: <20200424111232.GA53325@bfoster>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-6-bfoster@redhat.com>
 <20200423044604.GI27860@dread.disaster.area>
 <20200423142958.GB43557@bfoster>
 <20200423211437.GP27860@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423211437.GP27860@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 24, 2020 at 07:14:37AM +1000, Dave Chinner wrote:
> On Thu, Apr 23, 2020 at 10:29:58AM -0400, Brian Foster wrote:
> > On Thu, Apr 23, 2020 at 02:46:04PM +1000, Dave Chinner wrote:
> > > On Wed, Apr 22, 2020 at 01:54:21PM -0400, Brian Foster wrote:
> > > > At unmount time, XFS emits a warning for every in-core buffer that
> > > > might have undergone a write error. In practice this behavior is
> > > > probably reasonable given that the filesystem is likely short lived
> > > > once I/O errors begin to occur consistently. Under certain test or
> > > > otherwise expected error conditions, this can spam the logs and slow
> > > > down the unmount.
> > > > 
> > > > We already have a ratelimit state defined for buffers failing
> > > > writeback. Fold this state into the buftarg and reuse it for the
> > > > unmount time errors.
> > > > 
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > 
> > > Looks fine, but I suspect we both missed something here:
> > > xfs_buf_ioerror_alert() was made a ratelimited printk in the last
> > > cycle:
> > > 
> > > void
> > > xfs_buf_ioerror_alert(
> > >         struct xfs_buf          *bp,
> > >         xfs_failaddr_t          func)
> > > {
> > >         xfs_alert_ratelimited(bp->b_mount,
> > > "metadata I/O error in \"%pS\" at daddr 0x%llx len %d error %d",
> > >                         func, (uint64_t)XFS_BUF_ADDR(bp), bp->b_length,
> > >                         -bp->b_error);
> > > }
> > > 
> > 
> > Yeah, I hadn't noticed that.
> > 
> > > Hence I think all these buffer error alerts can be brought under the
> > > same rate limiting variable. Something like this in xfs_message.c:
> > > 
> > 
> > One thing to note is that xfs_alert_ratelimited() ultimately uses
> > the DEFAULT_RATELIMIT_INTERVAL of 5s. The ratelimit we're generalizing
> > here uses 30s (both use a burst of 10). That seems reasonable enough to
> > me for I/O errors so I'm good with the changes below.
> > 
> > FWIW, that also means we could just call xfs_buf_alert_ratelimited()
> > from xfs_buf_item_push() if we're also Ok with using an "alert" instead
> > of a "warn." I'm not immediately aware of a reason to use one over the
> > other (xfs_wait_buftarg() already uses alert) so I'll try that unless I
> > hear an objection.
> 
> SOunds fine to me.
> 
> > The xfs_wait_buftarg() ratelimit presumably remains
> > open coded because it's two separate calls and we probably don't want
> > them to individually count against the limit.
> 
> That's why I suggested dropping the second "run xfs_repair" message
> and triggering a shutdown after the wait loop. That way we don't
> issue "run xfs_repair" for every single failed buffer (largely
> noise!), and we get a non-rate-limited common "run xfs-repair"
> message once we processed all the failed writes.
> 

Sorry, must have missed that in the last reply. I don't think we want to
shut down here because XBF_WRITE_FAIL only reflects that the internal
async write retry (e.g. the one historically used to mitigate transient
I/O errors) has occurred on the buffer, not necessarily that the
immediately previous I/O has failed. For that reason I've kind of looked
at this particular instance as more of a warning that I/O errors have
occurred in the past and the user might want to verify it didn't result
in unexpected damage. FWIW, I've observed plenty of these messages long
after I've disabled error injection and allowed I/O to proceed and the
fs to unmount cleanly.

Looking at it again, the wording of the message is much stronger than a
warning (i.e. "Corruption Alert", "permanent write failures"), so
perhaps we should revisit what we're actually trying to accomplish with
this message. Note that we do have the buffer push time alert to
indicate that I/O errors and retries are occurring, as well as error
handling logic to shutdown on I/O failure while the fs is unmounting
(xfs_buf_iodone_callback_error()), so both of those cases are
fundamentally covered already.

ISTM that leaves at least a few simple options for the
xfs_wait_buftarg() message:

1.) Remove it.
2.) Massage it into more of a "Warning: buffer I/O errors have occurred
in the past" type of message. This could perhaps retain the existing
XBF_WRITE_FAIL logic, but use a flag to lift it out of the loop and thus
avoid the need to rate limit it at all.
3.) Fix up the logic to only dump (ratelimited) specifics on buffers
that have actually failed I/O. This means we use the existing message
but perhaps check ->b_error instead of XBF_WRITE_FAIL. We still don't
need to shut down (I'd probably add an assert), but we could also lift
the second xfs_repair line of the message out of the loop to reduce the
noise.

We could also look into clearing XBF_WRITE_RETRY on successful I/O
completion, FWIW. The existing logic kind of bugs me regardless.
Thoughts?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

