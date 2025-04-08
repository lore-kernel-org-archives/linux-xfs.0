Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BE22248B8
	for <linux-xfs@vger.kernel.org>; Tue,  8 Apr 2025 22:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744150478; cv=none; b=CKYa5ceGhs4YXszH8vSgm4mxgH7ue7e5whB0J7H1eE7aCqUsi5agL1G6gNoR51XQqdgoWpQ7031X8oQudCwK4f7krcmTznjcLm7wt9GvoeX6TIfw8Lp1FX61eZ9z1bkXGlh7dfUZbR7ugODllPz5nDt6XTa99iVeonypn6mJ8Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744150478; c=relaxed/simple;
	bh=D/KthX5C1ypFRt+9Uxev13uuVUyvaDI6YdNvKNWoIUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GJQjD8Zq6aifSCClFOAp1aA3t7I0oWuE1hGChP26fqDubs7xBepp59oFqF5RIwz2GsQxvQieKJzFTksVt+Lik0IXJ0NAB2ipJFOmhvtwRvfRPHWKbRevGBJj+0TVRmxlSfsr3tS/weRaIWtVnQEH891xcK0IKbuS2oAAcBLgbGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=DLhMUYWg; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="DLhMUYWg"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-af9925bbeb7so4623796a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 08 Apr 2025 15:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1744150476; x=1744755276; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cGMUfUfIVifQ2N9KcYn9o8QIf2C7TLYQwmiGQbDlkkg=;
        b=DLhMUYWgUkpyZMxs6xCovZDM3XFnIAklrOYYSCVE+I8BZG+PR6gJE3RlUjMCkII0e9
         TxX5coh0QNZ5n4sm1bOxx0NouHjFtDd+lMRLHWMJyRJbeSDe52J0YE1MhM7zwJcSg5T8
         Z+gbOSGSYb5LPvqXdnxMwyUkZ4bMrPoJXvvP+8u7azjgZzn0sxw1Zmx3PbLyiyXMSo81
         qQbBbz+4vk5zaOO4i1l57/ohedhZ4NvKvFAkwE8euJqxJ+yP21TPixRjidHnA2fkrJS9
         8ZmUMOBW1yqgIijJbMb7gS6ek6qkgg21p04bBr7V5+O3khMNu7+xxGmJQ0jKA5GrqumE
         SeYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744150476; x=1744755276;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cGMUfUfIVifQ2N9KcYn9o8QIf2C7TLYQwmiGQbDlkkg=;
        b=UWblPVdB2r0FqgYKZ2VtnQgM8MddVQ1a7iaKqtYQ6STHb24C2hAXw5rro5FPFNdi0u
         2vbkJR5ufLX5bCFqhDzZpwVNMrXUF+GzSPtj/21iLHrdoLMoONekLqXsvlGwU69XY/dr
         Qi418/F0rU4YqJX1VJuCL0yK1WQRf+6VMf2UhF3fCd7BaI6blwwHdvF8l1BL1ksyrwz8
         dwZQ03vhvFBIVh9roeKTRNAyrjKwBDsE9nzVlOJu7bDsQ4aiA37L9m3bwEPAS6c7B2S8
         6S66stMCy8akaZOiyb1vvWQFKGWBtk8WV3Ru0ymBRs7nzUpYvXAQF4RMEPcV+CooaXBR
         V9oQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmWPdoYigUvaagMQiXaYc4p4CMGrG6uZ8t1bmswpDMVHa5Quqt1fubDKjHP5gteSdYP3vgOYl+e2s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz55EfBlNPmuNtn3O2Nw/ZSzTVdTJIj+P8gygt86Nif0RuPiSE9
	26K9K7hyng1JpPu6UMovVnvX4e8mZqexVlpj4X4uTEZfbrQ+/7oAY70kxNWMoFs=
X-Gm-Gg: ASbGncv5SnhVXcQkNWgU+d6ssS0r/Wr2Yz/IaUKXzrgAM6xhaPLJ0VEmiS8PJAJLRc1
	lhb/1/xNceWhMVD6wYLdgl/ihv4ZsYLIyG80ochV40uhw22hDnhbaotN+rrxqs96qdaKFULCZDb
	6ckuNJBIFV5subtPBJQmDSQW77FL5LZbVNwXuVw04rlTK92mZBB2C0KUQAXGgxa+QXDskGNTgii
	sHiKgHASAw7JP5GHcUHEKYVIUvnimaGNhCeWSoRJskwahNcfYwGNWNWEZ5Q9JHbTIXm5a6aKAC6
	6oiT4VTttY9s1aPo+lE/7e2KVgm1Vd+V1BAUQtwbyuC5TW85pYxVrzeHjrztGRRWAs9Bz4suQuL
	godBJ+IPjzFtJ/g9GMw==
