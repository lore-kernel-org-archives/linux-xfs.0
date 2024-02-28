Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B633612FC
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 15:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709135531; cv=none; b=G35HKS5Q3VkzX2KPmetIkfgMRU1i1LykcQ1aXcdC1lgqy5R4cMKdc2Zo/n+Ht+pNc+4umMd8ql5eqazyPtmSht3rEweiWu9q7QcpUs8myIr0kg768Ze+F//f3jG5z9PheCXkIISOeVk34pzb6ioBtXncCJCjQfTx4niz7YWv1C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709135531; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g7hsCasXaAZ6l+zRA5VBfnCkbPOJhhP9sUalFcs4AQ+zMVpDoztFAGRv3y6Uw35xUTo+GuwbohMAHJoD3EwrK3PPSDeZfhMYFxQsL0fEgoL1GBpFl4xPSlKPN4xjdWCzZhDeTfyBqcU8Hi4ZpCuyDRV2TrFaG8r38CmLJJio9yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=S5cDXPYj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="S5cDXPYj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=S5cDXPYjKF/dtb2CgJHLoO/m49
	bV8QRbPZBtd720PThXB3Envmux6HFxcf9QxcB6Q5/fg4EctFl0+r4RsoasBAI67S/WG/WN1XkYkgq
	VeDPiaNBlJUcKlWE+T0VqtyPKLqs2ixRMA7KbIOVHiFuJMppn2KEifkvrOOzwBsaje8ZHIfAaLQ8x
	aksDWM2krcL46Qv0t1nP2O6sBwqJ+1pFNoIModsHj+1wY3kk1f5Q1HL5bHr1l/RTpeKKQLFsMOY0k
	81JJSDf+b9zsFS1kg1xCFzBD1ul8JuqqpPg0swbMHjMhJaFLDR7HJB1g396eg1s/GYCgmhZ548Ffe
	5OeBBU5g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfME5-00000009z7v-2egz;
	Wed, 28 Feb 2024 15:52:09 +0000
Date: Wed, 28 Feb 2024 07:52:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 13/14] docs: update swapext -> exchmaps language
Message-ID: <Zd9WqdciEVb8WH09@infradead.org>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
 <170900011855.938268.10348845286950504949.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900011855.938268.10348845286950504949.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
