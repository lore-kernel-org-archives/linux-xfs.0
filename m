Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F8EC4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Nov 2022 01:47:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiKBBrw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Nov 2022 21:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiKBBrv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Nov 2022 21:47:51 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB4E2037D
        for <linux-xfs@vger.kernel.org>; Tue,  1 Nov 2022 18:47:50 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id h193so6285413pgc.10
        for <linux-xfs@vger.kernel.org>; Tue, 01 Nov 2022 18:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=14naPSTzBFG+9qysttuhtE8ha40ww9JRJNs3ZRCT4Z8=;
        b=HNJQ1CDdzazjpsljdjxOxuljxqjY1wKRtmGDe+GshNVHkor2kbXyAwldZfqg5pd01z
         JqHF11FrrJffaMfRN8mfGUobbQ5nFxsShKTrMU9gcvjqPeMBL7bHC9YBhcuLPAVA/ur+
         IyCV7Vqxfj+qRVUq7FxucN1sDom57B92OYjyGpLBrcyZjgqSa4iESZT9qdLFmn3bme94
         MAc5+8rAwysuqYTAWtb6eUMns5BNvigUD0M22/umtVgLySAECBycmXLqn/WaFUh5/KFH
         J4g9q9ZsACzfBB+Bfexwsf3jQ0l/Tq38Wbl3qey2y7EEpiJCo64LakIjpTkGpTdKxYto
         eK4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=14naPSTzBFG+9qysttuhtE8ha40ww9JRJNs3ZRCT4Z8=;
        b=2p9DV8jksDx1WC7yO9J0kcFSFPM1nqkGoUyYsHi6Hu2eN0vlZnc8ZEz+nPp8BvT5+y
         pDlqA9++Kj/T3iD16Ec5S4MUe7iWohYKZ6VdkR1etxY1ZRHHH3jCMiIv+wMwQ8WeO3JX
         138ePRWE2yQ9aGGVH2TLYIC0EJfrHcUtaUorpbLSANcUAqFHyL+PrJ4HG818geaklfgM
         8hU9NUdPBY1AKwzMQi1K2IpBJGBS0q7UeFyWQqYkbnIWhP4DHZwOSteHU4+1QjzX4A/K
         PA57oSHkzjpHtF/pwQ2AmLgHrt5QV6hb4NVhvfDSiucIJg0WoUwGg8qFxkbHlqKm6VyC
         V0vQ==
X-Gm-Message-State: ACrzQf1E+vDpP33DS+vVsW1CvGE9kC812NSx+HDP+D7FIjZgL5enVJpk
        KYMIyuLFNwvzCBSil3bk+EZAu90oiMvpNw==
X-Google-Smtp-Source: AMsMyM5HfBAu10v5MjzhtnUrpILMYrJPFGQZQ9rWl16V1Faxgymy4Nxivqc9P6I4ZzO0y9vEyhahXg==
X-Received: by 2002:a63:a13:0:b0:440:a593:b79f with SMTP id 19-20020a630a13000000b00440a593b79fmr19231557pgk.557.1667353669850;
        Tue, 01 Nov 2022 18:47:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id ik23-20020a170902ab1700b00172951ddb12sm7012535plb.42.2022.11.01.18.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 18:47:49 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oq2r3-009CYo-Bx; Wed, 02 Nov 2022 12:47:45 +1100
Date:   Wed, 2 Nov 2022 12:47:45 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: replace xfs_btree_has_record with a general
 keyspace scanner
Message-ID: <20221102014745.GT3600936@dread.disaster.area>
References: <166473481572.1084209.5434516873607335909.stgit@magnolia>
 <166473481597.1084209.14598185861526380195.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473481597.1084209.14598185861526380195.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 02, 2022 at 11:20:16AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The current implementation of xfs_btree_has_record returns true if it
> finds /any/ record within the given range.  Unfortunately, that's not
> sufficient for scrub.  We want to be able to tell if a range of keyspace
> for a btree is devoid of records, is totally mapped to records, or is
> somewhere in between.  By forcing this to be a boolean, we were
> generally missing the "in between" case and returning incorrect results.
> Fix the API so that we can tell the caller which of those three is the
> current state.

