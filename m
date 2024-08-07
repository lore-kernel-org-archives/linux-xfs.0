Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBE21E520
	for <linux-xfs@vger.kernel.org>; Wed,  7 Aug 2024 00:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722990852; cv=none; b=JM5keuuk3f5+60nuLcL2QaXnPZaVCCXNOah640jJufPIiOLxc3/mbUUDBfgkTPVXBOlzzLm1P+VXhAik5ZWdayVtV7POKnQP0C3Pb/NH8+NmLX2+++gg1rgFv/kBd59Gt3z4dvsTSr6ZbTUIM6GRkJEcplQ0dqlh8oQKVt6zT1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722990852; c=relaxed/simple;
	bh=D9tMHsg5GXwd/Q9wzq34XNe1VZkHS69y/mSRWVScajk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DqvfJTaoxhEqdVBIKOfu8JNGKn4ZUxQVcSKuOA8ro7Dpg5IONkJevIjhxVnk4t1+CCqS84dZRYdUEtM3QNTM+E/lZX356tXnC1cAP8hPFMl6SyAcBwyiu5+i9cTX5xBYwfae4p2KkntdXHbuXlzH51MpdJIbHU+8EUMCdzJLMSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=I+tuw7/8; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="I+tuw7/8"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1fd65aaac27so2659505ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 06 Aug 2024 17:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1722990850; x=1723595650; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bnXWJK25vsk6Tkg5Uz/yY6n46HIUZ72hhBmsq/FGBUg=;
        b=I+tuw7/8NL17SeXdYBO4zRuLZgFtW37s5YK5Ru9YxhPdv+fhgbWjeGAX0wkIe+wqNb
         Tz7DZbZONEylpANFwOX+o0Hp8tbBb1arqbYJPEtTizEIORZ/eD2RUrnftvhjFLgNZmSZ
         MsSvt0xr1zybXq47qf5HyIjzL3QMhEc5vtZW4FjtgxOYeiHOLFVt0hmDUiTVHo/7k28H
         hnIqZ/czYH0m8PcnlKhZ+B5YWiWWoV21x1Ksh7rKFehWxlVITikFpQyZRdkjMhDITaBJ
         4exr3846miHNdM6Deqsb0E0lztDH5d5ZwLHoTlHtD0hiVOFT1sz51OK57phS0zYUsFG7
         IXQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722990850; x=1723595650;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bnXWJK25vsk6Tkg5Uz/yY6n46HIUZ72hhBmsq/FGBUg=;
        b=JiddIDLgsfcmwpDxJAxvqQGWKhyjxAKkYEuJnhOgHPUMP25dRovsfG1lMwrm+5ZJOR
         JZGBjoR3nbS8FdHZcQbGJChWMdyzzhsdPQ1N3M7bOZ7UMpU780UR9Irt5CD/UuAzWRFo
         6uvNxeWZ1VJ5ortVK7OsBSYhkd/TeEpqvT/PWDVgOGPq0YT1eQGE7E6sgZyNxQxZol9P
         lHXxu1UGgdkZG7epNuMnOVeL/ZbxzXH5nbBYwc1COo8Ee+8XlzN6brq4KYtxjIss4t6P
         ZQA/+TyzCdakxXJuX5BGv/eeuOjjxqIarzppEb+NtKRrd/bgISgoQscEkTAD/BECioS9
         bn1w==
X-Forwarded-Encrypted: i=1; AJvYcCWoOv+mSbvD5AjtfGSRNCo71uftS3NB0ZhkYSZcmdrj58llbrMUIlEJDSOdA4WIqXEUPsl9mL5/Zo64NZR7+W8Y/VQL1+/QUQ05
X-Gm-Message-State: AOJu0YxRwze2MT27t0RpSvQeNs5bfhNGgrY6c0hao7Mz9/20uNF5ZNDn
	v1ES7MatFu6+NO61EsgXh+5ZhuTI/rjhrQK0ochXTrMi1mcxziqYugUQqPicqQk=
X-Google-Smtp-Source: AGHT+IEWoggHYWqMACDmKxQEBTqXmn1EKyVhsRXVzA75W9v0DUuK0hIHaAxv0/P7oXUeuT8VRp7mfA==
X-Received: by 2002:a17:902:e541:b0:1fd:9648:2d66 with SMTP id d9443c01a7336-200854f9289mr8036335ad.17.1722990849751;
        Tue, 06 Aug 2024 17:34:09 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff58f29c91sm94089355ad.16.2024.08.06.17.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Aug 2024 17:34:09 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sbUcx-007xev-0P;
	Wed, 07 Aug 2024 10:34:07 +1000
