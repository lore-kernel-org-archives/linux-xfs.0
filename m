Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793115828;
	b=VMwDl0jzpXKgpaEhYAbDBJlGOQRIyDcVsfLbqW5bSvM4OvUC0PbQ3zMTOwr2zmenNR8q
	 N3zbV+0FroRsOrfm5HQc9FFPvnK3v889YE3KhHolMwhgpcelgUjEiPc8vaZSVy/ADbE14
	 dBxfaWkNu272LeKgUL4g8ddSoqg3F/Xy1j15FXXgiXcDbyq/XYILGhU4U2Q620AdDbkKN
	 ODJgbQg+/x2ItS3taMybqtxHjceyJS8Pm9wbfdBrzq8PKcAFP16f8A3JZN7F9/iGzb+KR
	 mT/nyOA0SxnDNiZ4q08aZerVGb9MmVaiLZoNrFk/ZzVPr4RDUXPUoBe7W/SQXTHXUHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793115828;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=4uz2UVrT1VV+rN4FbmmMcx3D6m4r4n7MivNGUYLXpkIXpG0VZyxyForjSzOgGxhivA/B
	 tYs68I0QYM5uZGsKKwm4i8nOwk8aN3c6NbO4TseV+LoZ09M/EWMGE5FmniueVophCGOFu
	 lvOP+lr/robvF2pl+T7mlSrLVI82cUFXbfkhIZyU9UJ2rIp6cwRMkVt3Mx9S4TmZ7vB+7
	 tuYVsIO8+Dw5MnEBvis/vh9UPCPo3UWUVDCZwJ1mtoH87PbIhwOTsC1m1WCdxAwN3aqBh
	 DWwgp2W89dd5FEkhZ0h1JpwYOWY0SpVeQmBa7kVULmzShTBjxPxk6SGUTWhng6sFpGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=CpMGOJUq;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D45606A31A
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 15:43:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73D45606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=CpMGOJUq
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=CpMGOJUqXbZJusAcSRxSF0/+aW
	9ds5ISl1lDHykDOsOlcTIWKTbtG5ihYbq+49bIniwpGKyERpBkK8skHhdtuAwTsDUuxHF97+nsmPX
	FE30cgPN7cEITOpAWXRFFYqEopjkzRKBztUDcyQ9gDRc/CsNUGcfXcVoCVP+ZxtkpaUcKXhuo6xIO
	IQ288NnxGWn9k3x5bpvYlZHQeHrXdyrSUJw4OWvcO7KJrO726vWnAk38qL9eumrycaQDch2M/0OXZ
	xHtaCMNs9CFQDQhjdjx/zc1rP4Y/Q8TVbT4rrNaX57fuygOQpkiTrKyoayBkMfbFKWs3SAKgOrxyA
	+bMGdBMw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLjL1-00000005G8b-3Cid;
	Tue, 27 Oct 2026 15:43:47 +0000
Date: Tue, 27 Oct 2026 08:43:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Anthony Iliopoulos <ailiop@suse.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: skip iunlock with empty iolock flags in
 xfs_file_dio_write_aligned
Message-ID: <auDGs4pq8Bw30ASD@infradead.org>
References: <20261021210032.14001-1-ailiop@suse.com>
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
In-Reply-To: <20261021210032.14001-1-ailiop@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

