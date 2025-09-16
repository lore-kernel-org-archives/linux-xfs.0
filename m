Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1750530FC15
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 13:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758029576; cv=none; b=k0CnMDP7d9NFYqyo2hYYmIokaRqRi66WrR6TqU6funWv7mqT5J0yp8uSgTZvt/n43u9yPxXPIU98H8K9Ej8j0qHn4/uv1iNBtIbjmzlway/O4J/xVZDVfCfVCry3IlHZxsItFB7B6Hq/0YRRqMDnheqkRWQgLY/yayODOrL0JQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758029576; c=relaxed/simple;
	bh=KbZQiPz3g3kIQgNS9BVdaV2+m1tI7hwbB46GP2RMgZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B8GV1mDr0tJmuKrUjnrpKltHxzhkBEAQzkmNvWvixMswm3EaTBzXsIgM92IKrnOeUnePH3s0sBV/M7RaFWxfL4ci4nZFxNo4tWpOXbBn4u5VPGFovlke5OHugDXq3oObZ9AfF3MFdBQrMadjm/ExcWP8bDERwGn0wKEeqkYcRTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TUWjXd3j; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Him36vWT; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TUWjXd3j; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Him36vWT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TUWjXd3j";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Him36vWT";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TUWjXd3j";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Him36vWT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8E11D2205F;
	Tue, 16 Sep 2025 13:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758029570; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3EPYFgCoPkaqt3dem2N/qP8X8Z/QI8IvW8RNZ3MaijI=;
	b=TUWjXd3jx72Mw4SGZgTW52pwmDolf/J2jq6xL/7vhL4y3Q0abklvWSJJvYTy8TXkzy2D1G
	9NLmsVmRn2ZyIYc2yFkx10rMkwcBVRRc+4H+4J2nBw/P7ZBIewwDj8F10535q7/ZHXlClY
	JEyhHfqlcm7FlMukbndS78Ed09rJSDI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758029570;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3EPYFgCoPkaqt3dem2N/qP8X8Z/QI8IvW8RNZ3MaijI=;
	b=Him36vWTEsF4tTANDSK4MNs7vCZC7o18cJXdnfv2Pum/GXYKfPRx9EwptLVf6P68NQgVJC
	mF5XWqZApY/7a2Aw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758029570; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3EPYFgCoPkaqt3dem2N/qP8X8Z/QI8IvW8RNZ3MaijI=;
	b=TUWjXd3jx72Mw4SGZgTW52pwmDolf/J2jq6xL/7vhL4y3Q0abklvWSJJvYTy8TXkzy2D1G
	9NLmsVmRn2ZyIYc2yFkx10rMkwcBVRRc+4H+4J2nBw/P7ZBIewwDj8F10535q7/ZHXlClY
	JEyhHfqlcm7FlMukbndS78Ed09rJSDI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758029570;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3EPYFgCoPkaqt3dem2N/qP8X8Z/QI8IvW8RNZ3MaijI=;
	b=Him36vWTEsF4tTANDSK4MNs7vCZC7o18cJXdnfv2Pum/GXYKfPRx9EwptLVf6P68NQgVJC
	mF5XWqZApY/7a2Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7EA8F139CB;
	Tue, 16 Sep 2025 13:32:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +ZroHgJnyWjKFAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 16 Sep 2025 13:32:50 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 242CCA0A83; Tue, 16 Sep 2025 15:32:42 +0200 (CEST)
Date: Tue, 16 Sep 2025 15:32:42 +0200
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: Don't hold XFS_ILOCK_SHARED over log force
 during fsync
Message-ID: <vpsyvzbupclvb76axyzytms5rh5yzubcyj5l5h2iwpk3d7xf6a@dw6pemmdfcka>
References: <20250908151248.1290-2-jack@suse.cz>
 <aL9yc4WJLdqtCFOK@dread.disaster.area>
 <hzjznua7gqp32yc36b5uef6acy4nssfdy42jtlpaxcdzfi5ddy@kcveowwcwltb>
 <aMIe43ZYUtcQ9cZv@dread.disaster.area>
 <aMkAhMrKO8bE8Eba@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7nipzkgocm5ol7f3"
