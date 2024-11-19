Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1D9142E7C
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 05:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731995326; cv=none; b=cC/LSjuzecFOXycSgNxErwZG3g93z7Qun/5Lwm2pZJc5aj/TadvekDhBfdAZGVoIPZ5lEAAmK+DWghFC6dTLBiNTMTui+wBLGnZmO8KnEHEAyAuDLzeBhiSI3Ie/cbtsJRG4tLZZQDm8rDOVnReLMbrEEyRSPkoDXmArCnq11Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731995326; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dDnUBtMbQtmls1jATTL+dUS+wAmqA/B7wfb5I63++7x1L2r0Fl3J2DV0N7LoA2ydvgnM+LixzKXvOzVx1RK5E6sg0FY8OBvYn6YBOfzGq/kI/Bg3Tb+cANu/YjSlIGwG42o6NZICEgZdhpJ0w+H0HyGyh6YRgtZ4ej1vY+zS7mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0tDjjrgN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0tDjjrgN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=0tDjjrgNESS4Mh4QYbZFFeytlM
	k74TFVPOMTyGq6UUkzJUhNcnZO4x4YJwOQDa128TzjmA2VEAhruZQLIfbepbml7pXykLhF19bTHQB
	y0faBnv3RQvdLaTrHU4zR+nZDBHnxb3vIqa9jWab0NOfxap3+zTYYyr1qCt2/tmTxq9E33KWCMJ0a
	j0lFDzcv/4l5Y6OKaOEt0zTaxaBZ7DDvgpVAUKw0f04AHIsDsuE0rtozgy8uIY0+YDKMHF23YHDTN
	HGyDaiIFqhhGPlauyV34NS1siy7DBX77GCQi3LCMLmNyeI+sh8hpZcyH4j2pnsKla2P0CklKpHt4V
	sJBlkE5w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tDH6T-0000000BSNB-0HaV;
	Tue, 19 Nov 2024 05:48:45 +0000
Date: Mon, 18 Nov 2024 21:48:45 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, dan.carpenter@linaro.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/10] xfs: fix error bailout in xfs_rtginode_create
Message-ID: <ZzwmvQ3Ew15HVR4i@infradead.org>
References: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
 <173197084583.911325.13436063890373729938.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173197084583.911325.13436063890373729938.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

