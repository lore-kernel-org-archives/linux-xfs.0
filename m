Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272A339FD8
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724390305; cv=none; b=a90z7AsjeBCoQuH9qDLO62hPMUz4kWnvqMqrV/P3GqSLO+MkpSQIM8WLwtKsTtf92sC5rkAf3rrmY/0Ttp1J0cF/Ezfz9EsoCU2hedHDK2u7bRmRjzFFdetuJwAOxJnLdBkNMto82v4I/mYyNNu5DAZTQGwtoFDcq8cCwQa+Fc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724390305; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U8/KPceNPAsz/0o+MgvqB1zNJqshpx62einvu0/SmZC0GAHnzhG3s5u9rtkkEqupbL4nhsXBOvehPVjgN+9Li3axrtF6btwE4KcJ5rWWfnJowiQnoiKiFAwFLGeyGHUszjw9PoedgueibsPuSc+uzyXLe/A72qscw7r4fLnHL2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oRFQbNIc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oRFQbNIc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=oRFQbNIcB1CA7y0/kErpLpAXiR
	ghrk0zjreLoNkUNol4CbnzYIzVGtViSvcQ9a+pmFYn4aS8iBHtlH417MG3yjx555jqcdaWdkW5aSd
	elVangkLwZypC40RVelpaVVlf3CxzXumnW7MNm52Zv2c4N51vRT6kV2pUZD0p9LKY5Lx0XA4KZmvX
	NjSAw4UR/TETff8JLrvuTatKPxIg6No5JmUVsdRvt+hp9ZZSOZzpDTsrfl5Zn/XCNhwIanVglK1MX
	8A0ZIXOEOpZeita7ghQVyj93AC8NgSSiFyw26UiQfreAgI4LsabqBCcJPPnbp8FcKdGIFX3CyDWMm
	5TPktSIQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMgp-0000000FHlR-3Cm0;
	Fri, 23 Aug 2024 05:18:23 +0000
Date: Thu, 22 Aug 2024 22:18:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/26] xfs: support error injection when freeing rt
 extents
Message-ID: <Zsgbn801V5plrjqi@infradead.org>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088834.60592.5110162859616544393.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437088834.60592.5110162859616544393.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

