Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B03A3C553F;
	Fri, 25 Sep 2026 04:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790311787; cv=none; b=K4PacGlxmV7MKMWy76twH/EDsmZD/5lPeAHctd81m00Tf2WgPKksjrv09iYGWnFeImgkVhgBGX4m9castSammpDJpF8zpDSxFxYdwxX4bdaWC+ATJjOi+ZbDSX1tnFzs0HMM5tQTbgh2ExSFYjCQ/1hUdh+jU/GluJlveMxgr9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790311787; c=relaxed/simple;
	bh=hTWcRCxOeyzEzrKpgoOUEf9BNIAI/iGf97BkEx7BjjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SO3AVKH8jAEpUg+QvLfxL/MM2emVqhZhOSFBHtNsma3OTn47lX9xWm9svPocPXBFUqusF3FoeS9yAqm8IGnC86zpTAOQA06hkBQGmjqS0j9kQqkgaGswO4BzU+eR4cUI4T+SJAjTzyGL3IWbLBP6zS09mjdb3F3RcpKAKjq/o10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=plB8dblf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="plB8dblf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hTWcRCxOeyzEzrKpgoOUEf9BNIAI/iGf97BkEx7BjjU=; b=plB8dblf5WKWLNiAERBx8nctNB
	vV2j891Wr2T6I4dskNgDXZsUf1zcm31DZbbAqKEPZJmOVpurvr9pE6L8shdZdxgfTcD2hn7CMJxnn
	UDt4+qlXL8ZSm76Jw7fHB6eeny0Dfz1oBfH4MLexq/mQQfQhHjKx7jSZAxsZoF85ZKnpBJ4hYTrUo
	QtM4IDL0MgNK7/Rv9pNDf20czE20gpHVqMcxyF4aSZniJ71bCQ4G4XoV0HkU+4ijooQZ9Da76qluA
	U8aQVHm2Skkv+eWQdCztynA15oyXpU2TUtM1Lha4Idi0bNEDXgm0vlvLA9LwgYO9yH0Y4nCLY96IF
	bCUm3iDA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9xsX-0000000CdBV-2kWB;
	Fri, 25 Sep 2026 04:49:45 +0000
Date: Thu, 24 Sep 2026 21:49:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrea Parri <parri.andrea@gmail.com>
Cc: fstests@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
	Zorro Lang <zlang@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: exercise a failed CoW conversion during writeback
Message-ID: <arX9aRKcDRZlUsaW@infradead.org>
References: <20260924091338.198407-1-parri.andrea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924091338.198407-1-parri.andrea@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good with the minor issues comment by Darrick addressed:

Reviewed-by: Christoph Hellwig <hch@lst.de>

