Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A3517BEC5
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081424; cv=none; b=ro6J4YNHj/aBdnoLGDD2RYZYVQxDmYewSwIPm+oE9w+jhRuwL9P4p4y3SfSffnaHpvj7B026VlwcVJEIBbeGkQCNhHcpjUyNqzBT2xiH+dc9v1o5BiBCfc6YZK61tI58G1HKNfRnoYCzTwvcBGqsy3kPklvHxk9CQvr9UzrbQ6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081424; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y6Wr94wZrdLmy8nNdPCpaNLl7SL6J/VzpOGCLRSOAMJQJUlJZn2aOk7mQ6nnvcth0dm7+Q2Uzw6h4jloItWFD7Y2pUfuGdQW43wcMurQfEyBMzvoLntAikvmRQjyp5CWGY1rTbEtap1ETrenDshAJZDfUuBUFnNR+NEL8//heSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rZof29Id; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rZof29Id"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=rZof29IdUNXLjx/UbrYkeWWyFA
	ZTXyPCgbjxDdvXVK/axPA7wu2WciGhxM8aBq3FAuN+5slTX11eEEZFPdqLB//fpXTASRrgPZWj6Nd
	4/KJle4yTdcfnPEYj8GJb9v6CuOkPcOlpopmKclkQUdEBYpqJLFIWiONwroEw6MYob2wGXbX1ScbE
	Z4TdBzgDogw/ns0Kd6PhNv954mWgzD4my4TnbjJ13zDDvxSuBwtJNwgyGgc7kWAiCDvMoWQF9f+F7
	P3QzrHLaLVjoI819NlElTdRPc+ngqY2b7Z5WEp2ra+LxEAwDFRxSdy5csFqW2aLvUT78Z6dhKUSMx
	98nbpyhg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1nD-00000003DTi-1GcP;
	Fri, 13 Dec 2024 09:17:03 +0000
Date: Fri, 13 Dec 2024 01:17:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/43] xfs: enable extent size hints for CoW operations
Message-ID: <Z1v7j-xrRW8mcaMy@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405124995.1182620.912936243410911232.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405124995.1182620.912936243410911232.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

