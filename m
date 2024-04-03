Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060E315699F
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 23:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712186125; cv=none; b=W/yjgoklgfFUGvTNtOPjMVZ5TajZYnrHMIyg63zA9uQqhuzpg0G4pulv+fgQXzQfIitJZHrWi+Lm5vciav2+MlXh9ZHkv25Bn3FCWpd+nZWOkJERZRR/ret54k9/1PmtYNsp0Y35ySUXR7BDIzqYhaxg2upZlUIpJjzCuyasxPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712186125; c=relaxed/simple;
	bh=6e52w9bCYb+qgVvx2CyEycbs1XCV+apmErwH+zwML80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ohB2QTawicqphQR15Oi4PzqnUoFhtyHyA5vz1WwJIS48AD1b5VH+g4q7ct5BtdHswLNyCe1o8tZvqT1YIesZvWOBlpK/RCqPmNpf2x7gVwLTabN08F47nFb4L94XEYHQEjnDtHFtTKwO/nmZ1wmZogmbkXu98GxqiEdsUsdsWqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=1C8coHrK; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="1C8coHrK"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-5d8b887bb0cso344527a12.2
        for <linux-xfs@vger.kernel.org>; Wed, 03 Apr 2024 16:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712186123; x=1712790923; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ib0bAIhOeCoy3CFTfaIo9pNnyR1MPTcviylAdI/fI2A=;
        b=1C8coHrK2LFuGGrmoNIyEfPkJbIqRNYKDJG3GHXdLFLw6W8ycj4pWfd2Vu+tq8MZgi
         wa6kjB3GRV8iWpuYgkLCKKQQd7ZfoVj6HtboJas45sUIVsfds+x8YWwgYa9XQ+wKb+ii
         z5u8hBMybFu6nvdu53BwvbPmiTHpLVWvSjGrqEaK4croRLmdjuwQ2IjRtf33huDmp7fD
         5E3rlFyZQ89KqR9gvo4INf8K8gyEK5Ejx1qEdonXGhCrccei0Mx5xbPNow1wzqisOigJ
         C/v9vfC77tzT/Keke6QAQow8+i85Ub3DJ1F4VHL5+VjTFje0BOHyH0cMQAxfSQEODhns
         FolQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712186123; x=1712790923;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ib0bAIhOeCoy3CFTfaIo9pNnyR1MPTcviylAdI/fI2A=;
        b=kzN2xGiTLc87cYj9+FRcSk7XlX3TdKqj1gzHdNaZSUcEzdzHvIGzGdKNKyy8dC8v+2
         2fRYOTpcwP2rtuo5XLVYJzlzKAHD9iF63Ego0UoqhZAXTME1ibpnKS1NmI+X/XxzCeuK
         zX1KfI1UwXMIjweJmMZrjylDbcwZi8K7BwRl1nuQhgffGaLRU1aGU1FOU9RNRufbNKgT
         IYePwcWk8oxIa0KJSzRI22xlC8FMhtZmkkHI2u/njNOTtCKXYcGQCyxXfs6UcVALGU01
         LNU+tT+h1LQ+KIhe4QrkdKQLzY2P54xI/t4OZK8pKxriO7WwSt+8CA74O1LnrpfZpAgr
         mxgg==
X-Gm-Message-State: AOJu0YylR4soSSuZOMo8xZMoHPcgqKf7nd3JGN7gfGEiaduV6aaeFAN5
	ybckH7gjdwjMNs3B81+aWstM1i4n769hTLF0aDR8ipXfwx4Hjky785I8QaGTEQInzVVupskcfLU
	+
X-Google-Smtp-Source: AGHT+IGMHs3Gu6xxjd5l6dE/L5/NmaTEArU5AC6otoDgPLEA38pXx7fkTKxumsYiFz6PQhZDuzIIuw==
X-Received: by 2002:a17:90a:bb17:b0:2a2:c127:5aed with SMTP id u23-20020a17090abb1700b002a2c1275aedmr1141460pjr.0.1712186122967;
        Wed, 03 Apr 2024 16:15:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id x16-20020a17090a8a9000b002a28d18a144sm250203pjn.19.2024.04.03.16.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Apr 2024 16:15:22 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rs9p9-0032yR-1w;
	Thu, 04 Apr 2024 10:15:19 +1100
