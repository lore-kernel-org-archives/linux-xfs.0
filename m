Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC45612D771
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718944794; cv=none; b=qv6YAQb+NJj/X8595rXCyp4RGjrkOn7sRaKXozG3WGZdpWh51mWSia1fCIPhvUV+qb7NKlNWnECTV1VaiKqo3A5RK5yiea8l4nWc9lgMZKWc9XHctYpk35pAA4m6AJ3se7rkfc4S/waUDE3wlpTDe+M2hGvVcZWVvdc38U5plkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718944794; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yte9e7t7NU3UboduKuqeKvQ4zDAAVosPzehtYKXF+hPAEqcO7wtg6rFbH59mJOeUEC/+Q1hbPNpSKDisoKqG/WusdXUR8uc6tGPqIxRciRUAzSeK72q9Jr0uxqgXlPiP5xXagxWShk1A5AU1uD35gmYoFwgQn8RWBfWR5wrwdgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eglOutnG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eglOutnG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=eglOutnGo2Z4DVqEvCM7vBvdeU
	FaX3qcYdsdnIjnuieDmXDg8SXyUv+gmL7bhfYlxuIuKzaIh9snQXPn9oger1dTnh6vUYtO9+TTqoo
	DYbkLJHrdNnncxSoS0CtWYMo54JWGL1a7Lnx+/s19v7s1jGtxQ0nu39wsnoNYUfbz1ogjbwh9Ug/z
	DO1rfXX3uZdaf4ezoaizE9hTOVDuHW4KGZO07TOsSIRJVwhHgPnodLf+Zh6U5NYKghTwyySoc9dd4
	Zdk3sdOaDAlxeG8dS9JB1OSUE6vjnfWSbhtnUejHNzOUhGZS+2xicXEptZRuZqSv/fjgBnOOvH6La
	d9lVCD5w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKW40-00000007fUT-2a94;
	Fri, 21 Jun 2024 04:39:52 +0000
Date: Thu, 20 Jun 2024 21:39:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/24] xfs: use xfs_trans_ichgtime to set times when
 allocating inode
Message-ID: <ZnUEGHFLbzxbBLyI@infradead.org>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
 <171892418033.3183075.12663415998312646212.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892418033.3183075.12663415998312646212.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

