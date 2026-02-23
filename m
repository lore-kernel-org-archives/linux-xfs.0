Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A019834EF05
	for <linux-xfs@vger.kernel.org>; Mon, 23 Feb 2026 13:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771852370; cv=none; b=kdjmwxOk/FwnUOeFY5kMT2ooyZKrm26ISsdDli4O3vqDGJVOyREyxe3cI1eBe3DSPwWQbV2TglqVWjvgOj4+BxdWwkFtStnGCtkbpa8Ag/rnf588ha9vATwdTNlNi2BA9ggWshs3XtrNKHlR5e6bkisTYfpSaFks/wfBg0xKRzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771852370; c=relaxed/simple;
	bh=+3zVvV0OSpzicqQCw4TlP5uWzOCF0TgX7KgvcSqc3l8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kv+V2N618BO0De41zSvcAUMjMCyjklEIcgihuo/tqa5mHwd0R++UbgHq9Hkew7pOWLkwlU7OH42IL7UKlgtcBlazYz+iY46CM2UsBU0RONMhRNd8KHGUb/E+98a+xIG9vH+bgYrsiCSPSASxl5BPFLLAnh0zcX9QPWarxoq8ihU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1HCbao93; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1HCbao93"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mNZuc4ruYnyR4/gHWiFYHe25mCAWr+tSvPAX90wEK/Y=; b=1HCbao93PAcn/jh9kejSlJCUV7
	pkTQV2qk9vvoiuuwj/pprToaOgJgJCZKufodaGIozMESemDLgLXf/agpcF7qrXezVmBxlOvRXBveM
	WlJP+Icg4vCS8hV4Zg04mhgUdkg/OO5f3YPwQiUCWLu7n7DMV12BN4L6YsvKcb8viKJhonqg7C9pz
	OyC94Zp+hAYAOQQx5j0Z2LYU72Xzcs2XFLsMuDJl628aeTo5T3NKv+wDBNQ1N5hhcQK+MwnLs7hzt
	f3YZSjcYAM05xV5RBmMjxK9vHEBGQfWy5XUVmOQMnq8K4wcetzjL8MRL/c+z0i5cTKrXc0GDHdiQM
	+4z+5Inw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vuVk0-00000000KoP-2oYj;
	Mon, 23 Feb 2026 13:12:48 +0000
Date: Mon, 23 Feb 2026 05:12:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, cem@kernel.org,
	hch@infradead.org
Subject: Re: [PATCH v9] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <aZxSUPbjOmfuS_io@infradead.org>
References: <20260223091106.296338-2-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260223091106.296338-2-lukas@herbolt.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Feb 23, 2026 at 10:11:07AM +0100, Lukas Herbolt wrote:
> Add support for FALLOC_FL_WRITE_ZEROES if the underlying device enable
> the unmap write zeroes operation.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
