Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942B3142E7C;
	Tue, 19 Nov 2024 05:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731995186; cv=none; b=f350LLdKqiSsn+mPESKJIBRF9sK6fOAoEymX/AqgGO1UyylIAdPJCDYRlbxEXFrD0hMt5QvZj6lNamBFOj7j4ix/acRdIhgxP5ppDH8x4m5fceOLiLmNEtgOTIW1N+c4HF7dRDNoEy6nYeP+SMOJgKX+63xfOHXkXWbt5UEIhus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731995186; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fZmdSaawECQhs306MeB/K5qn9+3SbQRv4IqEBKylWiaD2BnPvLUTogB4nljaOQbYuaENz1IpAlLrh5i4BhvDo9YDNK6T+NuHKwMl35PIvCGplq3OPrXHVnK36fmRg2+w7iG+3gqJQmIGCprir+g19Rq1VSjtndGOFMSi59c1rt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wJNOpeJc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wJNOpeJc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=wJNOpeJcid5Dke0nOMxHdPZqXT
	fKJ5XLTOgSwr6nyy+9g3tFR4XF1dYzRFVCfOcXdIkTGyNrrE6GKBDCttzyL0oQGGI52eVE8ghw+FW
	fjZF3AZZ1vSCIUERFUBsanIz7o7ofR8ooujLmPsKTtju6mkyORrZ5T0Xl0gl/gDY5gnxN23llxSWu
	Oln7UIvguVOo3ZVs/NL98GLVHkdKNXYxV5ML2uY9TMQseflRcSNjGfVLMgN2GpkF2gX3GmWgoKzAb
	akRnyp/pMXSUYnLJUCLl5lpHadeE/i7EOD9zUamUdl9UyiOrXASSQypix/88pdmk2ZJzag7wfQFVR
	/R+vQt/A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tDH4C-0000000BS6S-18SZ;
	Tue, 19 Nov 2024 05:46:24 +0000
Date: Mon, 18 Nov 2024 21:46:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/10] xfs: don't drop errno values when we fail to
 ficlone the entire range
Message-ID: <ZzwmMH3FAvytMDuh@infradead.org>
References: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
 <173197084499.911325.9564765824006983077.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173197084499.911325.9564765824006983077.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

