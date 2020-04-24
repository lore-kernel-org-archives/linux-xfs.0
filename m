Return-Path: <SRS0=lEGq=6I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B72C54FCB
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 22:08:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2368420857
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 22:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbgDXWI2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Apr 2020 18:08:28 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55988 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725874AbgDXWI2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Apr 2020 18:08:28 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id EC5F33A2D79;
        Sat, 25 Apr 2020 08:08:24 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jS6Uh-0000CD-9A; Sat, 25 Apr 2020 08:08:23 +1000
Date:   Sat, 25 Apr 2020 08:08:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 05/13] xfs: ratelimit unmount time per-buffer I/O
 error message
Message-ID: <20200424220823.GD2040@dread.disaster.area>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-6-bfoster@redhat.com>
 <20200423044604.GI27860@dread.disaster.area>
 <20200423142958.GB43557@bfoster>
 <20200423211437.GP27860@dread.disaster.area>
 <20200424111232.GA53325@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424111232.GA53325@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=44l3WESBWvFp0OVIzlgA:9 a=CjuIK1q_8ugA:10 a=igBNqPyMv6gA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 24, 2020 at 07:12:32AM -0400, Brian Foster wrote:
> On Fri, Apr 24, 2020 at 07:14:37AM +1000, Dave Chinner wrote:
> > On Thu, Apr 23, 2020 at 10:29:58AM -0400, Brian Foster wrote:
> > > On Thu, Apr 23, 2020 at 02:46:04PM +1000, Dave Chinner wrote:
> > > > On Wed, Apr 22, 2020 at 01:54:21PM -0400, Brian Foster wrote:
> > > > > At unmount time, XFS emits a warning for every in-core buffer that
> > > > > might have undergone a write error. In practice this behavior is
> > > > > probably reasonable given that the filesystem is likely short lived
> > > > > once I/O errors begin to occur consistently. Under certain test or
> > > > > otherwise expected error conditions, this can spam the logs and slow
> > > > > down the unmount.
> > > > > 
> > > > > We already have a ratelimit state defined for buffers failing
> > > > > writeback. Fold this state into the buftarg and reuse it for the
> > > > > unmount time errors.
> > > > > 
> > > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > 
> > > > Looks fine, but I suspect we both missed something here:
> > > > xfs_buf_ioerror_alert() was made a ratelimited printk in the last
> > > > cycle:
> > > > 
> > > > void
> > > > xfs_buf_ioerror_alert(
> > > >         struct xfs_buf          *bp,
> > > >         xfs_failaddr_t          func)
> > > > {
> > > >         xfs_alert_ratelimited(bp->b_mount,
> > > > "metadata I/O error in \"%pS\" at daddr 0x%llx len %d error %d",
> > > >                         func, (uint64_t)XFS_BUF_ADDR(bp), bp->b_length,
> > > >                         -bp->b_error);
> > > > }
> > > > 
> > > 
> > > Yeah, I hadn't noticed that.
> > > 
> > > > Hence I think all these buffer error alerts can be brought under the
> > > > same rate limiting variable. Something like this in xfs_message.c:
> > > > 
> > > 
> > > One thing to note is that xfs_alert_ratelimited() ultimately uses
> > > the DEFAULT_RATELIMIT_INTERVAL of 5s. The ratelimit we're generalizing
> > > here uses 30s (both use a burst of 10). That seems reasonable enough to
> > > me for I/O errors so I'm good with the changes below.
> > > 
> > > FWIW, that also means we could just call xfs_buf_alert_ratelimited()
> > > from xfs_buf_item_push() if we're also Ok with using an "alert" instead
> > > of a "warn." I'm not immediately aware of a reason to use one over the
> > > other (xfs_wait_buftarg() already uses alert) so I'll try that unless I
> > > hear an objection.
> > 
> > SOunds fine to me.
> > 
> > > The xfs_wait_buftarg() ratelimit presumably remains
> > > open coded because it's two separate calls and we probably don't want
> > > them to individually count against the limit.
> > 
> > That's why I suggested dropping the second "run xfs_repair" message
> > and triggering a shutdown after the wait loop. That way we don't
> > issue "run xfs_repair" for every single failed buffer (largely
> > noise!), and we get a non-rate-limited common "run xfs-repair"
> > message once we processed all the failed writes.
> > 
> 
> Sorry, must have missed that in the last reply. I don't think we want to
> shut down here because XBF_WRITE_FAIL only reflects that the internal
> async write retry (e.g. the one historically used to mitigate transient
> I/O errors) has occurred on the buffer, not necessarily that the
> immediately previous I/O has failed.

I think this is an incorrect reading of how XBF_WRITE_FAIL
functions. XBF_WRITE_FAIL is used to indicate that the previous
write failed, not that a historic write failed. The flag is cleared
at buffer submission time - see xfs_buf_delwri_submit_buffers() and
xfs_bwrite() - and so it is only set on buffers whose previous IO
failed and hence is still dirty and has not been flushed back to
disk.

If we hit this in xfs_buftarg_wait() after we've pushed the AIL in
xfs_log_quiesce() on unmount, then we've got write failures that
could not be resolved by repeated retries, and the filesystem is, at
this instant in time, inconsistent on disk.

That's a shutdown error condition...

> For that reason I've kind of looked
> at this particular instance as more of a warning that I/O errors have
> occurred in the past and the user might want to verify it didn't result
> in unexpected damage. FWIW, I've observed plenty of these messages long
> after I've disabled error injection and allowed I/O to proceed and the
> fs to unmount cleanly.

Right. THat's the whole point of the flag - the buffer has been
dirtied and it hasn't been able to be written back when we are
purging the buffer cache at the end of unmount. i.e. When
xfs_buftarg_wait() is called, all buffers should be clean because we
are about to write an unmount record to mark the log clean once all
the logged metadata is written back.

What we do right now - write an unmount record after failing metadta
writeback - is actually a bug, and that is one of the
reasons why I suggested a shutdown should be done. i.e. we should
not be writing an unmount record to mark the log clean if we failed
to write back metadata. That metadata is still valid in the journal,
and so it should remain valid in the journal to allow it to be
replayed on the next mount. i.e. retry the writes from log recovery
after the hardware failure has been addressed and the IO errors have
gone away.

Tossing the dirty buffers unmount and then marking the journal
clean is actually making the buffer write failure -worse-. Doing this
guarantees the filesystem is inconsistent on disk (by updating the
journal to indicate those writes actually succeeded) and absolutely
requires xfs_repair to fix as a result.

If we shut down on XBF_WRITE_FAIL buffers in xfs_buftarg_wait(), we
will not write an unmount record and so give the filesystem a chance
to recover on next mount (e.g. after a power cycle to clear whatever
raid hardware bug was being hit) and write that dirty metadata back
without failure.  If recovery fails with IO errors, then the user
really does need to run repair.  However, the situation at this
point is still better than if we write a clean unmount record after
write failures...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
