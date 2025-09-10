Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFA324169F
	for <linux-xfs@vger.kernel.org>; Wed, 10 Sep 2025 09:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757495127; cv=none; b=hMtA2FR0WFY/Sns/6NTGTF1CIobVwUaTzn5toklzjPmlyRE3e2Q8J4TFPMzfnbrCWQSeHS8pQsogHLbgou1FWCf3wBB7maaqU2jD5mH6vkfUILsyE0gvkxligIb846xV4DqrLRBzurtOaXKtWvtjtj9LStsukLd61jq4klMzzWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757495127; c=relaxed/simple;
	bh=jD4RKst17AJYpohZhFDg+2UY16uOl9lLp4g5d2mwujc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s2g6sfSqBSyZE9/I3VGLrlEL29wU/jUovPyF7lEhTY5j+3eu+wewn8rjlPPZPBXFKiEYMbYGzya6lY0KZByeRnDEOV7alGINyRMhun+ZteHwTqXu97jza2HqRTbxZ7Aoaq8gMmpaqs70+LBTt2g71dn2xGTWSa0Oo9yID7rc7r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qrYAq3ZY; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UQbgx/IF; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=cPunC6t/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=PA8QDC9D; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qrYAq3ZY";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UQbgx/IF";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="cPunC6t/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="PA8QDC9D"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DC47E5D4B5;
	Wed, 10 Sep 2025 09:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757495123; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MGQKDdPdARl506/3rpnIRF+AUI6/TCD+kgNEWdduhQw=;
	b=qrYAq3ZYpW5udJ/gInqqXLPntPjn3mXhm/mcHsR9gYwYkJ4cLUl1lYjBVMnu7IdoI4SlCx
	cpOvOVkgbMyhOVcYIzQ+jES+t4xU/vvJUcLSLrEoET7zx4FqJB8EiN3j2G3y3beYbeX2xF
	G2o4gzwOZMo0aj4BvJceQADwBssp8pw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757495123;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MGQKDdPdARl506/3rpnIRF+AUI6/TCD+kgNEWdduhQw=;
	b=UQbgx/IF1oOFqe8E89IhVFISrTibVPG8K5Jokk1rJJx5jq80GHQylRmXGSbR75oaz89IvS
	n/44kdAb0DNzI2Dw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="cPunC6t/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PA8QDC9D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757495122; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MGQKDdPdARl506/3rpnIRF+AUI6/TCD+kgNEWdduhQw=;
	b=cPunC6t/6w9tNzS4R+FjGu6Hqpaq3GSDtcsmjuLfjGikRLdwnO5BdEo5SssDuZSEeQGkkE
	uanNXMxoKbAtqVFWtDTxN5iiKEp2MJPG2fE+jYadVG899m7qA+sZa90fgLEXS7j4CpsLoB
	vl2xoN3XSCd0SeZiqEFr+6KDN/0MR90=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757495122;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MGQKDdPdARl506/3rpnIRF+AUI6/TCD+kgNEWdduhQw=;
	b=PA8QDC9DeScJAirUeHQBz4KfONH7MBNr8l5e4tC4nmKX2VMchem0i8lE1yq8FZ3uUlTQg2
	1AneIPQI/U7HC9Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C693D13301;
	Wed, 10 Sep 2025 09:05:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Nx94MFI/wWjGOAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 10 Sep 2025 09:05:22 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7F98DA0A2D; Wed, 10 Sep 2025 11:05:18 +0200 (CEST)
Date: Wed, 10 Sep 2025 11:05:18 +0200
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: Don't hold XFS_ILOCK_SHARED over log force
 during fsync
Message-ID: <hzjznua7gqp32yc36b5uef6acy4nssfdy42jtlpaxcdzfi5ddy@kcveowwcwltb>
References: <20250908151248.1290-2-jack@suse.cz>
 <aL9yc4WJLdqtCFOK@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vgxg43pdz5f5qtun"
Content-Disposition: inline
In-Reply-To: <aL9yc4WJLdqtCFOK@dread.disaster.area>
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: DC47E5D4B5
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain,text/x-patch];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+,1:+,2:+];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	MISSING_XM_UA(0.00)[];
	HAS_ATTACHMENT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email]
X-Spam-Score: -4.01