Content-Disposition: inline
In-Reply-To: <aMkAhMrKO8bE8Eba@dread.disaster.area>
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain,text/x-patch];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+,1:+,2:+];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.com:email];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	HAS_ATTACHMENT(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -3.80


--7nipzkgocm5ol7f3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 16-09-25 16:15:32, Dave Chinner wrote:
> On Thu, Sep 11, 2025 at 10:59:15AM +1000, Dave Chinner wrote:
> > i.e. if we clear the commit sequences on last unpin (i.e. in
> > xfs_inode_item_unpin) then an item that is not in the CIL (and so
> > doesn't have dirty metadata) will have no associated commit
> > sequence number set.
> > 
> > Hence if ili_datasync_commit_seq is non-zero, then by definition the
> > inode must be pinned and has been dirtied for datasync purposes.
> > That means we can simply query ili_datasync_commit_seq in
> > xfs_bmbt_to_iomap() to set IOMAP_F_DIRTY.
> > 
> > I suspect that the above fsync code can then become:
> > 
> > 	spin_lock(&iip->ili_lock);
> > 	if (datasync)
> > 		seq = iip->ili_datasync_commit_seq;
> > 	else
> > 		seq = iip->ili_commit_seq;
> > 	spin_unlock(&iip->ili_lock);
> > 
> > 	if (!seq)
> > 		return 0;
> > 	return xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC, log_flushed);
> > 
> > For the same reason. i.e. a non-zero sequence number implies the
> > inode log item is dirty in the CIL and pinned.
> > 
> > At this point, we really don't care about races with transaction
> > commits. f(data)sync should only wait for modifications that have
> > been fully completed. If they haven't set the commit sequence in the
> > log item, they haven't fully completed. If the commit sequence is
> > already set, the the CIL push will co-ordinate appropriately with
> > commits to ensure correct data integrity behaviour occurs.
> > 
> > Hence I think that if we tie the sequence number clearing to the
> > inode being removed from the CIL (i.e. last unpin) we can drop all
> > the pin checks and use the commit sequence numbers directly to
> > determine what the correct behaviour should be...
> 
> Here's a patch that implements this. It appears to pass fstests
> without any regressions on my test VMs. Can you test it and check
> that it retains the expected performance improvement for
> O_DSYNC+DIO on fallocate()d space?

Heh, I just wanted to send my version of the patch after all the tests
passed :). Anyway, I've given your patch a spin with the test I have and
its performance looks good. So feel free to add:

Tested-by: Jan Kara <jack@suse.cz>

BTW I don't have customer setup with DB2 available where the huge
difference is visible (I'll send them backport of the patch to their SUSE
kernel once we settle on it) but I have written a tool that replays the
same set of pwrites from same set of threads I've captured from syscall
trace. It reproduces only about 20% difference between good & bad kernels
on my test machine but it was good enough for the bisection and analysis
and the customer confirmed that the revert of what I've bisected to
actually fixes their issue (rwsem reader lockstealing logic). So I'm
reasonably confident I'm really reproducing their issue.

BTW, your patch seems to be about 2% slower on average than what I have
written and somewhat more variable. It may be just a bad luck but
I suspect it may be related to the fact that I ended up using READ_ONCE for
reads of ili_commit_seq and ili_datasync_commit_seq while you use ili_lock.
So I just wanted to suggest that as a possible optimization (my patch
attached for reference). But regardless of whether you do the change or not
I think the patch is good to go.

								Honza

