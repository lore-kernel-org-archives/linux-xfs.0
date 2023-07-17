Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE5CC001DC
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Jul 2023 18:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbjGQSSi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Jul 2023 14:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbjGQSSf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jul 2023 14:18:35 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40298E7F
        for <linux-xfs@vger.kernel.org>; Mon, 17 Jul 2023 11:18:16 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-53fbf2c42bfso3685740a12.3
        for <linux-xfs@vger.kernel.org>; Mon, 17 Jul 2023 11:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20221208.gappssmtp.com; s=20221208; t=1689617895; x=1692209895;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+qzPKaoPNp2IeNfsd3Z7QpQOmAyVBjqzv2d4crC/gjA=;
        b=B/hCTSWszlqn3NFSUcWAN+L7WnIAa1v9Y0bCHS9y7gNSWxc8cWmdb2WlC4NTVLX96i
         wsWgWTHWOjWcatPuOCitjOlm0UaX2PyMWWQNQ56aH07dgfxJRRbI/tcdt4+WVAvuSIrj
         AQedSXuY/HGdB/uE26vTspE8LguJ3AzvZ5CnsBItvoZJINPcgkaGzLprUQxxt5pu2B/G
         7DdiGrIF9YAyetc4351upVK96hFMrEYQylhx35y5O1wWwQn+hzFa4MoaNYE8y7/xOQ7a
         9XzekX0MyxMLEo+GWeiqG4URkVQIsEH8krvOYHIGr1TP/WqbptbqIzDR8O5PqOsCwtXZ
         7hBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689617895; x=1692209895;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+qzPKaoPNp2IeNfsd3Z7QpQOmAyVBjqzv2d4crC/gjA=;
        b=HMNlqbNj4fER30z/JlPNplU8WiO4NSj+3s5Vqc0jindVJ85/IiwFI9+fNxHhUI5L+6
         9vhuWKddmw3ePli+Zm/WZx3Yf1rwofdc3ez5yvO7m44ms3ld0DJEiJkNWLCTOwZsOVeR
         det92XoxGEfJVoPk2pMnap143RrDiEoWmjFUZwLgAOssOR+8aX10u4OzxvXuzvIezCMP
         UGY3kcTx3V5DjQKBKZc7ETIi44W+Y/Y04OIFNTH2BZFf+ADDQFmOZBvrRJzrzbeh5Sdq
         534f5xGR7x9Rbq+UCn2Na332meg2P83f00zH0VS52mpu9cJpfn5LeMHA2eU0jR6+dgnC
         nmVg==
X-Gm-Message-State: ABy/qLa59dKzsXyQ9UY2HzoqYvZkgo+RmBjJLM8TZ//3BnllYa8JCk1G
        f01yU7TO2g5VVrYSZVoYGzQdIw==
X-Google-Smtp-Source: APBJJlGOcSI27axfJGgRqbX09GAMqFbmJdNIw1vGNJtFawuZr9BDFxqnwNRC03JL+Dsf2+DBCl+YhQ==
X-Received: by 2002:a17:90a:784f:b0:25e:c1ff:2cd with SMTP id y15-20020a17090a784f00b0025ec1ff02cdmr11548186pjl.30.1689617894928;
        Mon, 17 Jul 2023 11:18:14 -0700 (PDT)
Received: from telecaster ([2620:10d:c090:400::5:7a5c])
        by smtp.gmail.com with ESMTPSA id p14-20020a17090a4f0e00b00263cca08d95sm129362pjh.55.2023.07.17.11.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jul 2023 11:18:14 -0700 (PDT)
Date:   Mon, 17 Jul 2023 11:18:12 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, kernel-team@fb.com,
        Prashant Nema <pnema@fb.com>
Subject: Re: [PATCH 1/6] xfs: cache last bitmap block in realtime allocator
Message-ID: <ZLWF5INe+d5jlyWo@telecaster>
References: <cover.1687296675.git.osandov@osandov.com>
 <32d2288968c76dc51b2e735e557138925aa09e60.1687296675.git.osandov@osandov.com>
 <20230712182926.GU108251@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712182926.GU108251@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 12, 2023 at 11:29:26AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 20, 2023 at 02:32:11PM -0700, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > Profiling a workload on a highly fragmented realtime device showed a ton
> > of CPU cycles being spent in xfs_trans_read_buf() called by
> > xfs_rtbuf_get(). Further tracing showed that much of that was repeated
> > calls to xfs_rtbuf_get() for the same block of the realtime bitmap.
> > These come from xfs_rtallocate_extent_block(): as it walks through
> > ranges of free bits in the bitmap, each call to xfs_rtcheck_range() and
> > xfs_rtfind_{forw,back}() gets the same bitmap block. If the bitmap block
> > is very fragmented, then this is _a lot_ of buffer lookups.
> > 
> > The realtime allocator already passes around a cache of the last used
> > realtime summary block to avoid repeated reads (the parameters rbpp and
> > rsb). We can do the same for the realtime bitmap.
> > 
> > This replaces rbpp and rsb with a struct xfs_rtbuf_cache, which caches
> > the most recently used block for both the realtime bitmap and summary.
> > xfs_rtbuf_get() now handles the caching instead of the callers, which
> > requires plumbing xfs_rtbuf_cache to more functions but also makes sure
> > we don't miss anything.
> 
> Hmm.  I initially wondered why rtbitmap blocks wouldn't just stay
> attached to the transaction, but then I realized -- this is the
> /scanning/ phase that's repeatedly getting and releasing the rtbmp
> block, right?  The allocator hasn't dirtied any rtbitmap blocks yet, so
> each xfs_trans_brelse actually drops the buffer, and that's how the
> xfs_rtbuf_get ends up pounding on the bmapi and then the buffer cache?
> Repeatedly?

That's right.

> > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > ---
> >  fs/xfs/libxfs/xfs_rtbitmap.c | 167 ++++++++++++++++++-----------------
> >  fs/xfs/xfs_rtalloc.c         | 107 ++++++++++------------
> >  fs/xfs/xfs_rtalloc.h         |  28 ++++--
> >  3 files changed, 154 insertions(+), 148 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> > index fa180ab66b73..1a832c9a412f 100644
> > --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> > +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> > @@ -46,6 +46,21 @@ const struct xfs_buf_ops xfs_rtbuf_ops = {
> >  	.verify_write = xfs_rtbuf_verify_write,
> >  };
> >  
> > +static void
> > +xfs_rtbuf_cache_relse(
> > +	xfs_trans_t	*tp,		/* transaction pointer */
> 
> Please don't introduce more typedef usage.

Oops, I was just copying the surrounding code. I'll fix this in my
changes.

> 	struct xfs_trans	*tp,
> 	struct xfs_rtbuf_cache	*cache)
> 
> (Also there's a lot of broken indenting in the lines added by this
> patch.)

