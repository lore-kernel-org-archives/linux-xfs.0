Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5AC2AEF5;
	Tue, 28 Jul 2026 03:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785208531; cv=none; b=Xsukr3R5K6yi/d5d+kiYR68DcrnswB4iTuyK/tbkOS79j/N4kNr6sTtp5IroH/RMWzPd75YR43yn4vF8rjC/xcadL5D9YI0S1hZP7yYYDmnGSf20eRsHZczLLfPlhTCtSMfyC8vNZw6am5hz/oMDFNCQSQIRp6GyrTbZykogO3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785208531; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gzy6CesN0AuP+BCBphbPNlsDS1cyNTO322LztjeFOLkV+Hkx71ibwUkKLjZZxEPrT2UfKXOkHqCxwNLR6B31BNnHBfhZSOLvbI4srsHvg68XHL7emxnxZoj6EUFz4zpFI0v23uMMiAWoK3efXSewZXhZp7sRLfFrGJSFaTai84Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Hc6eRBAF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Hc6eRBAF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Hc6eRBAFI7yOQ+892t7nbNXj6v
	UCfg++86tz5xI9e4y6IxrBor4JxLn3Ac3q6NEtVzg+VwrIUNBE0gRgtWoEIIZgxqlMZgLJt8d99rR
	vQTCtPSbBzwyvguA59nBfb7Mg7RrDyNMIriz4Sf1Eje8nyttxTq4BSV78gRxIhjiIHNuefYFXJsXr
	23fbaqMxiOxEUkqYQ4BEIswF/JagvbeBVC2XubESpmLd1TxXgZ6M3pbjf7BJQgYYlD+78rp+VITEv
	HMsfMwnK49FMNk3M2+HECwbFQRxM0yCpkxEICiUIONZazXfbCsXFeNSicOChWrTnyZgmoLAiVB84y
	UkO10/yA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woYHu-00000004JbA-3w0E;
	Tue, 28 Jul 2026 03:15:26 +0000
Date: Mon, 27 Jul 2026 20:15:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/10] xfs: fix another iunlink infinite loop bug in
 online fsck
Message-ID: <amgezv7LqqcMz1sx@infradead.org>
References: <178512389537.1495075.1621818931849629575.stgit@frogsfrogsfrogs>
 <178512389765.1495075.12826241332710084937.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178512389765.1495075.12826241332710084937.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

