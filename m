Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D2C137C33
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 11:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712144668; cv=none; b=bNk6r1xDPQaZcwCCsLTZ5ektZYOG1fM8ratYDjhHqluTowxVTteNRMaJmwBiRa5URHnrRiB0QltpL0t4tSIhYnxRAabJGwXBCTTlt/EhiFkQKoHA/3kHnr02hB7UU9HwaTYjMxRO6DvUgBRPVYQb6qPdn7QlEco68WrMacTsLl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712144668; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qSMJ8bUlY07jO8KeKRBsT1mHBC9s2vEhlqJCLno7G/DjCg3cfN1IChrlMEdSecRFCAw/c41dpMGYCs06MEMAfKLs33vC1sgDUlGUifrpdmB8LC1KnE27ZrB/KOp5UFO7vuqToMqcmKdAfX5jDv8b04+WT9TJ2vYop1L9QWnGdus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3trNWK/P; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3trNWK/P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=3trNWK/P5Dt5DbvAaFIXGu57xD
	xzPbJivmLTwcDeNMCvsBEkWDbuuSyJwFQtIg/25Ni9uMd0XmRjAT6LdAag2hXiYOiQoz36uHECaBJ
	9rovScj0xuxfhrN/wt3qWSBg70kuUL1xSafFWs9bYVJ4YWSxwLM8Dz1bVUqgSVsnVINEl7zKz4cFB
	BS/9yzwBE176s725tdB+ORWs3vO07636caZ2BW5NinpV2phi4Y95M2+qGKgBpxNH/6oNUJ4i7UqKi
	VHWu6Kt2yrgiWPIDd7Z2X2Nbg1w4TE6OlB1S87iYXy5EPng59Q1jTRbYqLXoM/xHyNmIoZJeanHCJ
	KWRfHyNw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrz2Y-0000000FphJ-1Zxa;
	Wed, 03 Apr 2024 11:44:26 +0000
Date: Wed, 3 Apr 2024 04:44:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: online repair of symbolic links
Message-ID: <Zg1BGon20Mq0wEma@infradead.org>
References: <171212114215.1525560.14502410308582567104.stgit@frogsfrogsfrogs>
 <171212115957.1525560.2558446048915598892.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171212115957.1525560.2558446048915598892.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
