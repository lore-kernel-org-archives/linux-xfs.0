Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5943ADBA2;
	Mon, 21 Sep 2026 08:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789978967; cv=none; b=tPR0S5TbkDSCgGkywEyOt9535JUc2xl2/n6y0Osn6SgOqFsxTIEQ20dSf0KWSsKebdhPjTbh9Sc3fi2jFRwoai8bJhrB+Hb55UEuaeABdcxneyeN3mUr7o86qMg0aVI40iewuhwrOjvADAyI9c/4pwW+UD4tEn5xsrFTZN2EtpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789978967; c=relaxed/simple;
	bh=f0PWFQhau7H1t+kAwksDAgLgoeg/2x1qOVl/fF8u5rM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LJVf23Iyd9Mreubkl+9n3aBSq19bc2OvQrMJlNAtOrSHQMwneZSnFc2FHZfGN3mt3FqBkUNd877yAaTeSGSt12UNnKE7py9X8oCbu7SrEJhg7sVTBHAEAN67GSBlGxSiwj+5XhoWzFBAYbVM4aTmL5xujVKJbRkilaXM0TAT5wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 05CDC68B05; Mon, 21 Sep 2026 10:22:41 +0200 (CEST)
Date: Mon, 21 Sep 2026 10:22:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: 0wnerD1ed <l7z@0b1t.tech>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 13/16] xfs: add support for lazy direct read bounce
 buffering
Message-ID: <20260921082240.GA19833@lst.de>
References: <20260909060924.1102037-1-hch@lst.de> <20260909060924.1102037-14-hch@lst.de> <arDN1UdZIydNLUjz@shinmob> <CAKTh27_szTVmVmV26ASynzdJUwQEe49wCxMNq5ifRH9z7tiykA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKTh27_szTVmVmV26ASynzdJUwQEe49wCxMNq5ifRH9z7tiykA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 21, 2026 at 04:05:52PM +0800, 0wnerD1ed wrote:
> Thanks for the report. I've taken a look at the v3 series. block/046
> deliberately uses iovec lengths of 1, one logical block, and one logical
> block minus 1 to create the partial extraction state that exposed the
> original double unpin.
> 
> Patch 13 stops passing IOMAP_DIO_BOUNCE to iomap_dio_rw(), so the
> request now goes through the ordinary bio_iov_iter_get_pages() path
> first. That path validates each iovec against bdev_dma_alignment(),
> and the one-byte first iovec is rejected with EINVAL before it is
> pinned and before xfs_ioend_submit_read() can select lazy or always
> bounce mode.

Yeah, and this is supposed to be rejected.

> Setting csum/read_bounce to always therefore would not make this
> particular request reach the new bounce implementation. Patch 16 also
> removes bio_iov_iter_bounce_read(), including the special bvec layout
> that block/046 was written to exercise. Changing the helper to use
> aligned input and forcing always mode would test the replacement iomap
> implementation, but it would not preserve coverage of the original
> regression.
> 
> I have prepared a minimal local blktests change that keeps block/046
> active on kernels using the legacy implementation and marks it not run
> when the mounted XFS instance exposes the new csum/read_bounce
> interface. That preserves the existing fixed-versus-vulnerable
> coverage without treating EINVAL as a successful result. A separate
> test could cover the new lazy and always implementations with aligned
> input and an oracle appropriate to those paths.

Sounds good, although trying to exploit things with two small bio_vec
in general sounds like a good idea..
