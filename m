Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408AA18F2DB
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 07:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734074318; cv=none; b=hTqjedc+yuPCUhNsEgIMTZBuNiDQ3GGobtUmw6QUKvr8BCqYpr7k4Zn3Ap6cTG9cs8ASYQsGoQRqL2IVtKbHE2x0F1EmqojK5uhCbzxoz+NNV1yrWh9QzRK/AMwB5XjPb8iqXi6Z6fGtBtFDRHGFzAboMH7TZw4B0+hcnUFYvrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734074318; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GrK4Llw9GzAQmKX8h6OlciYnUGpH0UergYf9QuHuzrnikbCIo0LL+z2m5yBFE79/KmiqrVPRuuRqZ9JoXFMckZGb7ZBk/u0F+02oG+5C4XXMtP9Mj66OTWsNssDkgPtVGACngY1I0F9ceXvq5G9/tXD75wAoo4ah1RRK86x3mrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PNuUFfUs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PNuUFfUs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=PNuUFfUsa4NxNg+LA4TVodrjAJ
	2mXsRXBJEYLx61OEaMK1YvwOSPjJlVSdwu2SjwodNOiLPTniXhzp2o+y7Z0slDTvH1evD8PGMskNT
	4ipUgcBs2Vp7xXw+JoTvYP90M9/qLcb+Rv5hp2EatFQrrpWbft0BJsUfPN+f6JzI9suXwQ9BcqrMA
	OtqxRZeb8YJKOHAXIQqLKhzU/Y04gBvXDmsiunuX6kTVZs/27QT/bXTaV63Flbe7aw2d26deljwh5
	a6DqMJXTaeGRe7bl9GPla6FWkv8LJ6kcwfXyHqE+RX8z/Qbkryvs9044X2SP6YwYn+S4nGk+z17Zw
	at9w03sQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLzwa-00000002wmC-3VMy;
	Fri, 13 Dec 2024 07:18:36 +0000
Date: Thu, 12 Dec 2024 23:18:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/37] xfs: walk the rt reverse mapping tree when
 rebuilding rmap
Message-ID: <Z1vfzJMJL7we46af@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123761.1181370.4118391090133986822.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123761.1181370.4118391090133986822.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

