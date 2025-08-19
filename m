Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAEF288DA
	for <linux-xfs@vger.kernel.org>; Tue, 19 Aug 2025 21:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755639922; cv=none; b=X6doofZivd8pqsRjrQ61LIrNEm4kvGbMhJSCQz1j3ti/Iorr/fTiX7ZxviC1a0zcPn0ieW1kSvIjD5CXDwLIdmDK4BPtFB5BMipthCUDT58smt1GT+kkM57TnuLRB6T5MxBheJt+D8FdF4ogLvfZU8ozIkJBZn6Qyaqq0xqCtm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755639922; c=relaxed/simple;
	bh=ZcAhBxa6tVgz8fqBMZGeQoML7DFI4LV22kBw4VN1YAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PZbCRMVvIMki4biLoj7f56eamXIqovmrM7fCf7m0q/dfL1mV/i+vXJeSAXY5lt6mnFWxCKPXYgalRyGA/OspY8hbKvfsOoTi/Yf84GwLwtSyPmRIc5r85i3ZvxK0bDEc6M9vr+WlsCSRZxjZwbgXzWtdzpE1uhiyP+aN/vNhy1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=3M23+qrj; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="3M23+qrj"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-32372c05b79so2577897a91.0
        for <linux-xfs@vger.kernel.org>; Tue, 19 Aug 2025 14:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1755639920; x=1756244720; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oLUwQDbh+jEJ0zbDYQmRO3UACFm1vPVShe3kY9X3DL4=;
        b=3M23+qrjwFLAh5srZg7QafjtoMNUy5mt70J3LyyNEfmuVFaMq4j1xx5fTNg8DfsOtu
         g1Vhi4oC66lyLhrn5rcJ+tXpg+bv2ZRMyytC0FWBaPDceSQhfmpmcy48h51PHdv45LPI
         2HpWetAecNhmpli/80qVn+rZHJeotLMqD2drnmLn3OhGPPaPpGm0uExwdlROo6NoZ1aN
         nls2SIB3TujLWLOK1SeLpW7gJgRhgHWhldh6M9O0sUoBrqCUz3htprwAnb/rdptdRj8o
         /2G6TmC5d2ieEYEIA5FEv58Q6rIFnkxLkONRYTE3eAEf9VVLJgL+gzz7NbtoxJhLZXCj
         511Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755639920; x=1756244720;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oLUwQDbh+jEJ0zbDYQmRO3UACFm1vPVShe3kY9X3DL4=;
        b=dMkQCz930mQUsTMycddtv9x0fzq9NpJGE8YmRX4kqGdZUJ0eNMD7Ke/Ts1z32zMNwq
         Ch/sW/QEnQ5puwRfuqv6lzEajGukAc+Idb6MGFjGcQFxFo+opOq7asH9qqJ6UTbZNVjX
         gyyP0LJvuciKKUj9cV4fukO9YH4DyzuKBG7s5g/WBNzqkEMJxIF2obosX7G4cK+QcyfT
         LpqLd2gk0CXc/6fZu9oHUqvdaufvbEwvTrHt9woVQj3h2CSFI7RJkOPr7G7ZgZkWMriA
         96+42ZW32zJHd7NtVOvH/sn/ayFCVVLYNxwZpI/lv/2qj9zFQJSYfmYpIic8b9RD/P1P
         6gWg==
X-Forwarded-Encrypted: i=1; AJvYcCVN3f6jl2TT867k/m+ULX0d/CHi8w9rYwc7z71qMPUisrZiH/6zFALS5lG6snmE1JuWmh65u426oKE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqWxlqQEsak6m7td8SHPbfwekTVeMHsKulO2EvJyDcgkd2MGiy
	wfFg2SXF3fAFbtkvkH1F3Zbb8UGyDQmWyorG+brmmIOtI/wfOeeXlat6Nhi/Jizurtg=
