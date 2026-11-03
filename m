Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717628;
	b=hbfvVQ442YFshcok//kuQI8P+ZOR2JWG0hVzoB7FvuMvLueZdTVKiJlMKdO5xFh1u6Iv
	 5Rvas9jaczOZP8xUIwfX1/W0Z1BBYYRTrOcUQjJLr2TRIeieLoxBi29TLkN+sgxpA9vMJ
	 SPcwG3T6e74JG3kptSE9Byviq1toFuArJE5GT1T1d1OIEn8DxHwCEuNm9b6ODIdyCsESd
	 pt3PkHITD+SrC5hBulzP+nGv4RP0gfIsgTBlKs5CITj2nCEEtulMqzVhR4ftJeaF4J4PF
	 eOu1gcERBXgne1kcuPM0l2BVYjdm/6T8QnjjtuyXn1E4THt5tCkfx5e1LM7n3lCJ8AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717628;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=JjreI85OqGbxgW6CdMTI2hY2urQgS8/ZfMD6qbkwVSY=;
	b=PA5wGkrMHqVnMg+BOF3uhaRqTpNmMxJNUh6ER8oRzK59KCB48XJK7cLaGkr3al/XRaAp
	 K5LZO2WrFCjNvTPFooa5emjrWwAdRTv3dFpoeBEKzwxHQkC3yT06WW0Gjafeo2xz5sEMi
	 CEHAZTjjIS0+5V7rKlt96WbI6NhlZnlvjoj876pGnCFk80CWG24C1i0XGaGjwwoffDGlA
	 zrxSqFFChviLRz3xWjAL0mG050OewG5jqwRvGSwnIjkOsTSVYQiyZf+T4eMZTxum60o/M
	 vLLMJcJHsX2v79RPKuBCayzInhO9WT/set4NDB7NH/v/jWYN5GfAl/2x7owx6YTO7QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=ejykHRwD;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A04606C84E;
	Tue,  3 Nov 2026 14:53:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13A04606C84E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=ejykHRwD
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JjreI85OqGbxgW6CdMTI2hY2urQgS8/ZfMD6qbkwVSY=; b=ejykHRwDPsXXpDNHyGhK0ZiKJV
	LjtsvdoqHBKJ/FUhjkmhnLb3cOk1EqdLmuHyM+il4VOnwoV28kLIXc93f5fBGX8/79fn3ZWAjmzWu
	odEJrRyuxxc4o01NsTyC3EhF2LaPdw2POe1P4adEdYStADApxu9So36mm3APfsvVNiOxqmNjhG7xc
	7fXaH2FnIRpwZawf9SzYT4Dlo5MyybEbHfHikyIS/u37PDHcIBdDzp4mOVUdJNQjAoSgNYP5SZ/6h
	ScYdf5qTwZuv1GM+Et5kxfb6fcAii1NA5ZuLeXLqgb99KgGl7mRIEtNIApBR5O4tJT8jbrrOczeJP
	rSPgxhHw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOFtT-00000002oKI-1ogY;
	Tue, 03 Nov 2026 14:53:47 +0000
Date: Tue, 3 Nov 2026 06:53:47 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, ebiggers@kernel.org, hch@lst.de,
	Carlos Maiolino <cem@kernel.org>, fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	david@fromorbit.com, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v18 05/15] xfs: handle fsverity I/O in write/read path
Message-ID: <aun1e6gedSrVDuRQ@infradead.org>
References: <20261102144147.2393369-1-aalbersh@kernel.org>
 <20261102144147.2393369-6-aalbersh@kernel.org>
 <aumrai1iWxj97svo@infradead.org>
 <aunQUzz7AV-qvys-@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aunQUzz7AV-qvys-@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

[Note: a question for Eric about lifting a flag to the VFS below]

On Tue, Nov 03, 2026 at 02:55:48PM +0100, Andrey Albershteyn wrote:
> > Is there a reason to not just move the IOMAP_F_FSVERITY handling
> > into xfs_bmbt_to_iomap?  It would break if single extent is shared
> > between data and verity data, but we already leave a large enough hole
> > that this could never happen, right?
> 
> I think it can be moved to xfs_bmbt_to_iomap(), but we will need an
> offset there. The one extent case could happen if file size is
> exactly 64k and we got continuous phys space allocation with merkle
> tree (then the extents will be merged).

Or a multiple of 64k, yeah.  I though we went for an "air gap",
but I have to admit I forgot all the details of this already.

I guess passing an offset it is then.  And maybe also add a comment
about that while you're at it?

> > Sashiko complained about this, but I also really don't understand
> > how setting ctx->iomap.flags before we even get a mapping to start
> > with make much sense.  This should be set together with filling the
> > iomap either way.
> 
> The problem here is that when we found a dirty folio to writeback,
> and we know it's beyond EOF, how to find out that's it's fsverity
> folio. We don't have any fsverity metadata attach to an inode yet as
> we are in the process of creating it.
> 
> This is not a nice workaround here, but I use stale iomap.flags
> here. So, every next folio in that iomap has the stale flags from a
> previous one, which has fsverity set. This should be fine as the
> only folios written, at this point, are fsverity metadata.
> 
> Here I set it for the first folio in the iomap, to get it started.
> Otherwise, writeback will just will not continue on folios post EOF.
> 
> This could be probably done by elevating "verity in construction"
> into inode_state_flags *shrug*

Lifting the flag to the VFS feels like a good and nicer than finding
backways communicaton channels through iomap.  And once we have more
file systems supporting fsverity a common flag vs one in each
file system might be worth it even without that.

Eric?

