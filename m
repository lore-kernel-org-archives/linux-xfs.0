Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794808995;
	b=A6MrxsVPTZvfB2T5dLA4T28w+1TR10aTZKkXhqauTQvUKZLBLeIcIdL78hFMT0FpLr62
	 vsCR05jLYVsOX7ZEHUpKSS8RPY0iZw+Uj+1cbXdfy9dWhTZloCD1HyAejBRYnbnevj0RC
	 xGTky0xEjkdBh9Xsvh3BhWMo5M07Id5NA4p/Z3EgvdFPD1VSagWSQAQeTWSmo807MNh5x
	 KI4PHXi2UMkKtMSH+NXuPDVX58fpt1tNSPfILMhT78b55UsILuT617cWbb7Haw7DL6ZBy
	 w8sIHaRFKIpJbBptr2+aWJLsDrmKyJozvf8dBcSoMOA7siPV9tK9qOK1KHPj4eGkyNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794808995;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=zW816GU2QX8ELaoQYchbMMNPDHmK+314w4F3Ag0QwvfD3UrfU+wilMOZGWS7jzW/e5WO
	 R3KoJCTo65rmzwq5yVUJM4c73R1pm7jhOVhWtHydrThJalZJvzrD7+SrwCZHbC1GGJQoH
	 qdiJx+DfajNJhj3ANES6eoijKyh5O0L3Wa4CdKJyvvfY+GATXK8FiWsVwlo+Fpc0wJdZw
	 uhEwxsAb4TLTKhXeH6R18zc8XojcFFBt1sBV1q6AOe0rG618q/ylVyVO9obmtgYfoLBps
	 rEoGX7IWLc0td9H1FaDkVIOWMC/zmjlInz77YH5hen6oavOrmrU/vxgzwKAOYxviEvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=1a7KrTOd;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EB1606A886
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 06:03:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1EB1606A886
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=1a7KrTOd
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1a7KrTOd+Ei6Lvc3+OmGd7+SGQ
	duI9RYWxe79Ie2RxerRxiLorPDw6tGDMD2JL0VvXvD0bxDfZoQXX129htedPIOCxDsS+LUTwGykma
	rmSWn/F/hfjTgr5YIxANFr5XI50WIXe56MgWGL0+Q7TC++/VAlAximVMSdUQSFYO+1+ah5lSd0MUm
	UXMK8d4fPmyObFdv5Uytl3D+oP3KS8RqOSpOlawsyFHaNQKCtWFdX7hNFjQEDhtYp/CO2032HXNLQ
	kmNlBG6KtuFn76w3jc2Ia5r407MJD2dFUxqkrM8FkkYkssaEkMaxTpoUhBBO/GK9NBGlT1j/Hygyu
	j6DkrM1g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xSpo9-00000001CrO-0kgR;
	Mon, 16 Nov 2026 06:03:13 +0000
Date: Sun, 15 Nov 2026 22:03:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, xuhx@hust.edu.cn
Subject: Re: [PATCH] xfs: properly order xfsstats proc/sysfs init and teardown
Message-ID: <avqcoQaG2-gB6ZUn@infradead.org>
References: <20261114005925.103130-1-sandeen@redhat.com>
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
In-Reply-To: <20261114005925.103130-1-sandeen@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

