Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7543FBB9
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 17:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709140336; cv=none; b=nSiXv0oW9fQt1CqF32gTO8eez0u51LjY820qn+Tu/+kPjAFCMJbSqq72wZzF4JVrp5KonMPPmY0vE34YyvpJ6CjTTrH3V0OmbUS/5WKrAIzaqsLsTR4eJSEYg4O36NgDpTmocp0SnQboGYJ3AD5kHwY+4urE66Nichn/y3g1c/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709140336; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ae8j8PkHuIcUWQvINZxK/i1a7M7JSPrNcc21NYqfbmECUp5nFKWUHbmdpeHOw5AtW395xZtsZpEGBnytz3zX5t1iqs3gxwNhSS90/yBs4T3k0I9QwU6y8LWhFfq4+dOz7T4JuX1QBrjCk3bZ4u2Wb+zEVix+zIeKE2oOWPy7LH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Im+6TyEz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Im+6TyEz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Im+6TyEzweh6Xsz+mg3iZBdlyf
	wcd1feSU03SWlPvpeCd9oVppVbT7AQs9blRPPL3+7Im8qP9/CM+zVYVPmwnl1j6OGm0C0mlSGZdPP
	EnDqpVlDiownmVi4WxnwexGKL8aJc2zLFaOa45cq88oXXZtMpciPBsrWXXh5GEcpFgCBAclRMOrZR
	VXIHEBGR8lz95X/a2rbqVOmTtctTL4QuO+Zha9qrfdZr5JCp5Y2KL3Lfjt+yKFHnYRoBHoTxYt5QK
	EdBaXevIhhFPrDRWC4HGZyXvna0R08vZ6epSh/LAKBdv5elkHOfERmbVRMmc+Dyl10YnXF6RjBXkU
	RPrwNrQA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfNTb-0000000AFNd-0OZP;
	Wed, 28 Feb 2024 17:12:15 +0000
Date: Wed, 28 Feb 2024 09:12:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/2] xfs: ensure unlinked list state is consistent with
 nlink during scrub
Message-ID: <Zd9pb_Pvd2zGet5z@infradead.org>
References: <170900014056.939412.3163260522615205535.stgit@frogsfrogsfrogs>
 <170900014076.939412.5263933989053425912.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900014076.939412.5263933989053425912.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
