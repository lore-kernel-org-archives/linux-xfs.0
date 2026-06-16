Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0562475F7
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 13:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781615708; cv=none; b=YIMxNDYXFmSEFV4aUQrG2JbgwNjpS8Jqax0qHI77qRlp17IbEw6kXVGXs0TcKQGbuqDBRTOU95F/d5QR0oIZzcfR0NTMpUUI57tUUHrAoSAVI0+KlmEhluFn+8srQsUQCB4NmTA7V2Ii33u0bgMTKLYEqBzGK84Cn3qmwkjWj4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781615708; c=relaxed/simple;
	bh=j2qR4I27J/QRoxljowtUQqGLf+US/UgcHQcee4nn1+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QDOacAotgCgl9l+QcDAu84X33nkiwWiDQMiJueHTOl2uvwgZw1m0EgyNn8A/IwoacUvE8/vgCkJuzXsvchHVugUMphY0wI378rGEtiLawbGuJwd9GNE3TDwLJX349FuNelfG/Vq+dOFB0+Vqw6oRvx8KOYydOg0c068PIraza+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GiRnGQwu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GiRnGQwu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=j2qR4I27J/QRoxljowtUQqGLf+US/UgcHQcee4nn1+0=; b=GiRnGQwuOfXH8/W+onmaM65DWR
	PyATCvixHVLmndinHArshDu3IjeGy75PdmjSSw2ZVPTuASfKzKUBJFhZ2hBYHEeTK+TEA556KTnHX
	gmRihY+GMgF6rRpBEmhYKVKLSfR2v32dge1W0sIxbpPbD1wVis3VSnp7ksDytLFRbYYnSRZoHPA+C
	I92KMGE1sb2VTdjLkvEGJbZETGuTav6/r1dzA4pNP/7DI1Cy5cTSnjqkMcPMxQr10CYkfsnB3S3Aq
	s0Jf4meJP2hnKUSek4DMlOJeZUXIAZvGCGaAapXA+GzuKy1NK+ZmTS37L3+aFzXAy54O+N/UgCwxU
	KxtO0BGA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZTd9-0000000Foxj-42tu;
	Tue, 16 Jun 2026 13:15:04 +0000
Date: Tue, 16 Jun 2026 06:15:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, lukas@herbolt.com,
	"Darrick J . Wong" <djwong@kernel.org>, dgc@kernel.org,
	gost.dev@samsung.com, pankaj.raghav@linux.dev, andres@anarazel.de,
	kundan.kumar@samsung.com, hch@lst.de, cem@kernel.org,
	hch@infradead.org
Subject: Re: [PATCH v6 1/3] xfs: widen xfs_setfilesize() size argument to
 xfs_off_t
Message-ID: <ajFMV-mauHAgWZtv@infradead.org>
References: <20260611114029.176200-1-p.raghav@samsung.com>
 <20260611114029.176200-2-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611114029.176200-2-p.raghav@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jun 11, 2026 at 01:40:27PM +0200, Pankaj Raghav wrote:
> xfs_setfilesize() takes the written length as a size_t, which is only 32
> bits wide on 32-bit architectures. The upcoming FALLOC_FL_WRITE_ZEROES
> support calls it with a 64-bit fallocate length that can exceed 4GB.

Others might be better than me in arguing what type the new size
parameter should be - xfs_off_t looks a bit odd, but the VFS uses loff_t
for the length which translates to xfs_off_t, so at least it is
consistent.

Reviewed-by: Christoph Hellwig <hch@lst.de>
