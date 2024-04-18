Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FC453AC
	for <linux-xfs@vger.kernel.org>; Thu, 18 Apr 2024 04:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713414367; cv=none; b=koC2od4DVTGncr2CvnPPpaxqHbXUqUMXWM4rea8J/UQ7gnozHHkmTO5ezvLLjTQNpYSDFXiH3Lj1Cp06ML4sWH8mpZrzjD2zw/t+3whoYcPrkOv6fQ+ew4jpiMxe7oWNDvSo0mkmpt81n+WXzWqvs7PD5zkP4lPxI0WuYNoyn+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713414367; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oZDkVHJzOMwDEPj+IFL/RUQ3RPC1eSy3OKDbH+5dfhG1OqG3RaX6VPyEhAFn24Sq6XKytThSytTvjz50mZQc+ieW41RG8uljcYO0xClZc4uaFIagEvY4l8+xvYXmLbhoCGF8ulVEWVse594o4rh/xuNzgpLHNbTaHN+8I8KKi1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=n35KpHs6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n35KpHs6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=n35KpHs6kIiUUXaZIE4USpgFLG
	Uu7Klw1ANjYq0N9Ygss1EOWcuIgorsuaK76X35EuD+vgct2jGjwj3eYj76az3iTwZMEWzpsBOZHyw
	zBPUYN1Y0yhgtRPp1WP3iclG4zMaML/N0FiLs0L/CGD3olbt3P3R/MZITiDThsKqr1ERtWq+7rdSp
	vB99wY8amVszxIB+Ttr2TFfbeEDZlJiR7Dk2KQuQdD22w9OosBPsG2Xz3FPMf0yghfRwg6JUVDGob
	B0SAyrTfsTcGANpYZ+1FU9MwWB1hTy46uxgVfgsZQm3lFU7aXwSluyXkCniC6COQU84MTPB1IQugY
	YU0q0OgA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rxJLZ-00000000tcM-2ymm;
	Thu, 18 Apr 2024 04:26:05 +0000
Date: Wed, 17 Apr 2024 21:26:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH] libxfs: print the device name if flush-on-close fails
Message-ID: <ZiCg3RpRZKFFI0id@infradead.org>
References: <20240417231650.GE11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417231650.GE11948@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

