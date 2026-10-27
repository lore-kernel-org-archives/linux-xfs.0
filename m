Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793115808;
	b=TTq/eTcV9DabhnRa0caUEj/Nyg8WfYVR+ZZbN28HTWLmG+yFQzRun6fmGv0D5jBPBrnd
	 csRMdJZ8EKzHA6ZBEi312icUIwyI0vol7tuxQpkpEvtrmM2AcXnZcVq7mrv6TG9TQERb8
	 +tkhdjkD1WtWV1+MwJwCtE6fwiqzlcmXDlZ7sASSLnbTZXMpiSxaoGm6xpy9z9UXRBFq9
	 bBqOFVZW3ypyBmxEdV3152zdagzv2oSQY1KfcCZIUDbKcyZEKAJWPlzM/UFNJYOlx8m/T
	 QkTMHRMJI8lv/eSSYXNf5XuGKVHT4AOgFNBmqQbPzRfDQQxicyVqANeRxfZmYHlxJug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793115808;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=J2ghfA38nVcXLFpQeYCddfWwAY5KsE/LxHHWdOVu9v8=;
	b=fK6KHxsa1gyZ3s94R9podrJJTgOY6St6sjJQGhioxgxW645Ya9WViSh2vHtfsmmex497
	 ViKrh6JnofRPNwjAU20Qesc0tj+20r9+SeJbnZHJh9lwKn3saOjAIG/ZEmBOJ4zoYvOYT
	 A1UOO/fb2xwi0dw7vSIrh4bGKi71LxxRUdJFTlxXVPtCUTkWof5WnRT6RIoOCsFZ0IeDX
	 NfrIGNR37sNrzfXrT2S4aepqFmI7lwfTAEtcWL0xfW4V6J0KExlfyJR/Nzajz6EgxKU+8
	 OUvoxb0vXL9taU2AzQhbCjpz9YUzcaHhDc0J4nr9B+J58KqDEX7eIKFuwCmPLmMwS8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=YsxThwNs;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FF1606A31A;
	Tue, 27 Oct 2026 15:43:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70FF1606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=YsxThwNs
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=J2ghfA38nVcXLFpQeYCddfWwAY5KsE/LxHHWdOVu9v8=; b=YsxThwNs5SH5s1ZCCdbfSGYsV0
	GTDAMLKeUqhVMLIPwY7ZX1+Ju0239uO4uc6c7NFNqiy8e/YhRLYZ9eGRj+F9KiuROPnoGP8czA2Q4
	yOyoo9+BYGa15FIeT+WLhrk2AzLEMlFWA7TpFDuA0Lb1Dg5h4pAh05AdCoa7/V7EbaqbropeV5R9L
	EuNmPmzhyk0AEWqpLo99Vs6Fsaew6Ay3ffHp5BY7Fpy/FOTyytZdOFUVsrw0QAB8WMRIYWHp2Eohm
	eMLE10JzXEs6Akv+nKn45c+hq7ZMDpVSCnnzIe6F+R7L4SzNWdgeeZejQn0AWRX16pE0H/E0yHWle
	433XTgkQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLjKh-00000005G5m-42Wl;
	Tue, 27 Oct 2026 15:43:27 +0000
Date: Tue, 27 Oct 2026 08:43:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Wilfred Mallawa <wilfred.opensource@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: Re: [PATCH] xfs: fix unwind handling during xfs_mount_sysfs_init()
Message-ID: <auDGnxRq-T1Jr8kY@infradead.org>
References: <20261026053454.987673-2-wilfred.opensource@gmail.com>
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
In-Reply-To: <20261026053454.987673-2-wilfred.opensource@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Oct 26, 2026 at 03:34:55PM +1000, Wilfred Mallawa wrote:
> From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> 
> The goto for failing to setup /error/metadata jumps to the wrong place
> in xfs_mount_sysfs_init(). Fix it.
> 
> Fixes: a9a7b9e8686d ("xfs: add support for lazy direct read bounce buffering")
> Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

