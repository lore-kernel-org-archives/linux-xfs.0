Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECDE3C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Nov 2022 02:16:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiKBCQb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Nov 2022 22:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiKBCQb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Nov 2022 22:16:31 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4C095B2
        for <linux-xfs@vger.kernel.org>; Tue,  1 Nov 2022 19:16:30 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id v17so12237762plo.1
        for <linux-xfs@vger.kernel.org>; Tue, 01 Nov 2022 19:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8MO2+V7r/+sHR9NYHV4wLFaaNvp6q6EC88L6L6pl0qg=;
        b=nnN5GjZ29ORP1ZMrrLhEISNR3jmp4WDTeBao/Dtpr9OKAPRWJA1N0oFFdwa1LtqtT8
         L8cLmrSUg3Pyi7jYQJB/0qyr5nkKpdWheXahrCXxn+hQP6yKhQgZr4qy5TJMIFlM2l/X
         j7KoKGXRVTGOz2Vz+Iq/Hw4GL6Yr1Hx+iVaaWsPSTQ9QNkMd+DSlkzoS23KzmoXJfCYd
         W593UQ2+z62gwW4XQTP4E6WIUhY2ZKzYPKg4/uXMM/wXaf8gyz+87rp1OCXwA3WqEltH
         VqVIZvhkRXVwTxOxMAoVVYp7uYDrSumTEQ0qhuMYj59B3v0bdtpQOJZ+plJyJAurPLmm
         LMTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8MO2+V7r/+sHR9NYHV4wLFaaNvp6q6EC88L6L6pl0qg=;
        b=4HRYDFzX2LWWvQqfZL1hh8jWLFufkImvpBZuFlob31zjYiFD4BSc2UnVD4UFuf+ia5
         1dUr72YWF4ShN4bnrBQNPVmssLr6MTi5dKoV10brTDeh+w7iK8LQ1v1xLz2f78d9sR50
         e3DPPPv4xEZ1E106bJxTzEnbkwujX22+jIs93r03jIqGYYBrIt8BJVYZ3stsGAFQEei3
         FALWGWNoS/Sc0LUgZYYkw+s30sUEfYD8Y5iyIY+f+ErqOhynk3KAQVIqg3ORWT/mdxdQ
         Aj1isdE9rHTu6qRN+htUbMxHLjLc8tvKDbd6G/vtrNMA1DxmQ/edJ8RfG7R9nO6bMawh
         5dbw==
X-Gm-Message-State: ACrzQf2+L0kszpQncPiPuIm7pVAHB84Dt0jgTwxiRMmxThTbIPmPX5gJ
        LOr0UPyuq8/5lApfMkjyQJx3GN2CotX+1g==
X-Google-Smtp-Source: AMsMyM6xHgi9yEUd5GgvxlTUgdo1rp7Wt0HvjHvsWaeIDCvig6yqH4BsuwbfqzEfXxVNLeARnIAFaQ==
X-Received: by 2002:a17:90a:a88f:b0:214:25ce:fa67 with SMTP id h15-20020a17090aa88f00b0021425cefa67mr2642305pjq.116.1667355389600;
        Tue, 01 Nov 2022 19:16:29 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902c18500b001753654d9c5sm6987157pld.95.2022.11.01.19.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 19:16:29 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oq3Io-009D3L-Oc; Wed, 02 Nov 2022 13:16:26 +1100
Date:   Wed, 2 Nov 2022 13:16:26 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: mask key comparisons for keyspace fill scans
Message-ID: <20221102021626.GU3600936@dread.disaster.area>
References: <166473481572.1084209.5434516873607335909.stgit@magnolia>
 <166473481626.1084209.13610255473278160434.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473481626.1084209.13610255473278160434.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 02, 2022 at 11:20:16AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> For keyspace fullness scans, we want to be able to mask off the parts of