--vgxg43pdz5f5qtun
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 09-09-25 10:18:59, Dave Chinner wrote:
> On Mon, Sep 08, 2025 at 05:12:49PM +0200, Jan Kara wrote:
> > Holding XFS_ILOCK_SHARED over log force in xfs_fsync_flush_log()
> > significantly increases contention on ILOCK for O_DSYNC | O_DIRECT
> > writes to file preallocated with fallocate (thus DIO happens to
> > unwritten extents and we need ILOCK in exclusive mode for timestamp
> > modifications and extent conversions). But holding ILOCK over the log
> > force doesn't seem strictly necessary for correctness.
> 
> That was introduced a long while back in 2015 when the
> ili_fsync_fields flags were introduced to optimise O_DSYNC to avoid
> timestamp updates from causing log forces. That was commit
> fc0561cefc04 ("xfs: optimise away log forces on timestamp updates for
> fdatasync").
> 
> > We are just using
> > it for a mechanism to make sure parallel fsyncs all wait for log force
> > to complete but that can be also achieved without holding ILOCK.
> 
> Not exactly. It was used to ensure that we correctly serialised
> the setting of newly dirty fsync flags against the log force that
> allows us to clearing the existing fsync flags. It requires the
> ILOCK_EXCL to set new flags, hence holding the ILOCK_SHARED was
> sufficient to acheive this.
> 
> At the time, the ili_lock did not exist (introduced in 2020), so the
> only way to serialise inode log item flags updates was to use the
> ILOCK. But now with the ili_lock, we can update fields safely
> without holding the ILOCK...
> 
> > With this patch DB2 database restore operation speeds up by a factor of
> > about 2.5x in a VM with 4 CPUs, 16GB of RAM and NVME SSD as a backing
> > store.
> 
> *nod*
> 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/xfs/xfs_file.c       | 33 ++++++++++++++++++++++-----------
> >  fs/xfs/xfs_inode_item.c |  1 +
> >  fs/xfs/xfs_inode_item.h |  1 +
> >  3 files changed, 24 insertions(+), 11 deletions(-)
> > 
> > I've chosen adding ili_fsync_flushing_fields to xfs_inode_log_item since that
> > seemed in line with how the code is structured. Arguably that is unnecessarily
> > wasteful since in practice we use just one bit of information from
> > ili_fsync_fields and one bit from ili_fsync_flushing_fields. If people prefer
> > more space efficient solution, I can certainly do that.
> 
> So you are trying to mirror the ili_fields -> ili_last_fields
> behaviour w.r.t. inode flushing?

Kind of yes.

> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index b04c59d87378..2bb793c8c179 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -80,9 +80,13 @@ xfs_fsync_seq(
> >  	struct xfs_inode	*ip,
> >  	bool			datasync)
> >  {
> > +	unsigned int sync_fields;
> > +
> >  	if (!xfs_ipincount(ip))
> >  		return 0;
> > -	if (datasync && !(ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
> > +	sync_fields = ip->i_itemp->ili_fsync_fields |
> > +		      ip->i_itemp->ili_fsync_flushing_fields;
> 
> Racy read - the new ili_fsync_flushing_fields field is protected by
> ili_lock, not ILOCK....

Yup, luckily easy to fix.

> > +	if (datasync && !(sync_fields & ~XFS_ILOG_TIMESTAMP))
> >  		return 0;
> >  	return ip->i_itemp->ili_commit_seq;
> >  }
> 
> These xfs_fsync_seq() checks are the real reason we need to hold the
> ILOCK for fsync correctness.
> 
> The ili_fsync_fields, pin count and the ili_commit_seq are updated
> as part of the transaction commit processing. The only lock they
> share across this context is the ILOCK_EXCL, and the update order is
> this:
> 
> __xfs_trans_commit
>   xfs_trans_run_precommits
>     ->iop_precommit
>       xfs_inode_item_precommit		>>>> updates ili_fsync_fields
>   xlog_cil_commit
>     xlog_cil_insert_items
>       xlog_cil_insert_format_items
>         xfs_cil_prepare_item
>           ->iop_pin
> 	    xfs_inode_item_pin()	>>>> pin count increment
>     ->iop_committing(seq)
>       xfs_inode_item_committing(seq)    >>>> writes ili_commit_seq
>         xfs_inode_item_release()
> 	  xfs_iunlock(ILOCK_EXCL)	>>>> inode now unlocked
> 
> 
> Hence in xfs_file_fsync(), we have to hold the ILOCK_SHARED to
> determine if the log force needs to be done.
> 
> The ILOCK was extended to cover the log force in commit fc0561cefc04
> because we needed to clear the ili_fsync_fields after the log force,
> but it had to be done in a way that avoided racing with setting new
> fsync bits in the transaction commit. Using the ILOCK was the only
> way to do that, so the lock was then held across the log force...
> 
> Ok, so it look slike it is safe to drop the ILOCK across the log
> force as long as we have some other way to ensure we don't drop
> newly dirtied fsync fields on the ground.

Thanks for the details!

> > @@ -112,14 +117,20 @@ xfs_fsync_flush_log(
> >  	xfs_ilock(ip, XFS_ILOCK_SHARED);
> >  	seq = xfs_fsync_seq(ip, datasync);
> >  	if (seq) {
> > +		spin_lock(&ip->i_itemp->ili_lock);
> > +		ip->i_itemp->ili_fsync_flushing_fields =
> > +						ip->i_itemp->ili_fsync_fields;
> > +		ip->i_itemp->ili_fsync_fields = 0;
> > +		spin_unlock(&ip->i_itemp->ili_lock);
> 
> This is racy. if we get three fdatasync()s at the same time, they
> can do:
> 
> t0			t1			t2
> 
> fsync = ILOG_CORE
> flushing = ILOG_CORE
> fsync = 0
> <log force>
> 			xfs_fsync_seq
> 			  fields = ILOG_CORE
> 			fsync = 0
> 			flushing = 0
> 			fsync = 0
> 			<log force>
> 						xfs_fsync_seq
> 						  fields = 0
> 						<skips datasync>
> ......
> <log force completes>
> 
> In this case t2 should have waited on the log force like t0 and t1,
> but the lack of dirty fsync fields has allowed it to skip them.
> 
> We avoid these problems with ili_fields/ili_last_fields by always
> ORing the ili_last_fields back into the ili_fields whenever we
> update it. This means we don't lose bits that were set by previous
> operations that are still in flight.

Good spotting!

> > +		xfs_iunlock(ip, XFS_ILOCK_SHARED);
> >  		error = xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC,
> >  					  log_flushed);
> > -
> >  		spin_lock(&ip->i_itemp->ili_lock);
> > -		ip->i_itemp->ili_fsync_fields = 0;
> > +		ip->i_itemp->ili_fsync_flushing_fields = 0;
> >  		spin_unlock(&ip->i_itemp->ili_lock);
> > +	} else {
> > +		xfs_iunlock(ip, XFS_ILOCK_SHARED);
> >  	}
> > -	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> >  	return error;
> >  }
> 
> Hence it seems better to reintegrate xfs_fsync_seq() because it
> cleans up the locking and logic. I'd also call it
> "ili_last_fsync_fields" to match the naming that the inode flushing
> code uses (i.e. ili_last_fields):
> 
> 	struct xfs_inode_log_item *iip = ip->i_itemp;
> 	unsigned int		sync_fields;
> 	xfs_csn_t		seq = 0;
> 
> 	xfs_ilock(ip, XFS_ILOCK_SHARED);
> 	if (!xfs_ipincount(ip)) {
> 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
> 		return 0;
> 	}
> 
> 	spin_lock(&iip->ili_lock);
> 	sync_fields = iip->ili_fsync_fields | iip->ili_last_fsync_fields;
> 
> 	/*
> 	 * Don't force the log for O_DSYNC operations on inodes that
> 	 * only have dirty timestamps. Timestamps are not necessary
> 	 * for data integrity so we can skip them in this case.
> 	 */
> 	if (!datasync || (sync_fields & ~XFS_ILOG_TIMESTAMP))
> 		seq = iip->ili_commit_seq;
> 		iip->ili_last_fsync_fields |= iip->ili_fsync_fields;
> 		iip->ili_fsync_fields = 0;
> 	}
> 	spin_unlock(&iip->ili_lock);
> 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> 
> 	if (!seq)
> 		return 0;
> 
> 	error = xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC,
> 				  log_flushed);
> 	spin_lock(&iip->ili_lock);
> 	iip->ili_last_fsync_fields = 0;
> 	spin_unlock(&iip->ili_lock);
> 
> 	return error;

