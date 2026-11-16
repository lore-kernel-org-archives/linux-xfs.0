Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794808854;
	b=y6OaQT3x+WRv5ypcozBvEbppvk/jrUcoQT1nPbQZMXP81/he9xtAPQITBvhos8EwBStk
	 scWiRKzhlJ/nFvQD+000bOFvM+hkdN390jusP1MrOo0HWAEiI1GFlQRyyU0QWLkH54NFE
	 vjlQof4UxYWLIHcIOJoqjKroluGogOprHisLeqd/FYPHTxobYfNIY2MD+8Pjr7UB8Hhtq
	 Adt/C3HoRJ7Fs0/UJiwRJPdyKkk1dXH3N/Lz7FfI3RDQU1xEcmcFmPlQ1qnhZ1l4ayFzc
	 fXzevGH1vhdlmRsxIhMNe+6ZpxBPJfD/9OxXPrEGJrmbs2Shj9iPL8tKr9QX4wY9Amg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794808854;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=lR/Hn/AS3MiGXAzEThiuYFQRGwjkRWONC5s4BvrgdCUl1TK3Y22arSShiRW6S4051Ay/
	 YyIHwjTQQ3EmODyWoH428YREIVEqqmOvEAOwCKdAblHLH5a/Op8AT8gyftyyMDFhJm1tt
	 ckUeKatiOwkzNYGc93ajKcFbvKPNAOrBKQwiXHodSz07AF28JD1tuE0mIOjOe1o6KYyrC
	 jrqOUQO7bayRxvsyQoQe6fX/pKIqsbvEN/SytfyWAoJcZ2Rhe8QyXeWNbW3xTMOGghoa3
	 fmChoTCnSS51waP/zAqiUqDXES99ufMs6vXzur6YDmMGWeNGwhgjnlHn2trnxOPedGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=PTDNSMwH;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20666606A31C;
	Mon, 16 Nov 2026 06:00:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20666606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=PTDNSMwH
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=PTDNSMwHgm5hgqGhmKymg04C2Z
	Tt/3oMIHAC5440EWbmK2IC+1KFlJbGtUJAIJ+qD35u+gjnn5tw4V0RXFJyfJT0A7A8Qh+zBDxraFT
	eFX2dYft991wdwhO9mBh/P7tSt/Y7PqRK6hKSRpmxSEShGdlvofdmnVXz25D1AkUVvFQ1BtdqlbhH
	A+6rvxD+2BjijfaBMhTeBbtHiAvUA7U6c3youHZOU/FexYbrG+Rr5lZ4xd3ZassiccOxYnYNxtjJQ
	ECTusJQcHqVdHUmDvlpTeH8YH6+YHjjOwA7w+tq7VzL8gJ3Erf4A06D+clrfTCGqoe10CW2myz/nd
	YySafTRg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xSplt-00000001CO0-2v4c;
	Mon, 16 Nov 2026 06:00:53 +0000
Date: Sun, 15 Nov 2026 22:00:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Yiqing Wu <wuyiqing@cmss.chinamobile.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: remove unused variable in xrep_tempfile_copyin()
Message-ID: <avqcFRKaDb4CYa1O@infradead.org>
References: <20261116020510.17329-1-wuyiqing@cmss.chinamobile.com>
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
In-Reply-To: <20261116020510.17329-1-wuyiqing@cmss.chinamobile.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

