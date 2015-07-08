Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C767A7F56
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 11:26:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B65218F8035
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 09:26:35 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AFxfm97X5dVy0CC4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 08 Jul 2015 09:26:34 -0700 (PDT)
Date: Wed, 8 Jul 2015 12:26:31 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC] xfs: handle torn writes during log head/tail discovery
Message-ID: <20150708162631.GB42981@bfoster.bfoster>
References: <1436207194-35671-1-git-send-email-bfoster@redhat.com>
	<20150707005331.GX7943@dastard>
	<20150707131044.GC37156@bfoster.bfoster>
	<20150707233153.GY7943@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150707233153.GY7943@dastard>
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

On Wed, Jul 08, 2015 at 09:31:54AM +1000, Dave Chinner wrote:
> On Tue, Jul 07, 2015 at 09:10:44AM -0400, Brian Foster wrote:
> > On Tue, Jul 07, 2015 at 10:53:31AM +1000, Dave Chinner wrote:
> > > On Mon, Jul 06, 2015 at 02:26:34PM -0400, Brian Foster wrote:
> > > > Persistent memory without block translation table (btt) support provides
> > > > a block device suitable for filesystems, but does not provide the sector
> > > > write atomicity guarantees typical of block storage. This is a problem
> > > > for log recovery on XFS. The on-disk log record structure already
> > > > includes a CRC and thus can detect torn writes. The problem is that such
> > > > a failure isn't detected until log recovery is already in progress and
> > > > therefore results in a hard error and mount failure.
> ....
> > > The CRC validation needs to be done on more than just the head
> > > record. We can have up to 8 IOs in flight at the time power goes
> > > down, so we need to validate the CRCs for at least the previous 8
> > > log writes...
> > > 
> > 
> > Interesting, Ok.. so I take it that the recovery process should be to
> > examine the last N records and recover only up to the point of the last
> > correctly written record. I suppose this can be handled by backing up a
> > fixed size from the last record header that is discovered by the code as
> > is today.
> > 
> > > We also need to validate the tail record, as we could be in a
> > > situation where the head is overwriting the tail and it tears and
> > > so by discarding the head record we discard the tail update and so
> > > now the tail record is also corrupt. In that case, we need to abort
> > > recovery because the log is unrecoverable.
> > > 
> > 
> > I don't follow here. If the head is overwriting the tail, hasn't the
> > tail been moved forward and all the associated metadata changes written
> > back before that can occur?
> 
> See the comment about having multiple IOs in flight at once. Also,
> if flushes are not being used (i.e. nobarrier mount option) on
> storage with volatile write caches, the tail block that the head
> points to may or may not have been written to disk, hence the need
> to validate the tail record....
> 

The multiple I/Os in flight refers to log I/O, yes? If so, I still don't
quite follow that train of thought. Are you saying that of the 8 I/Os
potentially in flight, the current head could be pointing at a tail that
is also in-flight and ends up torn? If so, does that really require
anything beyond the previously noted requirement to verify the last 8
I/Os behind the head? IIUC, that case also means we'd skip recovery
entirely.

The nobarrier case makes sense, though that seems like it could be a
different problem. Wouldn't the cycle in the block not be updated in
this case (i.e., is that really a crc verification problem)?

> i.e. once we start down the "handle incorrectly written sectors in
> recovery via CRC validation" path, we need to consider all the
> different ways they can happen, not just the specific case of
> pmem-related problems...
> 

Agreed, I'm just trying to understand the various possibilities so I
know what needs to be done and why. I'm digging deeper into the on-disk
log here than I have before so I'm learning as I go.

