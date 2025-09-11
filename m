Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6B717D2
	for <linux-xfs@vger.kernel.org>; Thu, 11 Sep 2025 00:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757552362; cv=none; b=qmpHaOGHU1WX1VXLbn9vcAgqZaHyaq2rLRVvsG6E7np4cN0b1bFU0+smspHKaHeFuI+PwoGXT4Zpqm7O1oBgSkbYhtTZgSvH2WeJbac00EMkbqkGybeJuawtW374lTQg9/p829iiKNdl6I3gFRoOf8gEWQkgJhVSf86kt7iJGCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757552362; c=relaxed/simple;
	bh=s7V/Ndd9JEkogJhSgXCH5WrXLvnFHmEOetzW1nKSCTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=taeFePXhS2pp81c2K2klLCeRRd04uVhmdjCP37f4gcgskHEjJp+LDc5vehc7yDrgG3Tpc7RhOS+sx6QeTXHR/HgvB9aBnHXPPJljcuv6bowImX+wYt8je5KQMF7U0RoONUxN/8crVKmVPgcDVsu+v/mUt75Mb9SXlMymkDRd9Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=k8KgN/SD; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="k8KgN/SD"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-76e6cbb991aso149406b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 10 Sep 2025 17:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1757552360; x=1758157160; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+Li7OVKTPUH5SJ4NHl9m6L7IHLPQ6VED1ieFfNuMvt8=;
        b=k8KgN/SDbKN1NSK5srRvAgLLz+dKKxqbzMdPkA8DzW3UFNwKnoGLUWGezeeVLh6YP6
         YtYRJ0cUS0k7BNPQGKqRWL1xko7HPIwo0hPeby/vRIU6biGUoAWn4G+R6veVsZozsBWF
         D+qGjZNQWkmdL2DOb++XLRN8zFtxHWlVImIuJViY+zvG/87JK6FyNijStbjoOlma/lS6
         r30Dx30TUYT7ErRvqpNZ5Jv8TUDwlb1wodoIOzA2ZiUSAksx0H5WacgA4ZUu5hv80vMZ
         OOIR5QAwN7dSn6TwdOhTDm2Su9/5OPgooFjinbO0LI2LWSZl2u4ozSAgPMVr2vtXJOE0
         U+8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757552360; x=1758157160;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Li7OVKTPUH5SJ4NHl9m6L7IHLPQ6VED1ieFfNuMvt8=;
        b=W3rdhZLJBFGX/ZLTIHEkx1Fux5M5CnelGiVDupviUM6FK97DHM9mBy6ue/QiAWTLGk
         /nvac/yzmsMybPzhoqqFqtKQ/yL+5QzhcntxaNeYiKFjP/nI34xAEsCHoyNLmHNHXZZd
         Kr5LtVrtMwgWuWrtBuwerR/LZtejMvNGB5EMA6aVrrOg1KYQmtUrfOFezpu2K6MmZBko
         wib7uvfMqgKoMB2TJO/L7J5VMrsQSvDXXLVNEcKq2afJnPLiBIWZ89yzTzfAxg5jTyUK
         WviWv+5QkvqhM6xo1sNRKNnkd1VJt3CXZyoyZyLzQyMrGT8ePkQtDfnjrKAviGTDIYeA
         Ytyw==
X-Gm-Message-State: AOJu0YxQziQGl1J3MaHzP4s6R19x20nYwQgm9CU46L8ANYx/lnLS4uhn
	ZKXIo/W2NTW8cxaPsgL6GWgF1DqUq6v+ii+NekuPyQj7KcjN12fyat8uuIjP/VWk28w=
