Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10AE1468F4
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 18:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709057787; cv=none; b=VTLDWixqdXpxqdYWodFwbpOaHuDwZ4vpzFpDn+dKIDJ3i/BqYtADEymkDAtB0VeFGLg3tX1jsXNg1I3Gw9x7hoL5LZdhPrF1+hjMoYqlKx2oC7mNCWs5vVgE28QrtghBruyeycuqIXSAzrL7lbf51ub7ib5qksnkzGKwqfK3xRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709057787; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M4r+FDrXMgXqVzcQRRD+GgmbSP9KQBCPLDjeuwS1Elbc+jyjoXYc0uUEMR4Q0X6R+wWxSOjBrrJO20+iVefQgR6YdJYZQSdw+64/+/IOVoL5aw+fvrzrNVrxRnT9HKISO9siLnePDWRpSifvGmxnuuH7TXWBuG0CWK9vRlJWbpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sV9C8It/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sV9C8It/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=sV9C8It/UPSqsqwGIrjSUxge1E
	cBtQPAs7BjxmJIKiACaK+xTu5ah416rYq+foCvdvpS2fTMG0eTWOJBlJjdRGXceY+JcDSr0RzNwVL
	mDM8nYuLmgxCrpibxOCRKw2Hja+AtEL37xLaWPseu7FWjJh1vm5mtjavx7FWhaiEgXg65psF+zCtD
	RlKd5KWxoTTbRlSARPOTJVsM1f0qsoD6RvxhIUqww5raxhnfcbqfpNnEX6kni3j9GtCLoAXaF+/Os
	bYOcuj/vwxYNidgzfZP0irEjkiXIG90AvfsDnB4MqZqbH9dtDrmlde08TqE/nourJlA1jGNE7KUuU
	XmBWEPpA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rf209-00000006OWu-26Aq;
	Tue, 27 Feb 2024 18:16:25 +0000
Date: Tue, 27 Feb 2024 10:16:25 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: refactor live buffer invalidation for repairs
Message-ID: <Zd4m-TaRutKgNP-t@infradead.org>
References: <170900012206.938660.3603038404932438747.stgit@frogsfrogsfrogs>
 <170900012265.938660.17219985816705973845.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900012265.938660.17219985816705973845.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
