Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526A71119F
	for <linux-xfs@vger.kernel.org>; Sat, 30 Mar 2024 21:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711835490; cv=none; b=SFIr37CqL+0zV0ohAdBpwFtTc11X8V4EXvUAwKbBZnKsQXKpP1/Lrasyb4uas9rJrE/GXx4kc38JN0zD8h429fDhzewmNp8XXC7bqqSOxUG/VfXCCjsBK+VclHeZfXDAZ0KclJC1OpRqtarnhr08jXwGM95N5hbfjTPDabwE24o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711835490; c=relaxed/simple;
	bh=mJFBWmbFIL7YZSoYCY0d00ZhUicVx7E/rpRnvS86FLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R9bQxwHB8CHhe0kN6G9dVHqRmJs+Ozp7EEDmrivWJS18x5oKcIMMjGE4vEVAI+MMO1fInIKJ6X93BgiRY6dpPNqhGuWeIWbzhF919NLn20OBd3CkZwDwiooOHFXX7LSXypf8HF3aXCRA4CZiCERSU1/ZbuyRneti8+UcSEo8ALs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Aplb7MkE; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Aplb7MkE"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-22a639aedb6so1663960fac.3
        for <linux-xfs@vger.kernel.org>; Sat, 30 Mar 2024 14:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711835487; x=1712440287; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ej/5EbvsTbrZnQBMnv+vX1b5eqw7NCNCuvbkDNLngag=;
        b=Aplb7MkE1Ecw0egg7rgjUExFoHEsgPP501uptKWGMH5S9sZ8TeoetoV6wp/gBG7v8u
         hywZDzaDJflKskckQAEO4Q2YmP71DOFEQ5vqEbEpzITuZgcSxtaAcwbhb+wqn18baI3f
         FuupJrU8VMyROYq6/O6qqarKkhf7PjERLXKmhpXHyWd3X9vXgpmRiagmkj5TXCGFvfAP
         PzchqtiD5ASpwTOUQrD5XfPAEONt9zHV/GKiw1LCU3RS64iDPTg9s56hBLKjpe7mE3Fz
         wdMaOvo6+7wCB+GOg7Zn8DCmoxor51XDRbFr6oZJK3tT5z2rQjhJdo/M9pdI9g2sUFYJ
         wA8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711835487; x=1712440287;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ej/5EbvsTbrZnQBMnv+vX1b5eqw7NCNCuvbkDNLngag=;
        b=iU19x5r9STSrDsjGQCGBiy1kFqFamORnDLwyKvAdS1E1WLHhMRSKvikKPKetha3E2x
         6kbZBYc0JEIjUCEEt6tEzfaoJJEPv3KLG+JkuJdhMgmSJRAR63BLprg/HHdO+kFFQ/SZ
         ogyDYsWXL42e6KHyJgxqkIjmWaiQh54kQ1EutCwwh0gVA4jiPh+19XWESut/0Saq70u1
         wZtmA0dd3ZwlP7jEZgD2n87sOiWy85sVXqFJRLua+VTaIf/wvXSXRBF9cOoCFFMsLPZA
         ONHJD6EAzzLGvYdo3hcxuRrsGu5DJ2AwC6jPlUGFrDam//zHV6v4XYb7KZy2jsWhhAgi
         poxw==
X-Gm-Message-State: AOJu0Yxu7G0hOaraWlldINPOfsL+w43FhawiLQYAYvhPd7ajoVasjDKe
	LyxoKeTL8SClYh0nYvbmG7W7XWiFHTaYAA5JLeavwjfEdaOakwdwHW3zoIoJJ5A=
X-Google-Smtp-Source: AGHT+IFElGwgE2Nr1o7tc0u7VrW5DuFbpE6uTx7f6ZPKpfLjUxNFiYpCmxYvECApSROZZLBZE/V7Vg==
X-Received: by 2002:a05:6871:b14:b0:221:8e59:b3e7 with SMTP id fq20-20020a0568710b1400b002218e59b3e7mr6806164oab.1.1711835487005;
        Sat, 30 Mar 2024 14:51:27 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id fa15-20020a056a002d0f00b006ead124ff9fsm4987129pfb.136.2024.03.30.14.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Mar 2024 14:51:26 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rqgbj-00Fspc-1g;
	Sun, 31 Mar 2024 08:51:23 +1100
Date: Sun, 31 Mar 2024 08:51:23 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: fix severe performance problems when fstrimming
 a subset of an AG
