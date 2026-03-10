Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59D33A4F2A
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 09:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773134741; cv=none; b=kAC1RBmYivedxDWHDaG6R0f1hbTbsGQzZW0In5Nm5v+HwvEVqIr2LLhxn0qn1NAFhVPseLfJ11xUTQ7cLLNUZOwbr9ohGV/4B6SozUhKowvtBL7HhzBA2xpjjkaRTBJJjxTkM5RdGS9hz9vOhQoV83pVkS3nc7ruFumkSOjQ8/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773134741; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PMwPObFtnqVsMs1Ls/dgsZTtcsN3RFVi56tfAjZmj30f9qpJlzPirQ+PQHZLW56Mm1EC85fjKa0XPnQsZN2rbiTY9tzUPwBaGGzFLHVQFu0UQP9zTUKr4jU7D4Hs0KE2BSy1qaGpb1RLMQVuZ8jv1+1rUcAfsAI9UHERKEkuDe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CM56+poH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CM56+poH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=CM56+poHS63fISm1DT467auDOo
	yI/zyH7k+4NO9nyEhZFrpsgC+NtrvH6J7FoPhRguvRNJhe4AHyTIFOfQAMkth09VNBghbhrZtgQNZ
	51Zui8DtNHxyWElIwD9NiAPl1C98BuXfDW/qnsnSmbiSZaQHPLJsXwrhNlOvjhWXS1qgDHWFuMRPu
	UjuLudLnDsImU31LXlMje3RJ4ORlS3hBDoIZGXr324fzuYnrQintlEFEHLZEdzlCLW3NN6OuEiVZx
	uO0I3+h8BEtPZR7JkXIPzO/FeUURm2umHJtZDvTCz/f9HsOtEREEGXv0PiZp/5PQf9krrfqV12u4F
	e7Xh11rg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vztLP-000000095Hc-12jT;
	Tue, 10 Mar 2026 09:25:39 +0000
Date: Tue, 10 Mar 2026 02:25:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/28] xfs_healer: create a service to start the
 per-mount healer service
Message-ID: <aa_jkzIBRh1_bD8e@infradead.org>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
 <177311401718.1183235.13807931515634815060.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177311401718.1183235.13807931515634815060.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

