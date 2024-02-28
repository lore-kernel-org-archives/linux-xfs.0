Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583EB1487DC
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 16:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709136081; cv=none; b=T24x9ak6LU9jYkEHWBwbHr889gnlIc/e9vkr+Cw6kqR9/B7OWw/tfmFAO+8NnNf7sOiAk+q0/CWF58qw6W/MbaGaJalBqzeeFgzwKwmQ9DDcxEZEIdeOsl4v4XEUyz8PWtj7EISBvpzoGutBJc9h7IOPzySRckr3Sxqj3gBPSU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709136081; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G8d6Kyd1A0B2hy7mydzlTGwmYO1sCpUfN9+eoRltCGKVDbEHwzJXAiYozda1ML0SDRqOkuaYTg5NG2Cds7Vc79z/CKoFwbDvyr5U9zz0dxzyMRGY+Aw5labk/Lx0Noon48n8H7kkgmzP1Rflcpj4n8d8CXOf0uCWmxCtWIa3vV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tu+/nHYj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tu+/nHYj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=tu+/nHYj5sY9B9UrBSFrIlM4QG
	vJCfzXtw9D17DqkQvHcgPoEnAnqMLKIcFGS1SCHI6XMb64pIfTXz+IQ9tHPs2n6nZYccQDspAe+ld
	XpoVtzIzmIB2oDt2hEVLK4vXJJl3rYXfwYT5rpttvUalA+6pysZefUOTkf+aXPosHpMCv0fhnFB8K
	mHjLFle5/hBJn4iR+1NPSyypMnfWSxpVVhC+0zUT0fAuOtrjoVYLNdMxP3DfnebsX49uCr9IKKY8b
	XGWQNsjPdhh5yj0UfCqt88iLTc8sOeNBG5kgEe8s7eqhb9OHNNVPkczL8EuFsjVPQlDdmrNmpPEfX
	8bIXVRfw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfMMy-0000000A0ni-011N;
	Wed, 28 Feb 2024 16:01:20 +0000
Date: Wed, 28 Feb 2024 08:01:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/6] xfs: use atomic extent swapping to fix user file
 fork data
Message-ID: <Zd9Yz4K5CfQD7dY8@infradead.org>
References: <170900013612.939212.8818215066021410611.stgit@frogsfrogsfrogs>
 <170900013661.939212.16990072999538559114.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900013661.939212.16990072999538559114.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
