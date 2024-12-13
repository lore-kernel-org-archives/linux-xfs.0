Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6121B2199
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081728; cv=none; b=A2nFqWbrXQ5JzEcYi/bh11WYZItHCGhWjo0jq03mYpu9yCS+TtorSugy7O+bandLSTv1NPTFnibielrv4Zr+ZI1MDkXiEsNS5dzUbSJhuviR63TWqC3hFlieiHz/4ICFcTLznmHhloUn97q7GTL9/2V8Xw8QCsUzQc+u+xNyLCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081728; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OzrKlyARVLwVxP+iZ2H/Y9juL3QAd8WDJT17VThGJYgwOXyFV5IOBVvYv/E/MCpcNkXJBz0CM+zDZ9hfW2EMsJ7oDRsEi2VcoINNPJlpBl7L327BLanqW6wQvtuN8bMsy6GWUrEX8zds8ybNEQ1QGEShDb9wFLUMtTTaNK2Aa5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IIUBnfeR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IIUBnfeR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=IIUBnfeRXJ1Bf0o2cND0994rbf
	wyCYPR/03SWkidqD5KVk34Eg/Mrp94HCNBuApKVubHmoAJl5VPs+WBecRQtUwF4A7IybO4ZPMF+iP
	ZdbAS8PqlFCgk16N7eTXAm+7w9qEnpoX2CznW6+GxRq08F4WW88FTfe7e6p6SGmn8WSG96Wn9bHIh
	RTYaAiEX4u85Uq6C4R/gsXob1DiDMitLmNZyfA1xUuzCOuktuw7y/kfGuf1Dp6MU5S2tLWY/Q9pI1
	bPhf35TmEANBpelvPbKwfvNlqyA45DkKHCuZMf9bI9zRpo/WwV51r5m8jf8yGaLSrFXEi6RuLRhMu
	yMtkmwQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1s7-00000003EgJ-1qxq;
	Fri, 13 Dec 2024 09:22:07 +0000
Date: Fri, 13 Dec 2024 01:22:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 39/43] xfs: online repair of the realtime refcount btree
Message-ID: <Z1v8v_kKl4wG0d1b@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405125235.1182620.16747601733851034071.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405125235.1182620.16747601733851034071.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

