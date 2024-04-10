Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C294926AC7
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 07:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712733719; cv=none; b=X5lEOr72MlxoYmLT3AIlnFEIG9zQTFeTjSC64/P1WJzmnpiSt4FjF04a0Qclas1vn5jFLffiW82ix+Zw0M47zcUkfwjim0Jw4qKRol6AyyPH6a8vEDTS1WrwCShsK0NnQMOQZEUmqgBlrPEbfVY5gwcAldCaGh0puqcD3Zal5h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712733719; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jborqlu/tasMIsI6FSWti3KPGDDmwoGG1ELI/TCoV9nH8WGIfflHTqKW0nFu3/GCWEmwPlUldLTqhRgMOoxIr8AppmJCpTb9RGwqYgryrrZ1ODWINPcq1ye38chiqN1CU2EYTbF2K5wR4ne2zR/HzEyhSiTePbhq4m/8YsFISUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=puZFglH2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="puZFglH2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=puZFglH2OlSub/f4H/L1epM1Ep
	5cForldoNt9mWxWHAkfNo8ZxWT27Um6aM1x5e/2gu8wnDPmMu+l9j379lRpbl8soWudB13cDDH8Sf
	4nPNXsk744SVAfWdg1QJxtKI/SWpCbPdeCXEQSpbZMOkfPASTpmgqmxuNZEqLC4DNJwJv+Td/sy/L
	OhFxRQSYrwqgpVhsun6qfnDngjL2ixV41TDCVCR+44HSoEjcuC7B06QQKiUYiac2sIMX12kUDEMSi
	cFHa34ZXvD0hX/o3dNtqAiTU1QJeE3bEIOcysAVFA7Xthxb6PAkHSxs5wvMX7Ba3JwHsERiIXEzvu
	5dR7hdaQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruSHN-00000005agn-1cwy;
	Wed, 10 Apr 2024 07:21:57 +0000
Date: Wed, 10 Apr 2024 00:21:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: invalidate dirloop scrub path data when
 concurrent updates happen
Message-ID: <ZhY-Fc-pA2xOviFs@infradead.org>
References: <171270971578.3633329.3916047777798574829.stgit@frogsfrogsfrogs>
 <171270971623.3633329.11977689827599930758.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270971623.3633329.11977689827599930758.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