I'll fix it in this new function. Should I also be reindenting all of
the parameter lists where I added this parameter?

> > +	struct xfs_rtbuf_cache *cache)	/* cached blocks */
> > +{
> > +	if (cache->bbuf) {
> > +		xfs_trans_brelse(tp, cache->bbuf);
> > +		cache->bbuf = NULL;
> > +	}
> > +	if (cache->sbuf) {
> > +		xfs_trans_brelse(tp, cache->sbuf);
> > +		cache->sbuf = NULL;
> > +	}
> > +}
> > +
> >  /*
> >   * Get a buffer for the bitmap or summary file block specified.
> >   * The buffer is returned read and locked.
> > @@ -56,14 +71,35 @@ xfs_rtbuf_get(
> >  	xfs_trans_t	*tp,		/* transaction pointer */
> >  	xfs_rtblock_t	block,		/* block number in bitmap or summary */
> >  	int		issum,		/* is summary not bitmap */
> > +	struct xfs_rtbuf_cache *cache,	/* in/out: cached blocks */
> >  	struct xfs_buf	**bpp)		/* output: buffer for the block */
> >  {
> > +	struct xfs_buf	**cbpp;		/* cached block buffer */
> > +	xfs_fsblock_t	*cbp;		/* cached block number */
> >  	struct xfs_buf	*bp;		/* block buffer, result */
> >  	xfs_inode_t	*ip;		/* bitmap or summary inode */
> >  	xfs_bmbt_irec_t	map;
> >  	int		nmap = 1;
> >  	int		error;		/* error value */
> >  
> > +	cbpp = issum ? &cache->bbuf : &cache->sbuf;
> > +	cbp = issum ? &cache->bblock : &cache->sblock;
> > +	/*
> > +	 * If we have a cached buffer, and the block number matches, use that.
> > +	 */
> > +	if (*cbpp && *cbp == block) {
> > +		*bpp = *cbpp;
> > +		return 0;
> > +	}
> > +	/*
> > +	 * Otherwise we have to have to get the buffer.  If there was an old
> > +	 * one, get rid of it first.
> > +	 */
> > +	if (*cbpp) {
> > +		xfs_trans_brelse(tp, *cbpp);
> > +		*cbpp = NULL;
> > +	}
> > +
> >  	ip = issum ? mp->m_rsumip : mp->m_rbmip;
> >  
> >  	error = xfs_bmapi_read(ip, block, 1, &map, &nmap, 0);
> > @@ -82,7 +118,8 @@ xfs_rtbuf_get(
> >  
> >  	xfs_trans_buf_set_type(tp, bp, issum ? XFS_BLFT_RTSUMMARY_BUF
> >  					     : XFS_BLFT_RTBITMAP_BUF);
> > -	*bpp = bp;
> > +	*cbpp = *bpp = bp;
> > +	*cbp = block;
> >  	return 0;
> >  }
> >  
> > @@ -96,6 +133,7 @@ xfs_rtfind_back(
> >  	xfs_trans_t	*tp,		/* transaction pointer */
> >  	xfs_rtblock_t	start,		/* starting block to look at */
> >  	xfs_rtblock_t	limit,		/* last block to look at */
> > +	struct xfs_rtbuf_cache *rtbufc,	/* in/out: cache of realtime blocks */
> >  	xfs_rtblock_t	*rtblock)	/* out: start block found */
> >  {
> >  	xfs_rtword_t	*b;		/* current word in buffer */
> > @@ -116,7 +154,7 @@ xfs_rtfind_back(
> >  	 * Compute and read in starting bitmap block for starting block.
> >  	 */
> >  	block = XFS_BITTOBLOCK(mp, start);
> > -	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
> > +	error = xfs_rtbuf_get(mp, tp, block, 0, rtbufc, &bp);
> >  	if (error) {
> >  		return error;
> >  	}
> > @@ -153,7 +191,6 @@ xfs_rtfind_back(
> >  			/*
> >  			 * Different.  Mark where we are and return.
> >  			 */
> > -			xfs_trans_brelse(tp, bp);
> >  			i = bit - XFS_RTHIBIT(wdiff);
> >  			*rtblock = start - i + 1;
> >  			return 0;
> > @@ -167,8 +204,7 @@ xfs_rtfind_back(
> >  			/*
> >  			 * If done with this block, get the previous one.
> >  			 */
> > -			xfs_trans_brelse(tp, bp);
> > -			error = xfs_rtbuf_get(mp, tp, --block, 0, &bp);
> > +			error = xfs_rtbuf_get(mp, tp, --block, 0, rtbufc, &bp);
> >  			if (error) {
> >  				return error;
> >  			}
> > @@ -199,7 +235,6 @@ xfs_rtfind_back(
> >  			/*
> >  			 * Different, mark where we are and return.
> >  			 */
> > -			xfs_trans_brelse(tp, bp);
> >  			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
> >  			*rtblock = start - i + 1;
> >  			return 0;
> > @@ -213,8 +248,7 @@ xfs_rtfind_back(
> >  			/*
> >  			 * If done with this block, get the previous one.
> >  			 */
> > -			xfs_trans_brelse(tp, bp);
> > -			error = xfs_rtbuf_get(mp, tp, --block, 0, &bp);
> > +			error = xfs_rtbuf_get(mp, tp, --block, 0, rtbufc, &bp);
> >  			if (error) {
> >  				return error;
> >  			}
> > @@ -246,7 +280,6 @@ xfs_rtfind_back(
> >  			/*
> >  			 * Different, mark where we are and return.
> >  			 */
> > -			xfs_trans_brelse(tp, bp);
> >  			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
> >  			*rtblock = start - i + 1;
> >  			return 0;
> > @@ -256,7 +289,6 @@ xfs_rtfind_back(
> >  	/*
> >  	 * No match, return that we scanned the whole area.
> >  	 */
> > -	xfs_trans_brelse(tp, bp);
> >  	*rtblock = start - i + 1;
> >  	return 0;
> >  }
> > @@ -271,6 +303,7 @@ xfs_rtfind_forw(
> >  	xfs_trans_t	*tp,		/* transaction pointer */
> >  	xfs_rtblock_t	start,		/* starting block to look at */
> >  	xfs_rtblock_t	limit,		/* last block to look at */
> > +	struct xfs_rtbuf_cache *rtbufc,	/* in/out: cache of realtime blocks */
> >  	xfs_rtblock_t	*rtblock)	/* out: start block found */
> >  {
> >  	xfs_rtword_t	*b;		/* current word in buffer */
> > @@ -291,7 +324,7 @@ xfs_rtfind_forw(
> >  	 * Compute and read in starting bitmap block for starting block.
> >  	 */
> >  	block = XFS_BITTOBLOCK(mp, start);
> > -	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
> > +	error = xfs_rtbuf_get(mp, tp, block, 0, rtbufc, &bp);
> >  	if (error) {
> >  		return error;
> >  	}
> > @@ -327,7 +360,6 @@ xfs_rtfind_forw(
> >  			/*
> >  			 * Different.  Mark where we are and return.
> >  			 */
> > -			xfs_trans_brelse(tp, bp);
> >  			i = XFS_RTLOBIT(wdiff) - bit;
> >  			*rtblock = start + i - 1;
> >  			return 0;
> > @@ -341,8 +373,7 @@ xfs_rtfind_forw(
> >  			/*
> >  			 * If done with this block, get the previous one.
> >  			 */
> > -			xfs_trans_brelse(tp, bp);
> > -			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
> > +			error = xfs_rtbuf_get(mp, tp, ++block, 0, rtbufc, &bp);
> >  			if (error) {
> >  				return error;
> >  			}
> > @@ -372,7 +403,6 @@ xfs_rtfind_forw(
> >  			/*
> >  			 * Different, mark where we are and return.
> >  			 */
> > -			xfs_trans_brelse(tp, bp);
> >  			i += XFS_RTLOBIT(wdiff);
> >  			*rtblock = start + i - 1;
> >  			return 0;
> > @@ -386,8 +416,7 @@ xfs_rtfind_forw(
> >  			/*
> >  			 * If done with this block, get the next one.
> >  			 */
> > -			xfs_trans_brelse(tp, bp);
> > -			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
> > +			error = xfs_rtbuf_get(mp, tp, ++block, 0, rtbufc, &bp);
> >  			if (error) {
> >  				return error;
> >  			}
> > @@ -416,7 +445,6 @@ xfs_rtfind_forw(
> >  			/*
> >  			 * Different, mark where we are and return.
> >  			 */
> > -			xfs_trans_brelse(tp, bp);
> >  			i += XFS_RTLOBIT(wdiff);
> >  			*rtblock = start + i - 1;
> >  			return 0;
> > @@ -426,7 +454,6 @@ xfs_rtfind_forw(
> >  	/*
> >  	 * No match, return that we scanned the whole area.
> >  	 */
> > -	xfs_trans_brelse(tp, bp);
> >  	*rtblock = start + i - 1;
> >  	return 0;
> >  }
> > @@ -447,8 +474,7 @@ xfs_rtmodify_summary_int(
> >  	int		log,		/* log2 of extent size */
> >  	xfs_rtblock_t	bbno,		/* bitmap block number */
> >  	int		delta,		/* change to make to summary info */
> > -	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
> > -	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
> > +	struct xfs_rtbuf_cache *rtbufc,	/* in/out: cache of realtime blocks */
> >  	xfs_suminfo_t	*sum)		/* out: summary info for this block */
> >  {
> >  	struct xfs_buf	*bp;		/* buffer for the summary block */
> > @@ -465,30 +491,9 @@ xfs_rtmodify_summary_int(
> >  	 * Compute the block number in the summary file.
> >  	 */
> >  	sb = XFS_SUMOFFSTOBLOCK(mp, so);
> > -	/*
> > -	 * If we have an old buffer, and the block number matches, use that.
> > -	 */
> > -	if (*rbpp && *rsb == sb)
> > -		bp = *rbpp;
> > -	/*
> > -	 * Otherwise we have to get the buffer.
> > -	 */
> > -	else {
> > -		/*
> > -		 * If there was an old one, get rid of it first.
> > -		 */
> > -		if (*rbpp)
> > -			xfs_trans_brelse(tp, *rbpp);
> > -		error = xfs_rtbuf_get(mp, tp, sb, 1, &bp);
> > -		if (error) {
> > -			return error;
> > -		}
> > -		/*
> > -		 * Remember this buffer and block for the next call.
> > -		 */
> > -		*rbpp = bp;
> > -		*rsb = sb;
> > -	}
> > +	error = xfs_rtbuf_get(mp, tp, sb, 1, rtbufc, &bp);
> > +	if (error)
> > +		return error;
> >  	/*
> >  	 * Point to the summary information, modify/log it, and/or copy it out.
> >  	 */
> > @@ -517,11 +522,9 @@ xfs_rtmodify_summary(
> >  	int		log,		/* log2 of extent size */
> >  	xfs_rtblock_t	bbno,		/* bitmap block number */
> >  	int		delta,		/* change to make to summary info */
> > -	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
> > -	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
> > +	struct xfs_rtbuf_cache *rtbufc)	/* in/out: cache of realtime blocks */
> >  {
> > -	return xfs_rtmodify_summary_int(mp, tp, log, bbno,
> > -					delta, rbpp, rsb, NULL);
> > +	return xfs_rtmodify_summary_int(mp, tp, log, bbno, delta, rtbufc, NULL);
> >  }
> >  
> >  /*
> > @@ -534,7 +537,8 @@ xfs_rtmodify_range(
> >  	xfs_trans_t	*tp,		/* transaction pointer */
> >  	xfs_rtblock_t	start,		/* starting block to modify */
> >  	xfs_extlen_t	len,		/* length of extent to modify */
> > -	int		val)		/* 1 for free, 0 for allocated */
> > +	int		val,		/* 1 for free, 0 for allocated */
> > +	struct xfs_rtbuf_cache *rtbufc)	/* in/out: cache of realtime blocks */
> >  {
> >  	xfs_rtword_t	*b;		/* current word in buffer */
> >  	int		bit;		/* bit number in the word */
> > @@ -555,7 +559,7 @@ xfs_rtmodify_range(
> >  	/*
> >  	 * Read the bitmap block, and point to its data.
> >  	 */
> > -	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
> > +	error = xfs_rtbuf_get(mp, tp, block, 0, rtbufc, &bp);
> >  	if (error) {
> >  		return error;
> >  	}
> > @@ -600,7 +604,7 @@ xfs_rtmodify_range(
> >  			xfs_trans_log_buf(tp, bp,
> >  				(uint)((char *)first - (char *)bufp),
> >  				(uint)((char *)b - (char *)bufp));
> > -			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
> > +			error = xfs_rtbuf_get(mp, tp, ++block, 0, rtbufc, &bp);
> >  			if (error) {
> >  				return error;
> >  			}
> > @@ -640,7 +644,7 @@ xfs_rtmodify_range(
> >  			xfs_trans_log_buf(tp, bp,
> >  				(uint)((char *)first - (char *)bufp),
> >  				(uint)((char *)b - (char *)bufp));
> > -			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
> > +			error = xfs_rtbuf_get(mp, tp, ++block, 0, rtbufc, &bp);
> >  			if (error) {
> >  				return error;
> >  			}
> > @@ -690,8 +694,7 @@ xfs_rtfree_range(
> >  	xfs_trans_t	*tp,		/* transaction pointer */
> >  	xfs_rtblock_t	start,		/* starting block to free */
> >  	xfs_extlen_t	len,		/* length to free */
> > -	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
> > -	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
> > +	struct xfs_rtbuf_cache *rtbufc)	/* in/out: cache of realtime blocks */
> >  {
> >  	xfs_rtblock_t	end;		/* end of the freed extent */
> >  	int		error;		/* error value */
> > @@ -702,7 +705,7 @@ xfs_rtfree_range(
> >  	/*
> >  	 * Modify the bitmap to mark this extent freed.
> >  	 */
> > -	error = xfs_rtmodify_range(mp, tp, start, len, 1);
> > +	error = xfs_rtmodify_range(mp, tp, start, len, 1, rtbufc);
> >  	if (error) {
> >  		return error;
> >  	}
> > @@ -711,7 +714,7 @@ xfs_rtfree_range(
> >  	 * We need to find the beginning and end of the extent so we can
> >  	 * properly update the summary.
> >  	 */
> > -	error = xfs_rtfind_back(mp, tp, start, 0, &preblock);
> > +	error = xfs_rtfind_back(mp, tp, start, 0, rtbufc, &preblock);
> >  	if (error) {
> >  		return error;
> >  	}
> > @@ -719,7 +722,7 @@ xfs_rtfree_range(
> >  	 * Find the next allocated block (end of allocated extent).
> >  	 */
> >  	error = xfs_rtfind_forw(mp, tp, end, mp->m_sb.sb_rextents - 1,
> > -		&postblock);
> > +		rtbufc, &postblock);
> >  	if (error)
> >  		return error;
> >  	/*
> > @@ -729,7 +732,7 @@ xfs_rtfree_range(
> >  	if (preblock < start) {
> >  		error = xfs_rtmodify_summary(mp, tp,
> >  			XFS_RTBLOCKLOG(start - preblock),
> > -			XFS_BITTOBLOCK(mp, preblock), -1, rbpp, rsb);
> > +			XFS_BITTOBLOCK(mp, preblock), -1, rtbufc);
> >  		if (error) {
> >  			return error;
> >  		}
> > @@ -741,7 +744,7 @@ xfs_rtfree_range(
> >  	if (postblock > end) {
> >  		error = xfs_rtmodify_summary(mp, tp,
> >  			XFS_RTBLOCKLOG(postblock - end),
> > -			XFS_BITTOBLOCK(mp, end + 1), -1, rbpp, rsb);
> > +			XFS_BITTOBLOCK(mp, end + 1), -1, rtbufc);
> >  		if (error) {
> >  			return error;
> >  		}
> > @@ -752,7 +755,7 @@ xfs_rtfree_range(
> >  	 */
> >  	error = xfs_rtmodify_summary(mp, tp,
> >  		XFS_RTBLOCKLOG(postblock + 1 - preblock),
> > -		XFS_BITTOBLOCK(mp, preblock), 1, rbpp, rsb);
> > +		XFS_BITTOBLOCK(mp, preblock), 1, rtbufc);
> >  	return error;
> >  }
> >  
> > @@ -767,6 +770,7 @@ xfs_rtcheck_range(
> >  	xfs_rtblock_t	start,		/* starting block number of extent */
> >  	xfs_extlen_t	len,		/* length of extent */
> >  	int		val,		/* 1 for free, 0 for allocated */
> > +	struct xfs_rtbuf_cache *rtbufc,	/* in/out: cache of realtime blocks */
> >  	xfs_rtblock_t	*new,		/* out: first block not matching */
> >  	int		*stat)		/* out: 1 for matches, 0 for not */
> >  {
> > @@ -789,7 +793,7 @@ xfs_rtcheck_range(
> >  	/*
> >  	 * Read the bitmap block.
> >  	 */
> > -	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
> > +	error = xfs_rtbuf_get(mp, tp, block, 0, rtbufc, &bp);
> >  	if (error) {
> >  		return error;
> >  	}
> > @@ -824,7 +828,6 @@ xfs_rtcheck_range(
> >  			/*
> >  			 * Different, compute first wrong bit and return.
> >  			 */
> > -			xfs_trans_brelse(tp, bp);
> >  			i = XFS_RTLOBIT(wdiff) - bit;
> >  			*new = start + i;
> >  			*stat = 0;
> > @@ -839,8 +842,7 @@ xfs_rtcheck_range(
> >  			/*
> >  			 * If done with this block, get the next one.
> >  			 */
> > -			xfs_trans_brelse(tp, bp);
> > -			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
> > +			error = xfs_rtbuf_get(mp, tp, ++block, 0, rtbufc, &bp);
> >  			if (error) {
> >  				return error;
> >  			}
> > @@ -870,7 +872,6 @@ xfs_rtcheck_range(
> >  			/*
> >  			 * Different, compute first wrong bit and return.
> >  			 */
> > -			xfs_trans_brelse(tp, bp);
> >  			i += XFS_RTLOBIT(wdiff);
> >  			*new = start + i;
> >  			*stat = 0;
> > @@ -885,8 +886,7 @@ xfs_rtcheck_range(
> >  			/*
> >  			 * If done with this block, get the next one.
> >  			 */
> > -			xfs_trans_brelse(tp, bp);
> > -			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
> > +			error = xfs_rtbuf_get(mp, tp, ++block, 0, rtbufc, &bp);
> >  			if (error) {
> >  				return error;
> >  			}
> > @@ -915,7 +915,6 @@ xfs_rtcheck_range(
> >  			/*
> >  			 * Different, compute first wrong bit and return.
> >  			 */
> > -			xfs_trans_brelse(tp, bp);
> >  			i += XFS_RTLOBIT(wdiff);
> >  			*new = start + i;
> >  			*stat = 0;
> > @@ -926,7 +925,6 @@ xfs_rtcheck_range(
> >  	/*
> >  	 * Successful, return.
> >  	 */
> > -	xfs_trans_brelse(tp, bp);
> >  	*new = start + i;
> >  	*stat = 1;
> >  	return 0;
> > @@ -941,20 +939,21 @@ xfs_rtcheck_alloc_range(
> >  	xfs_mount_t	*mp,		/* file system mount point */
> >  	xfs_trans_t	*tp,		/* transaction pointer */
> >  	xfs_rtblock_t	bno,		/* starting block number of extent */
> > -	xfs_extlen_t	len)		/* length of extent */
> > +	xfs_extlen_t	len,		/* length of extent */
> > +	struct xfs_rtbuf_cache *rtbufc)	/* in/out: cached blocks */
> >  {
> >  	xfs_rtblock_t	new;		/* dummy for xfs_rtcheck_range */
> >  	int		stat;
> >  	int		error;
> >  
> > -	error = xfs_rtcheck_range(mp, tp, bno, len, 0, &new, &stat);
> > +	error = xfs_rtcheck_range(mp, tp, bno, len, 0, rtbufc, &new, &stat);
> >  	if (error)
> >  		return error;
> >  	ASSERT(stat);
> >  	return 0;
> >  }
> >  #else
> > -#define xfs_rtcheck_alloc_range(m,t,b,l)	(0)
> > +#define xfs_rtcheck_alloc_range(m,t,b,l,r)	(0)
> >  #endif
> >  /*
> >   * Free an extent in the realtime subvolume.  Length is expressed in
> > @@ -968,22 +967,21 @@ xfs_rtfree_extent(
> >  {
> >  	int		error;		/* error value */
> >  	xfs_mount_t	*mp;		/* file system mount structure */
> > -	xfs_fsblock_t	sb;		/* summary file block number */
> > -	struct xfs_buf	*sumbp = NULL;	/* summary file block buffer */
> > +	struct xfs_rtbuf_cache rtbufc = {}; /* cache of realtime blocks */
> >  
> >  	mp = tp->t_mountp;
> >  
> >  	ASSERT(mp->m_rbmip->i_itemp != NULL);
> >  	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
> >  
> > -	error = xfs_rtcheck_alloc_range(mp, tp, bno, len);
> > +	error = xfs_rtcheck_alloc_range(mp, tp, bno, len, &rtbufc);
> >  	if (error)
> >  		return error;
> >  
> >  	/*
> >  	 * Free the range of realtime blocks.
> >  	 */
> > -	error = xfs_rtfree_range(mp, tp, bno, len, &sumbp, &sb);
> > +	error = xfs_rtfree_range(mp, tp, bno, len, &rtbufc);
> >  	if (error) {
> >  		return error;
> >  	}
> > @@ -1021,6 +1019,7 @@ xfs_rtalloc_query_range(
> >  	xfs_rtblock_t			high_key;
> >  	int				is_free;
> >  	int				error = 0;
> > +	struct xfs_rtbuf_cache		rtbufc = {};
> >  
> >  	if (low_rec->ar_startext > high_rec->ar_startext)
> >  		return -EINVAL;
> > @@ -1034,13 +1033,14 @@ xfs_rtalloc_query_range(
> >  	rtstart = low_rec->ar_startext;
> >  	while (rtstart <= high_key) {
> >  		/* Is the first block free? */
> > -		error = xfs_rtcheck_range(mp, tp, rtstart, 1, 1, &rtend,
> > -				&is_free);
> > +		error = xfs_rtcheck_range(mp, tp, rtstart, 1, 1, &rtbufc,
> > +				&rtend, &is_free);
> >  		if (error)
> >  			break;
> >  
> >  		/* How long does the extent go for? */
> > -		error = xfs_rtfind_forw(mp, tp, rtstart, high_key, &rtend);
> > +		error = xfs_rtfind_forw(mp, tp, rtstart, high_key, &rtbufc,
> > +					&rtend);
> >  		if (error)
> >  			break;
> >  
> > @@ -1056,6 +1056,8 @@ xfs_rtalloc_query_range(
> >  		rtstart = rtend + 1;
> >  	}
> >  
> > +	xfs_rtbuf_cache_relse(tp, &rtbufc);
> > +
> >  	return error;
> >  }
> >  
> > @@ -1085,11 +1087,14 @@ xfs_rtalloc_extent_is_free(
> >  	xfs_extlen_t			len,
> >  	bool				*is_free)
> >  {
> > +	struct xfs_rtbuf_cache		rtbufc = {};
> >  	xfs_rtblock_t			end;
> >  	int				matches;
> >  	int				error;
> >  
> > -	error = xfs_rtcheck_range(mp, tp, start, len, 1, &end, &matches);
> > +	error = xfs_rtcheck_range(mp, tp, start, len, 1, &rtbufc, &end,
> > +				  &matches);
> > +	xfs_rtbuf_cache_relse(tp, &rtbufc);
> >  	if (error)
> >  		return error;
> >  
> > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > index 16534e9873f6..61ef13286654 100644
> > --- a/fs/xfs/xfs_rtalloc.c
> > +++ b/fs/xfs/xfs_rtalloc.c
> > @@ -32,11 +32,10 @@ xfs_rtget_summary(
> >  	xfs_trans_t	*tp,		/* transaction pointer */
> >  	int		log,		/* log2 of extent size */
> >  	xfs_rtblock_t	bbno,		/* bitmap block number */
> > -	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
> > -	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
> > +	struct xfs_rtbuf_cache *rtbufc,	/* in/out: cache of realtime blocks */
> >  	xfs_suminfo_t	*sum)		/* out: summary info for this block */
> >  {
> > -	return xfs_rtmodify_summary_int(mp, tp, log, bbno, 0, rbpp, rsb, sum);
> > +	return xfs_rtmodify_summary_int(mp, tp, log, bbno, 0, rtbufc, sum);
> >  }
> >  
> >  /*
> > @@ -50,8 +49,7 @@ xfs_rtany_summary(
> >  	int		low,		/* low log2 extent size */
> >  	int		high,		/* high log2 extent size */
> >  	xfs_rtblock_t	bbno,		/* bitmap block number */
> > -	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
> > -	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
> > +	struct xfs_rtbuf_cache *rtbufc,	/* in/out: cache of realtime blocks */
> >  	int		*stat)		/* out: any good extents here? */
> >  {
> >  	int		error;		/* error value */
> > @@ -69,7 +67,7 @@ xfs_rtany_summary(
> >  		/*
> >  		 * Get one summary datum.
> >  		 */
> > -		error = xfs_rtget_summary(mp, tp, log, bbno, rbpp, rsb, &sum);
> > +		error = xfs_rtget_summary(mp, tp, log, bbno, rtbufc, &sum);
> >  		if (error) {
> >  			return error;
> >  		}
> > @@ -104,29 +102,27 @@ xfs_rtcopy_summary(
> >  	xfs_trans_t	*tp)		/* transaction pointer */
> >  {
> >  	xfs_rtblock_t	bbno;		/* bitmap block number */
> > -	struct xfs_buf	*bp;		/* summary buffer */
> > +	struct xfs_rtbuf_cache rtbufc = {}; /* cache of realtime blocks */
> >  	int		error;		/* error return value */
> >  	int		log;		/* summary level number (log length) */
> >  	xfs_suminfo_t	sum;		/* summary data */
> > -	xfs_fsblock_t	sumbno;		/* summary block number */
> >  
> > -	bp = NULL;
> >  	for (log = omp->m_rsumlevels - 1; log >= 0; log--) {
> >  		for (bbno = omp->m_sb.sb_rbmblocks - 1;
> >  		     (xfs_srtblock_t)bbno >= 0;
> >  		     bbno--) {
> > -			error = xfs_rtget_summary(omp, tp, log, bbno, &bp,
> > -				&sumbno, &sum);
> > +			error = xfs_rtget_summary(omp, tp, log, bbno, &rtbufc,
> > +				&sum);
> >  			if (error)
> >  				return error;
> >  			if (sum == 0)
> >  				continue;
> >  			error = xfs_rtmodify_summary(omp, tp, log, bbno, -sum,
> > -				&bp, &sumbno);
> > +				&rtbufc);
> >  			if (error)
> >  				return error;
> >  			error = xfs_rtmodify_summary(nmp, tp, log, bbno, sum,
> > -				&bp, &sumbno);
> > +				&rtbufc);
> >  			if (error)
> >  				return error;
> >  			ASSERT(sum > 0);
> > @@ -144,8 +140,7 @@ xfs_rtallocate_range(
> >  	xfs_trans_t	*tp,		/* transaction pointer */
> >  	xfs_rtblock_t	start,		/* start block to allocate */
> >  	xfs_extlen_t	len,		/* length to allocate */
> > -	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
> > -	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
> > +	struct xfs_rtbuf_cache *rtbufc)	/* in/out: cache of realtime blocks */
> >  {
> >  	xfs_rtblock_t	end;		/* end of the allocated extent */
> >  	int		error;		/* error value */
> > @@ -158,14 +153,14 @@ xfs_rtallocate_range(
> >  	 * We need to find the beginning and end of the extent so we can
> >  	 * properly update the summary.
> >  	 */
> > -	error = xfs_rtfind_back(mp, tp, start, 0, &preblock);
> > +	error = xfs_rtfind_back(mp, tp, start, 0, rtbufc, &preblock);
> >  	if (error) {
> >  		return error;
> >  	}
> >  	/*
> >  	 * Find the next allocated block (end of free extent).
> >  	 */
> > -	error = xfs_rtfind_forw(mp, tp, end, mp->m_sb.sb_rextents - 1,
> > +	error = xfs_rtfind_forw(mp, tp, end, mp->m_sb.sb_rextents - 1, rtbufc,
> >  		&postblock);
> >  	if (error) {
> >  		return error;
> > @@ -176,7 +171,7 @@ xfs_rtallocate_range(
> >  	 */
> >  	error = xfs_rtmodify_summary(mp, tp,
> >  		XFS_RTBLOCKLOG(postblock + 1 - preblock),
> > -		XFS_BITTOBLOCK(mp, preblock), -1, rbpp, rsb);
> > +		XFS_BITTOBLOCK(mp, preblock), -1, rtbufc);
> >  	if (error) {
> >  		return error;
> >  	}
> > @@ -187,7 +182,7 @@ xfs_rtallocate_range(
> >  	if (preblock < start) {
> >  		error = xfs_rtmodify_summary(mp, tp,
> >  			XFS_RTBLOCKLOG(start - preblock),
> > -			XFS_BITTOBLOCK(mp, preblock), 1, rbpp, rsb);
> > +			XFS_BITTOBLOCK(mp, preblock), 1, rtbufc);
> >  		if (error) {
> >  			return error;
> >  		}
> > @@ -199,7 +194,7 @@ xfs_rtallocate_range(
> >  	if (postblock > end) {
> >  		error = xfs_rtmodify_summary(mp, tp,
> >  			XFS_RTBLOCKLOG(postblock - end),
> > -			XFS_BITTOBLOCK(mp, end + 1), 1, rbpp, rsb);
> > +			XFS_BITTOBLOCK(mp, end + 1), 1, rtbufc);
> >  		if (error) {
> >  			return error;
> >  		}
> > @@ -207,7 +202,7 @@ xfs_rtallocate_range(
> >  	/*
> >  	 * Modify the bitmap to mark this extent allocated.
> >  	 */
> > -	error = xfs_rtmodify_range(mp, tp, start, len, 0);
> > +	error = xfs_rtmodify_range(mp, tp, start, len, 0, rtbufc);
> >  	return error;
> >  }
> >  
> > @@ -226,8 +221,7 @@ xfs_rtallocate_extent_block(
> >  	xfs_extlen_t	maxlen,		/* maximum length to allocate */
> >  	xfs_extlen_t	*len,		/* out: actual length allocated */
> >  	xfs_rtblock_t	*nextp,		/* out: next block to try */
> > -	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
> > -	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
> > +	struct xfs_rtbuf_cache *rtbufc,	/* in/out: cache of realtime blocks */
> >  	xfs_extlen_t	prod,		/* extent product factor */
> >  	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
> >  {
> > @@ -254,7 +248,8 @@ xfs_rtallocate_extent_block(
> >  		 * See if there's a free extent of maxlen starting at i.
> >  		 * If it's not so then next will contain the first non-free.
> >  		 */
> > -		error = xfs_rtcheck_range(mp, tp, i, maxlen, 1, &next, &stat);
> > +		error = xfs_rtcheck_range(mp, tp, i, maxlen, 1, rtbufc, &next,
> > +					  &stat);
> >  		if (error) {
> >  			return error;
> >  		}
> > @@ -262,8 +257,7 @@ xfs_rtallocate_extent_block(
> >  			/*
> >  			 * i for maxlen is all free, allocate and return that.
> >  			 */
> > -			error = xfs_rtallocate_range(mp, tp, i, maxlen, rbpp,
> > -				rsb);
> > +			error = xfs_rtallocate_range(mp, tp, i, maxlen, rtbufc);
> >  			if (error) {
> >  				return error;
> >  			}
> > @@ -290,7 +284,7 @@ xfs_rtallocate_extent_block(
> >  		 * If not done yet, find the start of the next free space.
> >  		 */
> >  		if (next < end) {
> > -			error = xfs_rtfind_forw(mp, tp, next, end, &i);
> > +			error = xfs_rtfind_forw(mp, tp, next, end, rtbufc, &i);
> >  			if (error) {
> >  				return error;
> >  			}
> > @@ -315,7 +309,7 @@ xfs_rtallocate_extent_block(
> >  		/*
> >  		 * Allocate besti for bestlen & return that.
> >  		 */
> > -		error = xfs_rtallocate_range(mp, tp, besti, bestlen, rbpp, rsb);
> > +		error = xfs_rtallocate_range(mp, tp, besti, bestlen, rtbufc);
> >  		if (error) {
> >  			return error;
> >  		}
> > @@ -344,9 +338,8 @@ xfs_rtallocate_extent_exact(
> >  	xfs_rtblock_t	bno,		/* starting block number to allocate */
> >  	xfs_extlen_t	minlen,		/* minimum length to allocate */
> >  	xfs_extlen_t	maxlen,		/* maximum length to allocate */
> > +	struct xfs_rtbuf_cache *rtbufc,	/* in/out: cache of realtime blocks */
> >  	xfs_extlen_t	*len,		/* out: actual length allocated */
> > -	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
> > -	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
> >  	xfs_extlen_t	prod,		/* extent product factor */
> >  	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
> >  {
> > @@ -359,7 +352,8 @@ xfs_rtallocate_extent_exact(
> >  	/*
> >  	 * Check if the range in question (for maxlen) is free.
> >  	 */
> > -	error = xfs_rtcheck_range(mp, tp, bno, maxlen, 1, &next, &isfree);
> > +	error = xfs_rtcheck_range(mp, tp, bno, maxlen, 1, rtbufc, &next,
> > +				  &isfree);
> >  	if (error) {
> >  		return error;
> >  	}
> > @@ -367,7 +361,7 @@ xfs_rtallocate_extent_exact(
> >  		/*
> >  		 * If it is, allocate it and return success.
> >  		 */
> > -		error = xfs_rtallocate_range(mp, tp, bno, maxlen, rbpp, rsb);
> > +		error = xfs_rtallocate_range(mp, tp, bno, maxlen, rtbufc);
> >  		if (error) {
> >  			return error;
> >  		}
> > @@ -402,7 +396,7 @@ xfs_rtallocate_extent_exact(
> >  	/*
> >  	 * Allocate what we can and return it.
> >  	 */
> > -	error = xfs_rtallocate_range(mp, tp, bno, maxlen, rbpp, rsb);
> > +	error = xfs_rtallocate_range(mp, tp, bno, maxlen, rtbufc);
> >  	if (error) {
> >  		return error;
> >  	}
> > @@ -424,8 +418,7 @@ xfs_rtallocate_extent_near(
> >  	xfs_extlen_t	minlen,		/* minimum length to allocate */
> >  	xfs_extlen_t	maxlen,		/* maximum length to allocate */
> >  	xfs_extlen_t	*len,		/* out: actual length allocated */
> > -	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
> > -	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
> > +	struct xfs_rtbuf_cache *rtbufc,	/* in/out: cache of realtime blocks */
> >  	xfs_extlen_t	prod,		/* extent product factor */
> >  	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
> >  {
> > @@ -456,8 +449,8 @@ xfs_rtallocate_extent_near(
> >  	/*
> >  	 * Try the exact allocation first.
> >  	 */
> > -	error = xfs_rtallocate_extent_exact(mp, tp, bno, minlen, maxlen, len,
> > -		rbpp, rsb, prod, &r);
> > +	error = xfs_rtallocate_extent_exact(mp, tp, bno, minlen, maxlen, rtbufc,
> > +		len, prod, &r);
> >  	if (error) {
> >  		return error;
> >  	}
> > @@ -481,7 +474,7 @@ xfs_rtallocate_extent_near(
> >  		 * starting in this bitmap block.
> >  		 */
> >  		error = xfs_rtany_summary(mp, tp, log2len, mp->m_rsumlevels - 1,
> > -			bbno + i, rbpp, rsb, &any);
> > +			bbno + i, rtbufc, &any);
> >  		if (error) {
> >  			return error;
> >  		}
> > @@ -499,8 +492,8 @@ xfs_rtallocate_extent_near(
> >  				 * this block.
> >  				 */
> >  				error = xfs_rtallocate_extent_block(mp, tp,
> > -					bbno + i, minlen, maxlen, len, &n, rbpp,
> > -					rsb, prod, &r);
> > +					bbno + i, minlen, maxlen, len, &n,
> > +					rtbufc, prod, &r);
> >  				if (error) {
> >  					return error;
> >  				}
> > @@ -529,7 +522,7 @@ xfs_rtallocate_extent_near(
> >  					 */
> >  					error = xfs_rtany_summary(mp, tp,
> >  						log2len, mp->m_rsumlevels - 1,
> > -						bbno + j, rbpp, rsb, &any);
> > +						bbno + j, rtbufc, &any);
> >  					if (error) {
> >  						return error;
> >  					}
> > @@ -545,7 +538,7 @@ xfs_rtallocate_extent_near(
> >  						continue;
> >  					error = xfs_rtallocate_extent_block(mp,
> >  						tp, bbno + j, minlen, maxlen,
> > -						len, &n, rbpp, rsb, prod, &r);
> > +						len, &n, rtbufc, prod, &r);
> >  					if (error) {
> >  						return error;
> >  					}
> > @@ -566,8 +559,8 @@ xfs_rtallocate_extent_near(
> >  				 * that we found.
> >  				 */
> >  				error = xfs_rtallocate_extent_block(mp, tp,
> > -					bbno + i, minlen, maxlen, len, &n, rbpp,
> > -					rsb, prod, &r);
> > +					bbno + i, minlen, maxlen, len, &n,
> > +					rtbufc, prod, &r);
> >  				if (error) {
> >  					return error;
> >  				}
> > @@ -626,8 +619,7 @@ xfs_rtallocate_extent_size(
> >  	xfs_extlen_t	minlen,		/* minimum length to allocate */
> >  	xfs_extlen_t	maxlen,		/* maximum length to allocate */
> >  	xfs_extlen_t	*len,		/* out: actual length allocated */
> > -	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
> > -	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
> > +	struct xfs_rtbuf_cache *rtbufc,	/* in/out: cache of realtime blocks */
> >  	xfs_extlen_t	prod,		/* extent product factor */
> >  	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
> >  {
> > @@ -656,7 +648,7 @@ xfs_rtallocate_extent_size(
> >  			/*
> >  			 * Get the summary for this level/block.
> >  			 */
> > -			error = xfs_rtget_summary(mp, tp, l, i, rbpp, rsb,
> > +			error = xfs_rtget_summary(mp, tp, l, i, rtbufc,
> >  				&sum);
> >  			if (error) {
> >  				return error;
> > @@ -670,7 +662,7 @@ xfs_rtallocate_extent_size(
> >  			 * Try allocating the extent.
> >  			 */
> >  			error = xfs_rtallocate_extent_block(mp, tp, i, maxlen,
> > -				maxlen, len, &n, rbpp, rsb, prod, &r);
> > +				maxlen, len, &n, rtbufc, prod, &r);
> >  			if (error) {
> >  				return error;
> >  			}
> > @@ -715,7 +707,7 @@ xfs_rtallocate_extent_size(
> >  			/*
> >  			 * Get the summary information for this level/block.
> >  			 */
> > -			error =	xfs_rtget_summary(mp, tp, l, i, rbpp, rsb,
> > +			error =	xfs_rtget_summary(mp, tp, l, i, rtbufc,
> >  						  &sum);
> >  			if (error) {
> >  				return error;
> > @@ -733,7 +725,7 @@ xfs_rtallocate_extent_size(
> >  			error = xfs_rtallocate_extent_block(mp, tp, i,
> >  					XFS_RTMAX(minlen, 1 << l),
> >  					XFS_RTMIN(maxlen, (1 << (l + 1)) - 1),
> > -					len, &n, rbpp, rsb, prod, &r);
> > +					len, &n, rtbufc, prod, &r);
> >  			if (error) {
> >  				return error;
> >  			}
> > @@ -922,7 +914,6 @@ xfs_growfs_rt(
> >  	xfs_extlen_t	rbmblocks;	/* current number of rt bitmap blocks */
> >  	xfs_extlen_t	rsumblocks;	/* current number of rt summary blks */
> >  	xfs_sb_t	*sbp;		/* old superblock */
> > -	xfs_fsblock_t	sumbno;		/* summary block number */
> >  	uint8_t		*rsum_cache;	/* old summary cache */
> >  
> >  	sbp = &mp->m_sb;
> > @@ -1025,6 +1016,7 @@ xfs_growfs_rt(
> >  	     bmbno++) {
> >  		struct xfs_trans	*tp;
> >  		xfs_rfsblock_t		nrblocks_step;
> > +		struct xfs_rtbuf_cache rtbufc = {}; /* cache of realtime blocks */
> >  
> >  		*nmp = *mp;
> >  		nsbp = &nmp->m_sb;
> > @@ -1111,9 +1103,8 @@ xfs_growfs_rt(
> >  		/*
> >  		 * Free new extent.
> >  		 */
> > -		bp = NULL;
> >  		error = xfs_rtfree_range(nmp, tp, sbp->sb_rextents,
> > -			nsbp->sb_rextents - sbp->sb_rextents, &bp, &sumbno);
> > +			nsbp->sb_rextents - sbp->sb_rextents, &rtbufc);
> >  		if (error) {
> >  error_cancel:
> >  			xfs_trans_cancel(tp);
> > @@ -1185,8 +1176,7 @@ xfs_rtallocate_extent(
> >  	xfs_mount_t	*mp = tp->t_mountp;
> >  	int		error;		/* error value */
> >  	xfs_rtblock_t	r;		/* result allocated block */
> > -	xfs_fsblock_t	sb;		/* summary file block number */
> > -	struct xfs_buf	*sumbp;		/* summary file block buffer */
> > +	struct xfs_rtbuf_cache rtbufc = {}; /* cache of realtime blocks */
> >  
> >  	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
> >  	ASSERT(minlen > 0 && minlen <= maxlen);
> > @@ -1208,13 +1198,14 @@ xfs_rtallocate_extent(
> >  	}
> >  
> >  retry:
> > -	sumbp = NULL;
> > +	rtbufc.bbuf = NULL;
> > +	rtbufc.sbuf = NULL;
> 
> xfs_rtbuf_cache_relse?

In this case, the cached blocks have been dirtied and attached to the
transaction, so it's not strictly necessary (which is also why the old
code didn't call xfs_trans_brelse()). But it's probably clearer to just
use xfs_rtbuf_cache_relse() anyways rather than needing to justify that.

> >  	if (bno == 0) {
> >  		error = xfs_rtallocate_extent_size(mp, tp, minlen, maxlen, len,
> > -				&sumbp,	&sb, prod, &r);
> > +				&rtbufc, prod, &r);
> >  	} else {
> >  		error = xfs_rtallocate_extent_near(mp, tp, bno, minlen, maxlen,
> > -				len, &sumbp, &sb, prod, &r);
> > +				len, &rtbufc, prod, &r);
> >  	}
> >  
> >  	if (error)
> > diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
> > index 62c7ad79cbb6..888552c4f287 100644
> > --- a/fs/xfs/xfs_rtalloc.h
> > +++ b/fs/xfs/xfs_rtalloc.h
> > @@ -101,29 +101,39 @@ xfs_growfs_rt(
> >  /*
> >   * From xfs_rtbitmap.c
> >   */
> > +struct xfs_rtbuf_cache {
> > +	struct xfs_buf *bbuf;	/* bitmap block buffer */
> > +	xfs_fsblock_t bblock;	/* bitmap block number */
> > +	struct xfs_buf *sbuf;	/* summary block buffer */
> > +	xfs_fsblock_t sblock;	/* summary block number */
> 
> These are really offsets into the data fork, right?  They ought to be
> xfs_fileoff_t, except that none of the rtalloc code uses the correct
> type?

Yup, once again I was mimicking the surrounding code. I can fix it here.

Thanks!

> And yes I do want to merge the fixes for that:
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=clean-up-realtime-units
> 
> --D
> 
> > +};
> > +
> >  int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
> > -		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
> > +		  xfs_rtblock_t block, int issum, struct xfs_rtbuf_cache *cache,
> > +		  struct xfs_buf **bpp);
> >  int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
> >  		      xfs_rtblock_t start, xfs_extlen_t len, int val,
> > -		      xfs_rtblock_t *new, int *stat);
> > +		      struct xfs_rtbuf_cache *rtbufc, xfs_rtblock_t *new,
> > +		      int *stat);
> >  int xfs_rtfind_back(struct xfs_mount *mp, struct xfs_trans *tp,
> >  		    xfs_rtblock_t start, xfs_rtblock_t limit,
> > -		    xfs_rtblock_t *rtblock);
> > +		    struct xfs_rtbuf_cache *rtbufc, xfs_rtblock_t *rtblock);
> >  int xfs_rtfind_forw(struct xfs_mount *mp, struct xfs_trans *tp,
> >  		    xfs_rtblock_t start, xfs_rtblock_t limit,
> > -		    xfs_rtblock_t *rtblock);
> > +		    struct xfs_rtbuf_cache *rtbufc, xfs_rtblock_t *rtblock);
> >  int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
> > -		       xfs_rtblock_t start, xfs_extlen_t len, int val);
> > +		       xfs_rtblock_t start, xfs_extlen_t len, int val,
> > +		       struct xfs_rtbuf_cache *rtbufc);
> >  int xfs_rtmodify_summary_int(struct xfs_mount *mp, struct xfs_trans *tp,
> >  			     int log, xfs_rtblock_t bbno, int delta,
> > -			     struct xfs_buf **rbpp, xfs_fsblock_t *rsb,
> > +			     struct xfs_rtbuf_cache *rtbufc,
> >  			     xfs_suminfo_t *sum);
> >  int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
> > -			 xfs_rtblock_t bbno, int delta, struct xfs_buf **rbpp,
> > -			 xfs_fsblock_t *rsb);
> > +			 xfs_rtblock_t bbno, int delta,
> > +			 struct xfs_rtbuf_cache *rtbufc);
> >  int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
> >  		     xfs_rtblock_t start, xfs_extlen_t len,
> > -		     struct xfs_buf **rbpp, xfs_fsblock_t *rsb);
> > +		     struct xfs_rtbuf_cache *rtbufc);
> >  int xfs_rtalloc_query_range(struct xfs_mount *mp, struct xfs_trans *tp,
> >  		const struct xfs_rtalloc_rec *low_rec,
> >  		const struct xfs_rtalloc_rec *high_rec,
> > -- 
> > 2.41.0
> > 
