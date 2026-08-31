Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2EE54A7FD
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 13:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183990; cv=none; b=fEWKSCoSicCo4ko7P4vDAgzpYQcoCtZeHMqrHRTBA7MwFDakPFEIoE3CpWT4btsrL97k00NNhmNl4cUclEswznCy/kMaDgc/YFPhK60+GZt8vNUqXIMX8XuDbLIjoO7BU0mSjlOjSOPaii39x03T+iHS9Dp80UeRyuG+NWLpO/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183990; c=relaxed/simple;
	bh=LCzseaTTlGaMsd/6AHA8AdUlVTboJgCyA5k+2EpeFBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s/r2wXa4uX0B8XETAaZo6PZDhl27kcUusEcx/eVtxpkY3giheFiB2Yt5Q/uW/9hDqgtcRqfmmECMaWWTBQ1T9eD7lZTlf6i9YQ5xYmUh5/b0Mbv757u8en9HVHby1/cHJFoUVzJjTWhILqjgUylNjI9lL6seGCgErtkYN4+3aoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vOsd758I; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vOsd758I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ybh7yKS1I8XUweXgNtowtafHmoM7m5JYcC9NoqAsP+I=; b=vOsd758IaXVpNYN/5MiLRPVyRl
	+NgNrJunl/tl9145utxKzRVAIyxWz4n1XNj4AnQgcnxcRC4X/rVL9irM45Jf/gQFfD2EZPRGdszIp
	kPEaurZ8LTfenluOBV5wmCrMV32vQk5eccVnYsuUjxR4zuJMhYXRUcE+FJuPNf1H92KFou2AOUAq3
	sOYSjKthvQYcSNi/70ujv4eQrpqT9MQGDSL7acwM6DrtwLuToEI0UTFF58KeLk2zyf2JmgY/EJCN3
	PC6QR/IM5RWXuBy9Mft+18BY+hM1YPAuVzWEKTqz5bI0BhDdO0hwZ1MQtOYerC98ucVLvlmTSBeua
	LpiUyInw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x12LC-00000009Vhb-1Dsb;
	Mon, 31 Aug 2026 13:46:26 +0000
Date: Mon, 31 Aug 2026 06:46:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Chris Wedgwood <cw@f00f.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] libxlog: build the imported kernel code
Message-ID: <apWFslv-2QG7ifT2@infradead.org>
References: <cover.1788110147.git.cw@f00f.org>
 <a4fa78a72c122033a9c852116ddaef152c80df4a.1788110147.git.cw@f00f.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4fa78a72c122033a9c852116ddaef152c80df4a.1788110147.git.cw@f00f.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Please try to pre-load the changes to the rest of the code into
properly document (as in hand written) patches that do one thing at
a time.  The wiring up should be mostly mechanical.

