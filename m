Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9926C346E56;
	Thu, 16 Jul 2026 09:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784193859; cv=none; b=C7zt3PpST52EvzjKylE9s+4hPYzGpNXMJgI5sOEFA6dd/grPYdECngD+qkBn4zHs82h5R0zXNpT+zIoAB9ze3K2ImCJWubeooqO7r7xA5umKROjeSFkWijwobPVUxkH8RQoZtEAWZXnPpwTFz9HBgJmkG+EJDg3S/cI2mIXpZes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784193859; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QoRwD8+KELWaWyCx4OsqZ/Ao3y3S6PREPZ1+z7hp/Q2fPon5JGC0O3qf4QmX9TJAH8nym33M6lkq2LXPO9Jxr38c/Fze6LmRbwsA7N49XSsM7vq+OhOg29PEF9ft9U3L3M6vTtgFdXRylI8Ih7pMGNnO/cu92QaKWcfmlmaJQRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LjfKK12u; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LjfKK12u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=LjfKK12upN024qSChZYc3F9jDT
	5m+7GoaH885ItF1SvAgIhhucCFP286vL7AoQwNORUh+1iN5rIE3iYpQzmXtTsf7nvcRzCdcM4Sr+2
	aP+X5b5qc2vJIwHRQVEDYodCSuec5lcnpSPcVPF/MFtT4266fymBZRJcMBJuhkbiMdSHSiAj9s7Ky
	10Pdazpf2vxVFn38LtuVpnrBVoxFFGb2OwFa9I9Vczq0azjuy4Sl1enPhoAFtdHeJq2/OHgA57wjl
	iHVx6TnVxpQe672pq4zXgiHosx47WOIkEhWpDSr9P/foN+QUfJs/JorqPHNpMFWAs6OIFLVN8iC0r
	WB1t2omg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wkIKH-0000000GqvP-3oe9;
	Thu, 16 Jul 2026 09:24:17 +0000
Date: Thu, 16 Jul 2026 02:24:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qiang Ma <maqianga@uniontech.com>
Cc: cem@kernel.org, djwong@kernel.org, hch@infradead.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] xfs: clear zapped attr fork state when bmap repair
 finds no attr fork
Message-ID: <alijQUTZ6KJGOtJq@infradead.org>
References: <20260716092245.1847930-1-maqianga@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716092245.1847930-1-maqianga@uniontech.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

