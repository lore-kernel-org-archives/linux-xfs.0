Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BD6374DA
	for <linux-xfs@vger.kernel.org>; Wed, 31 Jan 2024 20:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706733773; cv=none; b=N2CR3w1ITHm0b+Copt7s9wRE9zLKGxcPLhOjk9AFZElkHHrvrvOXxdzLuq9Sl7jGsvg+TFdTz57v7wC9FZvosb4Rb/7Ho8waZGpUY7H3KL8wm3nJXhQBWC/Ncv8MGeS7gwWNy451QmK2+37uUeU8n36Gg9BcLFaXiNDPv6HtFm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706733773; c=relaxed/simple;
	bh=0ttANtOrcttr7NXaqt/G0w+9AjfKy+c5thEW3pDhz3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c/YhhAZ3jIvhhjmytvrWPtqamno6G81l0RP5tnhCwtgEBS8qpQE29yK9ynBvtb1vpCSdfaD5IStmDWOYZNK6fO4o584Un77Xz2b5gjiUBXUXE/B+qqbmLIu2HCgV1s7TJ575oAHeGO12g9PtPvOyJOsf2qrHTWEFUzehjAQ2Ca0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ENa2o3JK; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ENa2o3JK"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1d918008b99so1628675ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 31 Jan 2024 12:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1706733772; x=1707338572; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4HikurBEOhu9euC7gl0ui3GG6XowXvyoYxK7m1zGW+s=;
        b=ENa2o3JK8jYa1RYoybqHhhajN7vXPeDGVwnPgMOyLNp2438iHE1aLCfbGsoBoRlcMr
         dk6dT2YyrH45ZE7R1Uz323TWe/Tcclgb8Q9er/zT2Mlmpy8wO8+92J+8F5Im4EBUzxKe
         14rf7XmzyXt9kUR2vEqHE8YYI5EZc24XCEi+0hSc0qQi0G/mAvR++ZyCA4cd/rN5iBIK
         Rge4ciJ0yNpP/tgYTHXGYiIeW/QwlbhRhXBBSRfJ09rSLVDaq0TqOOUYncnxfsPaY1Xy
         W9w50vs6qqh3wW476TzMrblmvTqMv5SAbrN9tcBohaB+Mh4cpGDLLcXwBEDzB+Fv+5lZ
         2Kxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706733772; x=1707338572;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4HikurBEOhu9euC7gl0ui3GG6XowXvyoYxK7m1zGW+s=;
        b=SYLtV2fZ4q35UyAXIky58TENfNjbsDaqn+RH+qJbRxPGu1x/bjSj8XQd4zWEBHFZvb
         syBz+sfUzlTcXrW/x4YYDeEeuO8fLueR9DX9C10Ut2prRnjEhho5hD8kSlVJ11UDdBEB
         Cy5oZLixLOeTBTulCSiHx8gocgJ5AljZIGvGuu19WD9nh43dEkVTVd7lvwuYp1x+KRj1
         1byVU5J+ilb/46hlEVynid4CtdOA4DS9OzKDdKUeT6nTKOAVafnkTpx7K8xNZNBVhHaP
         vGfN7bN0GgbBhdKBNKnREhC6Th/v6NNVLfsEuquplVvyGMGV9Xi7F+VcsNejOIhNff9t
         Lv4w==
X-Gm-Message-State: AOJu0Yy/HJmRfXrAp+Tg5VES5xZNk0f/RJ69CfSJwoDp5jJFcIi8ulNA
	2Rsi2KaMcw7PYzal02jyvDYy9iU4cfs8zfqC4cGs4GtWIGa9UMiypHmE3BNDzyY=
X-Google-Smtp-Source: AGHT+IFKgnjyHOHXjb8FWpmberef1nwD4qkIyOp+/vPJjvOfE+QEc5Mj2C0M+Fe+UDPDMwl9iwoIbw==
X-Received: by 2002:a17:90b:2406:b0:295:cf9f:a1de with SMTP id nr6-20020a17090b240600b00295cf9fa1demr2928435pjb.12.1706733771727;
        Wed, 31 Jan 2024 12:42:51 -0800 (PST)
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id db16-20020a17090ad65000b0029608793122sm225215pjb.20.2024.01.31.12.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 12:42:51 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rVHPz-000JNE-2o;
	Thu, 01 Feb 2024 07:42:47 +1100
Date: Thu, 1 Feb 2024 07:42:47 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
	linux-arch@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>, Russell King <linux@armlinux.org.uk>,
	linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2 7/8] Introduce dcache_is_aliasing() across all
 architectures
Message-ID: <Zbqwx12WfXvZ6kk2@dread.disaster.area>
References: <20240130165255.212591-1-mathieu.desnoyers@efficios.com>
 <20240130165255.212591-8-mathieu.desnoyers@efficios.com>
 <Zbm1CLy+YZWx2IuO@dread.disaster.area>
 <d30a890a-f64e-4082-8d8e-864bfb3c3800@efficios.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d30a890a-f64e-4082-8d8e-864bfb3c3800@efficios.com>

On Wed, Jan 31, 2024 at 09:58:21AM -0500, Mathieu Desnoyers wrote:
> On 2024-01-30 21:48, Dave Chinner wrote:
> > On Tue, Jan 30, 2024 at 11:52:54AM -0500, Mathieu Desnoyers wrote:
> > > Introduce a generic way to query whether the dcache is virtually aliased
> > > on all architectures. Its purpose is to ensure that subsystems which
> > > are incompatible with virtually aliased data caches (e.g. FS_DAX) can
> > > reliably query this.
> > > 
> > > For dcache aliasing, there are three scenarios dependending on the
> > > architecture. Here is a breakdown based on my understanding:
> > > 
> > > A) The dcache is always aliasing:
> > > 
> > > * arc
> > > * csky
> > > * m68k (note: shared memory mappings are incoherent ? SHMLBA is missing there.)
> > > * sh
> > > * parisc
> > 
> > /me wonders why the dentry cache aliasing has problems on these
> > systems.
> > 
> > Oh, dcache != fs/dcache.c (the VFS dentry cache).
> > 
> > Can you please rename this function appropriately so us dumb
> > filesystem people don't confuse cpu data cache configurations with
> > the VFS dentry cache aliasing when we read this code? Something like
> > cpu_dcache_is_aliased(), perhaps?
> 
> Good point, will do. I'm planning go rename as follows for v3 to
> eliminate confusion with dentry cache (and with "page cache" in
> general):
> 
> ARCH_HAS_CACHE_ALIASING -> ARCH_HAS_CPU_CACHE_ALIASING
> dcache_is_aliasing() -> cpu_dcache_is_aliasing()
> 
> I noticed that you suggested "aliased" rather than "aliasing",
> but I followed what arm64 did for icache_is_aliasing(). Do you
> have a strong preference one way or another ?

Not really.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
