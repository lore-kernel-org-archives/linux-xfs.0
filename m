Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF80BA41
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 04:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712724174; cv=none; b=nsNv1j8ool6gJBVsObxSb/l7jneEw7KPoDFsm1HTdcB3uxqM7RdyD0HOxgzzkeMtCUVCaxZijtvdYmb1uE1D7pFk5YH0nPWXKn6/uzYNFhrYSejw1JzX6hg4AsT5D//r+v+6XOoG11hhtVeSCYuySLtrpyrTpXPglEMloQjEjOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712724174; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kuRtuVzS5smPVTyXecF1k6D+I4ijTaqQsmFNxy5jkXTbeRLEprBLReOZDbMHDoXhKwq4e4MYtz6ck6QCC4846Q4DguDUJ6FuHwxyxiQm7KBL3dzGXr3xfqouUpk91dlYDjhMgpr2scft5LOLPco57/1HyRuNINP3j2DaAviC6nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wV4J5+0N; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wV4J5+0N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=wV4J5+0NbmY52ma/WYqwQ0SBCt
	x/gKuBwZ8K8lt3j0UHJtPITUvgSJPnZIKL5UAhy3k6At4r4BRmh7164229P7zAvWB4fP0rQFFmsRD
	R6b31PTDuIRbnPJ+7xAtZ+r9gGl7I1RPGaF3t2H4u2vwJJnQoPR7B0htoTsznmnQKEkM6ug1bugXb
	LbRaqlXjcycSf2qyDyqFMUEYG/ihcWccLzZxNK43/iEr3IXvhKeRmHechn1txZwVZgD3s0hii01p1
	ALsjV9bSHxZrFpAswGXqpmYz+JRuPBIhXNWTIX0q0pgmwtzPoNpOV1LWpfDpSIJE+UeCfVsW1yhUn
	MigGAtzw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruPnQ-000000053vs-41JP;
	Wed, 10 Apr 2024 04:42:52 +0000
Date: Tue, 9 Apr 2024 21:42:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: unlock new repair tempfiles after creation
Message-ID: <ZhYYzLomEn3BaW0h@infradead.org>
References: <171270967888.3631167.1528096915093261854.stgit@frogsfrogsfrogs>
 <171270968021.3631167.3162988716447434676.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270968021.3631167.3162988716447434676.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