X-Gm-Gg: ASbGncsF/ciQIxInHef+0zZCON/+TH06yNfQ7UGwSHutguMMVgyhaIA6wwqAj3vcQBP
	QsumLgqBu3jCk9umhFWNHOv4GmYM34Ioe2JmRBjXeA8DJHwDrR0AouhydFRR7xOtH+k+lJyaOlW
	Wc1DC8u5wyxM+DvRtiHiC3zAdsFFGS8RO1Cj2GtJsxUTZp0adF2zu1t6McM3GniqaALtJRE41tb
	KTjftUpOuK51aVImSxwBxFjohzs4/U5vB+qtIjlVIfPpr1hGTWKAwBlM07fVstiQ2m0cA+i1PzO
	MNNVvvElqVHeZFYS9EGEQ44mew3vHYySAAPQMfqguc2BySOAPfR45IQ5ZMsRIK1HMngUvEVBII1
	nbsfwVwDEl0qwRD2QSKkwD5+gtAVMzPdiLFIt2m6OaC8pUSfPSWpkxouew2eYcgVIvOqlisoPZA
	==
X-Google-Smtp-Source: AGHT+IH8smY6hkj4HFFQyTVVDmxyLlL6LVy8rMx6LbaxCrQ1UmE1EpWrclcw99bH4BFCOGh8o3u+wQ==
X-Received: by 2002:a17:902:e84c:b0:244:9bcf:a8ef with SMTP id d9443c01a7336-245ef150660mr5969435ad.18.1755639920042;
        Tue, 19 Aug 2025 14:45:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-245ed4c707csm6647955ad.69.2025.08.19.14.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 14:45:19 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uoU8q-00000008XVp-2bye;
	Wed, 20 Aug 2025 07:45:16 +1000
Date: Wed, 20 Aug 2025 07:45:16 +1000
From: Dave Chinner <david@fromorbit.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>,
	Eric Sandeen <sandeen@redhat.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Donald Douwsma <ddouwsma@redhat.com>
Subject: Re: [PATCH RFC] xfs: remap block layer ENODATA read errors to EIO
Message-ID: <aKTwbJvRP1PA-vit@dread.disaster.area>
References: <1bd13475-3154-4ab4-8930-2c8cdc295829@redhat.com>
 <aKQxD_txX68w4Tb-@infradead.org>
 <573177fd-202d-4853-b0d1-c7b7d9bbf2f2@sandeen.net>
 <aKSW1yC3yyR6anIM@infradead.org>
 <0d424258-e1ba-47c3-a0ae-60e241ca3c7c@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d424258-e1ba-47c3-a0ae-60e241ca3c7c@sandeen.net>

On Tue, Aug 19, 2025 at 10:38:54AM -0500, Eric Sandeen wrote:
> On 8/19/25 10:23 AM, Christoph Hellwig wrote:
> 
> ...
> 
> > The one thing we had a discussion about was ENOSPC, which can happen
> > with some thing provisioning solutions (and apparently redhat cares
> > about dm-thin there).  For this we do want retry metadata writes
> > based on that design, and special casing it would be good, because
> > an escaping ENOSPC would do the entirely wrong thing in all layers
> > about the buffer cache.
> > 
> > Another one is EAGAIN for non-blocking I/O.  That's mostly a data
> > path thing, and we can't really deal with it, but if we make full
> > use of it, it needs to be special cased.
> > 
> > And then EOPNOTSUP if we want to try optional operations that we
> > can't query ahead of time.  SCSI WRITE_SAME is one of them, but
> > we fortunately hide that behind block layer helpers.
> > 
> > For file system directly dealing with persistent reservations
> > BLK_STS_RESV_CONFLICT might be another one, but I hope we don't
> > get there :)
> > 
> > If the file system ever directly makes use of Command duration
> > limits, BLK_STS_DURATION_LIMIT might be another one.
> > 
> > As you see very little of that is actually relevant for XFS,
> > and even less for the buffer cache.
> 
> Ok, this is getting a little more complex. The ENODATA problem is
> very specific, and has (oddly) been reported by users/customers twice
> in recent days. Maybe I can send an acceptable fix for that specific,
> observed problem (also suitable for -stable etc), then another
> one that is more ambitious on top of that.

Right, the lowest risk, minimal targetted fix for the problem
reported is to remap the error in the attr layers. Nothing else is
then affected (ie. global changes of behaviour have significant
potential for unexpected regressions), but the issue is solved for
the users that are tripping over it.

Then, if someone really wants to completely rearchitect how we
handle IO errors in XFS, that can be done as a separate project,
with it's own justification, design review, planning for
integration/deprecation/removal of existing error handling
infrastructure, etc.

We do not tie acceptance of trivial bug fixes with a requirement to
completely rearchitect fundamental filesystem behaviours that are
only vaguely related to the bug that needs to be fixed.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