Date: Thu, 4 Apr 2024 10:15:19 +1100
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: only allow minlen allocations when near ENOSPC
Message-ID: <Zg3jBwIfZ1HVm8aV@dread.disaster.area>
References: <20240402233006.1210262-1-david@fromorbit.com>
 <20240402233006.1210262-2-david@fromorbit.com>
 <c515119e-5f0e-41ba-8bde-ae9f6283b3d8@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c515119e-5f0e-41ba-8bde-ae9f6283b3d8@oracle.com>

On Wed, Apr 03, 2024 at 05:31:49PM +0100, John Garry wrote:
> On 03/04/2024 00:28, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When we are near ENOSPC and don't have enough free
> > space for an args->maxlen allocation, xfs_alloc_space_available()
> > will trim args->maxlen to equal the available space. However, this
> > function has only checked that there is enough contiguous free space
> > for an aligned args->minlen allocation to succeed. Hence there is no
> > guarantee that an args->maxlen allocation will succeed, nor that the
> > available space will allow for correct alignment of an args->maxlen
> > allocation.
> > 
> > Further, by trimming args->maxlen arbitrarily, it breaks an
> > assumption made in xfs_alloc_fix_len() that if the caller wants
> > aligned allocation, then args->maxlen will be set to an aligned
> > value. It then skips the tail alignment and so we end up with
> > extents that aren't aligned to extent size hint boundaries as we
> > approach ENOSPC.
> > 
> > To avoid this problem, don't reduce args->maxlen by some random,
> > arbitrary amount. If args->maxlen is too large for the available
> > space, reduce the allocation to a minlen allocation as we know we
> > have contiguous free space available for this to succeed and always
> > be correctly aligned.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> This change seems to cause or at least expose a problem for me - I say that
> because it is the only difference to what I already had from https://lore.kernel.org/linux-xfs/ZeeaKrmVEkcXYjbK@dread.disaster.area/T/#me7abe09fe85292ca880f169a4af651eac5ed1424
> and the xfs_alloc_fix_len() fix.
> 
> With forcealign extsize=64KB, when I write to the end of a file I get 2x new
> extents, both of which are not a multiple of 64KB in size. Note that I am
> including https://lore.kernel.org/linux-xfs/20240304130428.13026-7-john.g.garry@oracle.com/,
> but I don't think it makes a difference.
> 
> Before:
>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
>    0: [0..383]:        73216..73599      0 (73216..73599)     384
>    1: [384..511]:      70528..70655      0 (70528..70655)     128
> 
> After:
>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
>    0: [0..383]:        73216..73599      0 (73216..73599)     384
>    1: [384..511]:      70528..70655      0 (70528..70655)     128
>    2: [512..751]:      30336..30575      0 (30336..30575)     240

So that's a 120kB (30 fsb) extent.

>    3: [752..767]:      48256..48271      0 (48256..48271)      16

And that's the 2FSB tail to make it up to 64kB.

