Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C8F15D5A7
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 17:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709139965; cv=none; b=upaoMRdQL6hjTW4iS+KiGAQ6aIZz0HsX/EPclBtx3RkuI3+xEx6OHjOblwSMiDwavIVoiHdqqbQjNKvE9m2shvVxXkGTikIvlO6TgsUWnIY5i/AW3Ohydbbpp4CFh7Ysyx6CRacswf5MyvexXU0PjCLEjh6uqIcb7Odl2J/TA7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709139965; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I8/BChvAQGsb/lmcHbjVNrVWcbPsEHsAhn/Upty1Nm1Q136HXX2sRIkAjKp0EyRmuv+05PJOqtEl/2oBmbpefqUdjOy50w+kNFVRboAthM0V9/dbWE4XoWJsvJJqGrkBrGErMK77bKWu+hvwaCZsAEycMVkJIrpiJri6pdMTbFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=M6FTZxI+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="M6FTZxI+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=M6FTZxI+2pZR7FflIObHYn2Lom
	qP8kQzySlmPj37m6hRtCqq9zdO6y0+Am1JOMX+rWEeXw9n/xEMaxoe12N0hWETqW/YJ2K1+EpWA7v
	RMefVplpi3UKwGLhAaDupbZWNdL40fkf2yWaVRSoUBEyJqoq5Z7bNDKy6PC2sKIcTtMOmLed+oosT
	0GFIfNLweXoiU1f8E0oTH3LDAuKulXSssCnvyWcqvvBy+K3hZYYb9iSewHSneWSY8WX3kvNQqyjA3
	3T5d78WHnrZTUC7bpy9BwAVzX3VPjNTKjzAualfIdJ/ahmI5/0papwZ5l1H2RalSRNmMSIlLu7ftt
	nxg/lmKA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfNNb-0000000AE1a-3BM5;
	Wed, 28 Feb 2024 17:06:03 +0000
Date: Wed, 28 Feb 2024 09:06:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 4/6] xfs: scrub should set preen if attr leaf has holes
Message-ID: <Zd9n--3zQplF7mjB@infradead.org>
References: <170900013612.939212.8818215066021410611.stgit@frogsfrogsfrogs>
 <170900013696.939212.6555423507350211535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900013696.939212.6555423507350211535.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
