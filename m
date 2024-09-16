Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E114E4C91
	for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2024 01:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726450111; cv=none; b=KzNupyM/8bZ060167GUudBtz0dpOpr6DHL/72GFyxW1/ObQCsmurF7BBwtB4IxXmQbSw2Ukf7niZka4Ybixi8Z/nxRE+HobWDz3FWJ/b8sbKWrGxeLkZLr0dbOYUHn9XuWOc1qyZWPLhyFddwHXyYRuuM+u6LB9/IjP/h9QB/kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726450111; c=relaxed/simple;
	bh=LHKALBOvY28sHCBtB92HH09RdZBo3YOqkc3V6Z3L5VM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fWzFKoccf9So7Z8IYlpilbd+Kmkku0wuoAkWXV7CA/qlhH0yk8oE55JLAIMUj8ncXB8AQmdjHafNUQRLl9ywBk+1UAODW/mgIcQWSHmZvr/98N/Mba95FKcnS4V7qjNxgHFTmlR8E6nv3QnOfhPrQYyOtb+IjGBs6YT7/VfoIBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=q7cPES5R; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="q7cPES5R"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-207397d1000so36357695ad.0
        for <linux-xfs@vger.kernel.org>; Sun, 15 Sep 2024 18:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1726450109; x=1727054909; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yLvYX5rvwR1YXKijAimv76ssYmzf1xa5qgbeIdENdOk=;
        b=q7cPES5R5uahi2YzvOTJPaAE5S18vH3QIbRz+oEl/Z5h/igDV2avRPLptgfdGt+yfi
         Pcn3ukbCE7fjqVNscbzV636wqTRqTGAu+i3JjAxpERdr1rJm9Z8cXxAiz2UXLM1E9np7
         PVZWyGRAJy9MCUIECMhN7WQ4I/fI388pqR0bLd0s0g/b3QZpG2TEzvbxGuUxd3tDnK85
         zUhrZCQxECbbcGjcw1n+0ZW4tpNf7n1ukz0OS7neNQtE3h8Jvz9M9WORbw3r15iuDjj+
         7M+8EW6xYkJwOW1hpEuKjr65UkUpjHeUufKzy1GG3SJloiY9tzGabRoF0mGCJtqx9EWA
         aWTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726450109; x=1727054909;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yLvYX5rvwR1YXKijAimv76ssYmzf1xa5qgbeIdENdOk=;
        b=hshn0r4MUYCqPffzeFNZ//Ptlfk0cd4kl6koWXcIL6tqMLQoKWR6SVxzVd2uYuFKY8
         zCqF+E7cEbd/Nx4kLrimijHkrtHzwmkGMbTtpEa6S38wcuRpZx56uyvN3a3d09RQv09k
         UgAfKq4pb/eEJPkGyTuKAB03QKN2BGTsMFSgP7f6tI2CTNXtB5rEmpvveTxFZchwb219
         JThFUOcVlE5FYJBul9jnpIKph9kLQQ5u6sTvRicKlNWhOdKUiRImmwisyjBQRD/1HK1O
         EtfB7ut5Yd2W12I6Fy4H6MuPBEML+392fjmHzq1I+w0TxqmfHiwZ+yU9t6SwG/4CmkUx
         rSWg==
X-Forwarded-Encrypted: i=1; AJvYcCXOQtJMMYotxTPnB522WGrEEohcj1+GZ3OfZzCzo5Ss0uP1K1cDJi7DqUp0DrqWzcOB56wQs8/zils=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXoHzBa21hrP9f3DGABvu5l2/bV0yEZ7WkI5Z3inyaJBbCB35O
	0UiataLQxbSUOdDMLd7/IY/mOAfoxloKJG+WqrozHMWw6bI4FEPbLCkNlmP5JV8=
X-Google-Smtp-Source: AGHT+IGEmC6n29xUtho8PXOqMBcLQ1NXsCz20Dj7dlDVHoUfPNTiiIbISNDeoHV5E9MB5ivNFqBwyQ==
X-Received: by 2002:a17:903:41cd:b0:206:9c9b:61bb with SMTP id d9443c01a7336-2074c5d2fa0mr284579215ad.6.1726450109090;
        Sun, 15 Sep 2024 18:28:29 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2079460574esm27341795ad.109.2024.09.15.18.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Sep 2024 18:28:28 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sq0XS-005j7e-0B;
	Mon, 16 Sep 2024 11:28:26 +1000
Date: Mon, 16 Sep 2024 11:28:26 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: create perag structures as soon as possible
 during log recovery
Message-ID: <ZueJusTG7CJ4jcp5@dread.disaster.area>
References: <20240910042855.3480387-1-hch@lst.de>
 <20240910042855.3480387-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910042855.3480387-4-hch@lst.de>

On Tue, Sep 10, 2024 at 07:28:46AM +0300, Christoph Hellwig wrote:
> An unclean log can contain both the transaction that created a new
> allocation group and the first transaction that is freeing space from
> it, in which case the extent free item recovery requires the perag
> structure to be present.
>
> Currently the perag structures are only created after log recovery
> has completed, leading a warning and file system shutdown for the
> above case.

