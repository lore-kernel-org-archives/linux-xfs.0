Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CE929D01
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711430988; cv=none; b=HBpPV99zYMZVfWBa3cKu4bvFonGAfNPO/dY3WWOnWr0sI5p2dJWj15aE81ceiet6sTKipuMaRaQDMfF3Kx+Keh4tbzdR9ySKhU4E7NFFoS+bMPLsub0Wp+N6O6FjBvbDemphScQEG1xyWXAhAd1Jl/1E0dkARacL6IV0NV/Fv4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711430988; c=relaxed/simple;
	bh=oeLaR7ekWVZqaGKgPixVTwbtrEY4bq6cr7YvYY8xnWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cv6R3zo6OGFSrnM0JfggHzFyWKGQdwtpteZA7UF9VgeNCpt4mDHkzyzPKyv7tf24tcEgtl+BpYzUmFhlbtUlUCBVUORRjmr04j8yMVFhuEFBPLobs01jy1JOpErqLKgdNfJpmf4tFqbDZ7iah+kO30xKPsST48VICP2BBpfc0+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hyEiZMc4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hyEiZMc4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Y7u8Eo/XLevgJJO4L4iMFzJ+0jsF1uyUwwznW54076Q=; b=hyEiZMc4Z4BGxJ6fNkoPJnFKNh
	Lb1cEYrvQE8r14kZtYOtIGIcviCnnFdlbMdOxHDLxMERYpahlBJEY5bJmpP/6B5AQssVVb/0P1p3t
	lQc5snDn0ZNtvjopxNCWDus0qZSE5XHCmvD2dWZJJEPa3SOUeeNSXLg9wvZEEU8ndUDS75UalJze7
	Mbm0ex1k2a/wdqmGyCrpXE/CgMF80oTx/sxxgDAMmuHQEvGhAyb6TYMCtyjDf8xRu2xj9pI8Re7OQ
	WQsIRVLDsjShQeYJqnAJEjIIOtNccmMvTnTMF5z5rsBY4DpHELPAVeQqpmnaaxMOqL4SY/PsJC5jQ
	hJLvjWIg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rozNa-0000000394s-2EjZ;
	Tue, 26 Mar 2024 05:29:46 +0000
Date: Mon, 25 Mar 2024 22:29:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 089/110] libxfs: add xfile support
Message-ID: <ZgJdSnLbTlY4ZW8s@infradead.org>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
 <171142132661.2215168.16277962138780069112.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171142132661.2215168.16277962138780069112.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +#ifdef HAVE_MEMFD_CLOEXEC
> +# ifdef HAVE_MEMFD_NOEXEC_SEAL
> +	fd = memfd_create(description, MFD_CLOEXEC | MFD_NOEXEC_SEAL);
> +# endif /* HAVE_MEMFD_NOEXEC_SEAL */
> +	/* memfd_create exists in kernel 3.17 (2014) and glibc 2.27 (2018). */
> +	fd = memfd_create(description, MFD_CLOEXEC);
> +#endif /* HAVE_MEMFD_CLOEXEC */
> +
> +#ifdef HAVE_O_TMPFILE
> +	fd = open("/dev/shm", O_TMPFILE | O_CLOEXEC | O_RDWR, 0600);
> +	fd = open("/tmp", O_TMPFILE | O_CLOEXEC | O_RDWR, 0600);
> +#endif
> +
> +#ifdef HAVE_MKOSTEMP_CLOEXEC
> +	fd = mkostemp("libxfsXXXXXX", O_CLOEXEC);
> +	if (fd >= 0)
> +		goto got_fd;
> +#endif

Is there any point in supporting pre-3.17 kernels here and not
just use memfd_create unconditionally?  And then just ifdef on
MFD_NOEXEC_SEAL instead of adding a configure check?