> xfs: rework datasync tracking and execution
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Jan Kara reported that the shared ILOCK held across the journal
> flush during fdatasync operations slows down O_DSYNC DIO on
> unwritten extents significantly. The underlying issue is that
> unwritten extent conversion needs the ILOCK exclusive, whilst the
> datasync operation after the extent conversion holds it shared.
> 
> Hence we cannot be flushing the journal for one IO completion whilst
> at the same time doing unwritten extent conversion on another IO
> completion on the same inode. THis means that IO completions
> lock-step, and IO performance is dependent on the journal flush
> latency.
> 
> Jan demostrated that reducing the ifdatasync lock hold time can
> improve O_DSYNC DIO to unwritten extents performance by 2.5x.
> Discussion on that patch found issues with the method, and we
> came to the conclusion that seperately tracking datasync flush
> seqeunces was the best approach to solving the problem.
> 
> The fsync code uses the ILOCK to serialise against concurrent
> modifications in the transaction commit phase. In a transaction
> commit, there are several disjoint updates to inode log item state
> that need to be considered atomically by the fsync code. These
> operations are allo done under ILOCK_EXCL context:
> 
> 1. ili_fsync_flags is updated in ->iop_precommit
> 2. i_pincount is updated in ->iop_pin before it is added to the CIL
> 3. ili_commit_seq is updated in ->iop_committing, after it has been
>    added to the CIL
> 
> In fsync, we need to:
> 
> 1. check that the inode is dirty in the journal (ipincount)
> 2. check that ili_fsync_flags is set
> 3. grab the ili_commit_seq if a journal flush is needed
> 4. clear the ili_fsync_flags to ensure that new modifications that
> require fsync are tracked in ->iop_precommit correctly
> 
> The serialisation of ipincount/ili_commit_seq is needed
> to ensure that we don't try to unnecessarily flush the journal.
> 
> The serialisation of ili_fsync_flags being set in
> ->iop_precommit and cleared in fsync post journal flush is
> required for correctness.
> 
> Hence holding the ILOCK_SHARED in xfs_file_fsync() performs all this
> serialisation for us.  Ideally, we want to remove the need to hold
> the ILOCK_SHARED in xfs_file_fsync() for best performance.
> 
> We start with the observation that fsync/fdatasync() only need to
> wait for operations that have been completed. Hence operations that
> are still being committed have not completed and datasync operations
> do not need to wait for them.
> 
> This means we can use a single point in time in the commit process
> to signal "this modification is complete". This is what
> ->iop_committing is supposed to provide - it is the point at which
> the object is unlocked after the modification has been recorded in
> the CIL. Hence we could use ili_commit_seq to determine if we should
> flush the journal.
> 
> In theory, we can already do this. However, in practice this will
> expose an internal global CIL lock to the IO path. The ipincount()
> checks optimise away the need to take this lock - if the inode is
> not pinned, then it is not in the CIL and we don't need to check if
> a journal flush at ili_commit_seq needs to be performed.
> 
> The reason this is needed is that the ili_commit_seq is never
> cleared. Once it is set, it remains set even once the journal has
> been committed and the object has been unpinned. Hence we have to
> look that journal internal commit sequence state to determine if
> ili_commit_seq needs to be acted on or not.
> 
> We can solve this by clearing ili_commit_seq when the inode is
> unpinned. If we clear it atomically with the last unpin going away,
> then we are guaranteed that new modifications will order correctly
> as they add a new pin counts and we won't clear a sequence number
> for an active modification in the CIL.
> 
> Further, we can then allow the per-transaction flag state to
> propagate into ->iop_committing (instead of clearing it in
> ->iop_precommit) and that will allow us to determine if the
> modification needs a full fsync or just a datasync, and so we can
> record a separate datasync sequence number (Jan's idea!) and then
> use that in the fdatasync path instead of the full fsync sequence
> number.
> 
> With this infrastructure in place, we no longer need the
> ILOCK_SHARED in the fsync path. All serialisation is done against
> the commit sequence numbers - if the sequence number is set, then we
> have to flush the journal. If it is not set, then we have nothing to
> do. This greatly simplifies the fsync implementation....
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_file.c       | 75 ++++++++++++++++++++++---------------------------
>  fs/xfs/xfs_inode.c      | 25 +++++++++++------
>  fs/xfs/xfs_inode_item.c | 58 ++++++++++++++++++++++++++++++--------
>  fs/xfs/xfs_inode_item.h | 10 ++++++-
>  fs/xfs/xfs_iomap.c      | 15 ++++++++--
>  5 files changed, 119 insertions(+), 64 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index f96fbf5c54c9..2702fef2c90c 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -75,52 +75,47 @@ xfs_dir_fsync(
>  	return xfs_log_force_inode(ip);
>  }
>  
> -static xfs_csn_t
> -xfs_fsync_seq(
> -	struct xfs_inode	*ip,
> -	bool			datasync)
> -{
> -	if (!xfs_ipincount(ip))
> -		return 0;
> -	if (datasync && !(ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
> -		return 0;
> -	return ip->i_itemp->ili_commit_seq;
> -}
> -
>  /*
> - * All metadata updates are logged, which means that we just have to flush the
> - * log up to the latest LSN that touched the inode.
> + * All metadata updates are logged, which means that we just have to push the
> + * journal to the required sequence number than holds the updates. We track
> + * datasync commits separately to full sync commits, and hence only need to
> + * select the correct sequence number for the log force here.
>   *
> - * If we have concurrent fsync/fdatasync() calls, we need them to all block on
> - * the log force before we clear the ili_fsync_fields field. This ensures that
> - * we don't get a racing sync operation that does not wait for the metadata to
> - * hit the journal before returning.  If we race with clearing ili_fsync_fields,
> - * then all that will happen is the log force will do nothing as the lsn will
> - * already be on disk.  We can't race with setting ili_fsync_fields because that
> - * is done under XFS_ILOCK_EXCL, and that can't happen because we hold the lock
> - * shared until after the ili_fsync_fields is cleared.
> + * We don't have to serialise against concurrent modifications, as we do not
> + * have to wait for modifications that have not yet completed. We define a
> + * transaction commit as completing when the commit sequence number is updated,
> + * hence if the sequence number has not updated, the sync operation has been
> + * run before the commit completed and we don't have to wait for it.
> + *
> + * If we have concurrent fsync/fdatasync() calls, the sequence numbers remain
> + * set on the log item until - at least - the journal flush completes. In
> + * reality, they are only cleared when the inode is fully unpinned (i.e.
> + * persistent in the journal and not dirty in the CIL), and so we rely on
> + * xfs_log_force_seq() either skipping sequences that have been persisted or
> + * waiting on sequences that are still in flight to correctly order concurrent
> + * sync operations.
>   */
> -static  int
> +static int
>  xfs_fsync_flush_log(
>  	struct xfs_inode	*ip,
>  	bool			datasync,
>  	int			*log_flushed)
>  {
> -	int			error = 0;
> -	xfs_csn_t		seq;
> +	struct xfs_inode_log_item *iip = ip->i_itemp;
> +	xfs_csn_t		seq = 0;
>  
> -	xfs_ilock(ip, XFS_ILOCK_SHARED);
> -	seq = xfs_fsync_seq(ip, datasync);
> -	if (seq) {
> -		error = xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC,
> +	spin_lock(&iip->ili_lock);
> +	if (datasync)
> +		seq = iip->ili_datasync_seq;
> +	else
> +		seq = iip->ili_commit_seq;
> +	spin_unlock(&iip->ili_lock);
> +
> +	if (!seq)
> +		return 0;
> +
> +	return xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC,
>  					  log_flushed);
> -
> -		spin_lock(&ip->i_itemp->ili_lock);
> -		ip->i_itemp->ili_fsync_fields = 0;
> -		spin_unlock(&ip->i_itemp->ili_lock);
> -	}
> -	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> -	return error;
>  }
>  
>  STATIC int
> @@ -158,12 +153,10 @@ xfs_file_fsync(
>  		error = blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
>  
>  	/*
> -	 * Any inode that has dirty modifications in the log is pinned.  The
> -	 * racy check here for a pinned inode will not catch modifications
> -	 * that happen concurrently to the fsync call, but fsync semantics
> -	 * only require to sync previously completed I/O.
> +	 * If the inode has a inode log item attached, it may need the journal
> +	 * flushed to persist any changes the log item might be tracking.
>  	 */
> -	if (xfs_ipincount(ip)) {
> +	if (ip->i_itemp) {
>  		err2 = xfs_fsync_flush_log(ip, datasync, &log_flushed);
>  		if (err2 && !error)
>  			error = err2;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 0ddb9ce0f5e3..b5619ed5667b 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1667,7 +1667,6 @@ xfs_ifree_mark_inode_stale(
>  	spin_lock(&iip->ili_lock);
>  	iip->ili_last_fields = iip->ili_fields;
>  	iip->ili_fields = 0;
> -	iip->ili_fsync_fields = 0;
>  	spin_unlock(&iip->ili_lock);
>  	ASSERT(iip->ili_last_fields);
>  
> @@ -1832,12 +1831,20 @@ static void
>  xfs_iunpin(
>  	struct xfs_inode	*ip)
>  {
> -	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED);
> +	struct xfs_inode_log_item *iip = ip->i_itemp;
> +	xfs_csn_t		seq = 0;
>  
>  	trace_xfs_inode_unpin_nowait(ip, _RET_IP_);
> +	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED);
> +
> +	spin_lock(&iip->ili_lock);
> +	seq = iip->ili_commit_seq;
> +	spin_unlock(&iip->ili_lock);
> +	if (!seq)
> +		return;
>  
>  	/* Give the log a push to start the unpinning I/O */
> -	xfs_log_force_seq(ip->i_mount, ip->i_itemp->ili_commit_seq, 0, NULL);
> +	xfs_log_force_seq(ip->i_mount, seq, 0, NULL);
>  
>  }
>  
> @@ -2506,7 +2513,6 @@ xfs_iflush(
>  	spin_lock(&iip->ili_lock);
>  	iip->ili_last_fields = iip->ili_fields;
>  	iip->ili_fields = 0;
> -	iip->ili_fsync_fields = 0;
>  	set_bit(XFS_LI_FLUSHING, &iip->ili_item.li_flags);
>  	spin_unlock(&iip->ili_lock);
>  
> @@ -2665,12 +2671,15 @@ int
>  xfs_log_force_inode(
>  	struct xfs_inode	*ip)
>  {
> +	struct xfs_inode_log_item *iip = ip->i_itemp;
>  	xfs_csn_t		seq = 0;
>  
> -	xfs_ilock(ip, XFS_ILOCK_SHARED);
> -	if (xfs_ipincount(ip))
> -		seq = ip->i_itemp->ili_commit_seq;
> -	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +	if (!iip)
> +		return 0;
> +
> +	spin_lock(&iip->ili_lock);
> +	seq = iip->ili_commit_seq;
> +	spin_unlock(&iip->ili_lock);
>  
>  	if (!seq)
>  		return 0;
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index afb6cadf7793..83b94b437696 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -153,7 +153,6 @@ xfs_inode_item_precommit(
>  	 * (ili_fields) correctly tracks that the version has changed.
>  	 */
>  	spin_lock(&iip->ili_lock);
> -	iip->ili_fsync_fields |= (flags & ~XFS_ILOG_IVERSION);
>  	if (flags & XFS_ILOG_IVERSION)
>  		flags = ((flags & ~XFS_ILOG_IVERSION) | XFS_ILOG_CORE);
>  
> @@ -214,12 +213,6 @@ xfs_inode_item_precommit(
>  	spin_unlock(&iip->ili_lock);
>  
>  	xfs_inode_item_precommit_check(ip);
> -
> -	/*
> -	 * We are done with the log item transaction dirty state, so clear it so
> -	 * that it doesn't pollute future transactions.
> -	 */
> -	iip->ili_dirty_flags = 0;
>  	return 0;
>  }
>  
> @@ -729,13 +722,24 @@ xfs_inode_item_unpin(
>  	struct xfs_log_item	*lip,
>  	int			remove)
>  {
> -	struct xfs_inode	*ip = INODE_ITEM(lip)->ili_inode;
> +	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
> +	struct xfs_inode	*ip = iip->ili_inode;
>  
>  	trace_xfs_inode_unpin(ip, _RET_IP_);
>  	ASSERT(lip->li_buf || xfs_iflags_test(ip, XFS_ISTALE));
>  	ASSERT(atomic_read(&ip->i_pincount) > 0);
> -	if (atomic_dec_and_test(&ip->i_pincount))
> +
> +	/*
> +	 * If this is the last unpin, then the inode no longer needs a journal
> +	 * flush to persist it. Hence we can clear the commit sequence numbers
> +	 * as a fsync/fdatasync operation on the inode at this point is a no-op.
> +	 */
> +	if (atomic_dec_and_lock(&ip->i_pincount, &iip->ili_lock)) {
> +		iip->ili_commit_seq = 0;
> +		iip->ili_datasync_seq = 0;
> +		spin_unlock(&iip->ili_lock);
>  		wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
> +	}
>  }
>  
>  STATIC uint
> @@ -863,12 +867,45 @@ xfs_inode_item_committed(
>  	return lsn;
>  }
>  
> +/*
> + * The modification is now complete, so before we unlock the inode we need to
> + * update the commit sequence numbers for data integrity journal flushes. We
> + * always record the commit sequence number (ili_commit_seq) so that anything
> + * that needs a full journal sync will capture all of this modification.
> + *
> + * We then
> + * check if the changes will impact a datasync (O_DSYNC) journal flush. If the
> + * changes will require a datasync flush, then we also record the sequence in
> + * ili_datasync_seq.
> + *
> + * These commit sequence numbers will get cleared atomically with the inode being
> + * unpinned (i.e. pin count goes to zero), and so it will only be set when the
> + * inode is dirty in the journal. This removes the need for checking if the
> + * inode is pinned to determine if a journal flush is necessary, and hence
> + * removes the need for holding the ILOCK_SHARED in xfs_file_fsync() to
> + * serialise pin counts against commit sequence number updates.
> + *
> + */
>  STATIC void
>  xfs_inode_item_committing(
>  	struct xfs_log_item	*lip,
>  	xfs_csn_t		seq)
>  {
> -	INODE_ITEM(lip)->ili_commit_seq = seq;
> +	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
> +
> +	spin_lock(&iip->ili_lock);
> +	iip->ili_commit_seq = seq;
> +	if (iip->ili_dirty_flags & ~(XFS_ILOG_IVERSION | XFS_ILOG_TIMESTAMP))
> +		iip->ili_datasync_seq = seq;
> +	spin_unlock(&iip->ili_lock);
> +
> +	/*
> +	 * Clear the per-transaction dirty flags now that we have finished
> +	 * recording the transaction's inode modifications in the CIL and are
> +	 * about to release and (maybe) unlock the inode.
> +	 */
> +	iip->ili_dirty_flags = 0;
> +
>  	return xfs_inode_item_release(lip);
>  }
>  
> @@ -1060,7 +1097,6 @@ xfs_iflush_abort_clean(
>  {
>  	iip->ili_last_fields = 0;
>  	iip->ili_fields = 0;
> -	iip->ili_fsync_fields = 0;
>  	iip->ili_flush_lsn = 0;
>  	iip->ili_item.li_buf = NULL;
>  	list_del_init(&iip->ili_item.li_bio_list);
> diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
> index ba92ce11a011..2ddcca41714f 100644
> --- a/fs/xfs/xfs_inode_item.h
> +++ b/fs/xfs/xfs_inode_item.h
> @@ -32,9 +32,17 @@ struct xfs_inode_log_item {
>  	spinlock_t		ili_lock;	   /* flush state lock */
>  	unsigned int		ili_last_fields;   /* fields when flushed */
>  	unsigned int		ili_fields;	   /* fields to be logged */
> -	unsigned int		ili_fsync_fields;  /* logged since last fsync */
>  	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
> +
> +	/*
> +	 * We record the sequence number for every inode modification, as
> +	 * well as those that only require fdatasync operations for data
> +	 * integrity. This allows optimisation of the O_DSYNC/fdatasync path
> +	 * without needing to track what modifications the journal is currently
> +	 * carrying for the inode. These are protected by the above ili_lock.
> +	 */
>  	xfs_csn_t		ili_commit_seq;	   /* last transaction commit */
> +	xfs_csn_t		ili_datasync_seq;  /* for datasync optimisation */
>  };
>  
>  static inline int xfs_inode_clean(struct xfs_inode *ip)
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 2a74f2957341..f8c925220005 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -149,9 +149,18 @@ xfs_bmbt_to_iomap(
>  		iomap->bdev = target->bt_bdev;
>  	iomap->flags = iomap_flags;
>  
> -	if (xfs_ipincount(ip) &&
> -	    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
> -		iomap->flags |= IOMAP_F_DIRTY;
> +	/*
> +	 * If the inode is dirty for datasync purposes, let iomap know so it
> +	 * doesn't elide the IO completion journal flushes on O_DSYNC IO.
> +	 */
> +	if (ip->i_itemp) {
> +		struct xfs_inode_log_item *iip = ip->i_itemp;
> +
> +		spin_lock(&iip->ili_lock);
> +		if (iip->ili_datasync_seq)
> +			iomap->flags |= IOMAP_F_DIRTY;
> +		spin_unlock(&iip->ili_lock);
> +	}
>  
>  	iomap->validity_cookie = sequence_cookie;
>  	return 0;
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--7nipzkgocm5ol7f3
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-xfs-Don-t-hold-XFS_ILOCK_SHARED-over-log-force-durin.patch"

From eeb10cf33fe01491a037fb184ed5872a227fe39e Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 31 Jul 2025 11:24:01 +0200
Subject: [PATCH] xfs: Don't hold XFS_ILOCK_SHARED over log force during fsync

Holding XFS_ILOCK_SHARED over log force in xfs_fsync_flush_log()
significantly increases contention on ILOCK for O_DSYNC | O_DIRECT
writes to file preallocated with fallocate (thus DIO happens to
unwritten extents and we need ILOCK in exclusive mode for timestamp
modifications and extent conversions). But holding ILOCK over the log
force doesn't seem strictly necessary for correctness. We are just using
it for a mechanism to make sure parallel fsyncs all wait for log force
to complete but that can be also achieved without holding ILOCK. We
introduce a new mechanism which tracks for each inode sequence number of
the last transaction that is relevant for fdatasync(2) and use that
instead of maintaining ili_fsync_fields.

With this patch DB2 database restore operation speeds up by a factor of
about 2.5x in a VM with 4 CPUs, 16GB of RAM and NVME SSD as a backing
store.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_file.c       | 51 +++++++++++--------------------
 fs/xfs/xfs_inode.c      |  2 --
 fs/xfs/xfs_inode_item.c | 68 +++++++++++++++++++++++++++++------------
 fs/xfs/xfs_inode_item.h |  3 +-
 fs/xfs/xfs_iomap.c      |  2 +-
 5 files changed, 68 insertions(+), 58 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f96fbf5c54c9..c7beee51a1bf 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -75,30 +75,10 @@ xfs_dir_fsync(
 	return xfs_log_force_inode(ip);
 }
 
-static xfs_csn_t
-xfs_fsync_seq(
-	struct xfs_inode	*ip,
-	bool			datasync)
-{
-	if (!xfs_ipincount(ip))
-		return 0;
-	if (datasync && !(ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
-		return 0;
-	return ip->i_itemp->ili_commit_seq;
-}
-
 /*
  * All metadata updates are logged, which means that we just have to flush the
- * log up to the latest LSN that touched the inode.
- *
- * If we have concurrent fsync/fdatasync() calls, we need them to all block on
- * the log force before we clear the ili_fsync_fields field. This ensures that
- * we don't get a racing sync operation that does not wait for the metadata to
- * hit the journal before returning.  If we race with clearing ili_fsync_fields,
- * then all that will happen is the log force will do nothing as the lsn will
- * already be on disk.  We can't race with setting ili_fsync_fields because that
- * is done under XFS_ILOCK_EXCL, and that can't happen because we hold the lock
- * shared until after the ili_fsync_fields is cleared.
+ * log up to the latest LSN that modified the inode metadata relevant for the
+ * fsync/fdatasync().
  */
 static  int
 xfs_fsync_flush_log(
@@ -106,21 +86,24 @@ xfs_fsync_flush_log(
 	bool			datasync,
 	int			*log_flushed)
 {
-	int			error = 0;
+	struct xfs_inode_log_item *iip = ip->i_itemp;
 	xfs_csn_t		seq;
 
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	seq = xfs_fsync_seq(ip, datasync);
-	if (seq) {
-		error = xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC,
-					  log_flushed);
+	/*
+	 * We only care about IO user knows has completed before calling fsync.
+	 * Thus we don't care about races with currently running transactions
+	 * possibly updating the sequence numbers. They can only make us force
+	 * a later seq than strictly needed.
+	 */
+	if (datasync)
+		seq = READ_ONCE(iip->ili_datasync_commit_seq);
+	else
+		seq = READ_ONCE(iip->ili_commit_seq);
 
-		spin_lock(&ip->i_itemp->ili_lock);
-		ip->i_itemp->ili_fsync_fields = 0;
-		spin_unlock(&ip->i_itemp->ili_lock);
-	}
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-	return error;
+	if (!seq)
+		return 0;
+
+	return xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC, log_flushed);
 }
 
 STATIC int
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9c39251961a3..209b8aba6238 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1656,7 +1656,6 @@ xfs_ifree_mark_inode_stale(
 	spin_lock(&iip->ili_lock);
 	iip->ili_last_fields = iip->ili_fields;
 	iip->ili_fields = 0;
-	iip->ili_fsync_fields = 0;
 	spin_unlock(&iip->ili_lock);
 	ASSERT(iip->ili_last_fields);
 
@@ -2502,7 +2501,6 @@ xfs_iflush(
 	spin_lock(&iip->ili_lock);
 	iip->ili_last_fields = iip->ili_fields;
 	iip->ili_fields = 0;
-	iip->ili_fsync_fields = 0;
 	set_bit(XFS_LI_FLUSHING, &iip->ili_item.li_flags);
 	spin_unlock(&iip->ili_lock);
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 829675700fcd..2a90e156b072 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -145,18 +145,7 @@ xfs_inode_item_precommit(
 		flags |= XFS_ILOG_CORE;
 	}
 
-	/*
-	 * Record the specific change for fdatasync optimisation. This allows
-	 * fdatasync to skip log forces for inodes that are only timestamp
-	 * dirty. Once we've processed the XFS_ILOG_IVERSION flag, convert it
-	 * to XFS_ILOG_CORE so that the actual on-disk dirty tracking
-	 * (ili_fields) correctly tracks that the version has changed.
-	 */
 	spin_lock(&iip->ili_lock);
-	iip->ili_fsync_fields |= (flags & ~XFS_ILOG_IVERSION);
-	if (flags & XFS_ILOG_IVERSION)
-		flags = ((flags & ~XFS_ILOG_IVERSION) | XFS_ILOG_CORE);
-
 	/*
 	 * Inode verifiers do not check that the CoW extent size hint is an
 	 * integer multiple of the rt extent size on a directory with both
@@ -204,6 +193,23 @@ xfs_inode_item_precommit(
 		xfs_trans_brelse(tp, bp);
 	}
 
+	/*
+	 * Set the transaction dirty state we've created back in inode item
+	 * before mangling flags for storing on disk. We use the value later in
+	 * xfs_inode_item_committing() to determine whether the transaction is
+	 * relevant for fdatasync or not. ili_dirty_flags gets cleared in
+	 * xfs_trans_ijoin() before adding inode to the next transaction.
+	 */
+	iip->ili_dirty_flags = flags;
+
+	/*
+	 * Now convert XFS_ILOG_IVERSION flag to XFS_ILOG_CORE so that the
+	 * actual on-disk dirty tracking (ili_fields) correctly tracks that the
+	 * version has changed.
+	 */
+	if (flags & XFS_ILOG_IVERSION)
+		flags = ((flags & ~XFS_ILOG_IVERSION) | XFS_ILOG_CORE);
+
 	/*
 	 * Always OR in the bits from the ili_last_fields field.  This is to
 	 * coordinate with the xfs_iflush() and xfs_buf_inode_iodone() routines
@@ -215,11 +221,6 @@ xfs_inode_item_precommit(
 
 	xfs_inode_item_precommit_check(ip);
 
-	/*
-	 * We are done with the log item transaction dirty state, so clear it so
-	 * that it doesn't pollute future transactions.
-	 */
-	iip->ili_dirty_flags = 0;
 	return 0;
 }
 
@@ -729,13 +730,26 @@ xfs_inode_item_unpin(
 	struct xfs_log_item	*lip,
 	int			remove)
 {
-	struct xfs_inode	*ip = INODE_ITEM(lip)->ili_inode;
+	struct xfs_inode_log_item	*iip = INODE_ITEM(lip);
+	struct xfs_inode		*ip = iip->ili_inode;
 
 	trace_xfs_inode_unpin(ip, _RET_IP_);
 	ASSERT(lip->li_buf || xfs_iflags_test(ip, XFS_ISTALE));
 	ASSERT(atomic_read(&ip->i_pincount) > 0);
-	if (atomic_dec_and_test(&ip->i_pincount))
+	/*
+	 * We can race with new commit pinning inode again and then
+	 * xfs_inode_item_committing() setting fsync sequence numbers. Hence we
+	 * have to grab ili_lock if dropping the last inode pin to be sure we
+	 * either see i_pincount increment from the new commit or
+	 * xfs_inode_item_committing() will wait with its setting of sequence
+	 * numbers.
+	 */
+	if (atomic_dec_and_lock(&ip->i_pincount, &iip->ili_lock)) {
+		WRITE_ONCE(iip->ili_commit_seq, 0);
+		WRITE_ONCE(iip->ili_datasync_commit_seq, 0);
+		spin_unlock(&iip->ili_lock);
 		wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
+	}
 }
 
 STATIC uint
@@ -863,7 +877,22 @@ xfs_inode_item_committing(
 	struct xfs_log_item	*lip,
 	xfs_csn_t		seq)
 {
-	INODE_ITEM(lip)->ili_commit_seq = seq;
+	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
+
+	/*
+	 * ili_lock protects us from races with xfs_inode_item_unpin(). See
+	 * comment in that function for details.
+	 */
+	spin_lock(&iip->ili_lock);
+	WRITE_ONCE(iip->ili_commit_seq, seq);
+	/*
+	 * Record the specific sequence for fdatasync optimisation. This allows
+	 * fdatasync to skip log forces for inodes that are only timestamp
+	 * dirty.
+	 */
+	if (iip->ili_dirty_flags & ~(XFS_ILOG_IVERSION | XFS_ILOG_TIMESTAMP))
+		WRITE_ONCE(iip->ili_datasync_commit_seq, seq);
+	spin_unlock(&iip->ili_lock);
 	return xfs_inode_item_release(lip);
 }
 
@@ -1055,7 +1084,6 @@ xfs_iflush_abort_clean(
 {
 	iip->ili_last_fields = 0;
 	iip->ili_fields = 0;
-	iip->ili_fsync_fields = 0;
 	iip->ili_flush_lsn = 0;
 	iip->ili_item.li_buf = NULL;
 	list_del_init(&iip->ili_item.li_bio_list);
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index ba92ce11a011..bdcd4b6ebba4 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -32,9 +32,10 @@ struct xfs_inode_log_item {
 	spinlock_t		ili_lock;	   /* flush state lock */
 	unsigned int		ili_last_fields;   /* fields when flushed */
 	unsigned int		ili_fields;	   /* fields to be logged */
-	unsigned int		ili_fsync_fields;  /* logged since last fsync */
 	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
 	xfs_csn_t		ili_commit_seq;	   /* last transaction commit */
+	/* last transaction commit with changes relevant for fdatasync */
+	xfs_csn_t		ili_datasync_commit_seq;
 };
 
 static inline int xfs_inode_clean(struct xfs_inode *ip)
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 2a74f2957341..23539cc29a37 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -150,7 +150,7 @@ xfs_bmbt_to_iomap(
 	iomap->flags = iomap_flags;
 
 	if (xfs_ipincount(ip) &&
-	    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
+	    READ_ONCE(ip->i_itemp->ili_datasync_commit_seq))
 		iomap->flags |= IOMAP_F_DIRTY;
 
 	iomap->validity_cookie = sequence_cookie;
-- 
2.51.0


--7nipzkgocm5ol7f3--
