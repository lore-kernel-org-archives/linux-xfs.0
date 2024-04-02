Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1290C323D
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 05:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712037489; cv=none; b=TCmoHVP7d8q6+QP9FrK0w9CNU6cvfYq26bcWWulCy2+Ypyj2JMRSdpN8BVvIXh4l3ycOZIeMAEB7UG8q6+YOT8VFvMG6S0nutKTf+rmax7CFICw29w1nyZaTV0BEaGNMYOD98/jAgQd97iitEWyUev7hQeKoHX9/I97EinXh04k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712037489; c=relaxed/simple;
	bh=uiYq7kShrPfh00kz5/Bj39PvwZrxIRsf1hfvwcHFhiw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pQaqofXh7mcnRZpS1EyouERtm9wMWf+ewl7oz/YdnlTSUQrrxRIN6KonfLNmi9R/tUjgfyV1nTwIR8Rqj3D2z+kYLXg+BIx/1/Uh9EvvJ/BuCaNwxy7/PUNK1d88pY0X0nAwCtLMAcdUMhCzY+nsGb/wfFvsPj5Bcf+7IRFjFUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=fSiK9k4r; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="fSiK9k4r"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-5e4613f2b56so3319638a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 01 Apr 2024 22:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712037486; x=1712642286; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z8xoykoQrY5BXFrEZcxyFmhK9D7PYlPVs1HAhWWoKVQ=;
        b=fSiK9k4rDw+smQz5zzZ/AMFMugi8UIy8N05URYeOtCyvLFLCOVyEAAbq5E15ENvNNG
         K9gAmiTfFP0Re5fn2gFEaGBsxn2bTOrepiMkz3daFhA3YiLlNxbgVxkctOg+yKh4aKK1
         z1blzYDW9eJ6gau4p+w7Rbn9lYlGMNlHWSnFDh+b7RAlEHBNc234n4dbenNb4U6LKGyA
         AXiZBB4yB3XgG9FLdE/RMjMh8yC5EkqxduvXfrsJ4BeCKPVww05dd1wX7ocoPZAnRlkG
         Uwxi4o69UblqG1a+5NiBou8AYtpGmELIwuLwS2qPOLec+o0JWzlHv4jvizOkDoRc3HQk
         bjCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712037486; x=1712642286;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z8xoykoQrY5BXFrEZcxyFmhK9D7PYlPVs1HAhWWoKVQ=;
        b=qC6S5bBwlzjcBZGabcAc9hbJaYDrIDs138leAUOBFehoPLLBFo7p10zPgrur3PPH72
         TI0ISGycLUlIfCWN5UeseOFyE3sTjoUPT0mFaHk8pW1tPzFoTW1y+44/DsNH5GfH4rxo
         PY2P60BpdZwS4WmioW52Na+5SIEhnc6zqetxPQpBhIta8HdATOZPuQMwf/steaIizl9P
         jQZpE+HjpekYtOZubdBwoWoIlMzXYq6T6BpTjb7bu6Cd50m+2IYhRjOo8Nl368tofUCo
         y4UXbYzEuhBY4IP6Z4Pk7gfA01EV+U3v7xW1OFwyg/AFNqugt6z6QR0ZNkqw/0FNbqss
         agjg==
X-Gm-Message-State: AOJu0Yz0hlSnAgV/I2yswUjgdgeIbWR96uXdAx6QR8fFvv87WDYJdkS7
	Mg3Y02vVRd7paKUFirJeNxaTpBHUNJZ0qmlaFyEXK/e8b6/8uYfEywoTTnrBRlA=
X-Google-Smtp-Source: AGHT+IFJBA04C3U/zAaytJIRAGdkgKfvfUYvVwSEw21b2zwMGG1sbj9RMZxZBbUP2saw0i2xQ4eGBg==
X-Received: by 2002:a05:6a20:2152:b0:1a3:4a1d:1092 with SMTP id z18-20020a056a20215200b001a34a1d1092mr9315463pzz.35.1712037486020;
        Mon, 01 Apr 2024 22:58:06 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id n16-20020a17090ac69000b002a06260ac96sm8912122pjt.16.2024.04.01.22.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Apr 2024 22:58:05 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rrX9m-0011dg-31;
	Tue, 02 Apr 2024 16:58:02 +1100
