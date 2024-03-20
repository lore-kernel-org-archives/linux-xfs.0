Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE45D14285
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 00:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711413280; cv=none; b=Hh2doEgk3A/G5zyyOLBCQrHGbvkU0Xn/C0UXby5PmfmsKr2OALHFG9AU0xd8QP3D5Y5N5Ab1uK+whT2AIrMBP+La3uVSNx172b7hmqaDjZFktSxB5XgRwE8l+HBGNo6Snh1jLx2flX8u31p8GZ0t92rtRGknmteh9NinN7+va+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711413280; c=relaxed/simple;
	bh=cihNk7W8bF68db4DNXgqVQFWU8ytfAVxk/GuoWtMB0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cEBpNBeGojuinzUWv5ybIETFPmeDdlfolAyLyztEnbfrpKDAnmsgtrwlgx2FJpyevwqqche/nA1Oo5ssJ+FLGB5WPpGsAts12jCXziwBYATBNt2KFe6R9EheW4A79EIJEoxBCBBBj6mFJDrOBDex3J/tjt2xzJ1EkVo4eNXySog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=wAfEuwDE; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="wAfEuwDE"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so3546983a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 17:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711413278; x=1712018078; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:resent-to:resent-message-id:resent-date
         :resent-from:from:to:cc:subject:date:message-id:reply-to;
        bh=N4mCJ1UyQniNjp8szlOEJZOxQeH+kkAf28gS48PuSdk=;
        b=wAfEuwDEBWch05+iEIXO4PrmLF9bmFPIchKIVG1SMvUA1x5ui5Q/ub93PBLAK3NZ8+
         eHzYo+3vc4TCISf3OQllI11MerNe7VCCZcYSjr3tihS+BLAloCEUHaqE0x9dpK6OevJq
         uF3qzSEj6SqG2fuz3gTChNoebA2jdg/f7JUnlryUJGtObg8CpuegmVV8QDaJvu6d3x1u
         adQrVzE9NTjt7nEEEq/CwMFH4ctC8LGRbs44a834Z25IBRwgamXsMEj2q4LZ8DuMkbj2
         lBesf9Op2tu9ZKn/lLaohCaM24LIVVOCVizQVsxs3ftgozVvbX+qQrUoMgAB+qhSgE9W
         yXhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711413278; x=1712018078;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:resent-to:resent-message-id:resent-date
         :resent-from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N4mCJ1UyQniNjp8szlOEJZOxQeH+kkAf28gS48PuSdk=;
        b=tk56xrJP7Db+lei+DTMPSZUxmVhqK9i0iGYpsSjTLulV4GuwZIijASaiOabm2zayJr
         3MlNhMs7AIr9ucDLaEOLSWVM7ras1Dcrbyw0bM9umVlL6jAAOIR/XnJqjFpLkdeMdx4r
         U7f8S8x5KHvzLL7fMaskv2o8ZSxicThZqMG18s8yyQyaMaR5sDnu1cd+IcF1gL3osPSD
         kQRXCCUVO2NMZwor4bPufIvw2D6FmnlPY/M5JdM+bynvhjLeT/PWCvYpPiT/S7Cgmsaq
         bS/dQY7AfMmLXaizkT6E+FGWyAX+sDPI2S+701lhhod/4Lc2Vn1f0mcEBZDfa0pN+dFn
         xLig==
X-Gm-Message-State: AOJu0YzoWV+NKX9bjZGFN/E2/0zebdQ74agVTglI+SwBrKjJDhMTfmLq
	5sdLTAr+eCmkeHWR2KbnbDLWwVL0vMzHje7iPNvTlbpiuYS/vBDaXFzpzNT35KF25ek/G6DX2z9
	E