> > > Also: should we zero out the torn sections before starting recovery,
> > > like we do with the call to xlog_clear_stale_blocks() later in
> > > xlog_find_tail()?
> > 
> > The thought crossed my mind just from a conservative implementation
> > standpoint, but I didn't think too hard about it for this rfc. It
> > probably makes sense to do something like this.
> > 
> > > > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > > > index 01dd228..6015d02 100644
> > > > --- a/fs/xfs/xfs_log_recover.c
> > > > +++ b/fs/xfs/xfs_log_recover.c
> > > > @@ -62,6 +62,9 @@ xlog_recover_check_summary(
> > > >  #define	xlog_recover_check_summary(log)
> > > >  #endif
> > > >  
> > > > +STATIC int
> > > > +xlog_validate_logrec_crc(struct xlog *, xfs_daddr_t);
> > > > +
> > > 
> > > Put the function here, don't use forward declarations....
> > > 
> > 
> > Eh, I put the function at the end because it depends on other functions
> > that don't have declarations but would require them if I put it earlier
> > in the file. The implementation will surely change and I'll avoid it if
> > I can, but I'm not sure how likely that is.
> 
> You can move functions around without changing them. ;)
> 

Sure, but why shuffle the file around to avoid a declaration? We use
declarations all over the place, including in this file.

> As it is, I'm planning to split the log recovery code into two parts
> (the bit shared with userspace and the bit that is kernel specific)
> so don't be afraid to move code around...
> 

Ok, if that's the reason. The approach I'm on now refactors things a bit
as is, so we'll see what falls out of that. I'd prefer to get the core
functionality and refactoring right before reorganizing everything, at
least.

> > > > +	if (!hbp)
> > > > +		return -ENOMEM;
> > > > +	error = xlog_bread(log, rec_blk, hblks, hbp, &offset);
> > > > +	if (error)
> > > > +		goto out;
> > > > +
> > > > +	rhead = (struct xlog_rec_header *) offset;
> > > > +
> > > > +	error = xlog_valid_rec_header(log, rhead, rec_blk);
> > > > +	if (error)
> > > > +		goto out;
> > > > +
> > > > +	/* read the full record and verify the CRC */
> > > > +	/* XXX: factor out from do_recovery_pass() ? */
> > > 
> > > Yes, please do ;)
> > > 
> > 
> > This was originally noting that the hblks = 1 above and the below buffer
> > sizing appear to have more complicated logic to get correct in
> > xlog_do_recovery_pass() that I didn't want to fully duplicate here.
> > 
> > Given that and the comments from my follow on mail about handling
> > wrapping around the log, it's sounding more like reuse of
> > xlog_do_recovery_pass() with a dummy XLOG_RECOVER_CRCPASS is the better
> > approach. It can skip all real processing of the records beyond the crc
> > verification and it will probably need to learn how to report the
> > starting block of the first record that fails crc verification.
> 
> We don't really want to add another full pass reading the log if we
> can avoid it. we already do a bisect to find the head/tail, a pass
> to find cancelld buffers and then another pass to do the actual
> recovery. Adding a third pass can is something I'd like to avoid if
> possible, especially if we have a full 2GB log on a drive that only
> does 100MB/s....
> 

Hmm, Ok. There's not much of a point anyways if we aren't going to do
anything different in general about crc failure in the middle of the
log.

I have something halfway reworked that adds a CRC pass, but that is with
the idea of doing more broad CRC verification. The code can still be
reused since xlog_do_recovery_pass() already implements all of the log
walking logic and already supports the ability to iterate a specific
range of blocks. I think it just changes where and how the code is
invoked a bit.

