Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A7F59149
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 21:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710367086; cv=none; b=jntymQ1ahwwYf5sdhNJm2ckQuESU5Y0gikludiLcOVtlWMM3PYiSqpNUMWwyPXUrne+tu0hqPCZDbqGzskYNYyUjGoMUIbiV+jgafbINpmgqwRis8rs7io88fK+kC+p4aDsHWX8brKI+NTnMjLcwibFZmEA/7aONjYg3FeZcthc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710367086; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W4I1qcHNUcjILGGRMGoY92T3rJ1IFdI25yfHXb8VdfiGHScfSOKjI5k5j2bFgWmFKO6ln3Ozr+rOtl8kTfJ+u3PbBHFyBAbLaibWHdX13+iO1AYGlThJiZBOLh9QbuZMXxoviM8ydqwJctaBJjGzOwD6bQ8UcdGglJPBLiwg+SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CSKHWT7U; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CSKHWT7U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=CSKHWT7UcUFfwMH/HLOjsldOiD
	kQV7OGDlu0JY1jigyAZu24CPUnZb6bw/mg6kWe9qilv40m4OlYG/KJTtaTM8zio1pcn65H+cD90g3
	cnL4VNwmVXZTDuZT9DSFDQNFqRMszsYZH9ZMCpD6HP/4gmyMdPsBYajbB2OYyt5oZVtFjhDcF7jlg
	iFZlpM/emjH79Jp95nQ0XiWl0bchiqPlL+4zm5iqbTfhQsGPADfSa1o7GK5yB/k+kc5E1DMtvynXk
	z9C3MqXDtdHZn1sMREnmjncMBZY7yODeuEgyOCXrJ8rSQp7ajxktpnugiMbQ1jLAZdAEyKqVF+vjZ
	zIFwu3rQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkWbs-0000000C3SS-0qup;
	Wed, 13 Mar 2024 21:58:04 +0000
Date: Wed, 13 Mar 2024 14:58:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/13] libxfs: fix incorrect porting to 6.7
Message-ID: <ZfIhbEJM5hj_mGTi@infradead.org>
References: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
 <171029430572.2061422.5338863572852946572.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029430572.2061422.5338863572852946572.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