My first reaction is that this "keyfill" API name is .... awful.

From an API perspective, all we are doing is changing the
"has_record()" API that returns a boolean to return a tri-state - we
add a "partial" return to the "all" and "none" states we currently
return. The whole API doesn't need renaming - it's impossible to
work out what "scan_keyfill" iis actually intended to do, whereas
"has_record"  is very much self documenting....

Hence I think that the implementation of xfs_btree_has_record()
needs to change, I don't think the entire API needs to be renamed.
All that needs to happen to the higher level API is this conversion:

> -	bool			*exists)
> +	enum xfs_btree_keyfill	*exists)

Even then, the enum could be named for what it means -
xfs_btree_rec_overlap - with values for none, full and partial. At
this point, nothing above xfs_btree_has record needs to know
anything about whatever a "key fill" operation might actually be.


>  static const struct xfs_btree_ops xfs_cntbt_ops = {
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index cfa052d40105..d1225b957649 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -518,6 +518,18 @@ xfs_bmbt_recs_inorder(
>  		xfs_bmbt_disk_get_startoff(&r2->bmbt);
>  }
>  
> +STATIC bool
> +xfs_bmbt_has_key_gap(
> +	struct xfs_btree_cur		*cur,
> +	const union xfs_btree_key	*key1,
> +	const union xfs_btree_key	*key2)
> +{
> +	xfs_fileoff_t			next;
> +
> +	next = be64_to_cpu(key1->bmbt.br_startoff) + 1;
> +	return next != be64_to_cpu(key2->bmbt.br_startoff);
> +}

IDGI - this is an extent tree - there is no gap if the extent at
key2 starts at the end of key1. IOWs, this only returns "no gap"
if the extent at key 1 is a single block in length. I'll come back
to this...

Oh, does this assume that the caller has already created a key to a
nonexistent record in the BMBT that points to the end of the first
extent? i.e. that this method is being called with key1 being a high
key for the bmbt record (i.e. an end pointer) and key2 being a low
key for the bmbt record (i.e. a start pointer)?

If so, this API needs some documentation on how it is expected to be
used - at least name the two keys something more descriptive like
"high key" and "next low key"....

It occurs to me that what I'm actually doing here is reverse
engineering the design of this mechanism from the code because
there's no documentation in the patch or the commit description of
the algorithm being used to find overlapping records....

>  static const struct xfs_btree_ops xfs_bmbt_ops = {
>  	.rec_len		= sizeof(xfs_bmbt_rec_t),
>  	.key_len		= sizeof(xfs_bmbt_key_t),
> @@ -538,6 +550,7 @@ static const struct xfs_btree_ops xfs_bmbt_ops = {
>  	.buf_ops		= &xfs_bmbt_buf_ops,
>  	.keys_inorder		= xfs_bmbt_keys_inorder,
>  	.recs_inorder		= xfs_bmbt_recs_inorder,
> +	.has_key_gap		= xfs_bmbt_has_key_gap,
>  };
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 4c16c8c31fcb..5710d3ee582a 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -5008,34 +5008,100 @@ xfs_btree_diff_two_ptrs(
>  	return (int64_t)be32_to_cpu(a->s) - be32_to_cpu(b->s);
>  }
>  
> -/* If there's an extent, we're done. */
> +struct xfs_btree_scan_keyfill {
> +	/* Keys for the start and end of the range we want to know about. */
> +	union xfs_btree_key	start_key;
> +	union xfs_btree_key	end_key;
> +
> +	/* Highest record key we've seen so far. */
> +	union xfs_btree_key	high_key;
> +
> +	enum xfs_btree_keyfill	outcome;
> +};

This "keyfill" scan operation is completely private to
xfs_btree_has_record(), which further indicates the higher level API
should not be renamed "keyfill"....

> +
>  STATIC int
> -xfs_btree_has_record_helper(
> +xfs_btree_scan_keyfill_helper(
>  	struct xfs_btree_cur		*cur,
>  	const union xfs_btree_rec	*rec,
>  	void				*priv)
>  {
> -	return -ECANCELED;
> +	union xfs_btree_key		rec_key;
> +	union xfs_btree_key		rec_high_key;
> +	struct xfs_btree_scan_keyfill	*info = priv;
> +	int64_t				res;
> +
> +	cur->bc_ops->init_key_from_rec(&rec_key, rec);
> +
> +	if (info->outcome == XFS_BTREE_KEYFILL_EMPTY) {
> +		info->outcome = XFS_BTREE_KEYFILL_SPARSE;
> +
> +		/* Bail if the first record starts after the start key. */
> +		res = cur->bc_ops->diff_two_keys(cur, &info->start_key,
> +				&rec_key);
> +		if (res < 0)
> +			return -ECANCELED;

Better comment needed.

		/*
		 * If the first record we find does not overlap the
		 * start key, then there is a hole at the start of
		 * the search range before the overlap was found.
		 * Hence we can classify this as a sparse overlap
		 * and we don't need to search any further.
		 */

> +	} else {
> +		/* Bail if there's a gap with the previous record. */
> +		if (cur->bc_ops->has_key_gap(cur, &info->high_key, &rec_key))
> +			return -ECANCELED;

Ah, yeah, there's the high key -> low key implementation assumption.

> +	}
> +
> +	/* If the current record is higher than what we've seen, remember it. */
> +	cur->bc_ops->init_high_key_from_rec(&rec_high_key, rec);
> +	res = cur->bc_ops->diff_two_keys(cur, &rec_high_key, &info->high_key);
> +	if (res > 0)
> +		info->high_key = rec_high_key; /* struct copy */
> +
> +	return 0;
>  }
>  
> -/* Is there a record covering a given range of keys? */
> +/*
> + * Scan part of the keyspace of a btree and tell us if the area has no records,
> + * is fully mapped by records, or is partially filled.
> + */
>  int
> -xfs_btree_has_record(
> +xfs_btree_scan_keyfill(
>  	struct xfs_btree_cur		*cur,
>  	const union xfs_btree_irec	*low,
>  	const union xfs_btree_irec	*high,
> -	bool				*exists)
> +	enum xfs_btree_keyfill		*outcome)
>  {
> +	struct xfs_btree_scan_keyfill	info = {
> +		.outcome		= XFS_BTREE_KEYFILL_EMPTY,
> +	};
> +	union xfs_btree_rec		rec;
> +	int64_t				res;
>  	int				error;
>  
> +	if (!cur->bc_ops->has_key_gap)
> +		return -EOPNOTSUPP;
> +
> +	cur->bc_rec = *low;
> +	cur->bc_ops->init_rec_from_cur(cur, &rec);
> +	cur->bc_ops->init_key_from_rec(&info.start_key, &rec);
> +
> +	cur->bc_rec = *high;
> +	cur->bc_ops->init_rec_from_cur(cur, &rec);
> +	cur->bc_ops->init_key_from_rec(&info.end_key, &rec);

Didn't a previous patch I just create helpers for these?

Oh.... patches in the series were threaded in the wrong order...


> +
>  	error = xfs_btree_query_range(cur, low, high,
> -			&xfs_btree_has_record_helper, NULL);
> -	if (error == -ECANCELED) {
> -		*exists = true;
> -		return 0;
> -	}
> -	*exists = false;
> -	return error;
> +			xfs_btree_scan_keyfill_helper, &info);
> +	if (error == -ECANCELED)
> +		goto out;
> +	if (error)
> +		return error;
> +
> +	if (info.outcome == XFS_BTREE_KEYFILL_EMPTY)
> +		goto out;
> +
> +	/* Did the record set go at least as far as the end? */
> +	res = cur->bc_ops->diff_two_keys(cur, &info.high_key, &info.end_key);
> +	if (res >= 0)
> +		info.outcome = XFS_BTREE_KEYFILL_FULL;

Hmmm. I'm wondering if we should have helpers for these sorts of
key comparisons.

static bool
xfs_btree_keycmp_lt(
	struct xfs_btree_cur	*cur,
	struct xfs_btree_key	*key1,
	struct xfs_btree_key	*key2)
{
	return cur->bc_ops->diff_two_keys(cur, key1, key2) < 0;
}

static bool
xfs_btree_keycmp_gt(
	struct xfs_btree_cur	*cur,
	struct xfs_btree_key	*key1,
	struct xfs_btree_key	*key2)
{
	return cur->bc_ops->diff_two_keys(cur, key1, key2) > 0;
}

static bool
xfs_btree_keycmp_ge(
	struct xfs_btree_cur	*cur,
	struct xfs_btree_key	*key1,
	struct xfs_btree_key	*key2)
{
	return cur->bc_ops->diff_two_keys(cur, key1, key2) >= 0;
}

Which then makes the code read a whole lot nicer:

	/* Did the record set go at least as far as the end? */
	if (xfs_btree_keycmp_ge(cur, &info.high_key, &info.end_key))
		info.outcome = XFS_BTREE_KEYFILL_FULL;
...

Not necessary for this patch, but I note there are a few places
where these sorts of key range/ordering checks are open coded...
> +
> +out:
> +	*outcome = info.outcome;
> +	return 0;
>  }
>  
>  /* Are there more records in this btree? */
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index eef27858a013..58a05f0d1f1b 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -157,6 +157,11 @@ struct xfs_btree_ops {
>  	int	(*recs_inorder)(struct xfs_btree_cur *cur,
>  				const union xfs_btree_rec *r1,
>  				const union xfs_btree_rec *r2);
> +
> +	/* decide if there's a gap in the keyspace between two keys */
> +	bool	(*has_key_gap)(struct xfs_btree_cur *cur,
> +			       const union xfs_btree_key *key1,
> +			       const union xfs_btree_key *key2);

Having read through it this far, this looks like it is checking for
two discrete keys form a contiguous range? Perhaps that's a better
name than "gap", because "contiguous" means different things for
different keys. e.g. extents vs inode records.


> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index 8c83e265770c..fd48b95b4f4e 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -380,6 +380,18 @@ xfs_inobt_recs_inorder(
>  		be32_to_cpu(r2->inobt.ir_startino);
>  }
>  
> +STATIC bool
> +xfs_inobt_has_key_gap(
> +	struct xfs_btree_cur		*cur,
> +	const union xfs_btree_key	*key1,
> +	const union xfs_btree_key	*key2)
> +{
> +	xfs_agino_t			next;
> +
> +	next = be32_to_cpu(key1->inobt.ir_startino) + XFS_INODES_PER_CHUNK;
> +	return next != be32_to_cpu(key2->inobt.ir_startino);
> +}

Huh. Is that correct? The high key for an inode chunk is:

STATIC void                                                                      
xfs_inobt_init_high_key_from_rec(                                                
        union xfs_btree_key             *key,                                    
        const union xfs_btree_rec       *rec)                                    
{                                                                                
        __u32                           x;                                       
                                                                                 
        x = be32_to_cpu(rec->inobt.ir_startino);                                 
        x += XFS_INODES_PER_CHUNK - 1;                                           
        key->inobt.ir_startino = cpu_to_be32(x);                                 
}                                                                                

Which means highkey->ir_startino (end range pointer) points to
low_key->ir_startino + 63 (start range pointer + inodes in chunk)

Hence if this "gap" API is supposed to be passed {high_key,
low_key}, then xfs_inobt_has_key_gap() is checking
(low_key->ir_startino + 127) against next_low_key->ir_startino...

> +STATIC bool
> +xfs_refcountbt_has_key_gap(
> +	struct xfs_btree_cur		*cur,
> +	const union xfs_btree_key	*key1,
> +	const union xfs_btree_key	*key2)
> +{
> +	xfs_agblock_t			next;
> +
> +	next = be32_to_cpu(key1->refc.rc_startblock) + 1;
> +	return next != be32_to_cpu(key2->refc.rc_startblock);
> +}

... and this matches the BMBT code (as does the rmapbt code), which seems to
assume a high key (end extent pointer) is being passed as key1, and key2 is
a low key (start extent pointer).

Am I completely misunderstanding what the key gap API uses for
low_key and high_key? I am completely confused now...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
