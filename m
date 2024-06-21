Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D1A12C46F
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718944848; cv=none; b=Xn500NJ4AlVh7qGXGdiI0KTai4Nk4n1gqNbm9feKQ5f/SuNQmugZ8PVm0T5d7hv9/cAfB2Zv4fTDpA6aIcYNPkfPcGzMUQarM+0eekaPwGkUgBPmFjeXHApG5WjCtLllgAHjKXNj13Z6DcmMhv25Gkm+9vRpysjmm0e+BzdwYew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718944848; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JGcmy96ehobOsva8T07o5LWzddfT4+Cm5J617h5s0IJxTpX5gsWS1mU0paFJjrsW1C5n0JqIUJWGKF1eTSY3aKtxSSVs6gDpBVvWdQMBt729zDHp0EL4ZUjcriF6s4aA2NiXdutR3tVPdSdFwJgw419R0hPFYqoI0oLmPHq4jD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wV9hnNU9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wV9hnNU9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=wV9hnNU9P7G/bmiQZAwiWZz8Ok
	TPG/eUf1kVyiguE2YPbGRS1GdEftNpJ3Ga7tEcc/3OTkqcZWOgoqEUjsTFUNt3TWgQz7yp2cnybNe
	2aZKDWZbU2/BZK3A+5ksVyvs1/h9oJMH0qKpPhfjNYgVqjJAd96iJeVyxVtwxyKee0R7HciiA/YMZ
	kA0qd0miNeysijaYoaAuaRbnV77/uD3LgANhla1WZxO1hkmqb0mFf2SHGJknQqZeyD4GCIcfrTLcn
	1Ov29BpS4Vh+jq6ND21WQ4nLhAaIufQIeR7MIq+cBn2aCH4fN84xLPsv5nEyPJ8qz5z0tYl7avfRX
	8EanTXdQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKW4s-00000007fct-2Nxu;
	Fri, 21 Jun 2024 04:40:46 +0000
Date: Thu, 20 Jun 2024 21:40:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/24] xfs: push xfs_icreate_args creation out of
 xfs_create*
Message-ID: <ZnUETm682bG3YE5W@infradead.org>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
 <171892418085.3183075.6634714056147736408.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892418085.3183075.6634714056147736408.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
