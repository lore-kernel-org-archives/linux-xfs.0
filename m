Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167F42D94A2
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 10:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762253928; cv=none; b=lpA5YY1Om9PSYzlMC7ZH2ZwXwGqzSjr6t066XF9uAouJx/wTFxs+UDXcmnQTo1MhGHWubSIduZsKcPlzIpsuenL8KY2hvNx7BVmIweKxVYrX2RwWfUEumUUvcEJI1pXOCckgti3Pr604tJntsIC79KUUOFhoUxEMlwDaiO4J1w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762253928; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J3nipXG43iwqpt49tiPZTeJYDkWr/qvcN8pueh7wCSn+RKZNGp/V299Ma5NirGwt4RMTprQal6fr+muz4brC+a6m1B8uNPKOQFZXdQ2J9gyk67ZHzd6I4JgjVtPBmkn1LJUq/zLF2WtYjAIVzGQdpmYuv5az7T63Yv5ChFCsEns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=otQT69Ai; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="otQT69Ai"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=otQT69Aiz9DP/orK/JJuD3MexF
	un8l9ieZ8ujPNlopF33wpzSXFagoGaS0tKFjTooEoZtDqtG6TGkkWYauVFeikeUjKLOyx+sBwEmKb
	96dn83Oxwf9SURv0pr8nLoELO0hSaOwmsepf9cDNAiV3Tq9UVbJl2mpY5fFKrHe/ubZ40dSDeS1tx
	AE6ws+kty2L+weQb2Pfiefsn4Muzh/gRVWlUb0tgKgCllmI2pxWA+uhpiJPuuim8WkwXVv6oU4az9
	gae2d56PV0544K2DVEDzq9Y/cRmfNpCbo409SP64TKdTf+00JW/DP5ZpaRhs7Dv9EtGRgv5lq3RTO
	3xDNopBw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vGEkQ-0000000Bg5c-26ct;
	Tue, 04 Nov 2025 10:58:46 +0000
Date: Tue, 4 Nov 2025 02:58:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, djwong@kernel.org
Subject: Re: [PATCH 1/2] libfrog: Prevent unnecessary waking of worker thread
 when using bounded workqueues
Message-ID: <aQncZvG2RhBf7wbN@infradead.org>
References: <20251104091439.1276907-1-chandanbabu@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104091439.1276907-1-chandanbabu@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