> > ---
> >   fs/xfs/libxfs/xfs_alloc.c | 19 ++++++++++++++-----
> >   1 file changed, 14 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 9da52e92172a..215265e0f68f 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -2411,14 +2411,23 @@ xfs_alloc_space_available(
> >   	if (available < (int)max(args->total, alloc_len))
> >   		return false;
> > +	if (flags & XFS_ALLOC_FLAG_CHECK)
> > +		return true;
> > +
> >   	/*
> > -	 * Clamp maxlen to the amount of free space available for the actual
> > -	 * extent allocation.
> > +	 * If we can't do a maxlen allocation, then we must reduce the size of
> > +	 * the allocation to match the available free space. We know how big
> > +	 * the largest contiguous free space we can allocate is, so that's our
> > +	 * upper bound. However, we don't exaclty know what alignment/siz > +	 * constraints have been placed on the allocation, so we can't
> > +	 * arbitrarily select some new max size. Hence make this a minlen
> > +	 * allocation as we know that will definitely succeed and match the
> > +	 * callers alignment constraints.
> >   	 */
> > -	if (available < (int)args->maxlen && !(flags & XFS_ALLOC_FLAG_CHECK)) {
> > -		args->maxlen = available;
> > +	alloc_len = args->maxlen + (args->alignment - 1) + args->minalignslop;
> 
> I added some kernel logs to assist debugging, and if I am reading them
> correctly, for ext #2 allocation we had at this point:
> 
> longest = 46, alloc_len = 47, args->minlen=30, maxlen=32, alignslop=0
> available=392; longest < alloc_len, so we set args->maxlen = args->minlen (=
> 30)

Why was args->minlen set to 30? Where did that value come from? i.e.
That is not correctly sized/aligned for force alignment - it should
be rounded down to 16 fsbs, right?

I'm guessing that "30" is (longest - alignment) = 46 - 16 = 30? And
then it wasn't rounded down from there?

> For ext3:
> longest = 32, alloc_len = 17, args->minlen=2, args->maxlen=2, alignslop=0,
> available=362; longest > alloc_len, so do nothing

Same issue here - for a forced align allocation, minlen needs to be
bound to alignment constraints. If minlen is set like this, then the
allocation will always return a 2 block extent if they exist.

IOWs, the allocation constraints are not correctly aligned, but the
allocation is doing exactly what the constraints say it is allowed
to do. Therefore the issue is in the constraint setup (args->minlen)
for forced alignment and not the allocation code that selects a
an args->minlen extent that is not correctly sized near ENOSPC.

I'm guessing that we need something like the (untested) patch below
to ensure args->minlen is properly aligned....

-Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: align args->minlen for forced allocation alignment

From: Dave Chinner <dchinner@redhat.com>

If args->minlen is not aligned to the constraints of forced
alignment, we may do minlen allocations that are not aligned when we
approach ENOSPC. Avoid this by always aligning args->minlen
appropriately. If alignment of minlen results in a value smaller
than the alignment constraint, fail the allocation immediately.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 45 +++++++++++++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7a0ef0900097..aeebe51550f5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3288,33 +3288,48 @@ xfs_bmap_longest_free_extent(
 	return 0;
 }
 
-static xfs_extlen_t
+static int
 xfs_bmap_select_minlen(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args,
 	xfs_extlen_t		blen)
 {
-
 	/* Adjust best length for extent start alignment. */
 	if (blen > args->alignment)
 		blen -= args->alignment;
 
 	/*
 	 * Since we used XFS_ALLOC_FLAG_TRYLOCK in _longest_free_extent(), it is
-	 * possible that there is enough contiguous free space for this request.
+	 * possible that there is enough contiguous free space for this request
+	 * even if best length is less that the minimum length we need.
+	 *
+	 * If the best length won't satisfy the maximum length we requested,
+	 * then use it as the minimum length so we get as large an allocation
+	 * as possible.
 	 */
 	if (blen < ap->minlen)
-		return ap->minlen;
+		blen = ap->minlen;
+	else if (blen > args->maxlen)
+		 blen = args->maxlen;
 
 	/*
-	 * If the best seen length is less than the request length,
-	 * use the best as the minimum, otherwise we've got the maxlen we
-	 * were asked for.
+	 * If we have alignment constraints, round the minlen down to match the
+	 * constraint so that alignment will be attempted. This may reduce the
+	 * allocation to smaller than was requested, so clamp the minimum to
+	 * ap->minlen to allow unaligned allocation to succeed. If we are forced
+	 * to align the allocation, return ENOSPC at this point because we don't
+	 * have enough contiguous free space to guarantee aligned allocation.
 	 */
-	if (blen < args->maxlen)
-		return blen;
-	return args->maxlen;
-
+	if (args->alignment > 1) {
+		blen = rounddown(blen, args->alignment);
+		if (blen < ap->minlen) {
+			if (args->datatype & XFS_ALLOC_FORCEALIGN)
+				return -ENOSPC;
+			blen = ap->minlen;
+		}
+	}
+	args->minlen = blen;
+	return 0;
 }
 
 static int
@@ -3350,8 +3365,7 @@ xfs_bmap_btalloc_select_lengths(
 	if (pag)
 		xfs_perag_rele(pag);
 
-	args->minlen = xfs_bmap_select_minlen(ap, args, blen);
-	return error;
+	return xfs_bmap_select_minlen(ap, args, blen);
 }
 
 /* Update all inode and quota accounting for the allocation we just did. */
@@ -3671,7 +3685,10 @@ xfs_bmap_btalloc_filestreams(
 		goto out_low_space;
 	}
 
-	args->minlen = xfs_bmap_select_minlen(ap, args, blen);
+	error = xfs_bmap_select_minlen(ap, args, blen);
+	if (error)
+		goto out_low_space;
+
 	if (ap->aeof && ap->offset)
 		error = xfs_bmap_btalloc_at_eof(ap, args);
 

