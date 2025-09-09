Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCBE176FB1
	for <linux-xfs@vger.kernel.org>; Tue,  9 Sep 2025 00:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757377146; cv=none; b=lmtHFfhP/RCXkvHCOxhxGu2YlV8feZoq0j0ln810Er+rmgwujXU1SUPcr+RYBNymePJkimJsJRb0l8F2/UnHptTHdFTrSsYYujdGZZUT3tVmVv7r4ZD4BvgT5jWYYY1xe8A76IcpUFd0IrkPhTzYJe2nvFRVzVYb467lRGiaJyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757377146; c=relaxed/simple;
	bh=YGYopKIIVCPTIBtF/wsAP8TSvCwXjZkHI0NmUgYRyPA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SCHuppiqNPhadYbZQZKnUBsyNh6tLvYWxQiw9JvmbSfBOm0JJgTQT8Rtlu6KW+bcAPLYF+rlLt6gHH3dD2/P/FhnX+4ZN9rHv2a8qjRY8C+rqxXJKz/DNdfSTJ6I7EM7RQkvGakj65aejbMcT/55OiU763UG3/6jn824gVf3vHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=rO7TAAlB; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="rO7TAAlB"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2445826fd9dso59716415ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 08 Sep 2025 17:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1757377143; x=1757981943; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pUunciil1e2xNL5N56CX3K7EfOCVfHru19LGWl0EcfA=;
        b=rO7TAAlBsD0UN/aTqL2j8mmCApBRLk6iYIssGNcsY6KAADzudhkyfE6oiSBCuk6jxM
         iJrz79xII0nbsVyC+EoEW7hngV3aYa+sL3TbqL2ZaiMzI7gZEMhtBUCtFTl/LnOnpya/
         +Et8o7RHivPvhjHHFSxtxwaFhx5KizSeu4ycQMf5egA/IgIMZ84DMS4O726CjqQIbwKD
         MHY1pjyfs6ZE+oV3EtmNp3zk5+jR9VDhKqI9RBU2MBe8pMXMRjOc5meMFT2bqPt+EPkf
         JuRxHEnzifqAb2OSuseJjPKYUQ8XvLfq/QxZpzXsWNwLPVHovOFrjAaooKVeExctQ4UJ
         ilrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757377143; x=1757981943;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pUunciil1e2xNL5N56CX3K7EfOCVfHru19LGWl0EcfA=;
        b=vsSng5Z62hD6rsv6f4CRoNRG2PT9SDoMVMvDfL5Z0FfYyVE2Rtfv91FsYw690S3oxV
         35fzPCuOvBXP1AVManBq0PLtsj2jK6SLTMFg2Axc9Vg3dELjY4AluO/ZDK6kX/0AlgSC
         eCmS/8DUluzKHVo43SV9n5QfbomYxsHSR+fiQmptG5HjzgPauvKa0v0/lZJ/ao1iFUkX
         haz/W8tUe/OlOe8nwDnLYhxOZ/6/5eFWyTLhY2p49mxqqASP7pIifnFkuUFurvP3Fww+
         +YLxroD8siHln+oU2ST/+vYEC5aSfbGMJ/yRsKIOn9SCXO3zii2ulTWx7whCcU5JDDI5
         iqSw==
X-Gm-Message-State: AOJu0YxEnlHBrynY6cL2KUOM/wcukiJ1NQGr8eZKyXdHime17aFyPKxG
	/rUgXuMhD0bT4q12jkVbSTz95+b8Vd9J1MDdFqKHnLTuR8I2nvKnHiQ7KPgp/WCKops=
