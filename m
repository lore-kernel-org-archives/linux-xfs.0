Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CED1CAA94
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 23:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737589901; cv=none; b=OGQvm41M/bRLxep590KL0cwK5rnIBOJb1SphMVfk13TWYXczRlZiLxFgrrMfXNSlPPfaLTPq3L0rwnauchhz5fTneDIqWokzqmHm9NvSKk9aCW3z1HZRZaXlfEg2aeL5lcSbwR4hDbkJpNnU9kwh4asRoXDQNHXzFQIbz7HtMdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737589901; c=relaxed/simple;
	bh=eGyA3rqoqd93cwyl2S8laa78snBew5qe12qSM3/if9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XpOUvnOWpErf+/VyGn5tXdp6AcczGYJ4ID8VPHjSjkegVJTuZ8OQ38CQgmrJcyY/H+Vx8QFWq1ctVOe+zEkb2lp5dqCK8BJaBn+Oae83NQQ/DU8o/y4EA2aQOZ4tnli39GN3WaIM9EqWovwZeW40oFb/7lkuSCcH39wDh1o6+Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ll0q/DmU; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ll0q/DmU"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2166022c5caso3628005ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 15:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1737589899; x=1738194699; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CR+WSCo7rNY6An/Jr/D/lBMugrGIQSBj95/AQbGzEws=;
        b=ll0q/DmUqAwQgzmwylfUOP15kXQOJGX9txIC/fk7vIBACtzNT1z7Hh0OM92fSsL+O+
         MisJcySLzV7gV/HXa7Ohts94n2u5SU6G8Ld3+jUkKn9bI/YPiZb8F7/mQ4w9ZfRJhlKp
         zUcyZSE8und3UUmhXtcknXtA6zVEnz5GFzJkuIic4+IZ3KOpdyq4VxwDLfbIj8Nt69a0
         CUPtas/TDfHZXfl0wGLbr5N2NHC/WZE4M1Bfp+DfCFgZ3GBEQ7v+UllyB+/9aK8M2W64
         /X5gmlvzTTxh/Zfs/fY5GLJnE1HZ15l2HYkgNjo4HGsu8Ie1x9ar7HrWSP/y36wWZTET
         papw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737589899; x=1738194699;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CR+WSCo7rNY6An/Jr/D/lBMugrGIQSBj95/AQbGzEws=;
        b=v7SHETR7RZR+gxd14CIJoYrvQ9olSDu7Qs+CVpRxJX6EgMhmnRJFIJQM43rNHwGmWM
         We35edmnM2cFAB8FTbWtT/gj70xaN5tnElJsGksx+jg0C3mPhRM/prOdHIC+Gpb47gNY
         2828iJ05hMbZCDUvhb8+xpCNuvo/FcKGA1pbD2ACsW8gxeN1o6o1wktQlgoePJxLVvpl
         l+FejC+9NtGRAvaFhQmNMWZCDj+UgNJeftsAANwDKUKKq5yC/O4DZU9vBgEakxatfMW9
         t89HsWci80TR4eFQBzgTaKkFxpGyIDyJKt1B6rgklK8cxU6XPYVRPOjx4pPehEpFICS9
         pgSQ==
X-Forwarded-Encrypted: i=1; AJvYcCXREURmX6dLAQ/ddbH1SwfxMRjfO0RaXTbtnD7xCxBnK4VKflM3a0TAJUPCVVua0/ep41AE6shB1Y8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyI/BKIhSRiVNQlLi3NyP1dx2HOJgG7U+e2kOm5lK0nNWaReB3c
	eUzBCZsCDLxROlG65zgSNNDEpuOHdZkvusPpcVaI0sayciw1Y0g2Bps6TEaNvTM=
X-Gm-Gg: ASbGncuffF2qqdvkIXVxqz1v54m1QOU1v0gyizkEFz13V8A/55fePiAGEj1aGV7qlj6
	rNmcMgpGSwY/X2J/FawvoaPAAUSJNU1QzqddB8sQbun5jQ9BPC3K9W56Uysp1PI+l7i/dL7m4tK
	D1E9QyrLK+mXo6d2x4mJ5LsSdbjJgGdjCCjyrogV/CvcDEl2QRicNgXUXTWSrUh6RcwDOjJTiMR
	LDt8GbZIRMPgG4pE7hS9g83H4ydKg0RynI3/ds4KpuTxhqCyklkKLCHsnZw1tJj2P3YfNYiLieH
	6LUb7ViOD4R/CsMqYe1x5BDDyJ1d1V56WKlDE5R8jMaHcA==
