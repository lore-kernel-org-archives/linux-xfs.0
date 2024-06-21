Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2390EA4
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718945175; cv=none; b=T+HXCezrcY4gK6PDUG6DpXe6OPbrP9E8bn6pz2hbSMM4Ge3sDKaNTvVIXw4zPOg1ARms45Bn2wPD8K2tqX8LWxHqy3wRlNue6Mc7YE4/a92jBSPX3PIUID/W48pedn1l+MPZWiHF6Ti79gCjmKYy2VSIx5zyCfWCtUUCbmz2/Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718945175; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P46qe3FELQGNTa1ECHpDbVMpuLPANF6z8Pxk4kQNshP2aKfSrhVU7QVFPd5Tuq1NXzdQ7HNMWdXPa97CROnFdw4lc+tuvtrzzNuyA17tObYYjKQ1HRkPCxuUD1e7MBDCxRotbqfGoxJnUmfogntjavNU8I9Lrocfx3b5IwDtWTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tDK7voPr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tDK7voPr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=tDK7voPreWuo5cZLHLsm/6Q1XH
	r7FHYPNyNjnkQvfCmmvmeo5cThUknBhf0hFybx5PmgRVsKwDG66IslfaUh9lTf2dESkp9OHy4BEaX
	qfT8GX6+E3xWqFditO08QVqIuNKOz7hseZCFrVhebFJWbQWafjpLym6RTJb7dC0Ir7tMkachcVAs5
	+QSdz8t95WAnCoTnAy0JMkwcbnVrBCT4I6M7jlWp7ZTn9CDQh5PC3LYllZumUmq9QuK9WfEM2Zth3
	iHAUyXGN7F/7PrubJCv114Xi8WOUQ6UwGmNFR2iAgw1u3/9J1awCQKDzAbFhEZhOAZOGdtG/pmjiq
	72KKmgjQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKWAA-00000007g25-0VPN;
	Fri, 21 Jun 2024 04:46:14 +0000
Date: Thu, 20 Jun 2024 21:46:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/24] xfs: don't use the incore struct xfs_sb for
 offsets into struct xfs_dsb
Message-ID: <ZnUFlgM9lg-IOnFb@infradead.org>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
 <171892418312.3183075.2680579805332636419.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892418312.3183075.2680579805332636419.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

