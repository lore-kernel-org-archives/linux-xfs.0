Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871FE290F;
	Tue, 28 Jan 2025 05:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738041978; cv=none; b=u4AZuI1o9yEIK2kFqJG17oZB2/eWVGmd446Xdk97a1L11LaDwcdVFMhYhoDhmhct0W8YFWa34FiYwIAfo9H2IfSAH35ri76pP4D+/1ZXHGmB4eS6SN1wefyuSthU2WZOg49QoHLPkm8s0uF6hByjysj9k2mBgZlySGiOAjqyhH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738041978; c=relaxed/simple;
	bh=ICq0/EgtLw9V4S1TZycRu6L9gTGWUfsYpnKHxw8grUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d+IIcSeKwcvvvFcx4VDuRc0rftrhc2LbIOnGcuMRk4FVc0caBjCFXnria/w44Qs6pijL4zOVL/mKdoXl2MuQbnENIfE7JRcaovOTvkAEpQFzVYFdFaR4WKNw7EQgrAOWNpR5chyPqhE/2dOVpOqKoTqK/ESvUJsNqpifKxZ/NaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ACkcBpMd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ACkcBpMd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kJzMLo0mdcPHa/7Sslr7vaeEy+8b7UA/ygDih5Q5ymY=; b=ACkcBpMdxi19O50pMHmK6kc/sF
	n0mKUsU5mKvm/UVIt1t6r0cfzUb67fjzp30tNLu1liI2qdYJd0GsqgXINy6JZqRYW9aaV1LcapWgn
	RbgH2aJr8XA10PjNug0jdsjfuhzIf1sSwmL0wxQpOkyDCh33Qix3QkR3/lkiVnd8eb1F6pOIRoEMo
	h/JJCsbIPMKhHfhQgHIwvOnk8R3eYynMawIYw8H3JoD2HmliWI+ODdSempmksrv0r/mCtM8Vp0XJw
	8kBQMaWpvUR09z1TVIETJJAQuh+oZzET29jtdZiDjxfAKjCasQf8Ykiuu+D14Il2DCcEP+hpqk6hG
	BnxO7x0g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tce76-000000049gX-048H;
	Tue, 28 Jan 2025 05:26:16 +0000
Date: Mon, 27 Jan 2025 21:26:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/7] iomap: factor out iomap length helper
Message-ID: <Z5hqd31L6Ww6TT_a@infradead.org>
References: <20250122133434.535192-1-bfoster@redhat.com>
 <20250122133434.535192-3-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250122133434.535192-3-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +static inline u64 iomap_length_trim(const struct iomap_iter *iter, loff_t pos,
> +		u64 len)
> +{
> +	u64 end = iter->iomap.offset + iter->iomap.length;
> +
> +	if (iter->srcmap.type != IOMAP_HOLE)
> +		end = min(end, iter->srcmap.offset + iter->srcmap.length);
> +	return min(len, end - pos);

Does this helper warrant a kerneldoc comment similar to iomap_length?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