Date: Tue, 2 Apr 2024 16:58:02 +1100
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: linux-xfs@vger.kernel.org, ojaswin@linux.ibm.com, ritesh.list@gmail.com
Subject: Re: [PATCH 1/3] xfs: simplify extent allocation alignment
Message-ID: <ZgueamvcnndUUwYd@dread.disaster.area>
References: <ZeeaKrmVEkcXYjbK@dread.disaster.area>
 <20240306053048.1656747-1-david@fromorbit.com>
 <20240306053048.1656747-2-david@fromorbit.com>
 <9f511c42-c269-4a19-b1a5-21fe904bcdfb@oracle.com>
 <ZfpnfXBU9a6RkR50@dread.disaster.area>
 <9cc5d4da-c1cd-41d3-95d9-0373990c2007@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cc5d4da-c1cd-41d3-95d9-0373990c2007@oracle.com>

On Tue, Mar 26, 2024 at 04:08:04PM +0000, John Garry wrote:
> On 20/03/2024 04:35, Dave Chinner wrote:
> 
> For some reason I never received this mail. I just noticed it on
> lore.kernel.org today by chance.
> 
> > On Wed, Mar 13, 2024 at 11:03:18AM +0000, John Garry wrote:
> > > On 06/03/2024 05:20, Dave Chinner wrote:
> > > >    		return false;
> > > > diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> > > > index 0b956f8b9d5a..aa2c103d98f0 100644
> > > > --- a/fs/xfs/libxfs/xfs_alloc.h
> > > > +++ b/fs/xfs/libxfs/xfs_alloc.h
> > > > @@ -46,7 +46,7 @@ typedef struct xfs_alloc_arg {
> > > >    	xfs_extlen_t	minleft;	/* min blocks must be left after us */
> > > >    	xfs_extlen_t	total;		/* total blocks needed in xaction */
> > > >    	xfs_extlen_t	alignment;	/* align answer to multiple of this */
> > > > -	xfs_extlen_t	minalignslop;	/* slop for minlen+alignment calcs */
> > > > +	xfs_extlen_t	alignslop;	/* slop for alignment calcs */
> > > >    	xfs_agblock_t	min_agbno;	/* set an agbno range for NEAR allocs */
> > > >    	xfs_agblock_t	max_agbno;	/* ... */
> > > >    	xfs_extlen_t	len;		/* output: actual size of extent */
> > > > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > > > index 656c95a22f2e..d56c82c07505 100644
> > > > --- a/fs/xfs/libxfs/xfs_bmap.c
> > > > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > > > @@ -3295,6 +3295,10 @@ xfs_bmap_select_minlen(
> > > >    	xfs_extlen_t		blen)
> > > 
> > > Hi Dave,
> > > 
> > > >    {
> > > > +	/* Adjust best length for extent start alignment. */
> > > > +	if (blen > args->alignment)
> > > > +		blen -= args->alignment;
> > > > +
> > > 
> > > This change seems to be causing or exposing some issue, in that I find that
> > > I am being allocated an extent which is aligned to but not a multiple of
> > > args->alignment.
> > 
> > Entirely possible the logic isn't correct ;)
> 
> Out of curiosity, how do you guys normally test all this sort of logic?

With difficulty.

Exercising all the weird corner cases is really hard because the
combinatory explosion that occurs when you have 20 control
parameters, up to 5 different failure fallback strategies,
behavioural variations with delayed allocation, ENOSPC and AGFL
refilling accounting variations, etc, means it's basically
impossible to enumerate and iterate the behaviour space fully.
And then we have filesystem geometry and application concurrency
to consider, too.

All of the behaviours up to this point in time are best effort - we
don't guarantee allocation policy is followed when there is not
enough free space to execute the preferred policy - we slowly fall
back to mechanisms that are further from the policy but more likely
to succeed. i.e. as we approach ENOSPC, the allocation policies get
"looser" - they are less restrictive and more variable and don't
give as good results as when there is plenty of free space for the
allocation policy to make good decisions from.

As such, I only check that macro-level behaviour when there is lots
of free space is largely correct. e.g. by doing something like
copying a kernel tree onto a new filesystem, then checking inode
locality follows directories, block locality follows inodes, large
files are stripe aligned, extent size hint based inodes appear to
have the correct extent sizes, etc.

I then rely on the ENOSPC tests in fstests to find regressions that
might occur when the filesystem is stressed with little free space
available. These are a whole lot better than they used to be; root
cause analysis of ENOSPC corner case bugs has consumed months of my
working life over the past 20 years....

> I found this issue with the small program which I wrote to generate traffic.
> I could not find anything similar.

That's because it's largely impossible to write a test that is
deterministic and works on all possible test configurations. Even
changing the size of the filesystem even slightly can result in
vastly different but still 100% correct allocation
behaviour....

> > > Firstly, in this same scenario, in xfs_alloc_space_available() we calculate
> > > alloc_len = args->minlen + (args->alignment - 1) + args->alignslop = 76 + (4
> > > - 1) + 0 = 79, and then args->maxlen = 79.
> > 
> > That seems OK, we're doing aligned allocation and this is an ENOSPC
> > corner case so the aligned allocation should get rounded down in
> > xfs_alloc_fix_len() or rejected.
> > 
> > One thought I just had is that the args->maxlen adjustment shouldn't
> > be to "available space" - it should probably be set to args->minlen
> > because that's the aligned 'alloc_len' we checked available space
> > against. That would fix this, because then we'd have args->minlen =
> > args->maxlen = 76.
> > 
> > However, that only addresses this specific case, not the general
> > case of xfs_alloc_fix_len() failing to tail align the allocated
> > extent.
> > 
> > > Then xfs_alloc_fix_len() allows
> > > this as args->len == args->maxlen (=79), even though args->prod, mod = 4, 0.
> > 
> > Yeah, that smells wrong.
> 
> Would it be worth adding a debug assert for prod and mod being honoured from
> the allocator? xfs_alloc_fix_len() does have an assert later on and it does
> not help here.

I don't see any value in that because it's not actually a "fatal"
issue. See above about trading off policy strictness for allocation
success.

Again, this force alignment stuff is a fundamental change in this
behaviour - it wants "hard failure" rather than "trade off" and so
there isn't a general case for asserting that allocation must be
mod/prod aligned. Extent size hints are a -hint-, not a requirement,
and I don't want random assert failures in test systems because
debug kernels start treating hints as "must not fail" requirements.

> > I'd suggest that we've never noticed this until now because we
> > have never guaranteed extent alignment. Hence the occasional
> > short/unaligned extent being allocated in dark ENOSPC corners was
> > never an issue for anyone.
> > 
> > However, introducing a new alignment guarantee turns these sorts of
> > latent non-issues into bugs that need to be fixed. i.e. This is
> > exactly the sort of rare corner case behaviour I expected to be
> > flushed out by guaranteeing and then extensively testing allocation
> > alignments.
> > 
> > If you drop the rlen == args->maxlen check from
> > xfs_alloc_space_available(),
> 
> I assume that you mean xfs_alloc_fix_len()

Yes.

> > the problem should go away and the
> > extent gets trimmed to 76 blocks.
> 
> ..if so, then, yes, it does. We end up with this:
> 
>    0: [0..14079]:      42432..56511      0 (42432..56511)   14080
>    1: [14080..14687]:  177344..177951    0 (177344..177951)   608
>    2: [14688..14719]:  350720..350751    1 (171520..171551)    32

Good, that's how it should work. :) 

I'll update the patchset I have with these fixes.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
