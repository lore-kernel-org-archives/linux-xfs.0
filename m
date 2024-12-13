Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE6219CC2D
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734080809; cv=none; b=Plr8g9oQ7iIprg6uqfUsKo7GxSV3RGauDZmIKVX5mu0qyl+K2iO060zljZ9hkADMGIBN07xnUYG7OiNcv+K1tcT11EYfVUkXTmxnWy99Uoj8yPNBnUQzcPtMWIE16eAVYdz5VyMXNQ0cUs7c+q8OczLNFf2phW0KaT/i6tgyJBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734080809; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HBilNlO7+V0mO833Oa7Y15N2Q5JTOdglQ5XFFtKNHVdzAufI7e0aJK8bLkNLENlpQX0DHqQ9bV6Cjaxhb4LNNkJI8VQmSPtzu3jKCEal4+owKxUwS9iLDXunQupADjUWnAAHaVCA4Vtu+LNlOASl7ZdPfX9MK1sQFowfE8wzAHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0xmAlc4c; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0xmAlc4c"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=0xmAlc4c/ARRcdzFICHJ4fLNXY
	aAK3a+AO1Gde4fXcwnSLr/4dHP+C+KBBMb1PZ9ZuEQU0CfRZQ0R2RuGCFw/0C9cybeDBAkhj4xdjw
	g0HZxgXIlmTFYDcjc0qiMIUGXhhrzHnyGzSdgkwReqBswZFBDwhNEnovW5ep+JzQx114vql+da+vw
	NxHqX6HfP+FNcZmHxWYBuUJ+GOZtKy5Kr5ypxQnaXgXieTcr439QFf+CrXRa+lIsmrmB6sYyFWNsi
	tvNTOWI3kBw7HLOk36Yig1dut17MUOcus3GzTaGsCpFEIjXB2DQxbpLEBqhRJcrfTj/GhztYIcLB7
	CLRYODog==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1dH-00000003BTR-2Pyk;
	Fri, 13 Dec 2024 09:06:47 +0000
Date: Fri, 13 Dec 2024 01:06:47 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/43] xfs: namespace the maximum length/refcount symbols
Message-ID: <Z1v5Jw1tthwac3Vb@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405124601.1182620.13597083236124645765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405124601.1182620.13597083236124645765.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