After some thinking... But isn't this still racy in a different way? Like:

t0			t1			t2

fsync = ILOG_CORE
last_fsync = ILOG_CORE
fsync = 0
<log force lsn1>
			modifies file - this is now possible because we
			  don't hold ILOCK anymore
			calls fsync
			so:
			fsync = ILOG_CORE
			last_fsync = ILOG_CORE
			fsync = 0
			<log force lsn2>
......
<log force lsn1 completes>
last_fsync = 0
						fsync
						fsync == 0 && last_fsync == 0 =>
						  <skips fsync>

Hence t2 didn't wait until log force of lsn2 completed which looks like a
bug.

The problem is last_fsync was cleared too early. We'd need to clear it only
once the latest log force for the inode has finished (which presumably
doable by remembering the latest forced seq in xfs_inode_log_item).

But I'm wondering whether we aren't overcomplicating this. Cannot we just
instead of ili_fsync_fields maintain the latest seq when the inode has been
modified in a way relevant for fdatasync? Let's call that
ili_datasync_commit_seq. Then in case of datasync we'll call
xfs_log_force_seq() for ili_datasync_commit_seq and in case of fsync for
ili_commit_seq. No need for complex clearing of ili_fsync_fields... The
only thing I'm not sure about is how to best handle the ili_fsync_fields
check in xfs_bmbt_to_iomap() - I haven't found a function to check whether a
particular seq has been already committed or not.

