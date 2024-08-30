Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258E014BF90;
	Fri, 30 Aug 2024 05:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724997476; cv=none; b=P03LUqLXM0WJamzDRztO1HxeHDj+URZrTLmYEhS9msZ10fKvT9WAVPB0iGu8HVtcVf1IxJaz1Vo/7O1mrb5P0olrKNstUepTdVJdnVeYIDjZZBbUYQaRTPcsS0B2UbpAKiA94OaNLPHyhnrvm72RLlZhtfv3Ns++Q1XdngmnpPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724997476; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rsWcai8/Iz2KEVv9ezJZLeaovSLY5UA/f+6aoTehY3f4jY9S+MMVY+1rv8g8ueg7ChsrFKznYqk66KJZhRqW+9pfwBJJsSo9v8s8njTask+//98EKSUviJ9W9EjqNL/7sGrAXQl/5mOWuJoBQpFitnRa3103VyITKgxRerJ+SpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dCkTRser; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dCkTRser"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=dCkTRserPCN2Ng9s2jrY3ecFfn
	5+qnlOjpYS0Xzqft0GKwZfjkL7Qiom+kID4SMC+1gD18u4mdCWK5ohLvyEktSfOI+Ropfn6qyaChL
	KG9NZWtoCyG0M6hcRaMpXcxUwCNiKZWI7bf3fEsn3SoBAuRQ801xaTw68r2Ws3KKN9WjV8zGO+yTG
	AUn1FTs5EN31sSOT448v+s0gfJGXCwjCPS4gtABc+EMB6VkjpcdIGpQXSTtmakPdz3wVAEtPaPp6O
	GlPLQDvhv9enseeFbeK1gCvTiGPkqInJzvFOi1F2WgYU2jcylJin61c77rAm5k3Kwjwpxb85DuGRZ
	nS1z0TAQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sjudu-00000004sg6-2teK;
	Fri, 30 Aug 2024 05:57:54 +0000
Date: Thu, 29 Aug 2024 22:57:54 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: functional testing for filesystem properties
Message-ID: <ZtFfYsDRgm2gvbZD@infradead.org>
References: <172478423759.2039792.1261370258750521007.stgit@frogsfrogsfrogs>
 <172478423776.2039792.13195157691349611058.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172478423776.2039792.13195157691349611058.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
