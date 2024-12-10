Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2552D79FD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733808681; cv=none; b=hYYHQErBMp97WjTnnC1Op/e9JKh+tmOXS2sK97wJK2Yf5VglmgarWR4yReP0B8ftMMPt2yrPI3wAy2GH+blp+KBSO1wjwVrRhNUjS3Ophencysh7AL2FBiRDLp3l5KOaJKYBCH8FkUwGSwZLfq/6huW4uNMcw1ECW2ud9wgioos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733808681; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=odfDlcpfJPRQXSKUR1dDcdHS0dwK8nIwdP5hAC6jj0bzE2Yue3RKlnWmoCyBLRHp3L00ROA+R1vItM2h25SPgqrsZrVwhIz4Ci2oYtFxDlZ87rEk0MYkKs1j5maj5AV6td+mNAi78RH1+x5B89LM+8PLuFPlFMuh9DNwmw1WoBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZJnjls4M; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZJnjls4M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ZJnjls4MjZI6yOZ77bLzVnyyWO
	Ra5l+gQmt2nTNTj9+2qlIjsD/PAL+t0KK2Wl7riDN4y2PGiPR6yWUT0oNNOttNMxqM6JvOpTleN6+
	BO0ILDzVcDW4t2UsXuPIfVXmcec77k95kZuyuoJ4bO17gfFzQNlB1eBF1Lv+0D2FXoxPu2AgR3Pma
	43364ZQ2VdvkZLMi8iUchbrXoCiM1so77RiHYwSFcWKzyclr4BX+JtYU99RaGUdMDtLBxue+j0SMQ
	CQOxSNdTJ/KwOXd9aiRYkACNsAnraq5Gc0V1nKvcFIX07H3JG9eqTmVK3o4LcN4c6n/SsGLNz3f1q
	XD55MDQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsq7-0000000AHs8-3Oij;
	Tue, 10 Dec 2024 05:31:19 +0000
Date: Mon, 9 Dec 2024 21:31:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/50] xfs_repair,mkfs: port to
 libxfs_rt{bitmap,summary}_create
Message-ID: <Z1fSJ9c6CE7Brhat@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352751992.126362.5121798366403344201.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352751992.126362.5121798366403344201.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