> > > > +
> > > > +	bblks = (int)BTOBB(be32_to_cpu(rhead->h_len));
> > > > +	error = xlog_bread(log, rec_blk+hblks, bblks, dbp, &offset);
> > > > +	if (error)
> > > > +		goto out;
> > > > +
> > > > +	/*
> > > > +	 * If the CRC validation fails, convert the return code so the caller
> > > > +	 * can distinguish from unrelated errors.
> > > > +	 */
> > > > +	error = xlog_unpack_data_crc(rhead, offset, log);
> > > > +	if (error)
> > > > +		error = -EFSBADCRC;
> > > 
> > > Note that this will only return an error on v5 filesystems so some
> > > changes will be needed here to handle v4 filesystems. It will
> > > also log a CRC mismatch error, so perhaps we want to make the error
> > > reporting in this case a little bit less noisy....
> > > 
> > 
> > Yeah, this was tied to the fact that the torn write verification only
> > took place on v5 in this patch. This will require some cleanup if we
> > want to do this unconditionally for all h_crc != 0 log records. Note
> > that this is also a potential behavior change because the v4 logic will
> > attempt to recover the corrupted log records.
> 
> Right, but we did that so that we didn't unexpectedly change
> behaviour of log recovery for v4 filesystems. Given that nobody has
> reported a problem w.r.t. CRC failures on log recovery on v4
> filesystem since that was added, I think it is probably safe to make
> v4 behave like v5 now and start bailing out of log recovery if there
> are bad CRCs.
> 

Sounds good, at least we'll be consistent with fs versions across the
"edges" and middle of the log.

> > Finally getting back to the bigger picture... if we do want to do this
> > verification unconditionally, do we want to expand this mechanism
> > further than just targetting torn writes? For example, crc failure
> > towards the end of the log doesn't necessarily mean a torn write. The
> > currently proposed approach is to only validate the last written
> > record(s) and assume crc failure is due to torn writes. Conversely, we
> > do know that a crc failure somewhere in the middle of the dirty log is
> > not a torn write problem. 
> 
> CRC failures are unlikely to begin with. failures in the middle of
> the log tend to imply deeper problems with the storage medium. Also,
> it's fine to abort recovery half way through if we come across such
> problems, so i don't think we need to care about torn writes outside
> of the region that we expect active writes to be occurring.
> 

Right... we know crc failure in the middle is not a torn write, as noted
above. The train of thought was about doing more broad crc failure
handling. As you explained below, mounting after such a halfway recovery
is not the right thing to do.

> > That said and as noted above, we are effectively changing behavior for
> > v4 filesystems and/or those on regular block storage, however. We're
> > also inconsistent depending on precisely where a failure occurs. CRC
> > failure towards the end will now skip the bad and subsequent log records
> > for v4 or v5. Failure earlier in the log might yell and proceed on v4
> > and hard fail on v5.
> 
> Bad records at the head of the log are different to those in the
> middle. We can't replay past a failure, so a bad record in the
> middle of the log leaves us with an inconsistent filesystems after
> recovery aborts. OTOH, trimming the incomplete records at the head
> to guarantee we end recovery at the last complete checkpoint before
> a full recovery pass still results in a consistent filesystem when
> recovery completes....
> 
> > Do we want to do something like have a generic CRC verification pass
> > across the entire log immediately after the head/tail is discovered and
> > skip everything beyond the first corrupted (for whatever reason) log
> > record (with a warning that the log has been truncated)?
> 
> That's exactly how log recovery behaves now - when we abort log
> recovery due to a verification failure, we've already replayed and
> written everything up to the corruption. Hence running xfs_repair -L
> at that point will only have to fix up metadata inconsistnecies in
> the part of the log that hasn't been replayed.
> 
> Also, we don't want to continue at that point, because the filesystem
> is inconsistent. e.g. we can't process unlinked lists, nor can we
> process EFIs because they are only valid once all the changes in the
> log have been recovered. xfs_repair is the only option we have after
> a failed log recovery right now....
> 

Ok. When thinking about this, I guess I was thinking that we'd be able
to recover and mount across a complete log record boundary, but that is
not the case. I take it the reason is that if some log record in the
middle is corrupted for something other than a torn write, it was still
completely written as far as the kernel was concerned at runtime. Thus,
some changes dependent on that record could have been written back to
the fs. Failure to replay the records beyond that point can thus leave
us inconsistent and in need of repair.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