> the key that we don't care about.  For most btree types we /do/ want the
> full keyspace, but for checking that a given space usage also has a full
> complement of rmapbt records (even if different/multiple owners) we need
> this masking so that we only track sparseness of rm_startblock, not the
> whole keyspace (which is extremely sparse).
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
....
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index edea6db8d8e4..6fbce2f3c17e 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -5020,12 +5020,33 @@ struct xfs_btree_scan_keyfill {
>  	union xfs_btree_key	start_key;
>  	union xfs_btree_key	end_key;
>  
> +	/* Mask for key comparisons, if desired. */
> +	union xfs_btree_key	*key_mask;

How does this mask work? i.e. the way it is supposed to be used it
not documented in either the commit message or the code....


> +STATIC int64_t
> +xfs_btree_diff_two_masked_keys(
> +	struct xfs_btree_cur		*cur,
> +	const union xfs_btree_key	*key1,
> +	const union xfs_btree_key	*key2,
> +	const union xfs_btree_key	*mask)
> +{
> +	union xfs_btree_key		mk1, mk2;
> +
> +	if (likely(!mask))
> +		return cur->bc_ops->diff_two_keys(cur, key1, key2);
> +
> +	cur->bc_ops->mask_key(cur, &mk1, key1, mask);
> +	cur->bc_ops->mask_key(cur, &mk2, key2, mask);
> +
> +	return cur->bc_ops->diff_two_keys(cur, &mk1, &mk2);
> +}

This seems .... very abstract.

Why not just add a mask pointer to xfs_btree_diff_two_keys(),
and in each of the btree implementations of ->diff_two_keys()
change them to:

	if (mask) {
		/* mask keys */
	}
	/* run existing diff on two keys */

That gets rid of all these function pointer calls, and we only need
a single "diff two keys" api to be defined...

> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 58a05f0d1f1b..99baa8283049 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -158,10 +158,17 @@ struct xfs_btree_ops {
>  				const union xfs_btree_rec *r1,
>  				const union xfs_btree_rec *r2);
>  
> +	/* mask a key for us */
> +	void	(*mask_key)(struct xfs_btree_cur *cur,
> +			    union xfs_btree_key *out_key,
> +			    const union xfs_btree_key *in_key,
> +			    const union xfs_btree_key *mask);
> +
>  	/* decide if there's a gap in the keyspace between two keys */
>  	bool	(*has_key_gap)(struct xfs_btree_cur *cur,
>  			       const union xfs_btree_key *key1,
> -			       const union xfs_btree_key *key2);
> +			       const union xfs_btree_key *key2,
> +			       const union xfs_btree_key *mask);
>  };
>  
>  /*
> @@ -552,6 +559,7 @@ typedef bool (*xfs_btree_key_gap_fn)(struct xfs_btree_cur *cur,
>  int xfs_btree_scan_keyfill(struct xfs_btree_cur *cur,
>  		const union xfs_btree_irec *low,
>  		const union xfs_btree_irec *high,
> +		const union xfs_btree_irec *mask,
>  		enum xfs_btree_keyfill *outcome);
>  
>  bool xfs_btree_has_more_records(struct xfs_btree_cur *cur);
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index fd48b95b4f4e..d429ca8d9dd8 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -384,11 +384,14 @@ STATIC bool
>  xfs_inobt_has_key_gap(
>  	struct xfs_btree_cur		*cur,
>  	const union xfs_btree_key	*key1,
> -	const union xfs_btree_key	*key2)
> +	const union xfs_btree_key	*key2,
> +	const union xfs_btree_key	*mask)
>  {
>  	xfs_agino_t			next;
>  
> -	next = be32_to_cpu(key1->inobt.ir_startino) + XFS_INODES_PER_CHUNK;
> +	ASSERT(!mask || mask->inobt.ir_startino);
> +
> +	next = be32_to_cpu(key1->inobt.ir_startino) + 1;
>  	return next != be32_to_cpu(key2->inobt.ir_startino);
>  }

I think you just fixed the issue I noticed in the last patch....


> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index 08d47cbf4697..4c123b6dd080 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -2685,13 +2685,18 @@ xfs_rmap_scan_keyfill(
>  {
>  	union xfs_btree_irec	low;
>  	union xfs_btree_irec	high;
> +	union xfs_btree_irec	mask;
> +
> +	/* Only care about space scans here */
> +	memset(&mask, 0, sizeof(low));

sizeof(mask)?

> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index d64143a842ce..9ca60f709c4b 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -433,16 +433,55 @@ xfs_rmapbt_recs_inorder(
>  	return 0;
>  }
>  
> +STATIC void
> +xfs_rmapbt_mask_key(
> +	struct xfs_btree_cur		*cur,
> +	union xfs_btree_key		*out_key,
> +	const union xfs_btree_key	*in_key,
> +	const union xfs_btree_key	*mask)
> +{
> +	memset(out_key, 0, sizeof(union xfs_btree_key));
> +
> +	if (mask->rmap.rm_startblock)
> +		out_key->rmap.rm_startblock = in_key->rmap.rm_startblock;
> +	if (mask->rmap.rm_owner)
> +		out_key->rmap.rm_owner = in_key->rmap.rm_owner;
> +	if (mask->rmap.rm_offset)
> +		out_key->rmap.rm_offset = in_key->rmap.rm_offset;
> +}

So the mask fields are just used as boolean state to select what
should be copied into the masked key?

> +
>  STATIC bool
>  xfs_rmapbt_has_key_gap(
>  	struct xfs_btree_cur		*cur,
>  	const union xfs_btree_key	*key1,
> -	const union xfs_btree_key	*key2)
> +	const union xfs_btree_key	*key2,
> +	const union xfs_btree_key	*mask)
>  {
> -	xfs_agblock_t			next;
> +	bool				reflink = xfs_has_reflink(cur->bc_mp);
> +	uint64_t			x, y;
>  
> -	next = be32_to_cpu(key1->rmap.rm_startblock) + 1;
> -	return next != be32_to_cpu(key2->rmap.rm_startblock);
> +	if (mask->rmap.rm_offset) {
> +		x = be64_to_cpu(key1->rmap.rm_offset) + 1;
> +		y = be64_to_cpu(key2->rmap.rm_offset);
> +		if ((reflink && x < y) || (!reflink && x != y))
> +			return true;
> +	}
> +
> +	if (mask->rmap.rm_owner) {
> +		x = be64_to_cpu(key1->rmap.rm_owner) + 1;
> +		y = be64_to_cpu(key2->rmap.rm_owner);
> +		if ((reflink && x < y) || (!reflink && x != y))
> +			return true;
> +	}
> +
> +	if (mask->rmap.rm_startblock) {
> +		x = be32_to_cpu(key1->rmap.rm_startblock) + 1;
> +		y = be32_to_cpu(key2->rmap.rm_startblock);
> +		if ((reflink && x < y) || (!reflink && x != y))
> +			return true;
> +	}
> +
> +	return false;

Urk. That needs a comment explaining what all the mystery reflink
logic is doing. It also needs to explain the order of precedence on
the mask checks and why that order is important (or not!).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
