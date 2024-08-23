Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134C9182DF
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724390142; cv=none; b=Tird5Ak1c2eG9vgSChmFcNuE5mYpyBclKNVA71mkPV0MGEWF14lQj5yd3o3VrpbQXys0vbYCSISZcPyxtxFzDLukZ9zKpJp9X5G8lFpjOrUz25A9d9xXsbiRTGSlgxQXvj78hf1BeyTtxoxA1C0kNeSaqx0WmhvL0czwgDmJWeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724390142; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gIlVoNum+2v3ucEjKaJi8ULciBES/gsUQnGIS6Yyh4rNwVP7hfWtqRn3F2X5C0VnMXSDPmqbJ5SDFJdYcP+PBQ04WNAD/E+4/8IpNNJk20Q/vgsyyBSDvTyULCjhuHPHDj0VW4c7YtGoxzLqqTscwMfEXjDGUNW9YkPCXernkNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fkJNnhTe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fkJNnhTe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=fkJNnhTeng5kOSWnH+PQoYqsIe
	5N9Ie6iYCTlocLceHZVQDTxfRnwpBfeP/lFSjpsikShzjRvyx7br45idRLeGIEy7ccz+azp1wUSNx
	1BbomVLRMFkyiHsGmTUWbqwSmH2QIaIEyZqK4nqt/Mcy4tjA37mFfdjFZoLToNcRfv7UX3nEtMLIv
	i4JmDDtrsTnxR1YjPxQ9Mw+Rj/UOmblPpsUiMrID5XY5O61rqd27rIrMClMxIPIe2sJYZADyUcCWK
	tj7FHw/btRcQQIukJvx9YIFttGYlsoFnfKtAkpIPNHEGNNmJRoXWqN5+Fud+MEsIRmsZWiKhjyQQn
	nlaCUEuA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMeC-0000000FHIx-3KIu;
	Fri, 23 Aug 2024 05:15:40 +0000
Date: Thu, 22 Aug 2024 22:15:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/26] xfs: encode the rtsummary in big endian format
Message-ID: <Zsga_M0DMLscYRWm@infradead.org>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088747.60592.2913943044668719207.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437088747.60592.2913943044668719207.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