X-Google-Smtp-Source: AGHT+IH9cX6va3sknrFba0tcrPU3rM+PU0kuwdR8J2gu0xEdSM+80oiolF2CFkGJKmGJ6fHYx5V8ZA==
X-Received: by 2002:a05:6a20:8f0c:b0:1a3:c3fe:fcaf with SMTP id b12-20020a056a208f0c00b001a3c3fefcafmr6892017pzk.9.1711413277805;
        Mon, 25 Mar 2024 17:34:37 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id m11-20020a17090aab0b00b0029bb433dc8asm10583871pjq.15.2024.03.25.17.34.36
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Mar 2024 17:34:37 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1roult-00A8yO-2T
	for linux-xfs@vger.kernel.org;
	Tue, 26 Mar 2024 11:34:33 +1100
Resent-From: Dave Chinner <david@fromorbit.com>
Resent-Date: Tue, 26 Mar 2024 11:34:33 +1100
Resent-Message-ID: <ZgIYGbiyibQTf6Z5@dread.disaster.area>
Resent-To: linux-xfs@vger.kernel.org
Date: Wed, 20 Mar 2024 15:35:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: linux-xfs@vger.kernel.org, ojaswin@linux.ibm.com, ritesh.list@gmail.com
Subject: Re: [PATCH 1/3] xfs: simplify extent allocation alignment
Message-ID: <ZfpnfXBU9a6RkR50@dread.disaster.area>
References: <ZeeaKrmVEkcXYjbK@dread.disaster.area>
 <20240306053048.1656747-1-david@fromorbit.com>
 <20240306053048.1656747-2-david@fromorbit.com>
 <9f511c42-c269-4a19-b1a5-21fe904bcdfb@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f511c42-c269-4a19-b1a5-21fe904bcdfb@oracle.com>

