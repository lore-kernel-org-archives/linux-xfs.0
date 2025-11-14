Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA573016E4
	for <linux-xfs@vger.kernel.org>; Fri, 14 Nov 2025 08:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763110634; cv=none; b=MhF6XU4T4GPGs1V5ovzVJh92QXLd7AChSMpmW0Zfp7wqL9KwJLnahcnGcr0FXvge9N9uy74K8XLRLlW/ickZXwT1TqkS9UHS9FKqruDSdnN3h2KUd0DsAQF5ugiWTLxTNoJHnEmV2iHxf3N/mXhM3Y8HDaKpK1WfrMoS+oYCoyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763110634; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AQi2VMSCM7Dxmr8uipxKdbUJCB9X5CgiGGzbuX3F6KZensTbAU7qO6Dwx6t31ssn7WmkNPPfO4Blp+caHhLCSBZ0eO4YlxXS6/fRK5+lQEbtiao5otHn97RIjLL0ojwSAA9x62DX116ifKh7jlXfWfr83afu5n+ialDXKhc1ND4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1zCvDsPh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1zCvDsPh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1zCvDsPh5BotCp8F+KoLoyvwDK
	LQr0vVGXFDGtfIpw0uBPQNfeSkagAKaQIOULtyx2QUr/1NTbt2Ke1owJM6Xp9CRGOfZliqV0U4w4l
	vQRGrcvF7P6CyJ8n1OpR2hhagQN4ah9cXUX9S9ZXB1tYmzgcR3C2bUUEEMWFufCDJkW3UsHP8/hOJ
	sL/HibC0Vn9qV+KeJjoniNYnzcxn044Xrd2oh4T9XmEhZ1kzwZHR/p0XEVz6PXLFyb8zhjGqRjf7d
	jxHIdfpDqqmfJwkFMmXvOAsdLn+la63HfrGE65BiqqzKzLOekkr2orqmrr2MyN4UJxqJ1FeLKKwt+
	pm10UaNg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJpc7-0000000Bqr1-1ytd;
	Fri, 14 Nov 2025 08:57:03 +0000
Date: Fri, 14 Nov 2025 00:57:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: hch@infradead.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <aRbu3_gQ8E7LgdR0@infradead.org>
References: <aRWB3ZCiCBQ8TcGR@infradead.org>
 <20251114085524.1468486-3-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114085524.1468486-3-lukas@herbolt.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

