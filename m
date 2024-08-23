Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462C139FD8
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724390352; cv=none; b=UqlteNgy74iBZA2rodCnZCxzGaH8if+lCulw2hUmB46RYV2UUchC2TdD+aAbCXYoOhTk2TlTHmVVdEjlygh5u1viCvkCy02LitNjSaBgvtGtEuWLz+RBcC/383oaEH8euUjnlMX871pHZkZ/jqMSfEmbbTQrRivgexDbqqOtA1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724390352; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gagIK8eQLpb+JLIaTzK/m3kaf6cTIR+qqCbmIJPxhQ+b176VrCl+zxahQDdR0epwj26uhahaZWi8/z7x/nDrdGYDXDLPppQoFhKr2J9QkTg+BMMevne+0JqdNGTeUWWlKO1MTwcg9U9KEcHdxCraVRVuaRo34Wxl3kt1nlS+mnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jsfI/WPV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jsfI/WPV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=jsfI/WPVo0K6RSZQIHkZQ+kBRb
	5SnaCLtHvbfQrW/TiKq7l41m4Jre7ViCRRGhntPGwrOl5q3d6X6G/QD6NeguqftDsMCKgg8Hqpdd9
	EOWTNEWFOxP6mBONbi3DeCdKeCGAEjo46sekDGaZXgfnjuiAS+FkZBQruwi+x5EtMGbXy/op9dDvI
	FAyT0CcBlnOwYqWE6LIwSakKkNaTbSJWc+ctMjcrni2/+d1Y2F/UW1hhS7uNn60GeR1ONM0etSaWy
	+SkeWGMiVw5JxEARRILAPWN8Hrxhb3n66BDrGUwaiXMqsK2KZDp07T4B5a8ASZcNfbJknjwlcIXu0
	WCiA4i9w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMha-0000000FHp5-3tpG;
	Fri, 23 Aug 2024 05:19:10 +0000
Date: Thu, 22 Aug 2024 22:19:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/26] xfs: don't coalesce file mappings that cross
 rtgroup boundaries in scrub
Message-ID: <ZsgbzgxScnspGHIE@infradead.org>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088904.60592.6390649383741617327.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437088904.60592.6390649383741617327.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

