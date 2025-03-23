Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFFBEC4;
	Sun, 23 Mar 2025 06:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742711518; cv=none; b=khOir4VsB43BKJVs9/Gv4Ajmbn04t1to922TCE2BYTH+SBEYJLbfdc787ubdf2iWJsyUeOh+xE2BJpsqw4iz6PPwUWg+0hBI++6ZyMdb/MqN/5RWgX/YBKhD2HT7+ZRo3JEtrgJPBc10rW53GyinQqHibWB2y3PdTPAhoF3gSeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742711518; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LzKgbqWVDhnR9VotV83F6kmtcXl4R9fHLT1O54EGeIqqH/oy4LuA1x06TZwPyI8zxRMNuMwjkMDRczwz1R+rS/pA/y86swptSajzMQeQWZAXe6Qomfb9Efe52Fxwbi+/5K12/7IMpY6QeQ4GrHJWnN2ZHQY39kBBlYSmCkk3smo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Nj4TD8K5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Nj4TD8K5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Nj4TD8K5B0zmaSsRmbAlo8MYY/
	6LqhQDhWrtPtdg+EkSFd1vovCxXIyAStb2hLhz09aNF+sdVQaiabT2POU3H8s9Xk+N7pLOY2GzUZ4
	tMzY/bi3WX4vSfSZEUYLlFtKWI5ylLmUIlBgWw/etdbTvJ+LDKM2WUhZgdqaj/8MkjeLd6+HYnFkt
	0EjJaeJVb9TDNN9JIfsixYBSZvs+XLyDbHM53hqwVJdBE9JCqLg57+Ccf0MfdhsoaPVQ3GWKQIGI0
	8+IisYBqYTJ7TTjiFFPM8clW2SzqbR0INp7/KUBpp5B+zTIpRAAK7J5BXYs92olXSUds6UEkHVtuC
	zIxTKhcg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1twEsF-00000000lbE-3Ofo;
	Sun, 23 Mar 2025 06:31:55 +0000
Date: Sat, 22 Mar 2025 23:31:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 5/3] xfs/818: fix some design issues
Message-ID: <Z9-q25mBMMDWG79F@infradead.org>
References: <20250312230736.GS2803749@frogsfrogsfrogs>
 <174182089094.1400713.5283745853237966823.stgit@frogsfrogsfrogs>
 <20250321165418.GP2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250321165418.GP2803749@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