X-Gm-Gg: ASbGncujhby2WFbU9xqtHInPRhAFCRbkOB9OviYe+5yMmArDx1tOIKHFycZpayJOdP1
	rXQ5y7PgWpAJZ59ppVr/LeXDElexCl+aeJfER3Oxb7ltYCOh8fhTpPAqwTLWi3/s4poBrGhDX3F
	UYYWqyZ+unkIMF7yHIAwwM1RDuESllb1AwIr75/04EChc+i7gcqywzCX6cqw4YVmsnbSzmmEdcO
	wLKrVSmA1ESs61csknj6urlZxF9UHUCBlkajHSko2TJdvy0hZUMJCn9WxVN2f9HEMV4ajSqj8W5
	+RfXlUyqmibRZdAJW6mo90WnwtsT05xKJmApqxku1HjtrgiPVytHqr7oq7XWFpPdcRPgUn2wY4w
	TtOy3K96zlxP4uarNEwkMkwF+CshARPdwO4ekmAq82YkUuwac9ppOdkqK8o0kGkzZ72Xm8jv0jn
	tcqeU4XQNqXt/wDCEOYNA=
X-Google-Smtp-Source: AGHT+IFkUYiGJQHEujscCIJGdcr5DPCjiBGA4KInQE+eV3zbZzt6fp9WdLt0lMcF1GpDO3C6bvAJYg==
X-Received: by 2002:a05:6a00:92a7:b0:771:e451:4ee3 with SMTP id d2e1a72fcca58-7742dd543d9mr22919216b3a.12.1757552359958;
        Wed, 10 Sep 2025 17:59:19 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77607c471dcsm119667b3a.96.2025.09.10.17.59.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 17:59:19 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uwVed-00000000L2i-3Kt7;
	Thu, 11 Sep 2025 10:59:15 +1000
Date: Thu, 11 Sep 2025 10:59:15 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: Don't hold XFS_ILOCK_SHARED over log force
 during fsync
Message-ID: <aMIe43ZYUtcQ9cZv@dread.disaster.area>
References: <20250908151248.1290-2-jack@suse.cz>
 <aL9yc4WJLdqtCFOK@dread.disaster.area>
 <hzjznua7gqp32yc36b5uef6acy4nssfdy42jtlpaxcdzfi5ddy@kcveowwcwltb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hzjznua7gqp32yc36b5uef6acy4nssfdy42jtlpaxcdzfi5ddy@kcveowwcwltb>

