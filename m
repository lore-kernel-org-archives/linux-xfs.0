Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4D711187
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 05:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727848287; cv=none; b=hPTbD5RgTrDW5dLKo3PaTTpmu2AgrU9yOPz0O9c0RJPy6RvesyUp/uKeNhKd4Ycnq7igOF2VvfA+p0xrDF6fOqES32QYk2NFJbPj2zbpQW9l3ARtgmuavcyAyZYaHXOyadtupQFozPjCSh6RA3HF3A//1BlIvbr5RAYUmZbwg4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727848287; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mDV8vYKKQxMdbjXlem1Jm2GltDClj60omkSPxWXQESk7hcvJHpzwN5O6jawOqVmZZGm2XiPyPZ8pP71cZi6EF5wcQtT/NPeBKe1L1j1VPKuYWGDOMbFpW0O2lmKNIbtO44YaXxGpVsk03G5Aec2kb6/dfERDrH2xeL+tVGNGgr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=K7qN8LZV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K7qN8LZV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=K7qN8LZVkCvtSiHVrLiAKD5oeu
	7jEX4nAfRww1VWhlCBcwySe+UiF22OX2LAWAl9Lg2D5ny3uirzVK8V0WK03yj0YvngBlL4PTxRsEb
	zgznCIQmIeM20YBHGGhUOu9KkzJaGlPVcnECpSlyChX9k3iqeFQPpuBQU99s5jFOp7E1Tl/Qskr7t
	htYlj7I35vytD2bAzutUCBSOd1V2kIIPo6UA/ML2BoJ10ox3WvwS8Rfe4/R40fOH6o2sAeZKfqQ3G
	BUAHikxOfbz9zzpcGFbCgEAeEUZPPJDLNj1bKzKL1DJvY3nXQU1PKUYmfhIOlBeuVng9lDNrdqHSt
	WhNWx3CQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svsGk-00000004s49-1DYe;
	Wed, 02 Oct 2024 05:51:26 +0000
Date: Tue, 1 Oct 2024 22:51:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/64] libxfs: implement get_random_u32
Message-ID: <ZvzfXiMcOC778Vmy@infradead.org>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
 <172783102082.4036371.11970213127667558908.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172783102082.4036371.11970213127667558908.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

