Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793203091;
	b=zb4wfcYbkiuucOyBeVg0EK7BdxsCIRC/jkP2crkb/D0r/VhL7CxJSxAZmOxt60T/ug2E
	 rru6kIo519IBs2SM4NcWMnnH6eyt+vOpH4cxWiPVEgeXj55p7+cwjsAMTF5VLLNiAWcgp
	 eAP5zA0JxHzwsxb1GSnrhE3Bgd29Q3sCbl7AT+yfJYzPrhCQpYq/nbgTYY3dLTptDdP8S
	 QCOC6R/kkJHO2Dv/2WlKnYGQadaxRGeDmOeUMG6auRKFQrirceqBnNV7pd2EVYGCR5kz3
	 ysKAsrX6CLTQBSeqki8v8xYMs3/SWBKb87hgiXht/ZJ36mAPaOVpwjq4cr/Jzzd8qmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793203091;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=0v6r4lgvlyFqcnN3PuEIXvXvdS6RgATXmBBMz/to/JrLjCbmdNfp0gU09jDWjMJehXGz
	 if1vJhkdNGKLYl1EkSqKorMKtHTUg6melf0PQhnRlyT5IvQSoQqz05+uD36ryscEfhWl0
	 KUi7Jy6WpF5R87ZvCIReDy9U2EMOSYEkcfrK2DKQCHRheVEMKhXJU8Uukj4A/uxEH1QTC
	 UxM6UADDuLiMvoSVXdyP5HK4stcNHMnX9nQnrGS7LbpYVQDP0OyOG+v0/LDx6COIgU/3E
	 cx+/Qdt8tRo6cunDmwUUptYX+mhL0tcmuOISj4Xzr0WyrOVnXHijGvQF6Bd9MX9/ydg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=OXKLLbnF;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE6D606A31A;
	Wed, 28 Oct 2026 15:58:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6BE6D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=OXKLLbnF
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=OXKLLbnFeHT/kUoNB9if9reT77
	vduAknFuJJhXaSe/62ZGW4l7WQcs7Zhe64rxx9tEd1rBZwOw4mn8edjGd7W9B1KpJ6ICS0ad64UI0
	QFO8SrI4Y/V+i86mww+leF18s60Pc2m3QV1IPWEHPz0jgmBXnyDO6Vt2oijfwUpIfQW2hqaBz6Xa/
	qv9eJIzpr4oo/Tq2/o/6Q1527ZVSkr8W/JZHjG1QGBuJf64JgwKdnNkEReDeHgpgsvRVcbfm8qBcX
	SgoUV/b4pGnMe0HgdeKC+AbKB+wZ7hHhELKH+o1Kl5OmYIeuH0SKf5QhtKBC/fASHg/LFUksGyHeM
	SskEwnEA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM62U-00000007TbE-3oUA;
	Wed, 28 Oct 2026 15:58:10 +0000
Date: Wed, 28 Oct 2026 08:58:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org, Anand Suveer Jain <asj@kernel.org>,
	Chao Yu <chao@kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 4/6] common/rc: add helpers for
 /sys/fs/$FSTYP/features/
Message-ID: <auIbkmmlUD7NBwuC@infradead.org>
References: <20261023203114.1655019-1-zlang@kernel.org>
 <20261023203114.1655019-5-zlang@kernel.org>
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
In-Reply-To: <20261023203114.1655019-5-zlang@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

