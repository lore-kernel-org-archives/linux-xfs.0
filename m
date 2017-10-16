Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56306 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750914AbdJPKiP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Oct 2017 06:38:15 -0400
Date: Mon, 16 Oct 2017 06:38:14 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Question about 67dc288c ("xfs: ensure verifiers are attached to
 recovered buffers")
Message-ID: <20171016103813.GC58994@bfoster.bfoster>
References: <20171013184916.GS7122@magnolia>
 <20171014115550.GB50635@bfoster.bfoster>
 <20171014220759.GZ15067@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171014220759.GZ15067@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On Sun, Oct 15, 2017 at 09:07:59AM +1100, Dave Chinner wrote:
> On Sat, Oct 14, 2017 at 07:55:51AM -0400, Brian Foster wrote:
> > On Fri, Oct 13, 2017 at 11:49:16AM -0700, Darrick J. Wong wrote:
> > > Hi all,
> > > 
> > > I have a question about 67dc288c ("xfs: ensure verifiers are attached to
> > > recovered buffers").  I was analyzing a scrub failure on generic/392
> > > with a v4 filesystem which stems from xfs_scrub_buffer_recheck (it's in
> > > scrub part 4) being unable to find a b_ops attached to the AGF buffer
> > > and signalling error.
> > > 
> > > The pattern I observe is that when log recovery runs on a v4 filesystem,
> > > we call some variant of xfs_buf_read with a NULL ops parameter.  The
> > > buffer therefore gets created and read without any verifiers.
> > > Eventually, xlog_recover_validate_buf_type gets called, and on a v5
> > > filesystem we come back and attach verifiers and all is well.  However,
> > > on a v4 filesystem the function returns without doing anything, so the
> > > xfs_buf just sits around in memory with no verifier.  Subsequent
> > > read/log/relse patterns can write anything they want without write
> > > verifiers to check that.
> > > 
> > > If the v4 fs didn't need log recovery, the buffers get created with
> > > b_ops as you'd expect.
> > > 
> > > My question is, shouldn't xlog_recover_validate_buf_type unconditionally
> > > set b_ops and save the "if (hascrc)" bits for the part that ensures the
> > > LSN is up to date?
> > > 
> > 
> > Seems reasonable, but I notice that the has_crc() check around
> > _validate_buf_type() comes in sometime after the the original commit
> > referenced below (d75afeb3) and commit 67dc288c. It appears to be due to
> > commit 9222a9cf86 ("xfs: don't shutdown log recovery on validation
> > errors").
> > 
> > IIRC, the problem there is that log recovery had traditionally always
> > unconditionally replayed everything in the log over whatever resides in
> > the fs. This actually meant that recovery could transiently corrupt
> > buffers in certain cases if the target buffer happened to be relogged
> > more than once and was already up to date, which leads to verification
> > failures.
> 
> Yes, that is one of the problems - we can get writeback of partially
> updated buffers mid-way through log recovery on v4 filesystems.
> 
> > This was addressed for v5 filesystems with LSN ordering rules,
> > but the challenge for v4 filesystems was that there is no metadata LSN
> > and thus no means to detect whether a buffer is already up to date with
> > regard to a transaction in the log.
> 
> In a nutshell.
> 
> > Dave might have more historical context to confirm that...
> 
> Historically it only occurred (rarely) due to memory pressure
> triggering writeback during recovery. However, when we changed to context
> specific delayed write buffer lists we started doing that writeback
> after every checkpoint was recovered. Hence it's now pretty trivial
> to trigger verifier failures during log recovery on v4
> filesystems...
> 
> > If that is
> > still an open issue, a couple initial ideas come to mind:
> > 
> > 1.) Do something simple/crude like reclaim all buffers after log
> > recovery on v4 filesystems to provide a clean slate going forward.
> 
> This might be a worthwhile thing to do, anyway. Log recovery can
> lead to a lot of cached metadata that won't be referenced again
> after reocvery is complete. Perhaps we should just clear the
> buffer cache after the first phase of recovery just before/after
> we re-read the superblock and re-init the incore space accounting...
> 

Ok. In that case, then perhaps doing something like this wouldn't need
to be limited to just v4 filesystems.

> > 2.) Unconditionally attach verifiers during recovery as originally done
> > and wire up something generic that short circuits verifier invocations
> > on v4 filesystems when log recovery is in progress.
> 
> I'd prefer "return to clean slate" than have to handle log
> recovery state specially in every verifier. It's simple, it's easy
> to maintain, and it creates a barrier between metadata recovered
> from the log and post-processing of intents/unlinks that ensures
> we've made all the recovered changes stable on disk before we move
> on...
> 

Either of these seem reasonable to me so if there is additional reason
to go with #1, then that works for me.

Just note that the intent of #2 above was not to modify every verifier
to accommodate this situation.  Rather, to consider a generic change
such as not invoking the verifier under particular conditions. Modifying
the individual verifiers might be more reasonable if we had a generic
verifier abstraction as Darrick and I discussed a bit ago wrt to some
unrelated changes that I don't recall, but even then I'm not sure I
would consider it the most elegant option..

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
