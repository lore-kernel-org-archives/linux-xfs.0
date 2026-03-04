Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19051DF254;
	Wed,  4 Mar 2026 13:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772630444; cv=none; b=HZWWmWqyF7dx+XUlCBo6MGespMQgwGCs97obD2NfDVS9Kqz675WMrGqB+Qd/VKiFJx6LRf/50jIQAbFPMjNb59BpQ6fX7LbXqZqkb/Z5hUaXUfEOMb/TOb14VNeQ2qYzV2AA5EZYqdZdF0T7z61zlTKTmlv3bc7R9hjyHOPd83w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772630444; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MCiSbBnjpNUDgsxWZSiWeg/JJp2fME7YAgTW2KpS2Zp2TdtV5XWk8tA4xKQtUp4DlNp38y9BA130jYKQDuTEANiH4gBSFWlp7kiE75L3jqR5KqSSUUHlDzVYm4i0XrkJFbsygA/NXlgHrSZWZiteS1fPxPdPUxYBWMYRHpZHNw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2eYagBrw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2eYagBrw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=2eYagBrwGFN+jBA+qaWMx4UTqI
	g7XPWQjyyH9ohXUfjNMMbHbCDx9WsGIYx7f0P5vh9HU+OYGc+2GawUWew2QiwLYi7R5JjmOQ8r27S
	qnpFYn/5MtTwclu50fyVAf3qtGdIBMfvHIWNl0Y7QIbibVxlfDfDQikjT4LMaylr2lP0xZCm3evmA
	6qoEhX5jyh6Ucoyad5gAKqgGzcjQKRWBTEyBye08WsSchT6r6CczJVJhc4DvwESiZtUC0MYjEyKJN
	rtL3H3Lq3IIZXQ4p1kc8hPTR4M/R66n0EQMDWSIAw5lVI5QZP9xcmWG6utHzvcm8IEPZAu7Kk18n0
	gCF8bx+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxm9a-0000000HExF-2rWi;
	Wed, 04 Mar 2026 13:20:42 +0000
Date: Wed, 4 Mar 2026 05:20:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: hongao <hongao@uniontech.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, djwong@kernel.org,
	sandeen@redhat.com, hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xfs: Remove redundant NULL check after __GFP_NOFAIL
Message-ID: <aagxqnPGwUil-_E7@infradead.org>
References: <B6935AE39B8FFBF2+20260303033332.277641-1-hongao@uniontech.com>
 <505A5848AA49D10A+20260304112914.599369-1-hongao@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505A5848AA49D10A+20260304112914.599369-1-hongao@uniontech.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