Message-ID: <ZgiJWxVcVwag0fIP@dread.disaster.area>
References: <171150385517.3220448.15319110826705438395.stgit@frogsfrogsfrogs>
 <171150385535.3220448.4852463781154330350.stgit@frogsfrogsfrogs>
 <ZgSaffJmGXBiXwKZ@dread.disaster.area>
 <20240329225149.GR6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240329225149.GR6390@frogsfrogsfrogs>

On Fri, Mar 29, 2024 at 03:51:49PM -0700, Darrick J. Wong wrote:
> On Thu, Mar 28, 2024 at 09:15:25AM +1100, Dave Chinner wrote:
> > On Tue, Mar 26, 2024 at 07:07:58PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
....
> > I think a commit message update is necessary. :)
> 
> xfs: fix performance problems when fstrimming a subset of a fragmented AG
> 
> On a 10TB filesystem where the free space in each AG is heavily
> fragmented, I noticed some very high runtimes on a FITRIM call for the
> entire filesystem.  xfs_scrub likes to report progress information on
> each phase of the scrub, which means that a strace for the entire
> filesystem:
> 
> ioctl(3, FITRIM, {start=0x0, len=10995116277760, minlen=0}) = 0 <686.209839>
> 
> shows that scrub is uncommunicative for the entire duration.  Reducing
> the size of the FITRIM requests to a single AG at a time produces lower
> times for each individual call, but even this isn't quite acceptable,
> because the time between progress reports are still very high:
> 
> Strace for the first 4x 1TB AGs looks like (2):
> ioctl(3, FITRIM, {start=0x0, len=1099511627776, minlen=0}) = 0 <68.352033>
> ioctl(3, FITRIM, {start=0x10000000000, len=1099511627776, minlen=0}) = 0 <68.760323>
> ioctl(3, FITRIM, {start=0x20000000000, len=1099511627776, minlen=0}) = 0 <67.235226>
> ioctl(3, FITRIM, {start=0x30000000000, len=1099511627776, minlen=0}) = 0 <69.465744>
> 
> I then had the idea to limit the length parameter of each call to a
> smallish amount (~11GB) so that we could report progress relatively
> quickly, but much to my surprise, each FITRIM call still took ~68
> seconds!
> 
> Unfortunately, the by-length fstrim implementation handles this poorly
> because it walks the entire free space by length index (cntbt), which is
> a very inefficient way to walk a subset of the blocks of an AG.
> 
> Therefore, create a second implementation that will walk the bnobt and
> perform the trims in block number order.  This implementation avoids the
> worst problems of the original code, though it lacks the desirable
> attribute of freeing the biggest chunks first.
> 
> On the other hand, this second implementation will be much easier to
> constrain the system call latency, and makes it much easier to report
> fstrim progress to anyone who's running xfs_scrub.

Much better :)

