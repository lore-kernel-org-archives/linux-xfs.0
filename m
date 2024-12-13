Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C4717AE1C
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734072590; cv=none; b=BGTfkIZmLsA0+8OGdrwy4+2+OL0hVgN5PAPR35mXitXO+Tw6RKN/KWUPta1Sx4/gH8qm7jxnIgl6725Gg20mmPJt5a208jiRwfCLhFFZCPWo/i+Kk1N2tW8+zY8vWiYeK3MuqmHY6NDgDoUWKJ7w72Q/MFY668TAoCJIl1UIG8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734072590; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IABouN9biwdTDj3hfYeSkzhxHL9vuCyU1fpcDvSgJW6JhS+XfIcoRsCs2IknmLiAMuIl78tGrSyzON1HS5mlIOap9Oa7aEK2t1KuUIEE/wh5YTtxWXOpDwcJoLsDmgYroPx0Z5q7QX/vOxkv30Ig6TcSEb1Ydyal+tmRknd2XK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GR27glXE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GR27glXE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=GR27glXEpTKfstnJ0LoGd/zaan
	dKpxScyJ/jYh38ZvE0ohSIkty1n1OXHZroxD4Uw89TsUxq5U3Y9l3HsVOvV6Qp0jC7Qr3k5W1JIqD
	LLWqZlEj9XWB1NkPlU11bL8pY7xTIMbFzAJ9MSzkN+bnsMhrgW4LFKa8sZNOgBMnvRel5VYloKhpD
	kQvnZdp0hExeBxJXpf5pNESQ42zuNhuKeZEM3CU39ON3qdFi8OTTupqNFemhIEkQDOnqy34qTQXVJ
	bTSmpAGBKvsppfFV9dlMwXKnVsUSPI3oWdngOIyYvQ/n8+QdZEdE+5jVEchtYTU0GcWT2QKk2ROpo
	gnW5xIDA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLzUi-00000002tzN-2cEc;
	Fri, 13 Dec 2024 06:49:48 +0000
Date: Thu, 12 Dec 2024 22:49:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/37] xfs: add realtime reverse map inode to metadata
 directory
Message-ID: <Z1vZDKl_iRlD_Vso@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123520.1181370.12338691375422114269.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123520.1181370.12338691375422114269.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