X-Google-Smtp-Source: AGHT+IHaMy+6xBIMYG0uehZ3fvKU97NG0GIFdN8l4dmBBBi9bUHzdTceyQ6RVgjQiPgM5S1jdX6YCA==
X-Received: by 2002:a17:902:ce0c:b0:21c:e34:c8c3 with SMTP id d9443c01a7336-21c35540560mr416546775ad.24.1737589898928;
        Wed, 22 Jan 2025 15:51:38 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21c2d42cb87sm100450515ad.254.2025.01.22.15.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 15:51:38 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1takVT-00000009HMD-2x8v;
	Thu, 23 Jan 2025 10:51:35 +1100
Date: Thu, 23 Jan 2025 10:51:35 +1100
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>,
	brauner@kernel.org, cem@kernel.org, dchinner@redhat.com,
	ritesh.list@gmail.com, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	martin.petersen@oracle.com
Subject: Re: [PATCH 1/4] iomap: Lift blocksize restriction on atomic writes
Message-ID: <Z5GEh0XA3Nt_4K2f@dread.disaster.area>
References: <Z1C9IfLgB_jDCF18@dread.disaster.area>
 <3ab6000e-030d-435a-88c3-9026171ae9f1@oracle.com>
 <Z1IX2dFida3coOxe@dread.disaster.area>
 <20241212013433.GC6678@frogsfrogsfrogs>
 <Z4Xq6WuQpVOU7BmS@dread.disaster.area>
 <20250114235726.GA3566461@frogsfrogsfrogs>
 <20250116065225.GA25695@lst.de>
 <20250117184934.GI1611770@frogsfrogsfrogs>
 <20250122064247.GA31374@lst.de>
 <0c0753fb-8a35-42a6-8698-b141b1e561ca@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c0753fb-8a35-42a6-8698-b141b1e561ca@oracle.com>

On Wed, Jan 22, 2025 at 10:45:34AM +0000, John Garry wrote:
> On 22/01/2025 06:42, Christoph Hellwig wrote:
> > On Fri, Jan 17, 2025 at 10:49:34AM -0800, Darrick J. Wong wrote:
> > > The trouble is that the br_startoff attribute of cow staging mappings
> > > aren't persisted on disk anywhere, which is why exchange-range can't
> > > handle the cow fork.  You could open an O_TMPFILE and swap between the
> > > two files, though that gets expensive per-io unless you're willing to
> > > stash that temp file somewhere.
> > 
> > Needing another inode is better than trying to steal ranges from the
> > actual inode we're operating on.  But we might just need a different
> > kind of COW staging for that.
> > 
> > > 
> > > At this point I think we should slap the usual EXPERIMENTAL warning on
> > > atomic writes through xfs and let John land the simplest multi-fsblock
> > > untorn write support, which only handles the corner case where all the
> > > stars are <cough> aligned; and then make an exchange-range prototype
> > > and/or all the other forcealign stuff.
> > 
> > That is the worst of all possible outcomes.  Combing up with an
> > atomic API that fails for random reasons only on aged file systems
> > is literally the worst thing we can do.  NAK.
> > 
> > 
> 
> I did my own quick PoC to use CoW for misaligned blocks atomic writes
> fallback.
> 
> I am finding that the block allocator is often giving misaligned blocks wrt
> atomic write length, like this:

Of course - I'm pretty sure this needs force-align to ensure that
the large allocated extent is aligned to file offset and hardware
atomic write alignment constraints....

> Since we are not considering forcealign ATM, can we still consider some
> other alignment hint to the block allocator? It could be similar to how
> stripe alignment is handled.

Perhaps we should finish off the the remaining bits needed to make
force-align work everywhere before going any further?

> Some other thoughts:
> - I am not sure what atomic write unit max we would now use.

What statx exposes should be the size/alignment for hardware offload
to take place (i.e. no change), regardless of what the filesystem
can do software offloads for. i.e. like statx->stx_blksize is the
"preferred block size for efficient IO", the atomic write unit
information is the "preferred atomic write size and alignment for
efficient IO", not the maximum sizes supported...

> - Anything written back with CoW/exchange range will need FUA to ensure that
> the write is fully persisted.

I don't think so. The journal commit for the exchange range
operation will issue a cache flush before the journal IO is
submitted. that will make the new data stable before the first
xchgrange transaction becomes stable.

Hence we get the correct data/metadata ordering on stable storage
simply by doing the exchange-range operation at data IO completion.
This the same data/metadata ordering semantics that unwritten extent
conversion is based on....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
