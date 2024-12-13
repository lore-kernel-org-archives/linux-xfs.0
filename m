Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5907A17B500
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 07:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734074066; cv=none; b=kU1+gf4oivWXOMjLcmGEIGeOVL7zLvz/Dsr2vagpTFYPWdtplSFLj0W0asVS4MW8OTkktqXTvr0OI4cLPTlzzDcDlunpJtzD3Bmf7A8Hf9SwdI8+YQpbAuVrusLuR4nPUqI0nW5K9H561W26igFWhT8EwfZV9g8u3tzSxUMukn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734074066; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j9C013pHGn+RoWduZR4m5gYvQE7lkbG6tKNpdMfBaX8dRLau4bYeXFAa8OHxMmFREvl7jdVyVcGYOt4V0V6UXscCxD+aAtUgao35G2d8tr0yErMBVJ64DSkl0sLc9wrrwFGBkMuG1uIGu/yHuZ/EPvQl+hlha4V7j3+MJXVP/EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AbUmYDgP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AbUmYDgP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=AbUmYDgPp0JNprPKRjtYZCggWR
	sWO58KupMji1IJXNtMEGYF4PCA8pwXkOsm/dmEwP2k7iFG70T3HMtGHDp7p7qg7kbyupeVp7ML4L/
	dNvr8/8InVNNtnVAEmkyQyf0jJBkdJVid8KF2+/5fwV/ovpcZ09DgUt8iSQUPeDbR+UFtQx9Ruivh
	5GBCRjgvpZq4QKL6wCjDpejzXPkh5rVhOz+b63Bg+sUwD3OYF1Du6902GoqDqHmyw1COmnwpU1XMq
	fHOHMeODc3fbrfKC5KZ/ZrhyJCzpB88ZzZiQMJXT5QHVqlv4NEmUYm9rYE5Vq4hIvAmCdk5TrHGma
	r8m6Qp+A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLzsW-00000002wQB-3UKm;
	Fri, 13 Dec 2024 07:14:24 +0000
Date: Thu, 12 Dec 2024 23:14:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/37] xfs: wire up a new metafile type for the realtime
 rmap
Message-ID: <Z1ve0MLXA_SSFlvT@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123554.1181370.7813302766369370222.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123554.1181370.7813302766369370222.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

