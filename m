Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54578186E2A
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jul 2024 20:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722283981; cv=none; b=EkvRaWuoInuI83KfgWL0iZRhsfvWY7WFfOi0pmOFemvkbEr8NoF2TXPllguBaT0HJ0jEZT6/nllSDPhedj5yVdh5tJmvTXaIY+ZycbQC/GgbAnX8ZoSyJEA/KYge6z/7u7kvCrvaQ8zBoi7l1JF7vzW/m5bBzoj113m9I+I7lTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722283981; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LyjfgQmsGHf7gr6pSznu3xSKmL4GwZZbWFbqfRZ0OH4R/DS7Rq/J94cjpsEV6KqSrE5SeW7jkn8t6d2ZCWImNMLbDFD5HBsf+2IH4WhyLxbth8hr/BtGBnaobgxpFR82UtdrFsq8I2xuvfeMPg0MKPV3V9LBCO3Vjnr9z4RtP4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=b3IrE25r; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b3IrE25r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=b3IrE25rCj2nDqeYuRlZxf8mCb
	SsQTwEIbASoz2s4swo3Tkjk1Sfzyem7JReksx6LoQ4gKrKncwLXkAnPQ738NxqrrRhGZyIPzlEvO+
	jINincEnlrUhCwra4ic+1oWOBMPn9/gqIIEoSx4jSKq9qNE1jTeat4EBjbjf9up7LW4mOy9i9LDon
	gnVQpSJiRKpJxGrLdC5m/0hgCp0F6pEGHbMWF6wayno+y9+CQdRKuL3TP4wz276lu3fwCl/717Naz
	T2XArm2FhwQLPBmWv8x/gEbkUgSG4ZPdtgcyQnryulyo+pL+ZP5XbQo6BBHWBZQAgAC8GJ9xWd2u3
	8rdI1TLQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sYWjq-0000000CZzq-2z3h;
	Mon, 29 Jul 2024 20:12:58 +0000
Date: Mon, 29 Jul 2024 13:12:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>,
	Santiago Kraus <santiago_kraus@yahoo.com>,
	tobias.powalowski@googlemail.com, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: don't crash on -vv
Message-ID: <Zqf3yh44kPhEbMxi@infradead.org>
References: <20240729191955.GC6374@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240729191955.GC6374@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
