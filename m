Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50790 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753202AbdGCQ1w (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Jul 2017 12:27:52 -0400
Date: Mon, 3 Jul 2017 12:27:50 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/4] xfs: fix log recovery corruption error due to tail
 overwrite
Message-ID: <20170703162747.GA29709@bfoster.bfoster>
References: <1498574436-57561-1-git-send-email-bfoster@redhat.com>
 <1498574436-57561-4-git-send-email-bfoster@redhat.com>
 <20170701050605.GV5874@birch.djwong.org>
 <20170703121331.GC26149@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170703121331.GC26149@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 03, 2017 at 08:13:33AM -0400, Brian Foster wrote:
> On Fri, Jun 30, 2017 at 10:06:05PM -0700, Darrick J. Wong wrote:
> > On Tue, Jun 27, 2017 at 10:40:35AM -0400, Brian Foster wrote:
> > > If we consider the case where the tail (T) of the log is pinned long
> > > enough for the head (H) to push and block behind the tail, we can
> > > end up blocked in the following state without enough free space (f)
> > > in the log to satisfy a transaction reservation:
> > > 
> > > 	0	phys. log	N
> > > 	[-------HffT---H'--T'---]
> > > 
> > > The last good record in the log (before H) refers to T. The tail
> > > eventually pushes forward (T') leaving more free space in the log
> > > for writes to H. At this point, suppose space frees up in the log
> > > for the maximum of 8 in-core log buffers to start flushing out to
> > > the log. If this pushes the head from H to H', these next writes
> > > overwrite the previous tail T. This is safe because the items logged
> > > from T to T' have been written back and removed from the AIL.
> > > 
> > > If the next log writes (H -> H') happen to fail and result in
> > > partial records in the log, the filesystem shuts down having
> > > overwritten T with invalid data. Log recovery correctly locates H on
> > > the subsequent mount, but H still refers to the now corrupted tail
> > > T. This results in log corruption errors and recovery failure.
> > > 
> > > Since the tail overwrite results from otherwise correct runtime
> > > behavior, it is up to log recovery to try and deal with this
> > > situation. Update log recovery tail verification to run a CRC pass
> > > from the first record past the tail to the head. This facilitates
> > > error detection at T and moves the recovery tail to the first good
> > > record past H' (similar to truncating the head on torn write
> > > detection). If corruption is detected beyond the range possibly
> > > affected by the max number of iclogs, the log is legitimately
> > > corrupted and log recovery failure is expected.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/xfs_log_recover.c | 110 +++++++++++++++++++++++++++++++++--------------
> > >  1 file changed, 78 insertions(+), 32 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > > index 269d5f9..4113252 100644
> > > --- a/fs/xfs/xfs_log_recover.c
> > > +++ b/fs/xfs/xfs_log_recover.c
> > > @@ -1029,61 +1029,106 @@ xlog_seek_logrec_hdr(
> > >  }
> > >  
> > >  /*
> > > - * Check the log tail for torn writes. This is required when torn writes are
> > > - * detected at the head and the head had to be walked back to a previous record.
> > > - * The tail of the previous record must now be verified to ensure the torn
> > > - * writes didn't corrupt the previous tail.
> > > + * Calculate distance from head to tail (i.e., unused space in the log).
> > > + */
> > > +static inline int
> > > +xlog_tail_distance(
> > > +	struct xlog	*log,
> > > +	xfs_daddr_t	head_blk,
> > > +	xfs_daddr_t	tail_blk)
> > > +{
> > > +	if (head_blk < tail_blk)
> > > +		return tail_blk - head_blk;
> > > +
> > > +	return tail_blk + (log->l_logBBsize - head_blk);
> > > +}
> > > +
> > > +/*
> > > + * Verify the log tail. This is particularly important when torn or incomplete
> > > + * writes have been detected near the front of the log and the head has been
> > > + * walked back accordingly.
> > >   *
> > > - * Return an error if CRC verification fails as recovery cannot proceed.
> > > + * We also have to handle the case where the tail was pinned and the head
> > > + * blocked behind the tail right before a crash. If the tail had been pushed
> > > + * immediately prior to the crash and the subsequent checkpoint was only
> > > + * partially written, it's possible it overwrote the last referenced tail in the
> > > + * log with garbage. This is not a coherency problem because the tail must have
> > > + * been pushed before it can be overwritten, but appears as log corruption to
> > > + * recovery because we have no way to know the tail was updated if the
> > > + * subsequent checkpoint didn't write successfully.
> > > + *
> > > + * Therefore, CRC check the log from tail to head. If a failure occurs and the
> > > + * offending record is within max iclog bufs from the head, walk the tail
> > > + * forward and retry until a valid tail is found or corruption is detected out
> > > + * of the range of a possible overwrite.
> > >   */
> > >  STATIC int
> > >  xlog_verify_tail(
> > >  	struct xlog		*log,
> > > -	xfs_daddr_t		head_blk,
> > > -	xfs_daddr_t		tail_blk)
> > > +	xfs_daddr_t		*head_blk,
> > > +	xfs_daddr_t		*tail_blk,
> > > +	int			hsize)
> > >  {
> > >  	struct xlog_rec_header	*thead;
> > >  	struct xfs_buf		*bp;
> > >  	xfs_daddr_t		first_bad;
> > > -	int			count;
> > >  	int			error = 0;
> > >  	bool			wrapped;
> > > -	xfs_daddr_t		tmp_head;
> > > +	xfs_daddr_t		tmp_tail;
> > > +	xfs_daddr_t		orig_tail = *tail_blk;
> > >  
> > >  	bp = xlog_get_bp(log, 1);
> > >  	if (!bp)
> > >  		return -ENOMEM;
> > >  
> > >  	/*
> > > -	 * Seek XLOG_MAX_ICLOGS + 1 records past the current tail record to get
> > > -	 * a temporary head block that points after the last possible
> > > -	 * concurrently written record of the tail.
> > > +	 * Make sure the tail points to a record (returns positive count on
> > > +	 * success).
> > >  	 */
> > > -	count = xlog_seek_logrec_hdr(log, head_blk, tail_blk,
> > > -				     XLOG_MAX_ICLOGS + 1, bp, &tmp_head, &thead,
> > > -				     &wrapped);
> > > -	if (count < 0) {
> > > -		error = count;
> > > +	error = xlog_seek_logrec_hdr(log, *head_blk, *tail_blk, 1, bp,
> > > +			&tmp_tail, &thead, &wrapped);
> > > +	if (error < 0)
> > >  		goto out;
> > > -	}
> > > -
> > > -	/*
> > > -	 * If the call above didn't find XLOG_MAX_ICLOGS + 1 records, we ran
> > > -	 * into the actual log head. tmp_head points to the start of the record
> > > -	 * so update it to the actual head block.
> > > -	 */
> > > -	if (count < XLOG_MAX_ICLOGS + 1)
> > > -		tmp_head = head_blk;
> > > +	if (*tail_blk != tmp_tail)
> > > +		*tail_blk = tmp_tail;
> > >  
> > >  	/*
> > > -	 * We now have a tail and temporary head block that covers at least
> > > -	 * XLOG_MAX_ICLOGS records from the tail. We need to verify that these
> > > -	 * records were completely written. Run a CRC verification pass from
> > > -	 * tail to head and return the result.
> > > +	 * Run a CRC check from the tail to the head. We can't just check
> > > +	 * MAX_ICLOGS records past the tail because the tail may point to stale
> > > +	 * blocks cleared during the search for the head/tail. These blocks are
> > > +	 * overwritten with zero-length records and thus record count is not a
> > > +	 * reliable indicator of the iclog state before a crash.
> > >  	 */
> > > -	error = xlog_do_recovery_pass(log, tmp_head, tail_blk,
> > > +	first_bad = 0;
> > > +	error = xlog_do_recovery_pass(log, *head_blk, *tail_blk,
> > >  				      XLOG_RECOVER_CRCPASS, &first_bad);
> > > +	while (error && first_bad) {
> > > +		int	tail_distance;
> > > +
> > > +		/*
> > > +		 * Is corruption within range of the head? If so, retry from
> > > +		 * the next record. Otherwise return an error.
> > > +		 */
> > > +		tail_distance = xlog_tail_distance(log, *head_blk, first_bad);
> > > +		if (tail_distance > BTOBB(XLOG_MAX_ICLOGS * hsize))
> > > +			break;
> > 
> > (Thinking aloud...)
> > 
> > So if I understand this correctly, we start by checking that there's a
> > log record immediately after where we think is the tail T.  If there's
> > no record then the log is junk and we just give up, but if we find a
> > record then we try to check CRCs from head H to tail T.
> > 
> 
> Right.. this part basically adds a full on tail->head CRC pass whereas
> actual log recovery would check CRCs as records are processed (i.e., the
> slight change in behavior referenced in the cover letter).
> 
> > 	0	phys. log	N
> > 	[-------HffT---H'--T'---]
> > 
> > If the CRC pass fails (again I'm wondering if it's appropriate to keep
> > trying things even if error == EIO or ENOMEM or something) then we'll
> > try to bump the tail ahead towards T', so long as we don't stray farther
> > than the head + log buffer size.
> > 
> 
> The idea is that we can attribute corruption to a partial tail overwrite
> so long as the failure occurs within the "danger zone" of the head, as
> defined by the max iclog value and log buf size. If the tail happened to
> be located farther ahead outside of that range, this is not a
> possibility and the corruption is legitimate. The tradeoff is that this
> is a policy and so the corruption at the tail could potentially be
> "legitimate" regardless, but it's the same tradeoff we made previously
> with torn write detection.
> 
> And yes, this should only trigger on error == -EFSBADCRC. Actually, I'm
> starting to think that both here and the head verification should handle
> -EFSCORRUPTED as well. I think the more recent report incident (that
> motivated this patch) was actually producing logs that may have been
> more likely to fail with the latter than the former (if the log record
> header is not valid, for example). I will take another look at that.
> 

A few notes on the above...

First, I have to correct the statement in the cover letter that this
allows the referenced metadump images to mount. The mount still fails
due to an inode cluster corruption of some sort encountered during
recovery. I could have sworn I got those images to mount before. I
suppose it's possible I either had some nasty hacks to force the issue
or otherwise just lost track after constructing the tail overwrite
reproducer script and misremembered. Either way, I see that they don't
mount even with some earlier variants of this code and fail the same way
if I use for-next and hardcode the head/tail past the corrupted ranges
(to check whether I perhaps broke something else).

With regard to -EFSCORRUPTED, it appears to be rather difficult to
construct a log that fails due to EFSCORRUPTED at this point of recovery
because the head/tail search depends on somewhat sane log record
headers. IOW, severe enough corruption (buffer mem. corruption, for
e.g.) as such could fail log recovery much earlier before we can
actually identify a head/tail combination to work with.

That said, forcing an invalid h_len to disk does appear to allow
head/tail discovery to succeed while teasing out EFSCORRUPTED errors
during head/tail verification (and at least one minor/dependent bug in
the first_bad assignment in xlog_do_recovery_pass()). FWIW, I'm not
totally convinced one way or another whether this is a valuable change.
I may include it as a separate patch for reference, at least.

Brian

> > Bumping the tail forward involves checking for valid records and redoing
> > the CRC pass with the new tail.  If we run out of records, we bail out;
> > if the new CRC pass succeeds, we declare victory.  If not, then we'll
> > possibly try another tail bump.
> > 
> > I think I understand how this is suppsed to work now.  I'm concerned
> > that we try bumping the tail ahead even if the CRC pass runs out of
> > memory or hits a read error, though.  I'm also wondering why we pass
> > in a pointer to *head_blk, though we don't seem to update it?
> > 
> 
> I think I just updated both parameters to pass a pointer because it
> looked more consistent and/or otherwise hadn't worked out the tail
> verification algorithm at that point. I can change it back to head_blk
> if that is preferred.
> 
> Thanks for the review!
> 
> Brian
> 
> > --D
> > 
> > > +
> > > +		/* skip to the next record; returns positive count on success */
> > > +		error = xlog_seek_logrec_hdr(log, *head_blk, first_bad, 2, bp,
> > > +				&tmp_tail, &thead, &wrapped);
> > > +		if (error < 0)
> > > +			goto out;
> > >  
> > > +		*tail_blk = tmp_tail;
> > > +		first_bad = 0;
> > > +		error = xlog_do_recovery_pass(log, *head_blk, *tail_blk,
> > > +					      XLOG_RECOVER_CRCPASS, &first_bad);
> > > +	}
> > > +
> > > +	if (!error && *tail_blk != orig_tail)
> > > +		xfs_warn(log->l_mp,
> > > +		"Tail block (0x%llx) overwrite detected. Updated to 0x%llx",
> > > +			 orig_tail, *tail_blk);
> > >  out:
> > >  	xlog_put_bp(bp);
> > >  	return error;
> > > @@ -1185,7 +1230,8 @@ xlog_verify_head(
> > >  		}
> > >  	}
> > >  
> > > -	return xlog_verify_tail(log, *head_blk, *tail_blk);
> > > +	return xlog_verify_tail(log, head_blk, tail_blk,
> > > +				be32_to_cpu((*rhead)->h_size));
> > >  }
> > >  
> > >  /*
> > > -- 
> > > 2.7.5
> > > 
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
