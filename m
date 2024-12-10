Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5897879FD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733808742; cv=none; b=FXUc2iH5C+MMReyC1h+SnTX0nX+ajGyt4cKgMxAF1lVuefqo8BRoACN9rO6a2spbM3XVJjl54CYvqTaeYZH9qmT527AT+wSx9cqrkatA0wH+yC8/jotvbQnVS+s6WmIWBVnI69KtuElVv8SOpL3CkT9fkrHPG5CSNPlBMIiYjTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733808742; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bW1L23mPAA0hTazoQotCeZ61mbUN5pGIeyvOOthaK1sNPYSdoc/cBSZqEUkKIVw9mRiJT9R1iuLr8a8YFS4X853djZzeU8txhuKfqg0/MRVbMHAgGnRJNKD+YySbJq/ovhMvaui0CStJSuAfqAotHQV5NHmTLGHpbqnrgo4JG7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3bU1NX55; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3bU1NX55"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=3bU1NX55T5TZi+Y7uk2Zvw+fP6
	GiOtVUAtv2WjTATvBcsFANY8ZXcbVBbgsUx/z2M0yXUAsuvDYNFEbopSvBMkEGuny1BgeB4Z1Nsiy
	03X4zt0U37ujh28rzpjz4PWHgIbxvJDj8AZt18CtJ7ayAYIXJQ4716Kw40egmJy8oVWSQf5QLN1AL
	eodmwr2iHj7mwSNfzCFtsroBqXbFWiTc9HrKtTwcw5+vrJWySwoUP3iOAiM3TAlzb6giLHoq/wSLC
	FfOQpCNffL9Aul+LN+xMFHyyo/px6lLtM5L8njBK9zvmTOsXsbPzdtMef6chHDMs2gpUgrUMu1nMk
	AwH8eqZg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsr7-0000000AHwU-0WDb;
	Tue, 10 Dec 2024 05:32:21 +0000
Date: Mon, 9 Dec 2024 21:32:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/50] man: document the rt group geometry ioctl
Message-ID: <Z1fSZUwYVvXgKrNG@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752037.126362.17032439118208843597.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752037.126362.17032439118208843597.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

