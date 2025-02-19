Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDD7179BC;
	Wed, 19 Feb 2025 07:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739949415; cv=none; b=Sd32X046MH3JXhfIHcEd3FMsXz+V+CQhGb86laMtDZUZhYrmkGzMgIshM0Z/O2bovxsiBQNPB3e0Nbeq7F+PRq2cLjzssSO+pWzsHuBrCEZLyOeaABP8TXq90+vdyfaubJMSVG+6f6XEmdo5RSFIcIV3sUspRTHwnakCSfqAcOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739949415; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r4/ljzBw6E8x/6sWTFMbaCahShnlu4c4AX9GLbGa+N0Lcahka/1J79aoiVeoRUU5plFJW9fNWKP0glXq1jdIQIBHYZOlLWn7ocpS1goS4tyLG+2W/flrl4b0KoW6knZJYv1KgaRzdMSs1N4LX2k7QtarkFAN4ieVrHbq2YURIjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fAQ9GLBG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fAQ9GLBG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=fAQ9GLBGwknj/RMpkXeIZEpKoc
	7q+Q5CG76XXty6zTN/jTvYEUWmaBd/lXn2Q86msZHdZL5qifCj46G5/9vFUYZrsXbwHz3qXmghWjZ
	yV3++WSHJTgOdI/jZ9BP2Yeq+bwwPauATnSM2OklQ2Ecv79rsIbhuHgZH8utP/jPUkN2/fmFIuGzy
	GVZKlh8smXHpowV7M66VPtEDANgS2qQXkSohNuLcEXdjfWzgktot6Af1VX5lebFOiy/Hnuqc41Y7D
	HJsPi3Wgbk0mZtlv/RRzWl4CJsqQPZQCP+m+CAog8oafAAE3ZYfA3k1qYO53R/O5HPy0/xEUz3nno
	EEJcyj5A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeKD-0000000BCGF-3P65;
	Wed, 19 Feb 2025 07:16:53 +0000
Date: Tue, 18 Feb 2025 23:16:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 11/15] xfs/449: update test to know about xfs_db -R
Message-ID: <Z7WFZaops8tup2xW@infradead.org>
References: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
 <173992589382.4079457.3244666731390058048.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992589382.4079457.3244666731390058048.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