On Wed, Sep 10, 2025 at 11:05:18AM +0200, Jan Kara wrote:
> On Tue 09-09-25 10:18:59, Dave Chinner wrote:
> > On Mon, Sep 08, 2025 at 05:12:49PM +0200, Jan Kara wrote:
> > > Holding XFS_ILOCK_SHARED over log force in xfs_fsync_flush_log()
> > > significantly increases contention on ILOCK for O_DSYNC | O_DIRECT
> > > writes to file preallocated with fallocate (thus DIO happens to
> > > unwritten extents and we need ILOCK in exclusive mode for timestamp
> > > modifications and extent conversions). But holding ILOCK over the log
> > > force doesn't seem strictly necessary for correctness.
> > 
> > That was introduced a long while back in 2015 when the
> > ili_fsync_fields flags were introduced to optimise O_DSYNC to avoid
> > timestamp updates from causing log forces. That was commit
> > fc0561cefc04 ("xfs: optimise away log forces on timestamp updates for
> > fdatasync").
.....
> > > +		xfs_iunlock(ip, XFS_ILOCK_SHARED);
> > >  		error = xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC,
> > >  					  log_flushed);
> > > -
> > >  		spin_lock(&ip->i_itemp->ili_lock);
> > > -		ip->i_itemp->ili_fsync_fields = 0;
> > > +		ip->i_itemp->ili_fsync_flushing_fields = 0;
> > >  		spin_unlock(&ip->i_itemp->ili_lock);
> > > +	} else {
> > > +		xfs_iunlock(ip, XFS_ILOCK_SHARED);
> > >  	}
> > > -	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> > >  	return error;
> > >  }
> > 
> > Hence it seems better to reintegrate xfs_fsync_seq() because it
> > cleans up the locking and logic. I'd also call it
> > "ili_last_fsync_fields" to match the naming that the inode flushing
> > code uses (i.e. ili_last_fields):
> > 
> > 	struct xfs_inode_log_item *iip = ip->i_itemp;
> > 	unsigned int		sync_fields;
> > 	xfs_csn_t		seq = 0;
> > 
> > 	xfs_ilock(ip, XFS_ILOCK_SHARED);
> > 	if (!xfs_ipincount(ip)) {
> > 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
> > 		return 0;
> > 	}
> > 
> > 	spin_lock(&iip->ili_lock);
> > 	sync_fields = iip->ili_fsync_fields | iip->ili_last_fsync_fields;
> > 
> > 	/*
> > 	 * Don't force the log for O_DSYNC operations on inodes that
> > 	 * only have dirty timestamps. Timestamps are not necessary
> > 	 * for data integrity so we can skip them in this case.
> > 	 */
> > 	if (!datasync || (sync_fields & ~XFS_ILOG_TIMESTAMP))
> > 		seq = iip->ili_commit_seq;
> > 		iip->ili_last_fsync_fields |= iip->ili_fsync_fields;
> > 		iip->ili_fsync_fields = 0;
> > 	}
> > 	spin_unlock(&iip->ili_lock);
> > 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> > 
> > 	if (!seq)
> > 		return 0;
> > 
> > 	error = xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC,
> > 				  log_flushed);
> > 	spin_lock(&iip->ili_lock);
> > 	iip->ili_last_fsync_fields = 0;
> > 	spin_unlock(&iip->ili_lock);
> > 
> > 	return error;
> 
> After some thinking... But isn't this still racy in a different way? Like:
> 
> t0			t1			t2
> 
> fsync = ILOG_CORE
> last_fsync = ILOG_CORE
> fsync = 0
> <log force lsn1>
> 			modifies file - this is now possible because we
> 			  don't hold ILOCK anymore
> 			calls fsync
> 			so:
> 			fsync = ILOG_CORE
> 			last_fsync = ILOG_CORE
> 			fsync = 0
> 			<log force lsn2>
> ......
> <log force lsn1 completes>
> last_fsync = 0
> 						fsync
> 						fsync == 0 && last_fsync == 0 =>
> 						  <skips fsync>
> 
> Hence t2 didn't wait until log force of lsn2 completed which looks like a
> bug.

Yes, you are right. I didn't think about that case...

> The problem is last_fsync was cleared too early. We'd need to clear it only
> once the latest log force for the inode has finished (which presumably
> doable by remembering the latest forced seq in xfs_inode_log_item).
> 
> But I'm wondering whether we aren't overcomplicating this. Cannot we just
> instead of ili_fsync_fields maintain the latest seq when the inode has been
> modified in a way relevant for fdatasync?

Trying to work out the implications of not pushing the latest
sequence when a datasync operation is asked for is making my head
hurt. I -think- it will work, but....

> Let's call that
> ili_datasync_commit_seq. Then in case of datasync we'll call
> xfs_log_force_seq() for ili_datasync_commit_seq and in case of fsync for
> ili_commit_seq. No need for complex clearing of ili_fsync_fields... The
> only thing I'm not sure about is how to best handle the ili_fsync_fields
> check in xfs_bmbt_to_iomap() - I haven't found a function to check whether a
> particular seq has been already committed or not.

.... this is problematic. It would need to look something like
xlog_item_in_current_chkpt(). That checks the log item is dirty in
the current checkpoint, but doesn't check against all the
checkpoints that are currently in flight.

To do that, we would have to walk the cil->xc_committing list to
check against all the seqeunce numbers outstanding checkpoints that
are in flight. However, we -really- don't want to be iterating that
list on every IO; that would make the cil->xc_push_lock a very hot
lock. That's going to cause performance regressions, not improve
things.

Something different needs to be done here...

> Tentative patch attached.

....

