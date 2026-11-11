Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794409960;
	b=XvPpeA2H2zhDheTrtkcqysCgj/AdvtSzRqxoCjpxUQc473NHhcbHGxWSB+B4aYAE+rIx
	 8czUxmbv1tJC9T0GvNz+KJBkIGIg6wh5ZgxJ7EnAZO0ssJ/4wKjD2iTdeLnn9+8raivzK
	 1AHKrbxnjwatNozcP8RgAd2DvoDIOBmMDyZCFIH0F8+Fv1RiQY/yDpP1vKRSCRooUTkQD
	 W/mBYARGcUgwHVJVQRYVKR6YMSnSN4HQyeHA29ocNVPxa7ke433elNK8NkEbCO9vj+tOy
	 rDOGRF8m69U3eWMH8MgwM5RdCvluXgYxqVbLnii0NAuQBM3yU9g2+WM2xC77VGyExlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409960;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=jQ7Q7y0mPGJIkYWZ1n43TNfPNFP6ahpVAafNwZeyg4JdAk+gHWwoVaUyiKHGP8FEfJ1h
	 d0bzpcll4kFIwjnW4SQFQDKmXC1bqADddyyWuDQuVC5vCJReEbkKog1VNNpNLVR2jKeVb
	 KDUm6WFSJHzJnlhWNlXlgLly7izmC6Z3QxOMCDo6On6XEAVdkHr5rfNdM3uSr4SYU0FOv
	 37oHQSI3YLwPlm6iEVVOLvejny7aqDprGETbhcMDdhd3V1vTQVWP4M3qgyo9kR0YY14pU
	 wapRWsYVQclUJOtd27rQW+stNodE4ekyLoX6ov+FAdWy3s3tWlN8tkWvKKi57qUcviw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=BVmurucv;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9274606A32A;
	Wed, 11 Nov 2026 15:12:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C9274606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=BVmurucv
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=BVmurucvLZF3NJRy5K4W3YTNjS
	1VnvwGSXmO4brTRe07Uj7ypC1EzWHEHhULtA7k2GS++cdiADH62xkEfQR7Qeo6vOJv0HP1tdBQZkV
	OdntPSISPgvNRX1EXhPnFIPWkvhlBKtpNRd31nRCcfalb/P48EC3/+GPKKzWgNpFe1bC7t/xv45zC
	GA/nCPjAn3Y/Pdg522FeaqQV4OUNxJl7X9lWu6ePCqJS1k9pU/hp6XUyx5KyDh9kppsvPlo4Bg6Ps
	ObC8xBbU4WCw4I/3bUvhp9L+Ek6ovbzoRM9aWjbATYrzJJUmDiP31v87rMv2Sqo57MaupP+Fp9Lud
	aHt/tJMQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRA07-000000073os-1n60;
	Wed, 11 Nov 2026 15:12:39 +0000
Date: Wed, 11 Nov 2026 07:12:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: daejun7.park@samsung.com
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test that swapext waits for in-flight direct I/O
Message-ID: <avSF50cW9sMbOp__@infradead.org>
References: <20261110-xfs-swapext-dio-test-v1-1-ead6ea3e23f1@samsung.com>
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
In-Reply-To: <20261110-xfs-swapext-dio-test-v1-1-ead6ea3e23f1@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

