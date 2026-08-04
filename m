Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8075D3E5EF1;
	Tue,  4 Aug 2026 18:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785867896; cv=none; b=YwHSuMa5S4LgAtmFImIqs13kY5ZO9cdwZYWmFfLLazA0x29pPH+0vMFcIWlgyTCT/yaovjROG0xH77M7qci1c9I0yllGchH+mGwUUCuSiiu6sf6OhizAZjwhOC7mdfFDLcT+bqzGBhoY8l7bYFUeaOfswuShFaHWhntwK5UdFgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785867896; c=relaxed/simple;
	bh=GIb6iW8sSEZ13YQfLq9sM4Ji8Nm52lTPT3QowAx3jPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UfoZxZs3QANoUgL7Nb2kXk9QxCDF3IxAAjWMTtZo4I2Z9blUExQUPZdW8Pz5Kjkd7qPNAndsX3tcTU0SEqXZh5fBrAaAujzW3wfrJjBT7ThA96vRkFhrgWOcZNsJBVEoxue5EWzdL8sTCecaKFUqUmqavcBuo5lGnaOJZzJ9li0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e3G4Q9Q3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e3G4Q9Q3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0DC1F000E9;
	Tue,  4 Aug 2026 18:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785867895;
	bh=ABzXFS1cHdOS7LhNVaYwD3Z82Do0sMylapiPW/GnJdo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e3G4Q9Q3CSdHX6kBynKoFfnLeUWV2Kd0bDryv2PEUvwl95G15JEK/5Yp8egrYuprx
	 dmHi6DfgfBEEn93ILJz0C8AXFd5QxE5/Z/6uqhF942ktUDNpPaRm9Ji8e9istL+8Mb
	 GMwlfmnSyqqYhTt0hN84H989qQIUAc1Mxvy7YcIhYaMSymx3XWEkQEZJwoILMTk+Dn
	 dqRz+wkMgQyIUVencHoEQKxP3/yPbhsssdqb36a5hsKJUj2wX+sfhsFbp9mx0i+6SJ
	 Qzqqi2Rk4iQI5wqTRGy2DnQeuKb3BtE/WiKMw68lf05ZJn3qj32fuf1PU7b3LnuzF5
	 CQbY+szG+4JJw==
Date: Tue, 4 Aug 2026 18:24:53 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v14 11/21] xfs: don't report dio_mem_align and
 dio_offset_align for fsverity files
Message-ID: <20260804182453.GA2904385@google.com>
References: <20260803200820.393203-1-aalbersh@kernel.org>
 <20260803200820.393203-12-aalbersh@kernel.org>
 <20260804174347.GC14046@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804174347.GC14046@lst.de>

On Tue, Aug 04, 2026 at 07:43:47PM +0200, Christoph Hellwig wrote:
> On Mon, Aug 03, 2026 at 10:08:01PM +0200, Andrey Albershteyn wrote:
> > Sashiko.dev reported that while fsverity files falls back to the
> > buffered IO for Direct I/O, they should not report non-zero values in
> > dio_mem_align and dio_offset_align, meaning it's not supported.
> 
> This doesn't make much sense to me.  If we didn't want to report
> we'd also want to not set STATX_DIOALIGN | STATX_DIO_READ_ALIGN.
> But in the end there is very little upside of this while adding
> extra special cases.

Zero values in the alignments are defined to mean that DIO is
unsupported; see statx(2).  It's right to do that here and also set
STATX_DIOALIGN | STATX_DIO_READ_ALIGN, as that explicitly reports that
DIO is unsupported.

Leaving the attribute flags unset would mean not reporting anything at
all, which could mean DIO either supported or unsupported.

Acked-by: Eric Biggers <ebiggers@kernel.org>

- Eric