X-Google-Smtp-Source: AGHT+IEEyEPhrxGUk1N3L0q3D7SR3s83zgp0gDHNgtJidFhVSkBiE6TihzQRwGMUSWivCx9GzEU2Ww==
X-Received: by 2002:a17:902:f646:b0:21f:61a9:be7d with SMTP id d9443c01a7336-22ac400e48amr4843815ad.49.1744150475558;
        Tue, 08 Apr 2025 15:14:35 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-60-96.pa.nsw.optusnet.com.au. [49.181.60.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-229785bfe34sm106701975ad.67.2025.04.08.15.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 15:14:35 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1u2HDD-00000006EYI-0B3H;
	Wed, 09 Apr 2025 08:14:31 +1000
Date: Wed, 9 Apr 2025 08:14:31 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] xfs: compute the maximum repair reaping defer intent
 chain length
Message-ID: <Z_Wfx79a6gDNoaAD@dread.disaster.area>
References: <20250403191244.GB6283@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250403191244.GB6283@frogsfrogsfrogs>

On Thu, Apr 03, 2025 at 12:12:44PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Actually compute the log overhead of log intent items used in reap
> operations and use that to compute the thresholds in reap.c instead of
> assuming 2048 works.  Note that there have been no complaints because
> tr_itruncate has a very large logres.
> 
> Cc: <stable@vger.kernel.org> # v6.6
> Fixes: 1c7ce115e52106 ("xfs: reap large AG metadata extents when possible")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/scrub/trace.h       |   29 ++++++++++++++++++++++++++
>  fs/xfs/xfs_bmap_item.h     |    3 +++
>  fs/xfs/xfs_extfree_item.h  |    3 +++
>  fs/xfs/xfs_log_priv.h      |   13 +++++++++++
>  fs/xfs/xfs_refcount_item.h |    3 +++
>  fs/xfs/xfs_rmap_item.h     |    3 +++
>  fs/xfs/scrub/reap.c        |   50 +++++++++++++++++++++++++++++++++++++++-----
>  fs/xfs/scrub/trace.c       |    1 +
>  fs/xfs/xfs_bmap_item.c     |   10 +++++++++
>  fs/xfs/xfs_extfree_item.c  |   10 +++++++++
>  fs/xfs/xfs_log_cil.c       |    4 +---
>  fs/xfs/xfs_refcount_item.c |   10 +++++++++
>  fs/xfs/xfs_rmap_item.c     |   10 +++++++++
>  13 files changed, 140 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index d7c4ced47c1567..172765967aaab4 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -2000,6 +2000,35 @@ DEFINE_REPAIR_EXTENT_EVENT(xreap_agextent_binval);
>  DEFINE_REPAIR_EXTENT_EVENT(xreap_bmapi_binval);
>  DEFINE_REPAIR_EXTENT_EVENT(xrep_agfl_insert);
>  
> +DECLARE_EVENT_CLASS(xrep_reap_max_deferred_reaps_class,
> +	TP_PROTO(const struct xfs_trans *tp, unsigned int per_intent_size,
> +		 unsigned int max_deferred_reaps),
> +	TP_ARGS(tp, per_intent_size, max_deferred_reaps),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(unsigned int, log_res)
> +		__field(unsigned int, per_intent_size)
> +		__field(unsigned int, max_deferred_reaps)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = tp->t_mountp->m_super->s_dev;
> +		__entry->log_res = tp->t_log_res;
> +		__entry->per_intent_size = per_intent_size;
> +		__entry->max_deferred_reaps = max_deferred_reaps;
> +	),
> +	TP_printk("dev %d:%d logres %u per_intent_size %u max_deferred_reaps %u",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->log_res,
> +		  __entry->per_intent_size,
> +		  __entry->max_deferred_reaps)
> +);
> +#define DEFINE_REPAIR_REAP_MAX_DEFER_CHAIN_EVENT(name) \
> +DEFINE_EVENT(xrep_reap_max_deferred_reaps_class, name, \
> +	TP_PROTO(const struct xfs_trans *tp, unsigned int per_intent_size, \
> +		 unsigned int max_deferred_reaps), \
> +	TP_ARGS(tp, per_intent_size, max_deferred_reaps))
> +DEFINE_REPAIR_REAP_MAX_DEFER_CHAIN_EVENT(xreap_agextent_max_deferred_reaps);
> +
>  DECLARE_EVENT_CLASS(xrep_reap_find_class,
>  	TP_PROTO(const struct xfs_group *xg, xfs_agblock_t agbno,
>  		 xfs_extlen_t len, bool crosslinked),
> diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
> index 6fee6a5083436b..72512fc700e21a 100644
> --- a/fs/xfs/xfs_bmap_item.h
> +++ b/fs/xfs/xfs_bmap_item.h
> @@ -72,4 +72,7 @@ struct xfs_bmap_intent;
>  
>  void xfs_bmap_defer_add(struct xfs_trans *tp, struct xfs_bmap_intent *bi);
>  
> +unsigned int xfs_bui_item_overhead(unsigned int nr);
> +unsigned int xfs_bud_item_overhead(unsigned int nr);
> +
>  #endif	/* __XFS_BMAP_ITEM_H__ */
> diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
> index 41b7c43060799b..ebb237a4ae87b4 100644
> --- a/fs/xfs/xfs_extfree_item.h
> +++ b/fs/xfs/xfs_extfree_item.h
> @@ -94,4 +94,7 @@ void xfs_extent_free_defer_add(struct xfs_trans *tp,
>  		struct xfs_extent_free_item *xefi,
>  		struct xfs_defer_pending **dfpp);
>  
> +unsigned int xfs_efi_item_overhead(unsigned int nr);
> +unsigned int xfs_efd_item_overhead(unsigned int nr);
> +
>  #endif	/* __XFS_EXTFREE_ITEM_H__ */
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index f3d78869e5e5a3..39a102cc1b43e6 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -698,4 +698,17 @@ xlog_kvmalloc(
>  	return p;
>  }
>  
> +/*
> + * Given a count of iovecs and space for a log item, compute the space we need
> + * in the log to store that data plus the log headers.
> + */
> +static inline unsigned int
> +xlog_item_space(
> +	unsigned int	niovecs,
> +	unsigned int	nbytes)
> +{
> +	nbytes += niovecs * (sizeof(uint64_t) + sizeof(struct xlog_op_header));
> +	return round_up(nbytes, sizeof(uint64_t));
> +}
> +
>  #endif	/* __XFS_LOG_PRIV_H__ */
> diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
> index bfee8f30c63ce9..e23e768e031e20 100644
> --- a/fs/xfs/xfs_refcount_item.h
> +++ b/fs/xfs/xfs_refcount_item.h
> @@ -76,4 +76,7 @@ struct xfs_refcount_intent;
>  void xfs_refcount_defer_add(struct xfs_trans *tp,
>  		struct xfs_refcount_intent *ri);
>  
> +unsigned int xfs_cui_item_overhead(unsigned int nr);
> +unsigned int xfs_cud_item_overhead(unsigned int nr);
> +
>  #endif	/* __XFS_REFCOUNT_ITEM_H__ */
> diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
> index 40d331555675ba..5fed8864bc32cc 100644
> --- a/fs/xfs/xfs_rmap_item.h
> +++ b/fs/xfs/xfs_rmap_item.h
> @@ -75,4 +75,7 @@ struct xfs_rmap_intent;
>  
>  void xfs_rmap_defer_add(struct xfs_trans *tp, struct xfs_rmap_intent *ri);
>  
> +unsigned int xfs_rui_item_overhead(unsigned int nr);
> +unsigned int xfs_rud_item_overhead(unsigned int nr);
> +
>  #endif	/* __XFS_RMAP_ITEM_H__ */
> diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
> index b32fb233cf8476..2fd9b7465b5ed2 100644
> --- a/fs/xfs/scrub/reap.c
> +++ b/fs/xfs/scrub/reap.c
> @@ -36,6 +36,9 @@
>  #include "xfs_metafile.h"
>  #include "xfs_rtgroup.h"
>  #include "xfs_rtrmap_btree.h"
> +#include "xfs_extfree_item.h"
> +#include "xfs_rmap_item.h"
> +#include "xfs_refcount_item.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/trace.h"
> @@ -106,6 +109,9 @@ struct xreap_state {
>  
>  	/* Number of deferred reaps queued during the whole reap sequence. */
>  	unsigned long long		total_deferred;
> +
> +	/* Maximum number of intents we can reap in a single transaction. */
> +	unsigned int			max_deferred_reaps;
>  };
>  
>  /* Put a block back on the AGFL. */
> @@ -165,8 +171,8 @@ static inline bool xreap_dirty(const struct xreap_state *rs)
>  
>  /*
>   * Decide if we want to roll the transaction after reaping an extent.  We don't
> - * want to overrun the transaction reservation, so we prohibit more than
> - * 128 EFIs per transaction.  For the same reason, we limit the number
> + * want to overrun the transaction reservation, so we restrict the number of
> + * log intent reaps per transaction.  For the same reason, we limit the number
>   * of buffer invalidations to 2048.
>   */
>  static inline bool xreap_want_roll(const struct xreap_state *rs)
> @@ -188,13 +194,11 @@ static inline void xreap_reset(struct xreap_state *rs)
>  	rs->force_roll = false;
>  }
>  
> -#define XREAP_MAX_DEFER_CHAIN		(2048)
> -
>  /*
>   * Decide if we want to finish the deferred ops that are attached to the scrub
>   * transaction.  We don't want to queue huge chains of deferred ops because
>   * that can consume a lot of log space and kernel memory.  Hence we trigger a
> - * xfs_defer_finish if there are more than 2048 deferred reap operations or the
> + * xfs_defer_finish if there are too many deferred reap operations or the
>   * caller did some real work.
>   */
>  static inline bool
> @@ -202,7 +206,7 @@ xreap_want_defer_finish(const struct xreap_state *rs)
>  {
>  	if (rs->force_roll)
>  		return true;
> -	if (rs->total_deferred > XREAP_MAX_DEFER_CHAIN)
> +	if (rs->total_deferred > rs->max_deferred_reaps)
>  		return true;
>  	return false;
>  }
> @@ -495,6 +499,37 @@ xreap_agextent_iter(
>  	return 0;
>  }
>  
> +/*
> + * Compute the worst case log overhead of the intent items needed to reap a
> + * single per-AG space extent.
> + */
> +STATIC unsigned int
> +xreap_agextent_max_deferred_reaps(
> +	struct xfs_scrub	*sc)
> +{
> +	const unsigned int	efi = xfs_efi_item_overhead(1);
> +	const unsigned int	rui = xfs_rui_item_overhead(1);

These wrappers don't return some "overhead" - they return the amount of
log space the intent will consume. Can we please call them
xfs_<intent_type>_log_space()?

> +
> +	/* unmapping crosslinked metadata blocks */
> +	const unsigned int	t1 = rui;
> +
> +	/* freeing metadata blocks */
> +	const unsigned int	t2 = rui + efi;
> +
> +	/* worst case of all four possible scenarios */
> +	const unsigned int	per_intent = max(t1, t2);

When is per_intent going to be different to t2? i.e. rui + efi > rui
will always be true, so we don't need to calculate it at runtime.

i.e. what "four scenarios" is this actually handling? I can't work
out what they are from the code or the description...

> +	/*
> +	 * tr_itruncate has enough logres to unmap two file extents; use only
> +	 * half the log reservation for intent items so there's space to do
> +	 * actual work and requeue intent items.
> +	 */
> +	const unsigned int	ret = sc->tp->t_log_res / (2 * per_intent);

So we are assuming only a single type of log reservation is used for
these reaping transactions?

If so, this is calculating a value that is constant for the life of
the mount and probably should be moved to all the other log
reservation calculation functions that are run at mount time and
stored with them.

i.e. this calculation is effectively:

	return (xfs_calc_itruncate_reservation(mp, false) >> 1) /
		(xfs_efi_log_space(1) + xfs_rui_log_space(1));

Also, I think that the algorithm used to calculate the number of
intents we can fit in such a transaction should be described in
the comment above the function, then implement the algorithm as
efficiently as possible (as we already do in xfs_trans_resv.c).

> +	trace_xreap_agextent_max_deferred_reaps(sc->tp, per_intent, ret);

If it is calculated at mount time, this can be emitted along with
all the other log reservations calculated at mount time.

> +	return max(1, ret);

Why? tp->t_logres should always be much greater than the intent
size. How will this ever evaluate as zero without there being some
other serious log/transaction reservation bug elsewhere in the code?

i.e. if we can get zero here, that needs ASSERTS and/or WARN_ON
output and a filesystem shutdown because there is something
seriously wrong occurring in the filesystem.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