I'm missing something - the intents aren't processed until the log
has been recovered - queuing an intent to be processed does
not require the per-ag to be present. We don't take per-ag
references until we are recovering the intent. i.e. we've completed
journal recovery and haven't found the corresponding EFD.

That leaves the EFI in the log->r_dfops, and we then run
->recover_work in the second phase of recovery. It is
xfs_extent_free_recover_work() that creates the
new transaction and runs the EFI processing that requires the
perag references, isn't it?

IOWs, I don't see where the initial EFI/EFD recovery during the
checkpoint processing requires the newly created perags to be
present in memory for processing incomplete EFIs before the journal
recovery phase has completed.

> 
> Fix this by creating new perag structures and updating
> the in-memory superblock fields as soon a buffer log item that covers
> the primary super block is recovered.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_log_recover.h |  2 ++
>  fs/xfs/xfs_buf_item_recover.c   | 16 +++++++++
>  fs/xfs/xfs_log_recover.c        | 59 ++++++++++++++-------------------
>  3 files changed, 43 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
> index 521d327e4c89ed..d0e13c84422d0a 100644
> --- a/fs/xfs/libxfs/xfs_log_recover.h
> +++ b/fs/xfs/libxfs/xfs_log_recover.h
> @@ -165,4 +165,6 @@ void xlog_recover_intent_item(struct xlog *log, struct xfs_log_item *lip,
>  int xlog_recover_finish_intent(struct xfs_trans *tp,
>  		struct xfs_defer_pending *dfp);
>  
> +int xlog_recover_update_agcount(struct xfs_mount *mp, struct xfs_dsb *dsb);
> +
>  #endif	/* __XFS_LOG_RECOVER_H__ */
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 09e893cf563cb9..033821a56b6ac6 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -969,6 +969,22 @@ xlog_recover_buf_commit_pass2(
>  			goto out_release;
>  	} else {
>  		xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
> +
> +		/*
> +		 * Update the in-memory superblock and perag structures from the
> +		 * primary SB buffer.
> +		 *
> +		 * This is required because transactions running after growf
> +		 * s may require in-memory structures like the perag right after
> +		 * committing the growfs transaction that created the underlying
> +		 * objects.
> +		 */
> +		if ((xfs_blft_from_flags(buf_f) & XFS_BLFT_SB_BUF) &&
> +		    xfs_buf_daddr(bp) == 0) {
> +			error = xlog_recover_update_agcount(mp, bp->b_addr);
> +			if (error)
> +				goto out_release;
> +		}
>  	}

If we are going to keep this logic, can you do this as a separate
helper function? i.e.:

	if (inode buffer) {
                xlog_recover_do_inode_buffer();
        } else if (dquot buffer) {
                xlog_recover_do_dquot_buffer();
        } else if (superblock buffer) {
		xlog_recover_do_sb_buffer();
	} else {
                xlog_recover_do_reg_buffer();
        }

and

xlog_recover_do_sb_buffer()
{
	error = xlog_recover_do_reg_buffer()
	if (error || xfs_buf_daddr(bp) != XFS_SB_ADDR)
		return error;
	return xlog_recover_update_agcount();
}

>  
>  	/*
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 2af02b32f419c2..7d7ab146cae758 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3334,6 +3334,30 @@ xlog_do_log_recovery(
>  	return error;
>  }
>  
> +int
> +xlog_recover_update_agcount(
> +	struct xfs_mount		*mp,
> +	struct xfs_dsb			*dsb)
> +{
> +	xfs_agnumber_t			old_agcount = mp->m_sb.sb_agcount;
> +	int				error;
> +
> +	xfs_sb_from_disk(&mp->m_sb, dsb);
> +	if (mp->m_sb.sb_agcount < old_agcount) {
> +		xfs_alert(mp, "Shrinking AG count in log recovery");
> +		return -EFSCORRUPTED;
> +	}
> +	mp->m_features |= xfs_sb_version_to_features(&mp->m_sb);

I'm not sure this is safe. The item order in the checkpoint recovery
isn't guaranteed to be exactly the same as when feature bits are
modified at runtime. Hence there could be items in the checkpoint
that haven't yet been recovered that are dependent on the original
sb feature mask being present.  It may be OK to do this at the end
of the checkpoint being recovered.

I'm also not sure why this feature update code is being changed
because it's not mentioned at all in the commit message.

> +	error = xfs_initialize_perag(mp, old_agcount, mp->m_sb.sb_agcount,
> +			mp->m_sb.sb_dblocks, &mp->m_maxagi);

Why do this if sb_agcount has not changed?  AFAICT it only iterates
the AGs already initialised and so skips them, then recalculates
inode32 and prealloc block parameters, which won't change. Hence
it's a total no-op for anything other than an actual ag count change
and should be skipped, right?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
