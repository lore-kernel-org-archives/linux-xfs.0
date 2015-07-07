Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CB8CE7CBF
	for <xfs@oss.sgi.com>; Tue,  7 Jul 2015 08:10:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 87BAC30406A
	for <xfs@oss.sgi.com>; Tue,  7 Jul 2015 06:10:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id R7ksw07YBSCm9QxF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 07 Jul 2015 06:10:46 -0700 (PDT)
Date: Tue, 7 Jul 2015 09:10:44 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC] xfs: handle torn writes during log head/tail discovery
Message-ID: <20150707131044.GC37156@bfoster.bfoster>
References: <1436207194-35671-1-git-send-email-bfoster@redhat.com>
	<20150707005331.GX7943@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150707005331.GX7943@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 07, 2015 at 10:53:31AM +1000, Dave Chinner wrote:
> On Mon, Jul 06, 2015 at 02:26:34PM -0400, Brian Foster wrote:
> > Persistent memory without block translation table (btt) support provides
> > a block device suitable for filesystems, but does not provide the sector
> > write atomicity guarantees typical of block storage. This is a problem
> > for log recovery on XFS. The on-disk log record structure already
> > includes a CRC and thus can detect torn writes. The problem is that such
> > a failure isn't detected until log recovery is already in progress and
> > therefore results in a hard error and mount failure.
> > 
> > Update the log head/tail discovery algorithm to detect and trim off a
> > torn log record from the end (from a recovery perspective) of the log.
> > Once the head is determined from the log cycle information and we have a
> > pointer to the last record to be recovered, read and verify the CRC of
> > said record before we initiate actual recovery. If CRC verification
> > fails, assume the record is torn and reset the head to the start of the
> > torn record. We reverse seek for the previous log record header from
> > that point and attempt recovery up through that record.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > Hi all,
> > 
> > As far as I'm aware, the torn log write problem is the only major gap we
> > have to safely run XFS w/ crc=1 on non-btt pmem devices. This is an RFC
> > to attempt to address that problem. I used a custom hack to actually
> > reproduce such torn writes on a ramdisk to primarily help me understand
> > the problem, but I was able to use the same hack to sanity test this
> > approach under the basic corruption case (this is generally untested,
> > otherwise).
> > 
> > This could obviously use some cleanup, but is the approach sane? I'm
> > curious if this should also be tied to DAX enablement so as to not
> > interfere with unrelated corruption handling (IOW, with what logic is it
> > reasonable enough to assume a crc failure of the final record == torn
> > write?). I'm also wondering if this should be tied to a new mount option
> > rather than make this behavior implicit. Any other thoughts?
> 
> Seems good fom a conceptual point of view - the fact that we CRC all
> log writes now means this will work on both v4 and v5 filesystems.
> 

Indeed, though v4 currently doesn't fail log recovery on CRC failure. It
just yells about it and attempts to continue. This seems like it could
broaden the scope of this a bit, though somewhat unrelated to the
original torn write problem (more on this at the end).

> The CRC validation needs to be done on more than just the head
> record. We can have up to 8 IOs in flight at the time power goes
> down, so we need to validate the CRCs for at least the previous 8
> log writes...
> 

Interesting, Ok.. so I take it that the recovery process should be to
examine the last N records and recover only up to the point of the last
correctly written record. I suppose this can be handled by backing up a
fixed size from the last record header that is discovered by the code as
is today.

> We also need to validate the tail record, as we could be in a
> situation where the head is overwriting the tail and it tears and
> so by discarding the head record we discard the tail update and so
> now the tail record is also corrupt. In that case, we need to abort
> recovery because the log is unrecoverable.
> 

I don't follow here. If the head is overwriting the tail, hasn't the
tail been moved forward and all the associated metadata changes written
back before that can occur?

> Also: should we zero out the torn sections before starting recovery,
> like we do with the call to xlog_clear_stale_blocks() later in
> xlog_find_tail()?
> 

