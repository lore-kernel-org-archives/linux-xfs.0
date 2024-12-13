Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB450188CC9
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 07:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734075299; cv=none; b=cB7LprUo32IFs3GtHuWzZSkSj0FhiKh+1S9tLPg4QPstvDFXe49GfLLgvmOHQXvDUeEcZexhU2hRl1TaGWLcllfk1EHA1onIQYuVHrCJX+QU7xmDVbha36VzxuWHss4oPFYiii/qRFJSYMXLLxKgW7uz1aiEnzsGLZ3Vjr4jbWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734075299; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VERGtGXtrZ6iBlN2FWE3WtSNgMGICnYjGlQw8wFwfhTRPPsMiOTUUseZTvV3UVhsZ5qJNIk6Qx+wvFuw5vjmZURyErux8XcKFhbTmZRM3iEptJ8gwry7tHbWFcjXf6d33LilGw5yWTC0GZIagj/k9GSIGinjOVgWJmGgcJbaTL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=C0kpQ6BF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C0kpQ6BF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=C0kpQ6BF9dY4iNtEIqN1xMzFCq
	eYKpdFjd5NpH4cjOKNYw22Wj3vJ5ZXyop72pg0rlCsDIlxSJTijtlxh1yhRSbIOowSFMR5Nsv6Dya
	jf9vbh3ZXc8RDm6M4UFlvaeyuoxSEnBI/8j2ouHMCtjG8vP3brbD2EWq5jBrFXmsOIiriOqxSC5Py
	+6yJc43kSIC6+UwYU5Ydp8C5rCvz8NWZSqGONnMjAgU6+qukMANaiNvePowtbP757Qi1/Zh1MpeYn
	DefS6gLPAX6r77yiLG7Yep/mGr1QEMtggDfr6WWZy2Ws0aUmzSrh/0hCoHGIkjlPYGRDTTChzIN4W
	H4fnWwBQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM0CP-00000002ylF-0xeS;
	Fri, 13 Dec 2024 07:34:57 +0000
Date: Thu, 12 Dec 2024 23:34:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 34/37] xfs: hook live realtime rmap operations during a
 repair operation
Message-ID: <Z1vjoY6E22E4Qf53@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123900.1181370.14934453235625748262.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123900.1181370.14934453235625748262.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