X-Gm-Gg: ASbGncvlajSg3oPd+t5EeUWTw8xrdCJP4TByd2cC0I0lnZZsqEk1fhsiKY9p5NrS1Dh
	LLk7b4E1ZZLSq8GBEmUatjrniIl51opTFgol6yWyXdRxq3YurF0SqvrRMnenhPI2WJNziqCqTJn
	ppcLzNBzzjvjFd/9KD9fVmGmpsVji8hzTJSeeKudkyUNA3JUhxOzK19yhrkGvkWDrW8I7O+JtQ4
	AO5o910AdIY0SvHZJo/NNT2ZLS4qhXe6tQRHBg4e/7MEblumXdDZMTWFq9Sv8Asbw7shL8wX2BQ
	8CRb3epZI5oB165Bsdudhx2d548XCZxt+qC2S4Y48btqqZQywa32BcBiEYsYBgez3BBAMjbpqB4
	Hfn8aXjOpAyK+95qkwCHKe1GBnwPiMh01YRlmO/4SSqGD+UJyHwsVph8IE9jAnfNwcau86HA4xQ
	==
X-Google-Smtp-Source: AGHT+IHvOHPjX8e11N3enr9oy0nWRQYRvCJYpkmcRs55fg2RHI3sNmwtDYJXaVH4OjoZeEJegRjxvA==
X-Received: by 2002:a17:903:985:b0:249:2ba0:7f7f with SMTP id d9443c01a7336-2516ef5132cmr100141375ad.9.1757377143337;
        Mon, 08 Sep 2025 17:19:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24c8945d8d4sm159883705ad.127.2025.09.08.17.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 17:19:02 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uvm4Z-0000000H48n-2omL;
	Tue, 09 Sep 2025 10:18:59 +1000
Date: Tue, 9 Sep 2025 10:18:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: Don't hold XFS_ILOCK_SHARED over log force
 during fsync
Message-ID: <aL9yc4WJLdqtCFOK@dread.disaster.area>
References: <20250908151248.1290-2-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908151248.1290-2-jack@suse.cz>

On Mon, Sep 08, 2025 at 05:12:49PM +0200, Jan Kara wrote:
> Holding XFS_ILOCK_SHARED over log force in xfs_fsync_flush_log()
> significantly increases contention on ILOCK for O_DSYNC | O_DIRECT
> writes to file preallocated with fallocate (thus DIO happens to
> unwritten extents and we need ILOCK in exclusive mode for timestamp
> modifications and extent conversions). But holding ILOCK over the log
> force doesn't seem strictly necessary for correctness.

