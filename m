Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16953BB47
	for <linux-xfs@vger.kernel.org>; Thu, 18 Apr 2024 04:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713414143; cv=none; b=h+/67X1EuZBK38Q9KHziz59hCJBOx0e8AuBp90csUA60UY6+wpkp2NKLjJWMd++hxL+azM27pmko549YBowHDlHrMyKzwzvrHjHgrbpI3r0JZVGONDKdkq0J2S1UI22hyLaWlGuzPyLJayCBf1WOozEF/1GaOGaNvP1p6/iXPXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713414143; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jHfUcCvu8LHPqjqky+deVWlbbtWeA5bonKLkAH952+aJcHY10lORRR9FIbt5CA9nVg9JW3Px1ZIJoVl3d9YdQZI/hUPA6HTe/xWPutx/MLlTB0e3xWSZ2Xo9nLthfxpKXuTluTZlD0rPLHsV55NrVS2dUPuY06lx67NEeSxTaZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xMi83AnE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xMi83AnE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=xMi83AnEVZDN9O+qEEaoioB1OQ
	dwc/xAbLhvGBDYOzgtoc5qURFPkHkza6j2Qb0nHZ05OwHbmlWM4qBc7rNdYttUPraImn3yA+FVBb1
	YK5qOJ1dauKzA+aCrKmGnWBwk1LoJqvGAtWXu9DQQSwfFXFHnKYh158AxapZ3Wm0Kl8n+QGOF/Ba+
	Uf9ze64kdQPzaf1UpQ61s3hcIOLkXmb83netLjNP+uhkzf4Qsq+mZMQfvYPXb98e8mc7G83UirhTG
	AqJEvCzczK7+iNNmqpYHAz6OlxxrYESPSLLOM4pIO9s2UBZwOoEM0ApAtmSCEPCpgf1Y7nIvaOiAW
	j+MiLxTA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rxJHx-00000000t8j-12s5;
	Thu, 18 Apr 2024 04:22:21 +0000
Date: Wed, 17 Apr 2024 21:22:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@infradead.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/2] xfs: use dontcache for grabbing inodes during scrub
Message-ID: <ZiCf_Uu5yHed-tYd@infradead.org>
References: <171339555559.1999874.4456227116424200314.stgit@frogsfrogsfrogs>
 <171339555581.1999874.6289959953441529247.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171339555581.1999874.6289959953441529247.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

