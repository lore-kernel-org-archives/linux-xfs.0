Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52682 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762933AbdJQOx7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Oct 2017 10:53:59 -0400
Date: Tue, 17 Oct 2017 10:53:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Question about 67dc288c ("xfs: ensure verifiers are attached to
 recovered buffers")
Message-ID: <20171017145355.GA6392@localhost.localdomain>
References: <20171013184916.GS7122@magnolia>
 <20171014115550.GB50635@bfoster.bfoster>
 <20171014190530.GA4594@magnolia>
 <20171016212933.GG15067@dastard>
 <20171016221818.GQ4703@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171016221818.GQ4703@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>

On Mon, Oct 16, 2017 at 03:18:18PM -0700, Darrick J. Wong wrote:
> On Tue, Oct 17, 2017 at 08:29:33AM +1100, Dave Chinner wrote:
> > On Sat, Oct 14, 2017 at 12:05:30PM -0700, Darrick J. Wong wrote:
> > > On Sat, Oct 14, 2017 at 07:55:51AM -0400, Brian Foster wrote:
> > > > On Fri, Oct 13, 2017 at 11:49:16AM -0700, Darrick J. Wong wrote:
> > > > > Hi all,
> > > > > 
> > > > > I have a question about 67dc288c ("xfs: ensure verifiers are attached to
> > > > > recovered buffers").  I was analyzing a scrub failure on generic/392
> > > > > with a v4 filesystem which stems from xfs_scrub_buffer_recheck (it's in
> > > > > scrub part 4) being unable to find a b_ops attached to the AGF buffer
> > > > > and signalling error.
> > > > > 
> > > > > The pattern I observe is that when log recovery runs on a v4 filesystem,
> > > > > we call some variant of xfs_buf_read with a NULL ops parameter.  The
> > > > > buffer therefore gets created and read without any verifiers.
> > > > > Eventually, xlog_recover_validate_buf_type gets called, and on a v5
> > > > > filesystem we come back and attach verifiers and all is well.  However,
> > > > > on a v4 filesystem the function returns without doing anything, so the
> > > > > xfs_buf just sits around in memory with no verifier.  Subsequent
> > > > > read/log/relse patterns can write anything they want without write
> > > > > verifiers to check that.
> > > > > 
> > > > > If the v4 fs didn't need log recovery, the buffers get created with
> > > > > b_ops as you'd expect.
> > > > > 
> > > > > My question is, shouldn't xlog_recover_validate_buf_type unconditionally
> > > > > set b_ops and save the "if (hascrc)" bits for the part that ensures the
> > > > > LSN is up to date?
> > > > > 
> > > > 
> > > > Seems reasonable, but I notice that the has_crc() check around
> > > > _validate_buf_type() comes in sometime after the the original commit
> > > > referenced below (d75afeb3) and commit 67dc288c. It appears to be due to
> > > > commit 9222a9cf86 ("xfs: don't shutdown log recovery on validation
> > > > errors").
> > > > 
> > > > IIRC, the problem there is that log recovery had traditionally always
> > > > unconditionally replayed everything in the log over whatever resides in
> > > > the fs. This actually meant that recovery could transiently corrupt
> > > > buffers in certain cases if the target buffer happened to be relogged
> > > > more than once and was already up to date, which leads to verification
> > > > failures. This was addressed for v5 filesystems with LSN ordering rules,
> > > > but the challenge for v4 filesystems was that there is no metadata LSN
> > > > and thus no means to detect whether a buffer is already up to date with
> > > > regard to a transaction in the log.
> > > > 
> > > > Dave might have more historical context to confirm that... If that is
> > > > still an open issue, a couple initial ideas come to mind:
> > > > 
> > > > 1.) Do something simple/crude like reclaim all buffers after log
> > > > recovery on v4 filesystems to provide a clean slate going forward.
> > > > 
> > > > 2.) Unconditionally attach verifiers during recovery as originally done
> > > > and wire up something generic that short circuits verifier invocations
> > > > on v4 filesystems when log recovery is in progress.
> > > 
> > > What do you think about 3) add b_ops later if they're missing?
> > > 
> > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > index 2f97c12..8842a27 100644
> > > --- a/fs/xfs/xfs_buf.c
> > > +++ b/fs/xfs/xfs_buf.c
> > > @@ -742,6 +742,15 @@ xfs_buf_read_map(
> > >         if (bp) {
> > >                 trace_xfs_buf_read(bp, flags, _RET_IP_);
> > >  
> > > +               /*
> > > +                * If this buffer is up to date and has no verifier, try
> > > +                * to set one.  This can happen on v4 because log
> > > +                * recovery reads in the buffers for replay but does not
> > > +                * set b_ops.
> > > +                */
> > > +               if ((bp->b_flags & XBF_DONE) && !bp->b_ops)
> > > +                       bp->b_ops = ops;
> > 
> > I don't really like this because it will hide bugs in the code.
> > 
> > It also doesn't solve the problem because a read with NULL ops will
> > still leave a buffer with no ops attached.
> > 
> > IMO, if we've read/created a buffer without ops, then it is up to
> > the code that created/read it to either attach the required ops
> > before the buffer is released or to invalidate the buffer before
> > anyone else can use it or write it. The buffer write code warns
> > about writing buffers without verfiers, but we can't warn on read
> > because read-with-NULL-verifier is a valid thing to do....
> 
> Fair 'nuff.  FWIW I'm ok with approach #1 if anyone enthusiastically
> wants to write it up.
> 

I'll add it to my todo list but FYI I have very limited time this week,
it's more likely I won't actually get to it until next week.

Brian

> --D
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
