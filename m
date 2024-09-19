Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DF414A82
	for <linux-xfs@vger.kernel.org>; Thu, 19 Sep 2024 01:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726710200; cv=none; b=BmRZB72QyVRpYqAeQtxT+6kdlQ299a+WsRrDqRl1D4LHsWx05eAiW7bWpeVgAWiAHeQd673+pL8KHcO0GsZHP/smlZhBDvxf24mGhDZ6Vhc0GJWe/RrTVmNLWBwTjFBTyZLhpFvwyXxAKjv1SbbTAh7PiMk7I/VpbLnA1hjugw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726710200; c=relaxed/simple;
	bh=oNXPqtyDgLu9Kh2ue6NBD6CfWTrY2WHFnxBQrLR39sg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=av7xSP3zGwD17hW+ECugot2v1IJJhi4yMzLnYFS+k0rWzaLBzTLu+zQ403HtsypFwiqkTpnrmt5IqO3nmWLU+PlysFbMZTFFWUCMST8Bz5lR1NKxcqxBjy7jj4b2p599r7jpWOnDHoYsuUeYiLE7ctqVOtFBwmj8ijJwXD3kBhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=zBDJ6s/7; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="zBDJ6s/7"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7193010d386so236760b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 18:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1726710198; x=1727314998; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+jwxQJbxpwl4voWuXzYITDQeat0ESjsMo2U9Mc7bSDY=;
        b=zBDJ6s/7s54hp1CPEEoM5xvQtVnHO9JpYjNVxYHuwzcCmu0iUhSxVkE1Nz3Qa7lNdP
         /1cxGp7hj9VIbmrZvqdfkEv4CNhjjqNYgJKbLcplGlWvuwch1HPxXgoXPAfDS8ilZfMF
         cLxTIeLj45WtloEoPSfyGPGQSN3CVJPq0H8g7P9oX+ffFL8vvdbD3+m5ZpWtfMnu5AuI
         XMtXmNGFzwVw3D6hFPoVVGcYqaaJ+IBpdMfNbF1j4Z1sc2WXoB47QYRstLaH0Gjv19r4
         YJlXquYfhTpv3wP/Mq2RkBeUmvl3vy1sHoZKx9Hf3FZ9jq0XAwGK9sJG2RoQyYr+gZgL
         h28g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726710198; x=1727314998;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+jwxQJbxpwl4voWuXzYITDQeat0ESjsMo2U9Mc7bSDY=;
        b=ezeKGwdkFOlCgBPZ5OlqVKsq2o2IiwSh+/paTEkJ5VpvOUoeaEloxfLJeVorHYeQ8G
         X4mqpX6KTh6R8Y11BSirR+sNuO90ufh3Cy3ZYOOdGviM44XZg7iuR6amnzVZRZEoOlxg
         Zdu7XhoiRtPDjsmzYtYGaCkCfXw6PIhlG3dYQaob22KkEss21ep1YSprPTWFYjBj8L2m
         Srytm7wEMYziSS556hygx1TFzAbpozvvHuISkzwb/XpkpU+QqyHr2OFUwOsEXXjDIA7T
         EDmkwKUpimDxsSD49DUxwoXg+ChQp/7DK25+x6293fC/QCPYVD09IUUr7XDZbM8JJ2av
         kepg==
X-Forwarded-Encrypted: i=1; AJvYcCW668tZSYafXjgZKtrPG1aVhYxLh5bwLG20u/YXM3WVPWEuVTjTaZFJXyLP0BQrCmf3lv2Z+4twdsw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyeKKs9ge2YzKHJJbVxoMfZK6OgF/0tp7ylEb+kBpiDuGrUAfDp
	ttvIRv9JPdJeoGzwjpvxv/IaDke08E/TWY+dqSE3olYV2BLbrOiSt96Wr2zhH6k=
X-Google-Smtp-Source: AGHT+IHP3QnTzJJQUGix1BZtfPAN61RzG3kG6wmczzL7AUu1v04MsD1wNi6JBs9VM4Ciz1/aEAynVA==
X-Received: by 2002:a05:6a21:3942:b0:1d2:bb49:908b with SMTP id adf61e73a8af0-1d2bb499130mr25408416637.18.1726710198379;
        Wed, 18 Sep 2024 18:43:18 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-719918df7ccsm150940b3a.40.2024.09.18.18.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 18:43:17 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sr6CR-0072c8-0x;
	Thu, 19 Sep 2024 11:43:15 +1000
Date: Thu, 19 Sep 2024 11:43:15 +1000
From: Dave Chinner <david@fromorbit.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Chris Mason <clm@meta.com>, Jens Axboe <axboe@kernel.dk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Theune <ct@flyingcircus.io>, linux-mm@kvack.org,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Daniel Dao <dqminh@cloudflare.com>, regressions@lists.linux.dev,
	regressions@leemhuis.info
Subject: Re: Known and unfixed active data loss bug in MM + XFS with large
 folios since Dec 2021 (any kernel from 6.1 upwards)
Message-ID: <ZuuBs762OrOk58zQ@dread.disaster.area>
References: <CAHk-=wh5LRp6Tb2oLKv1LrJWuXKOvxcucMfRMmYcT-npbo0=_A@mail.gmail.com>
 <Zud1EhTnoWIRFPa/@dread.disaster.area>
 <CAHk-=wgY-PVaVRBHem2qGnzpAQJheDOWKpqsteQxbRop6ey+fQ@mail.gmail.com>
 <74cceb67-2e71-455f-a4d4-6c5185ef775b@meta.com>
 <ZulMlPFKiiRe3iFd@casper.infradead.org>
 <52d45d22-e108-400e-a63f-f50ef1a0ae1a@meta.com>
 <ZumDPU7RDg5wV0Re@casper.infradead.org>
 <5bee194c-9cd3-47e7-919b-9f352441f855@kernel.dk>
 <459beb1c-defd-4836-952c-589203b7005c@meta.com>
 <ZurXAco1BKqf8I2E@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZurXAco1BKqf8I2E@casper.infradead.org>

On Wed, Sep 18, 2024 at 02:34:57PM +0100, Matthew Wilcox wrote:
> On Wed, Sep 18, 2024 at 11:28:52AM +0200, Chris Mason wrote:
> > I think the bug was in __filemap_add_folio()'s usage of xarray_split_alloc()
> > and the tree changing before taking the lock.  It's just a guess, but that
> > was always my biggest suspect.
> 
> Oh god, that's it.
> 
> there should have been an xas_reset() after calling xas_split_alloc().
> 
> and 6758c1128ceb calls xas_reset() after calling xas_split_alloc().

Should we be asking for 6758c1128ceb to be backported to all
stable kernels then?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