>  static  int
>  xfs_fsync_flush_log(
> @@ -106,21 +86,25 @@ xfs_fsync_flush_log(
>  	bool			datasync,
>  	int			*log_flushed)
>  {
> -	int			error = 0;
> +	struct xfs_inode_log_item *iip = ip->i_itemp;
>  	xfs_csn_t		seq;
>  
>  	xfs_ilock(ip, XFS_ILOCK_SHARED);
> -	seq = xfs_fsync_seq(ip, datasync);
> -	if (seq) {
> -		error = xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC,
> -					  log_flushed);
> -
> -		spin_lock(&ip->i_itemp->ili_lock);
> -		ip->i_itemp->ili_fsync_fields = 0;
> -		spin_unlock(&ip->i_itemp->ili_lock);
> +	if (!xfs_ipincount(ip)) {
> +		xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +		return 0;
>  	}
> +
> +	if (datasync)
> +		seq = iip->ili_datasync_commit_seq;
> +	else
> +		seq = iip->ili_commit_seq;
>  	xfs_iunlock(ip, XFS_ILOCK_SHARED);

> -	return error;
> +
> +	if (!seq)
> +		return 0;
> +
> +	return xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC, log_flushed);

OK, so why do we still need the ILOCK and pin count check here?
If we don't check xfs_ipincount() and simply pass the relevant
sequence number to xfs_log_force_seq(), then it will check if the
sequence has already been committed and skip it if it has already
been done.

Yes, this has the same cil->xc_push_lock contention issue as
xfs_bmbt_to_iomap() would have, but we can mostly avoid this with a
further modification to the sequence number behaviour.

i.e. if we clear the commit sequences on last unpin (i.e. in
xfs_inode_item_unpin) then an item that is not in the CIL (and so
doesn't have dirty metadata) will have no associated commit
sequence number set.

Hence if ili_datasync_commit_seq is non-zero, then by definition the
inode must be pinned and has been dirtied for datasync purposes.
That means we can simply query ili_datasync_commit_seq in
xfs_bmbt_to_iomap() to set IOMAP_F_DIRTY.

I suspect that the above fsync code can then become:

	spin_lock(&iip->ili_lock);
	if (datasync)
		seq = iip->ili_datasync_commit_seq;
	else
		seq = iip->ili_commit_seq;
	spin_unlock(&iip->ili_lock);

	if (!seq)
		return 0;
	return xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC, log_flushed);

For the same reason. i.e. a non-zero sequence number implies the
inode log item is dirty in the CIL and pinned.

At this point, we really don't care about races with transaction
commits. f(data)sync should only wait for modifications that have
been fully completed. If they haven't set the commit sequence in the
log item, they haven't fully completed. If the commit sequence is
already set, the the CIL push will co-ordinate appropriately with
commits to ensure correct data integrity behaviour occurs.

Hence I think that if we tie the sequence number clearing to the
inode being removed from the CIL (i.e. last unpin) we can drop all
the pin checks and use the commit sequence numbers directly to
determine what the correct behaviour should be...


> @@ -863,7 +866,11 @@ xfs_inode_item_committing(
>  	struct xfs_log_item	*lip,
>  	xfs_csn_t		seq)
>  {
> -	INODE_ITEM(lip)->ili_commit_seq = seq;
> +	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
> +
> +	iip->ili_commit_seq = seq;
> +	if (iip->ili_datasync_tx)
> +		iip->ili_datasync_commit_seq = seq;
>  	return xfs_inode_item_release(lip);

I think I'd prefer that this be based on iip->ili_dirty_flags.

i.e. we currently clear that field at the end of
inode_item_precommit, but if we leave it intact until the committing
callback we can look directly at those flags and then zero them
unconditionally.

i.e.

	struct xfs_inode_log_item *iip = INODE_ITEM(lip);

	spin_lock(&iip->ili_lock);
	iip->ili_commit_seq = seq;
	if (iip->ili_dirty_flags & ~(XFS_ILOG_IVERSION|XFS_ILOG_TIMESTAMP))
		iip->ili_datasync_commit_seq = seq;
	spin_unlock(&iip->ili_lock);

	/*
	 * Clear all the transaction specific dirty state and
	 * release the log item reference now we are done commiting
	 * the transaction.
	 */
	iip->ili_dirty_flags = 0;
	return xfs_inode_item_release(lip);

This way we don't need an extra field in the inode log item just to
hold a temporary state between ->precommit and ->committing
callbacks.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
