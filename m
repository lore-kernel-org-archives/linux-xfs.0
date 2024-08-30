Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4CB1531D6;
	Fri, 30 Aug 2024 05:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724997436; cv=none; b=TJ/bpe5Rjw3O3wOpcYxNcUPXH3ZEy9klMXXDfXe1kSVI0hsjisiasWwnNcsAazSgDZnhS9g5lh3ID5kcGXlsiGvjLOH2As/7RWzBoS3qW/zyCLCvwMoNrkHm0sAKz6mwk58wh62tcm85aQ7gp9fvZmyg1ZzVX5gI2XO2PaBPyaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724997436; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g/YxyJcis2Ny4l+kMCOO/ltvbWkObPRhgKajft+W0XZjLhAUrZXpfrskQLlq5o69GR3yv4edInx8I//mlYfPdu/AaiTsNh2RkMPre6/ZfrsL8W9IingLHRuaxpuI+JDdYw9KM4TZdMfWR/8lNaek238xR36gq3vMP34tJI3+pvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=f90bD3fK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="f90bD3fK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=f90bD3fK3dyTrn32i8FDc6e9yO
	QyWT1BBMHJ572RAKNVr/T402oeZs2rsVai4UMARLjYYESMmExIFZoG5TFZFf+6tppRFgzJGv4HRbz
	4jQbdMYHlrXZCXS2+AUrkbMPMm4uH6/lb7K+GJGQrirjeLzL+YRPLlvSJmG/VARtC/ZyNFjvcnClS
	2UjsCIU050QF2jADtCHCt18BKACz+y5R7loHyNlHHlyqFenSDgPe2NohXByzNGdJBhNe+rY3B8UrR
	JqMo0BYIVZgO287BAaGp+0P1k1w8518FjdeqRpPQ//qX1B0RGKI0UaOOYszbcJnm4qeGRJVZI/PE9
	pJOfJCFA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sjudH-00000004sT0-0mup;
	Fri, 30 Aug 2024 05:57:15 +0000
Date: Thu, 29 Aug 2024 22:57:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: refactor statfs field extraction
Message-ID: <ZtFfOyMfX40ICN4p@infradead.org>
References: <172478423382.2039664.3766932721854273834.stgit@frogsfrogsfrogs>
 <172478423399.2039664.15689426615151903933.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172478423399.2039664.15689426615151903933.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

