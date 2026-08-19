Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC5C302753;
	Wed, 19 Aug 2026 07:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787123105; cv=none; b=kaYZHaoDhD2NRH4ybvge8mOFTeXGY21ziJd3DZaX2MATHs613OxNYb1pSYWxL40C4b+2e9Ur1N1vYVhWFoRIEqclfUufMQv7ammhGGrtUYW8kaVlswLXNU2KL449zr0mDtN//4DCvkz6rXoHMmis6O5iEm7Ht2Uw5juI43bhhU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787123105; c=relaxed/simple;
	bh=9umQ3CmQ+ZT8dXt0L1dUfegVyXh/ATX7zvsbsvo+4ew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I0y/tNqlHlA4MMGuoshZ5lRfPnc73qdIEntn03dSQypqtwTuqf0J9Sl+Iik7LtgvBidfatj3p+TxV1Cgmq2XPyCC7zNPAk1HH8yAMIAdFOBiB4+In8oyezhNgGb72SC6WgMzSfjaA7DJS8PrktOjKDTOf9WdSMXmPiEDAIxoid4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7734C68C7B; Wed, 19 Aug 2026 09:04:59 +0200 (CEST)
Date: Wed, 19 Aug 2026 09:04:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Kanchan Joshi <joshi.k@samsung.com>, brauner@kernel.org, hch@lst.de,
	dgc@kernel.org, jack@suse.cz, cem@kernel.org, axboe@kernel.dk,
	kbusch@kernel.org, ritesh.list@gmail.com, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH v4 1/6] fs: add write-stream management ioctls
Message-ID: <20260819070459.GA1541@lst.de>
References: <20260717125538.508925-1-joshi.k@samsung.com> <CGME20260717125627epcas5p3f5ad1cf917d563cc061e571b2f932319@epcas5p3.samsung.com> <20260717125538.508925-2-joshi.k@samsung.com> <20260721030338.GU7380@frogsfrogsfrogs> <71ae458a-a6e3-4c6f-8fb9-7e8bc088bb87@samsung.com> <20260730172211.GF3556460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730172211.GF3556460@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 30, 2026 at 10:22:11AM -0700, Darrick J. Wong wrote:
> "The third argument is an untyped pointer to memory.  It's traditionally
> char  *argp (from the days before void * was valid C), and will be so
> named for this discussion."

That documentation is wrong or at least very incomplete.  A pointer
is the typical use, but there are plenty of ioctls passing scalar
values <= sizeof(long), going all the way back to early UNIX days.

> You can also see this reflected in the discussion of the R/W/WR variants
> of _IO:
> https://docs.kernel.org/driver-api/ioctl.html

_IO* are optional helpers, and plenty especially older ioctls are
defined without using them.

> Granted your kernel code can treat that argp as an integer and not a
> __user pointer if it wants to, but that goes against most ioctl
> implementations.  Further, subsystems that marshal ioctl information for
> passing through to another layer (e.g. fuse) assume that the third
> argument is a pointer and that it can copy sizeof(data_type) bytes at
> that address in and out of the kernel as part of marshalling.

That is not a good assumption and things will break.

