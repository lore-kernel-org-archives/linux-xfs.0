Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80ED5169397;
	Wed, 19 Feb 2025 07:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739949731; cv=none; b=nJwoBxsXntZx7s0MjUd5YNAqyVV1XevGhuhnd1eNj/BQgpLF48osZoseKNVB1lbybBtqQpNhrO+EgpfXO/yNeF4rEVcbfHZDTFrC4YZosG7KGB/V1Oi6WjI5/jaNo4WDhmU5I/YwbMrAWEjyaaRhmb5xqGhyLj9Czg9sr9qXBeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739949731; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t2d2JoiWA9kZjQ8kc8rF+r6uXzJ0U2aUkz3OeEQ8GhheookZxBpufDMYhEJYPHREJedkxuX2YBBakueD4allSLRRYoXuzkeZ+YkVMhHOuo9Q4PCny3x4DVv+qd1MLGs3WZ8OtBolmN2FzT7E/cazUkKIhtloXkB3by4HEA0bT8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FVFPT23I; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FVFPT23I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=FVFPT23IR5khutpHFifc4VIW74
	skLR2uOOcREYZWdBS9FHoZ6tMWk92CS6O7IJUgwP8hEY1eir56Xcnogo/4uUZt82NG9JkRZXJ2lHB
	5tj+CWZ/Ect01FT/fEdupAnnNtVfYSrf0AI/ord5JiRTXY76Em/OKWqcZBgHoIdBtfsFY7rB7n46v
	P+/X6fg8Q6JGsdR4oudRGw4ng5PKwYWgiy8/dfWzuQIOPF4LL0TO4kVKsofZQNFkItZfGHwKcUPsf
	sCEYCPYwp/zfaKG0Ot+Tm8zuV5f+FUmZPNK/3o5bCi/msTpD0A6ves23yWVOrtKQe5o1G8Fau/2gE
	sk1dx73g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkePK-0000000BDUW-1B3K;
	Wed, 19 Feb 2025 07:22:10 +0000
Date: Tue, 18 Feb 2025 23:22:10 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] common: test statfs reporting with project quota
Message-ID: <Z7WGonB-n4k1s5wW@infradead.org>
References: <173992590656.4080455.15086949489894120802.stgit@frogsfrogsfrogs>
 <173992590675.4080455.17713454161928793525.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992590675.4080455.17713454161928793525.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

