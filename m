Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38806 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750914AbdJPKhV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Oct 2017 06:37:21 -0400
Date: Mon, 16 Oct 2017 06:37:19 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Question about 67dc288c ("xfs: ensure verifiers are attached to
 recovered buffers")
Message-ID: <20171016103719.GB58994@bfoster.bfoster>
References: <20171013184916.GS7122@magnolia>
 <20171014115550.GB50635@bfoster.bfoster>
 <20171014190530.GA4594@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171014190530.GA4594@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>

On Sat, Oct 14, 2017 at 12:05:30PM -0700, Darrick J. Wong wrote:
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
> > failures. This was addressed for v5 filesystems with LSN ordering rules,
> > but the challenge for v4 filesystems was that there is no metadata LSN
> > and thus no means to detect whether a buffer is already up to date with
> > regard to a transaction in the log.
> > 
> > Dave might have more historical context to confirm that... If that is
> > still an open issue, a couple initial ideas come to mind:
> > 
> > 1.) Do something simple/crude like reclaim all buffers after log
> > recovery on v4 filesystems to provide a clean slate going forward.
> > 
> > 2.) Unconditionally attach verifiers during recovery as originally done
> > and wire up something generic that short circuits verifier invocations
> > on v4 filesystems when log recovery is in progress.
> 
> What do you think about 3) add b_ops later if they're missing?
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 2f97c12..8842a27 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -742,6 +742,15 @@ xfs_buf_read_map(
>         if (bp) {
>                 trace_xfs_buf_read(bp, flags, _RET_IP_);
>  
> +               /*
> +                * If this buffer is up to date and has no verifier, try
> +                * to set one.  This can happen on v4 because log
> +                * recovery reads in the buffers for replay but does not
> +                * set b_ops.
> +                */
> +               if ((bp->b_flags & XBF_DONE) && !bp->b_ops)
> +                       bp->b_ops = ops;
> +
>                 if (!(bp->b_flags & XBF_DONE)) {
>                         XFS_STATS_INC(target->bt_mount, xb_get_read);
>                         bp->b_ops = ops;
> 
> 
> (Sort of a hack, I think I prefer something along the lines of #2 better.)
> 

Yeah, seems like a plausible fix from a technical perspective. The first
thing that comes to mind is the need to verify that nothing actually
looks up an in-core buffer rather than attempt to read it and could
somehow use it from there. That may not be the case or even likely going
forward, but you never know how code is going to change in the future.
The fact that it's not a relevant concern with the other approaches is
what makes me give slight preference to those, fwiw.

OTOH, a variant of this that say iterated the cached buffers and did a
post-recovery "validation" to attach any missing verifiers might be a
way to avoid that flaw. As Dave kind of alludes to in his reply, that
just might be more work/code than it's really worth.

Brian

> --D
> 
> > 
> > Brian
> > 
> > > It seems like a bad idea to let buffers sit around with no verifier.
> > > The original patch adding this function is d75afeb3 ("xfs: add buffer
> > > types to directory and attribute buffers") and looks like it was
> > > supposed to do this for any filesystem, but I wasn't around to know the
> > > evolution of that part of xlog.
> > > 
> > > --D
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