On Wed, Mar 13, 2024 at 11:03:18AM +0000, John Garry wrote:
> On 06/03/2024 05:20, Dave Chinner wrote:
> >   		return false;
> > diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> > index 0b956f8b9d5a..aa2c103d98f0 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.h
> > +++ b/fs/xfs/libxfs/xfs_alloc.h
> > @@ -46,7 +46,7 @@ typedef struct xfs_alloc_arg {
> >   	xfs_extlen_t	minleft;	/* min blocks must be left after us */
> >   	xfs_extlen_t	total;		/* total blocks needed in xaction */
> >   	xfs_extlen_t	alignment;	/* align answer to multiple of this */
> > -	xfs_extlen_t	minalignslop;	/* slop for minlen+alignment calcs */
> > +	xfs_extlen_t	alignslop;	/* slop for alignment calcs */
> >   	xfs_agblock_t	min_agbno;	/* set an agbno range for NEAR allocs */
> >   	xfs_agblock_t	max_agbno;	/* ... */
> >   	xfs_extlen_t	len;		/* output: actual size of extent */
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 656c95a22f2e..d56c82c07505 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -3295,6 +3295,10 @@ xfs_bmap_select_minlen(
> >   	xfs_extlen_t		blen)
> 
> Hi Dave,
> 
> >   {
> > +	/* Adjust best length for extent start alignment. */
> > +	if (blen > args->alignment)
> > +		blen -= args->alignment;
> > +
> 
> This change seems to be causing or exposing some issue, in that I find that
> I am being allocated an extent which is aligned to but not a multiple of
> args->alignment.

Entirely possible the logic isn't correct ;)

IIRC, I added this because I thought that blen ends up influencing
args->maxlen and nothing else. The alignment isn't taken out of
"blen", it's supposed to be added to args->maxlen.

> For my test, I have forcealign=16KB and initially I write 1756 * 4096 =
> 7192576B to the file, so I have this:
> 
>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
>    0: [0..14079]:      42432..56511      0 (42432..56511)   14080
> 
> That is 1760 FSBs for extent #0.
> 
> Then I write 340992B from offset 7195648, and I find this:
>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
>    0: [0..14079]:      42432..56511      0 (42432..56511)   14080
>    1: [14080..14711]:  177344..177975    0 (177344..177975)   632
>    2: [14712..14719]:  350720..350727    1 (171520..171527)     8
> 
> extent #1 is 79 FSBs, which is not a multiple of 16KB.

> In this case, in xfs_bmap_select_minlen() I find initially blen=80

Ah, so you've hit the corner case of the largest free space being
exactly 80 in length and args->maxlen = 80.

> args->alignment=4, ->minlen=0, ->maxlen=80. Subsequently blen is reduced to
> 76 and args->minlen is set to 76, and then xfs_bmap_btalloc_best_length() ->
> xfs_alloc_vextent_start_ag() happens to find an extent of length 79.

So there's nothing wrong here. We've asked for any extent that
is between 76 and 80 blocks in length to be allocated, and we found
one that is 79 blocks in length.

Finding a 79 block extent instead of an 80 block extent like blen
indicated means that there was either:

- a block moved to the AGFL from that 80 block free extent prior to
  doing the free extent search.
- a block was busy and so was trimmed out via
  xfs_alloc_compute_aligned()
- the front edge wasn't aligned so it took a block off the front of
  the free space to align it. It's this condition that code I added
  above takes into account - an exact match on size does not imply
  that aligned allocation of exactly that size can be done.

Given the front edge is aligned, I'd say it was the latter that
occurred. The question is this: why wasn't the tail edge aligned
down to make the extent length 76 blocks?

> Removing the specific change to modify blen seems to make things ok again.

Right, because now the allocation ends up being set up with
args->minlen = args->maxlen = 80 and the allocation is unable to
align the extent and meet the args->minlen requirement from that
same unaligned 80 block free space. Hence that allocation fails and
we fall back to a different allocation strategy that searches other
AGs for a matching aligned allocation.

IOWs, removing the 'blen -= args->alignment' code simply kicks the
problem down the road until all AGs run out of 80 block contiguous
extents.

This really smells like a tail alignment bug, not a problem with the
allocation setup. Returning an extent that is 76 blocks in length
fulfils the 4 block alignment requirement, so why did tail alignment
fail?

> I will also note something strange which could be the issue, that being that
> xfs_alloc_fix_len() does not fix this up - I thought that was its job.

Yes, it should fix this up.

> Firstly, in this same scenario, in xfs_alloc_space_available() we calculate
> alloc_len = args->minlen + (args->alignment - 1) + args->alignslop = 76 + (4
> - 1) + 0 = 79, and then args->maxlen = 79.

That seems OK, we're doing aligned allocation and this is an ENOSPC
corner case so the aligned allocation should get rounded down in
xfs_alloc_fix_len() or rejected.

One thought I just had is that the args->maxlen adjustment shouldn't
be to "available space" - it should probably be set to args->minlen
because that's the aligned 'alloc_len' we checked available space
against. That would fix this, because then we'd have args->minlen =
args->maxlen = 76.

However, that only addresses this specific case, not the general
case of xfs_alloc_fix_len() failing to tail align the allocated
extent.

> Then xfs_alloc_fix_len() allows
> this as args->len == args->maxlen (=79), even though args->prod, mod = 4, 0.

Yeah, that smells wrong.

I'd suggest that we've never noticed this until now because we
have never guaranteed extent alignment. Hence the occasional
short/unaligned extent being allocated in dark ENOSPC corners was
never an issue for anyone.

However, introducing a new alignment guarantee turns these sorts of
latent non-issues into bugs that need to be fixed. i.e. This is
exactly the sort of rare corner case behaviour I expected to be
flushed out by guaranteeing and then extensively testing allocation
alignments.

If you drop the rlen == args->maxlen check from
xfs_alloc_space_available(), the problem should go away and the
extent gets trimmed to 76 blocks. This shouldn't affect anything
else because maxlen allocations should already be properly aligned -
it's only when something like ENOSPC causes args->maxlen to be
modified to an unaligned value that this issue arises.

In the end, I suspect we'll want to make both changes....

> To me, that (args->alignment - 1) component in calculating alloc_len is odd.
> I assume it is done as default args->alignment == 1.

No, it's done because guaranteeing aligned allocation requires
selecting an aligned region from an unaligned free space. i.e.  when
alignment is 4, then we can need up to 3 additional blocks to
guarantee front alignment for a given length extent.
i.e. we have to over-allocate to guarantee we can trim up
to alignment at the front edge and still guarantee that the extent
is as long as required by args->minlen/maxlen.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