> > Here's a completely untested, uncompiled version of this by-bno
> > search I just wrote up to demonstrate that if we pass ag-confined
> > agbnos from the top level, we don't need to duplicate this gather
> > code at all or do trim range constraining inside the gather
> > functions...
> 
> Mostly looks ok, but let's dig in--
> 
> > -Dave.
> > 
> > diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> > index 268bb734dc0a..0c949dfc097a 100644
> > --- a/fs/xfs/xfs_discard.c
> > +++ b/fs/xfs/xfs_discard.c
> > @@ -145,14 +145,18 @@ xfs_discard_extents(
> >  	return error;
> >  }
> >  
> > +struct xfs_trim_cur {
> > +	xfs_agblock_t	start;
> > +	xfs_extlen_t	count;
> > +	xfs_agblock_t	end;
> > +	xfs_extlen_t	minlen;
> > +	bool		by_len;
> > +};
> >  
> >  static int
> >  xfs_trim_gather_extents(
> >  	struct xfs_perag	*pag,
> > -	xfs_daddr_t		start,
> > -	xfs_daddr_t		end,
> > -	xfs_daddr_t		minlen,
> > -	struct xfs_alloc_rec_incore *tcur,
> > +	struct xfs_trim_cur	*tcur,
> >  	struct xfs_busy_extents	*extents,
> >  	uint64_t		*blocks_trimmed)
> >  {
> > @@ -179,21 +183,21 @@ xfs_trim_gather_extents(
> >  	if (error)
> >  		goto out_trans_cancel;
> >  
> > -	cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
> >  
> > -	/*
> > -	 * Look up the extent length requested in the AGF and start with it.
> > -	 */
> > -	if (tcur->ar_startblock == NULLAGBLOCK)
> > -		error = xfs_alloc_lookup_ge(cur, 0, tcur->ar_blockcount, &i);
> > -	else
> > +	if (tcur->by_len) {
> > +		cur = xfs_bnobt_init_cursor(mp, tp, agbp, pag);
> 
> I'm confused, why are we searching the by-bno btree if "by_len" is set?

Because I changed the logic half way through writing it and forgot
to change the variable name....

> Granted the logic for setting by_len triggers only for FITRIMs of
> subsets of an AG so this functions conrrectly...
> 
> > +		error = xfs_alloc_lookup_ge(cur, tcur->ar_startblock,
> > +				0, &i);
> 
> ...insofar as this skips a free extent that starts before and ends after
> tcur->start.

Right - did I mention this wasn't even compiled? :)

> 
> > +	} else {
> > +		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
> >  		error = xfs_alloc_lookup_le(cur, tcur->ar_startblock,
> >  				tcur->ar_blockcount, &i);
> > +	}
> 
> How about this initialization logic:
> 
> 	if (tcur->by_bno) {
> 		/* sub-AG discard request always starts at tcur->start */
> 		cur = xfs_bnobt_init_cursor(mp, tp, agbp, pag);
> 		error = xfs_alloc_lookup_le(cur, tcur->start, 0, &i);

OK.

> 	} else if (tcur->start == NULLAGBLOCK) {
> 		/* first time through a by-len starts with max length */
> 		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
> 		error = xfs_alloc_lookup_ge(cur, 0, tcur->count, &i);
> 	} else {
> 		/* nth time through a by-len starts where we left off */
> 		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
> 		error = xfs_alloc_lookup_le(cur, tcur->start, tcur->count, &i);
> 	}

... but that is what I was explicilty trying to avoid because the
initial search on a by-count config is for tcur->count =
pag->pagf_longest.

IOWs, there is no "greater" sized free extent than tcur->count,
every free extent *must* be less than or equal to pag->pagf_longest.
The _ge() search is done because the start block of zero is less
than every agbno in the tree. Hence we have to do a _ge() search to
"find" the pag->pagf_longest extent based on start block criteria.

If we pass in a tcur->start = NULLAGBLOCK (0xffffffff) or
pag->pag_blocks then every agbno is "less than" the start block, and
so it should return the extent at the right most edge of the tree
with a _le() search regardless of where in the AG it is located.

Hence the initial search can also be a _le() search and we don't
have to special case it - the by-count tree has two components in
it's search key and if we set the initial values of both components
correctly one search works for all cases...

> > @@ -248,10 +235,35 @@ xfs_trim_gather_extents(
> >  		 * supposed to discard skip it.  Do not bother to trim
> >  		 * down partially overlapping ranges for now.
> >  		 */
> > -		if (dbno + dlen < start || dbno > end) {
> > +		if (fbno + flen < tcur->start) {
> >  			trace_xfs_discard_exclude(mp, pag->pag_agno, fbno, flen);
> >  			goto next_extent;
> >  		}
> > +		if (fbno > tcur->end) {
> > +			trace_xfs_discard_exclude(mp, pag->pag_agno, fbno, flen);
> > +			if (tcur->by_len) {
> > +				tcur->count = 0;
> > +				break;
> > +			}
> > +			goto next_extent;
> > +		}
> > +
> > +		/* Trim the extent returned to the range we want. */
> > +		if (fbno < tcur->start) {
> > +			flen -= tcur->start - fbno;
> > +			fbno = tcur->start;
> > +		}
> > +		if (fbno + flen > tcur->end + 1)
> > +			flen = tcur->end - fbno + 1;
> > +
> > +		/*
> > +		 * Too small?  Give up.
> > +		 */
> > +		if (flen < minlen) {
> > +			trace_xfs_discard_toosmall(mp, pag->pag_agno, fbno, flen);
> > +			tcur->count = 0;
> > +			break;
> > +		}
> 
> For a by-bno search, this logic skips the entire rest of the AG after
> the first free extent that's smaller than tcur->minlen.  Instead, it
> should goto next_extent, yes?

Yes.

> > @@ -415,12 +438,23 @@ xfs_ioc_trim(
> >  	start = BTOBB(range.start);
> >  	end = start + BTOBBT(range.len) - 1;
> >  
> > -	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
> > -		end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1;
> 
> Couldn't this simply be:
> 
> 	end = min_t(xfs_daddr_t, start + BTOBBT(range.len) - 1,
> 		    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1);

Yes.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
