Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20967FC1D
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738907907; cv=none; b=oqaO7c7fa28G+WAKIxdNf6Ka2Sd58dVx0tq7VhJuK6I7GjF3jc/IbC27b6hcZ37mNchPWKbR20M6Ry0ZN+r3KuaqFixG62qphg65YX7iFsvFAEUNeNImQU7MFNvP3cuJatWXWynYi52dzTBLfmQAwP/OED7IXaP1s7bXFZGe36I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738907907; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J/yJwXJf84xQYvTuRclohHawViKefEkwYq4BwSp1IQ+Vkw3qmosQ1YKi+SBIiqa81iu7rvvHo86sm4j2kSs1L1zil/EKRtsPvWrLHKUFWL5MDEq0/P61urfiKH4Nmm9w37OEPjStuB4c0971FB7tiLvs00u6gb3D4v7dt7/ifx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ABLuPVHg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ABLuPVHg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ABLuPVHg0pxWs9W3JCMuPdqgi4
	40f7byGlEfiAXjfCk5L8E01X3OtfPT6snKU5/qW3ceW/F5vVND87lVAOq/370Sc8cm4UKceM9UbxY
	vkB6HsuFNblFTEpkP4iLuyNXY5JIfRdZuBVmuoWlDibeJkh9rLNYAv+igGMR6BkNzq+eODnIqcwaA
	VvcxDF/IUFrZMSoF+T1Q8i3jlVmouXqELnoHYtr6PB4WUYAP9oV28wH8Fo9QBCyWf0d4tQQIiWneR
	QQgJRGCX8GInnActloXGX2w/WedXQGS/EslSvGFCfKOgSlxO2D/3iiaAsplCGg4A9h2Ub+7agVPoV
	AvwtDRAQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgHNh-00000008RHm-2g7U;
	Fri, 07 Feb 2025 05:58:25 +0000
Date: Thu, 6 Feb 2025 21:58:25 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/27] xfs_logprint: report realtime RUIs
Message-ID: <Z6WhAdXfzbUg_LX3@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088479.2741033.18274174802899432825.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088479.2741033.18274174802899432825.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