Tentative patch attached.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--vgxg43pdz5f5qtun
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-xfs-Don-t-hold-XFS_ILOCK_SHARED-over-log-force-durin.patch"

From d699b7901ccb3e85e197c6dcc1b3ffd2a33707ef Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 31 Jul 2025 11:24:01 +0200
Subject: [PATCH v2] xfs: Don't hold XFS_ILOCK_SHARED over log force during fsync

Holding XFS_ILOCK_SHARED over log force in xfs_fsync_flush_log()
significantly increases contention on ILOCK for O_DSYNC | O_DIRECT
writes to file preallocated with fallocate (thus DIO happens to
unwritten extents and we need ILOCK in exclusive mode for timestamp
modifications and extent conversions). But holding ILOCK over the log
force doesn't seem strictly necessary for correctness. We are just using
it for a mechanism to make sure parallel fsyncs all wait for log force
to complete but that can be also achieved without holding ILOCK.

With this patch DB2 database restore operation speeds up by a factor of
about 2.5x in a VM with 4 CPUs, 16GB of RAM and NVME SSD as a backing
store.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_file.c       | 48 ++++++++++++++---------------------------
 fs/xfs/xfs_inode.c      |  2 --
 fs/xfs/xfs_inode_item.c | 12 ++++++++---
 fs/xfs/xfs_inode_item.h |  4 +++-
 4 files changed, 28 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b04c59d87378..c5b8ebddc179 100644
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
@@ -106,21 +86,25 @@ xfs_fsync_flush_log(
 	bool			datasync,
 	int			*log_flushed)
 {
-	int			error = 0;
+	struct xfs_inode_log_item *iip = ip->i_itemp;
 	xfs_csn_t		seq;
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	seq = xfs_fsync_seq(ip, datasync);
-	if (seq) {
-		error = xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC,
-					  log_flushed);
-
-		spin_lock(&ip->i_itemp->ili_lock);
-		ip->i_itemp->ili_fsync_fields = 0;
-		spin_unlock(&ip->i_itemp->ili_lock);
+	if (!xfs_ipincount(ip)) {
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
+		return 0;
 	}
+
+	if (datasync)
+		seq = iip->ili_datasync_commit_seq;
+	else
+		seq = iip->ili_commit_seq;
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-	return error;
+
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
index 829675700fcd..27f28bea0a8f 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -153,7 +153,10 @@ xfs_inode_item_precommit(
 	 * (ili_fields) correctly tracks that the version has changed.
 	 */
 	spin_lock(&iip->ili_lock);
-	iip->ili_fsync_fields |= (flags & ~XFS_ILOG_IVERSION);
+	if (flags & ~(XFS_ILOG_IVERSION | XFS_ILOG_TIMESTAMP))
+		iip->ili_datasync_tx = true;
+	else
+		iip->ili_datasync_tx = false;
 	if (flags & XFS_ILOG_IVERSION)
 		flags = ((flags & ~XFS_ILOG_IVERSION) | XFS_ILOG_CORE);
 
@@ -863,7 +866,11 @@ xfs_inode_item_committing(
 	struct xfs_log_item	*lip,
 	xfs_csn_t		seq)
 {
-	INODE_ITEM(lip)->ili_commit_seq = seq;
+	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
+
+	iip->ili_commit_seq = seq;
+	if (iip->ili_datasync_tx)
+		iip->ili_datasync_commit_seq = seq;
 	return xfs_inode_item_release(lip);
 }
 
@@ -1055,7 +1062,6 @@ xfs_iflush_abort_clean(
 {
 	iip->ili_last_fields = 0;
 	iip->ili_fields = 0;
-	iip->ili_fsync_fields = 0;
 	iip->ili_flush_lsn = 0;
 	iip->ili_item.li_buf = NULL;
 	list_del_init(&iip->ili_item.li_bio_list);
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index ba92ce11a011..7a3364f3a6b4 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -32,9 +32,11 @@ struct xfs_inode_log_item {
 	spinlock_t		ili_lock;	   /* flush state lock */
 	unsigned int		ili_last_fields;   /* fields when flushed */
 	unsigned int		ili_fields;	   /* fields to be logged */
-	unsigned int		ili_fsync_fields;  /* logged since last fsync */
+	bool			ili_datasync_tx;   /* does fdatasync need to flush current tx? */
 	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
 	xfs_csn_t		ili_commit_seq;	   /* last transaction commit */
+	/* last transaction commit with changes relevant for fdatasync */
+	xfs_csn_t		ili_datasync_commit_seq;
 };
 
 static inline int xfs_inode_clean(struct xfs_inode *ip)
-- 
2.51.0


--vgxg43pdz5f5qtun--