Date: Wed, 7 Aug 2024 10:34:07 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>, chandan.babu@oracle.com,
	dchinner@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	catherine.hoang@oracle.com, martin.petersen@oracle.com
Subject: Re: [PATCH v3 03/14] xfs: simplify extent allocation alignment
Message-ID: <ZrLA/46GudqcYx4K@dread.disaster.area>
References: <20240801163057.3981192-1-john.g.garry@oracle.com>
 <20240801163057.3981192-4-john.g.garry@oracle.com>
 <20240806185651.GG623936@frogsfrogsfrogs>
 <ZrK3JlJIV5j4h44F@dread.disaster.area>
 <20240807002358.GQ623936@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240807002358.GQ623936@frogsfrogsfrogs>

On Tue, Aug 06, 2024 at 05:23:58PM -0700, Darrick J. Wong wrote:
> On Wed, Aug 07, 2024 at 09:52:06AM +1000, Dave Chinner wrote:
> > On Tue, Aug 06, 2024 at 11:56:51AM -0700, Darrick J. Wong wrote:
> > > On Thu, Aug 01, 2024 at 04:30:46PM +0000, John Garry wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > We currently align extent allocation to stripe unit or stripe width.
> > > > That is specified by an external parameter to the allocation code,
> > > > which then manipulates the xfs_alloc_args alignment configuration in
> > > > interesting ways.
> > > > 
> > > > The args->alignment field specifies extent start alignment, but
> > > > because we may be attempting non-aligned allocation first there are
> > > > also slop variables that allow for those allocation attempts to
> > > > account for aligned allocation if they fail.
> > > > 
> > > > This gets much more complex as we introduce forced allocation
> > > > alignment, where extent size hints are used to generate the extent
> > > > start alignment. extent size hints currently only affect extent
> > > > lengths (via args->prod and args->mod) and so with this change we
> > > > will have two different start alignment conditions.
> > > > 
> > > > Avoid this complexity by always using args->alignment to indicate
> > > > extent start alignment, and always using args->prod/mod to indicate
> > > > extent length adjustment.
> > > > 
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > [jpg: fixup alignslop references in xfs_trace.h and xfs_ialloc.c]
> > > > Signed-off-by: John Garry <john.g.garry@oracle.com>
> > > 
> > > Going back to the 6/21 posting[1], what were the answers to the
> > > questions I posted?  Did I correctly figure out what alignslop refers
> > > to?
> > 
> > Hard to say.
> > 
> > alignslop is basically an temporary accounting mechanism used to
> > prevent filesystem shutdowns when the AG is near ENOSPC and exact
> > BNO allocation is attempted and fails because there isn't an exact
> > free space available. This exact bno allocation attempt can dirty
> > the AGFL, and before we dirty the transaction *we must guarantee the
> > allocation will succeed*. If the allocation fails after we've
> > started modifying metadata (for whatever reason) we will cancel a
> > dirty transaction and shut down the filesystem.
> > 
> > Hence the first allocation done from the xfs_bmap_btalloc() context
> > needs to account for every block the specific allocation and all the
> > failure fallback attempts *may require* before it starts modifying
> > metadata. The contiguous exact bno allocation case isn't an aligned
> > allocation, but it will be followed by an aligned allocation attempt
> > if it fails and so it must take into account the space requirements
> > of aligned allocation even though it is not an aligned allocation
> > itself.
> > 
> > args->alignslop allows xfs_alloc_space_available() to take this
> > space requirement into account for any allocation that has lesser
> > alignment requirements than any subsequent allocation attempt that
> > may follow if this specific allocation attempt fails.
> > 
> > IOWs, args->alignslop is similar to args->minleft and args->total in
> > purpose, but it only affects the accounting for this specific
> > allocation attempt rather than defining the amount of space
> > that needs to remain available at the successful completion of this
> > allocation for future allocations within this transaction context.
> 
> Oh, okay.  IOWs, "slop" is a means for alloc callers to communicate that
> they need to perform an aligned allocation, but that right now they want
> to try an exact allocation (with looser alignment) so that they might
> get better locality.  However, they don't want the exact allocation scan
> to commit to a certain AG unless the aligned allocation will be able to
> find an aligned space *somewhere* in that AG if the exact scan fails.
> For any other kind of allocation situation, slop should be zero.
> 
> If the above statement is correct,

It is, except for a small nit: alignslop isn't exact bno allocation
specific, it allows any sort of unaligned -> fail -> aligned
allocation fallback pattern to select an AG where the fallback
aligned allocation will have space to succeed.

> could we paste that into the
> definition of struct xfs_alloc_arg so that I don't have to recollect all
> this the next time I see something involving alignslop?

Sure.

> After which
> I'm ok saying:
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
