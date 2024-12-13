Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD51C157A6C
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734080969; cv=none; b=ohxHxcZMWQOYfYLO3ck1PCeZqCw3qy5rlSXuQBeUzBB91keqkGBu06vDhRwz2JEj1rAkeHUzOS7StHJdzlHzS1DqpYtONl08fHFi/FDyy93jrCUVDZOU6oI5S3ZA1Xuv9fH9DOrkpUOXd6O40ocUQyF+A2SO+sVH3D2ps7Q8UuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734080969; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qoM1vtBZcIaSFkiCNtnaaDLPWZUZ6F6RCqrp0VmGebIbvZrKad1+uJPre02yPFKJPp74aOBCEvM67GlW4+3jyFR/fuCqpr8Xuks1qtG4tXrQf4wYrTfgek1hT5jXKlb8rwXIzCvmBerS7Le5oXuapYbhNKPXOnupL6XIGQxlBFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uc/nwZL3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uc/nwZL3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=uc/nwZL35RyOElCm1loChcc2g3
	0Z/vQwdz7PA/HDF4rLFZLEO7z+75oVdMEdYvvmCpm6B1Vnzn0qNZmGu6vDecVhcbZeRcI5NYqQIRe
	CSMlysZgG32nxwHtA3bG3qGJ9jtTU4nS5hSEMVsODNhhFw+Yg4fCGIm11/vTG/wNm8SCyhSjsaBa/
	zSlPVuTTs8AUFizcjEY2QUaVSrr/e2RZXKudBKZywFvAudGlmo2j30S/bCgxRQXZ6FtLUb1axndDO
	8oB0BBYNCfSG7dz6mdvxhwX2ex+5lvqQ6cULlMFcBKIg9KaMAEQDo5PRFkwx97HFzpx2wX1xg6Q5x
	vQ+vwpjQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1fr-00000003Bqe-21ZD;
	Fri, 13 Dec 2024 09:09:27 +0000
Date: Fri, 13 Dec 2024 01:09:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/43] xfs: prepare refcount functions to deal with
 rtrefcountbt
Message-ID: <Z1v5xygcKjpWIH9p@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405124670.1182620.13744202774701671253.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405124670.1182620.13744202774701671253.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

