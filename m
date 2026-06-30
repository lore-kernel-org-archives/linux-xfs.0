Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988511DE2A5;
	Tue, 30 Jun 2026 06:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782800286; cv=none; b=m8puuh3cAX9VyAh+dxkTXCQo/PXWKP5npU3Ux+KsTdOvXAzSE3MPvMrxBNBc0745qyFXaLWwLo+p0io2tQoKTP5S/HSHoL2ahuis1l3JsQgkIHKpd/kDCR04CNVKg0OqMh4bCIzRxwkRva5Y4gOYcOhJffBnVxRui3pP/cRZ1ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782800286; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N3ZREYCZl33ezAqVC1wAn2kq3KoQFWY8XKnsGgvy+dMemhKqJl9gyjdngiocZ5vMCZn1wxyhk6M/G0WRujpvvkXsvDrfotRDwtExHLmUWhggkbVblzcAimZb3k9Zezdub42pyk0YDxRjHbxoVdjm310Me9ZktyEFygI32fqADCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rNOpcsrk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rNOpcsrk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=rNOpcsrkbLMSupLW52W8zLxzQD
	RwXeZ6wDFlw7j1J9y1zdsjD7t/VsjjAFKY3pMURi6YgSZq+HSbo8xpHcCpi2JAba24BQqXxxUyDFm
	pTs86sqIZpsv/AzLK9q1qwkzBamM0PhRFv7xWuA1YCF8jWFNitzFLvEhJ9pt/4qB4ms159DCJTQbb
	cpEpYBaAm0Z3CHzwMua1iz1ZMgo5EnoQn0+Lb4uHOWsL4PUFbCd2qt81TlIM5V4/yIBnBkwOkwaSp
	JKsuAsfrGif3bKZKr5CUCAWDTw0ttbvNgaVDlBr2CaFWkF59O2iLB8J9cErx8o5+DXbObNKbhEYEx
	zC/9j+8w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weRnH-0000000FuRz-41Ov;
	Tue, 30 Jun 2026 06:18:03 +0000
Date: Mon, 29 Jun 2026 23:18:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Fengnan Chang <changfengnan@bytedance.com>
Cc: brauner@kernel.org, djwong@kernel.org, hch@infradead.org,
	ojaswin@linux.ibm.com, dgc@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, lidiangang@bytedance.com,
	pankaj.raghav@linux.dev
Subject: Re: [PATCH v5 3/4] iomap: pass error code to
 should_report_dio_fserror directly
Message-ID: <akNfm35BqCT9ZpS3@infradead.org>
References: <20260629120124.25223-1-changfengnan@bytedance.com>
 <20260629120124.25223-4-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629120124.25223-4-changfengnan@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