The thought crossed my mind just from a conservative implementation
standpoint, but I didn't think too hard about it for this rfc. It
probably makes sense to do something like this.

> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 01dd228..6015d02 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -62,6 +62,9 @@ xlog_recover_check_summary(
> >  #define	xlog_recover_check_summary(log)
> >  #endif
> >  
> > +STATIC int
> > +xlog_validate_logrec_crc(struct xlog *, xfs_daddr_t);
> > +
> 
> Put the function here, don't use forward declarations....
> 

Eh, I put the function at the end because it depends on other functions
that don't have declarations but would require them if I put it earlier
in the file. The implementation will surely change and I'll avoid it if
I can, but I'm not sure how likely that is.

> >  /*
> >   * This structure is used during recovery to record the buf log items which
> >   * have been canceled and should not be replayed.
> > @@ -898,6 +901,7 @@ xlog_find_tail(
> >  	xfs_daddr_t		after_umount_blk;
> >  	xfs_lsn_t		tail_lsn;
> >  	int			hblks;
> > +	bool			skipped_last = false;
> >  
> >  	found = 0;
> >  
> > @@ -925,6 +929,7 @@ xlog_find_tail(
> >  	/*
> >  	 * Search backwards looking for log record header block
> >  	 */
> > +retry:
> >  	ASSERT(*head_blk < INT_MAX);
> >  	for (i = (int)(*head_blk) - 1; i >= 0; i--) {
> >  		error = xlog_bread(log, i, 1, bp, &offset);
> > @@ -962,6 +967,31 @@ xlog_find_tail(
> >  		return -EIO;
> >  	}
> >  
> > +	/*
> > +	 * Now that we think we've found the log head, we have to check that the
> > +	 * last log record wasn't torn when written out to the log. This is
> > +	 * possible on devices without sector atomicity guarantees (e.g., pmem).
> > +	 *
> > +	 * Verify the CRC of the last log record that was written. If the CRC is
> > +	 * invalid, point the head at the start of this record and retry the
> > +	 * above backwards log record header search. We'll try the recovery up
> > +	 * through this record. Note that we only walk backwards once since this
> > +	 * is only intended to handle the torn write on power loss case.
> > +	 *
> > +	 * TODO: mount option? tied to DAX?
> > +	 */
> 
> Always do it - if any hardware is tearing writes, then we should
> handle it sanely.
> 

Ok.

> > +	if (xfs_sb_version_hascrc(&log->l_mp->m_sb) && !skipped_last) {
> 
> No need to be tied to xfs_sb_version_hascrc(), even v4 filesystems
> now have a CRC calculated on the log. Only skip it on v4 filesystes
> when the h_crc field is zero (indicating the log came from an old
> kernel that didn't calculate CRCs).
> 

Ah, Ok.

> > +		error = xlog_validate_logrec_crc(log, i);
> > +		if (error == -EFSBADCRC) {
> > +			skipped_last = true;
> > +			*head_blk = i;
> > +			xfs_warn(log->l_mp,
> > +	"WARNING: Torn write? Attempting recovery up to previous record.");
> > +			goto retry;
> > +		} else if (error)
> > +			goto done;
> > +	}
> 
> Better to do a loop and factor the code a bit?
> 

Yeah, I'll have to revisit how this looks given that we'll need to
examine multiple records and figure out which one is the last fully
written.

> > +
> >  	/* find blk_no of tail of log */
> >  	rhead = (xlog_rec_header_t *)offset;
> >  	*tail_blk = BLOCK_LSN(be64_to_cpu(rhead->h_tail_lsn));
> > @@ -4607,6 +4637,63 @@ xlog_recover_finish(
> >  	return 0;
> >  }
> >  
> > +/*
> > + * Read and CRC validate a full log record. This is used to detect torn log
> > + * writes during head/tail discovery.
> > + */
> > +STATIC int
> > +xlog_validate_logrec_crc(
> > +	struct xlog		*log,
> > +	xfs_daddr_t		rec_blk)
> > +{
> > +	int			hblks, bblks;
> > +	struct xlog_rec_header	*rhead;
> > +	struct xfs_buf		*hbp = NULL;
> > +	struct xfs_buf		*dbp = NULL;
> > +	int			error;
> > +	char			*offset;
> > +
> > +	hblks = 1;	/* XXX */
> > +
> > +	/* read and validate the log record header */
> > +	hbp = xlog_get_bp(log, 1);
> > +	if (!hbp)
> > +		return -ENOMEM;
> > +	error = xlog_bread(log, rec_blk, hblks, hbp, &offset);
> > +	if (error)
> > +		goto out;
> > +
> > +	rhead = (struct xlog_rec_header *) offset;
> > +
> > +	error = xlog_valid_rec_header(log, rhead, rec_blk);
> > +	if (error)
> > +		goto out;
> > +
> > +	/* read the full record and verify the CRC */
> > +	/* XXX: factor out from do_recovery_pass() ? */
> 
> Yes, please do ;)
> 

This was originally noting that the hblks = 1 above and the below buffer
sizing appear to have more complicated logic to get correct in
xlog_do_recovery_pass() that I didn't want to fully duplicate here.

Given that and the comments from my follow on mail about handling
wrapping around the log, it's sounding more like reuse of
xlog_do_recovery_pass() with a dummy XLOG_RECOVER_CRCPASS is the better
approach. It can skip all real processing of the records beyond the crc
verification and it will probably need to learn how to report the
starting block of the first record that fails crc verification.

> > +	dbp = xlog_get_bp(log, BTOBB(be32_to_cpu(rhead->h_size)));
> > +	if (!dbp)
> > +		goto out;
> > +
> > +	bblks = (int)BTOBB(be32_to_cpu(rhead->h_len));
> > +	error = xlog_bread(log, rec_blk+hblks, bblks, dbp, &offset);
> > +	if (error)
> > +		goto out;
> > +
> > +	/*
> > +	 * If the CRC validation fails, convert the return code so the caller
> > +	 * can distinguish from unrelated errors.
> > +	 */
> > +	error = xlog_unpack_data_crc(rhead, offset, log);
> > +	if (error)
> > +		error = -EFSBADCRC;
> 
> Note that this will only return an error on v5 filesystems so some
> changes will be needed here to handle v4 filesystems. It will
> also log a CRC mismatch error, so perhaps we want to make the error
> reporting in this case a little bit less noisy....
> 

Yeah, this was tied to the fact that the torn write verification only
took place on v5 in this patch. This will require some cleanup if we
want to do this unconditionally for all h_crc != 0 log records. Note
that this is also a potential behavior change because the v4 logic will
attempt to recover the corrupted log records.

Finally getting back to the bigger picture... if we do want to do this
verification unconditionally, do we want to expand this mechanism
further than just targetting torn writes? For example, crc failure
towards the end of the log doesn't necessarily mean a torn write. The
currently proposed approach is to only validate the last written
record(s) and assume crc failure is due to torn writes. Conversely, we
do know that a crc failure somewhere in the middle of the dirty log is
not a torn write problem. 

That said and as noted above, we are effectively changing behavior for
v4 filesystems and/or those on regular block storage, however. We're
also inconsistent depending on precisely where a failure occurs. CRC
failure towards the end will now skip the bad and subsequent log records
for v4 or v5. Failure earlier in the log might yell and proceed on v4
and hard fail on v5.

Do we want to do something like have a generic CRC verification pass
across the entire log immediately after the head/tail is discovered and
skip everything beyond the first corrupted (for whatever reason) log
record (with a warning that the log has been truncated)? That's
certainly not as conservative an approach as I was targetting, but it
almost seems more logical if we're not going to try and keep this as
isolated as possible to torn write handling. The tradeoff is against the
v4 brute force recovery, but there might not be any better option for
the v5 scenario (xfs_repair -L and lose the entire log anyways..?).
Thoughts? Thanks for the feedback, Dave.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