That was introduced a long while back in 2015 when the
ili_fsync_fields flags were introduced to optimise O_DSYNC to avoid
timestamp updates from causing log forces. That was commit
fc0561cefc04 ("xfs: optimise away log forces on timestamp updates for
fdatasync").

> We are just using
> it for a mechanism to make sure parallel fsyncs all wait for log force
> to complete but that can be also achieved without holding ILOCK.

Not exactly. It was used to ensure that we correctly serialised
the setting of newly dirty fsync flags against the log force that
allows us to clearing the existing fsync flags. It requires the
ILOCK_EXCL to set new flags, hence holding the ILOCK_SHARED was
sufficient to acheive this.

At the time, the ili_lock did not exist (introduced in 2020), so the
only way to serialise inode log item flags updates was to use the
ILOCK. But now with the ili_lock, we can update fields safely
without holding the ILOCK...

> With this patch DB2 database restore operation speeds up by a factor of
> about 2.5x in a VM with 4 CPUs, 16GB of RAM and NVME SSD as a backing
> store.

*nod*

> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/xfs/xfs_file.c       | 33 ++++++++++++++++++++++-----------
>  fs/xfs/xfs_inode_item.c |  1 +
>  fs/xfs/xfs_inode_item.h |  1 +
>  3 files changed, 24 insertions(+), 11 deletions(-)
> 
> I've chosen adding ili_fsync_flushing_fields to xfs_inode_log_item since that
> seemed in line with how the code is structured. Arguably that is unnecessarily
> wasteful since in practice we use just one bit of information from
> ili_fsync_fields and one bit from ili_fsync_flushing_fields. If people prefer
> more space efficient solution, I can certainly do that.

So you are trying to mirror the ili_fields -> ili_last_fields
behaviour w.r.t. inode flushing?

> This is marked as RFC because I'm not quite sure I didn't miss some subtlety
> in XFS logging mechanisms and this will crash & burn badly in some corner
> case (but fstests seem to be passing fine for me).

Yeah, that's the issue, isn't it?

> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index b04c59d87378..2bb793c8c179 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -80,9 +80,13 @@ xfs_fsync_seq(
>  	struct xfs_inode	*ip,
>  	bool			datasync)
>  {
> +	unsigned int sync_fields;
> +
>  	if (!xfs_ipincount(ip))
>  		return 0;
> -	if (datasync && !(ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
> +	sync_fields = ip->i_itemp->ili_fsync_fields |
> +		      ip->i_itemp->ili_fsync_flushing_fields;

Racy read - the new ili_fsync_flushing_fields field is protected by
ili_lock, not ILOCK....

> +	if (datasync && !(sync_fields & ~XFS_ILOG_TIMESTAMP))
>  		return 0;
>  	return ip->i_itemp->ili_commit_seq;
>  }

These xfs_fsync_seq() checks are the real reason we need to hold the
ILOCK for fsync correctness.

The ili_fsync_fields, pin count and the ili_commit_seq are updated
as part of the transaction commit processing. The only lock they
share across this context is the ILOCK_EXCL, and the update order is
this:

__xfs_trans_commit
  xfs_trans_run_precommits
    ->iop_precommit
      xfs_inode_item_precommit		>>>> updates ili_fsync_fields
  xlog_cil_commit
    xlog_cil_insert_items
      xlog_cil_insert_format_items
        xfs_cil_prepare_item
          ->iop_pin
	    xfs_inode_item_pin()	>>>> pin count increment
    ->iop_committing(seq)
      xfs_inode_item_committing(seq)    >>>> writes ili_commit_seq
        xfs_inode_item_release()
	  xfs_iunlock(ILOCK_EXCL)	>>>> inode now unlocked


Hence in xfs_file_fsync(), we have to hold the ILOCK_SHARED to
determine if the log force needs to be done.

The ILOCK was extended to cover the log force in commit fc0561cefc04
because we needed to clear the ili_fsync_fields after the log force,
but it had to be done in a way that avoided racing with setting new
fsync bits in the transaction commit. Using the ILOCK was the only
way to do that, so the lock was then held across the log force...

Ok, so it look slike it is safe to drop the ILOCK across the log
force as long as we have some other way to ensure we don't drop
newly dirtied fsync fields on the ground.


> @@ -92,13 +96,14 @@ xfs_fsync_seq(
>   * log up to the latest LSN that touched the inode.
>   *
>   * If we have concurrent fsync/fdatasync() calls, we need them to all block on
> - * the log force before we clear the ili_fsync_fields field. This ensures that
> - * we don't get a racing sync operation that does not wait for the metadata to
> - * hit the journal before returning.  If we race with clearing ili_fsync_fields,
> - * then all that will happen is the log force will do nothing as the lsn will
> - * already be on disk.  We can't race with setting ili_fsync_fields because that
> - * is done under XFS_ILOCK_EXCL, and that can't happen because we hold the lock
> - * shared until after the ili_fsync_fields is cleared.
> + * the log force until it is finished. Thus we clear ili_fsync_fields so that
> + * new modifications since starting log force can accumulate there and just
> + * save old ili_fsync_fields value to ili_fsync_flushing_fields so that
> + * concurrent fsyncs can use that to determine whether they need to wait for
> + * running log force or not. This ensures that we don't get a racing sync
> + * operation that does not wait for the metadata to hit the journal before
> + * returning.  If we race with clearing ili_fsync_fields, then all that will
> + * happen is the log force will do nothing as the lsn will already be on disk.
>   */
>  static  int
>  xfs_fsync_flush_log(
> @@ -112,14 +117,20 @@ xfs_fsync_flush_log(
>  	xfs_ilock(ip, XFS_ILOCK_SHARED);
>  	seq = xfs_fsync_seq(ip, datasync);
>  	if (seq) {
> +		spin_lock(&ip->i_itemp->ili_lock);
> +		ip->i_itemp->ili_fsync_flushing_fields =
> +						ip->i_itemp->ili_fsync_fields;
> +		ip->i_itemp->ili_fsync_fields = 0;
> +		spin_unlock(&ip->i_itemp->ili_lock);

This is racy. if we get three fdatasync()s at the same time, they
can do:

t0			t1			t2

fsync = ILOG_CORE
flushing = ILOG_CORE
fsync = 0
<log force>
			xfs_fsync_seq
			  fields = ILOG_CORE
			fsync = 0
			flushing = 0
			fsync = 0
			<log force>
						xfs_fsync_seq
						  fields = 0
						<skips datasync>
......
<log force completes>

In this case t2 should have waited on the log force like t0 and t1,
but the lack of dirty fsync fields has allowed it to skip them.

We avoid these problems with ili_fields/ili_last_fields by always
ORing the ili_last_fields back into the ili_fields whenever we
update it. This means we don't lose bits that were set by previous
operations that are still in flight.

> +		xfs_iunlock(ip, XFS_ILOCK_SHARED);
>  		error = xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC,
>  					  log_flushed);
> -
>  		spin_lock(&ip->i_itemp->ili_lock);
> -		ip->i_itemp->ili_fsync_fields = 0;
> +		ip->i_itemp->ili_fsync_flushing_fields = 0;
>  		spin_unlock(&ip->i_itemp->ili_lock);
> +	} else {
> +		xfs_iunlock(ip, XFS_ILOCK_SHARED);
>  	}
> -	xfs_iunlock(ip, XFS_ILOCK_SHARED);
>  	return error;
>  }

Hence it seems better to reintegrate xfs_fsync_seq() because it
cleans up the locking and logic. I'd also call it
"ili_last_fsync_fields" to match the naming that the inode flushing
code uses (i.e. ili_last_fields):

	struct xfs_inode_log_item *iip = ip->i_itemp;
	unsigned int		sync_fields;
	xfs_csn_t		seq = 0;

	xfs_ilock(ip, XFS_ILOCK_SHARED);
	if (!xfs_ipincount(ip)) {
		xfs_iunlock(ip, XFS_ILOCK_SHARED);
		return 0;
	}

	spin_lock(&iip->ili_lock);
	sync_fields = iip->ili_fsync_fields | iip->ili_last_fsync_fields;

	/*
	 * Don't force the log for O_DSYNC operations on inodes that
	 * only have dirty timestamps. Timestamps are not necessary
	 * for data integrity so we can skip them in this case.
	 */
	if (!datasync || (sync_fields & ~XFS_ILOG_TIMESTAMP))
		seq = iip->ili_commit_seq;
		iip->ili_last_fsync_fields |= iip->ili_fsync_fields;
		iip->ili_fsync_fields = 0;
	}
	spin_unlock(&iip->ili_lock);
	xfs_iunlock(ip, XFS_ILOCK_SHARED);

	if (!seq)
		return 0;

	error = xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC,
				  log_flushed);
	spin_lock(&iip->ili_lock);
	iip->ili_last_fsync_fields = 0;
	spin_unlock(&iip->ili_lock);

	return error;
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 829675700fcd..39d15eb9311d 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -1056,6 +1056,7 @@ xfs_iflush_abort_clean(
>  	iip->ili_last_fields = 0;
>  	iip->ili_fields = 0;
>  	iip->ili_fsync_fields = 0;
> +	iip->ili_fsync_flushing_fields = 0;
>  	iip->ili_flush_lsn = 0;
>  	iip->ili_item.li_buf = NULL;
>  	list_del_init(&iip->ili_item.li_bio_list);

I also suspect that ili_last_fsync_fields needs to be cleared in
xfs_iflush() at the same time ili_fsync_fields is cleared. i.e.
flushing for writeback absolutely clears the fsync status of the
inode because, by definition, the inode is not pinned in the journal
and so is not dirty in memory. Hence a fsync at that point should
result in a no-op....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
