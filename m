Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E73D1A8F7B;
	Thu, 24 Sep 2026 05:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790229023; cv=none; b=vCVrF1WcQ+3TpuSf76FdNrdzS+0cPx0ZPwzIXejsjkjYujE1SKU0PsnJbNx207ii/o+iq//j7ntyzOX9U9yzTBlkaXPJgdOXBOY13zNFv0zQTXrQBkM/uZFf/6IcPVssl7F3KLbcHrWjKdxs4xs2v+gIMTRKSfe25PVytVBsGX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790229023; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jP9RNjrrEEwsdhmlhATl7fOObFAYoOi8/W6znl0HuBOQVddQRrsYKcFFPRAYdgsBjvlsJhVBTzYBjm/OwzPRc2ddrG6gGPPrK1zarLZ0S6aKAzniSMDfq+piKoa6UPJOlKVP/LV6A3Q9hv4ihoNaO+eUTxIf85egkSP4w8H0M0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TW1ALpwK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TW1ALpwK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=TW1ALpwKpXucUS5lSQTJox2TF6
	x9c+b5wyF7YH1U0o6lir+QZAEffpDv66hH3QTJLNUlbrZlGty3SBnPP0x7QTBv5X+g/bcvWYtcLq6
	rPZdCHhc/GQx8Tqdggm+/GglsereGs1GDFL8S/IKGiTRsB0YxRdV9V8dx1/ryySJ0J+AQYWyZNeV+
	h5I02GD0aMHcIYb43XQmFumPbTmEV/F2WCFoNNo3LHKzSgxhu4KVJvNr+wpgxIs6ItAk4pGOf0gnY
	d5RMjEW6U8XyxmsB5qXvj3ZPAPmatlJWmF4eEnSvUNZdKP8WVR45ONtorRod1LY/VWxuB2SXCz8oK
	90coozFw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9cLc-0000000A5Kg-0wfW;
	Thu, 24 Sep 2026 05:50:20 +0000
Date: Wed, 23 Sep 2026 22:50:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/12] xfs: fix inode btree repair when a cluster is
 larger than a chunk
Message-ID: <arS6HPcrGMX8h18x@infradead.org>
References: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
 <179014159650.1875436.8215876643273751378.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179014159650.1875436.8215876643273751378.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

