Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178DB1632CA
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 07:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734074600; cv=none; b=RWauUJGaq/LUgmY1875/Lexx8RfOxtQzxGXqXOBWqucdwVtuNQHIL/KNh2iYNIo/N4AznIHo0b+uCUt7n8PRya2TBDoFNuPCVC7DcCefTSqMph2oSC4aiP7wH0vs3vMv0VrhWPYyx0zkmXUF3w7sejh6T00n554t4JBndIvVkjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734074600; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QtfKRv9RekqHZmTlwfs3BkdzC6os6f5+fTG92aJ9RTV+DhE9CvTxA3AT1fgQZa7lhYaa6s5AjbI0w7yEBfirrLn3ET7goOxIZcFQe5OZWgoeJzkFei4EJFMO1CzbaTY51Q90vAQzFsRim10WYqsKTvu97YZGc5ZLQQ6nbiQ16Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NNNkMYmK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NNNkMYmK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=NNNkMYmKkP0vvRVYKhz0nG/naf
	0U263OAZiHKu2KnhdHObupDx/ih1id1VOCFS54ALhsqzC0OrXBQPW/d/Hs79kPsgOsmZK9LwOVtBS
	LRfVMocKoEaRjK8M0swY5ScV33mTVXEIJ58Xkkl4Pu6XqtABsgJwx/8CM/Kp/5n5LlMoFeSZyg4Lk
	lDeWpKjxeurE32n9IfUGu+e9o3Ob7lWh8WH+GjnSyuofphWQGFxvzPa69TiHnMLhKTaFoFY2D8RYJ
	X/IkOvDFp+6XnBG3HyoAFZkNuRVepPrJdY+1654Y251p56z0O0lvjojqbimafSoG8TRyclSK4HWYA
	jgMeArMA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM017-00000002xGr-2h0U;
	Fri, 13 Dec 2024 07:23:17 +0000
Date: Thu, 12 Dec 2024 23:23:17 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 31/37] xfs: support repairing metadata btrees rooted in
 metadir inodes
Message-ID: <Z1vg5dbgZNYss8Es@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123847.1181370.11971021393841190421.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123847.1181370.11971021393841190421.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

