Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA71E168BE
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733807618; cv=none; b=I4Y/e6KHbF7Mwn4OEf6Qxo+zOcU0PztaNNxCt+Yn2ppm950D0dzAZYv3EGCgXMmx56KZvtszAmxSWbUTQgIEgCsKH/1J+H1H8gIUhnmc4wyvYproUNANMVeBChLPaLTNfyWLQhM+gFno4JX4eU/LPCfSjpkOEV51wwnunkmwEJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733807618; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aEY20OraxtLyMs1vPaTa3c4o6KwlTxnGAldcQ0vb1iXhCiWw2GN/3TKbaaFXiNlLanYva3sDnXzcOzl4fqqUtUYxADsJ49jmT7stoi8+TVu9enA9WJw2V0UMayvEWxnrPgl7AVExqV0ktLMWZVreyzsZqQlOm/9Y00O9SbBv9ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=m4LUaP/O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m4LUaP/O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=m4LUaP/OKIeShriNWdKNe2qZ7S
	EJ5pWbxyPAqpAlHOYe3AdYiV6NA0k/d/hAjltiW/Oe3hVX+LKeeLKwqjmrL570bcA9kwzYORavrmD
	BwwQ88qB6sTwZr8PicTtBgzRCFAsF7FE7d9yjZGagkJ6Aw1tYc4uR89k/z/G0nkIm0ux0kE0nJaRQ
	jRGnIOgwCC5hyuGDWH1+bDQADiyotx29rVmQ9AKr2F03biXvhXEO3D9MPCD3kdfkHdWHWqfS9GWN2
	+ydDHoTY1+Q576yqzcNBSnyTWOfLe1OALvqXOcpQLLRY5JjXeDnnwzMJq8rnr+XBnq6QIAZMTUQ+F
	Wtbsx2Xw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsYz-0000000AFxh-19W8;
	Tue, 10 Dec 2024 05:13:37 +0000
Date: Mon, 9 Dec 2024 21:13:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/41] xfs_repair: refactor root directory initialization
Message-ID: <Z1fOARjwIKPXDog0@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748618.122992.6027492058039719994.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748618.122992.6027492058039719994.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
