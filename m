Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94C147D93B;
	Wed,  7 Oct 2026 13:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791378262; cv=none; b=BtyXfi3DHXeIpTGLAG07QoepaA8o4dbsdRUrv00wVP57Vd9HwNATeU8NV0X1oAf5nweEf1wo/lEGZ143xnSDjUpHPXrSo2C/bldgegVOJtgXdjis1FoR//+ty6p674g1goGleFq6S0QrRBnKy1xneh2NnMmjZOGDTDRBVrpULKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791378262; c=relaxed/simple;
	bh=MBhNtwehmoqBC4z3ttQjqHepjUrRZVSBilCEXadhZLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UiIGunM+YGP3lomMM0iDS8ws19vmzQ3GbBWbz++xh0Ts11OLBb+725XJaMTTq5G877iznEcGtMwiTNj4fxi44yapr5euwU2dAsgWpjuPyiS/9Za7syaNbq29Y0/Pgq99LkoKlzAlLKWWlUR8LiDChmVNcnQylpBEI8vxNZ9KxQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZBNNWoxx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZBNNWoxx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4fts0ClgKIWer3AhkWzgKNTOMAzirs3sN6XhDPfHB6A=; b=ZBNNWoxxQkieBRnuVAkvtKsaHX
	yOFoIudJ0UD+w0itzc9X6Vyom7a8/3I8nVt8MS6jOnI7W0pwv/R6taRF/haeWhrmqTc6D6xcDvk5v
	9L4bMDrZddxXA5DsejorgydZDWHIHHBLV6zRI7V0pc0mvw4nvOCGIef2OWCMwfbJXvljHFD1ILmsb
	Mac37ZJmFgYhQUvEMdb35qajrRi6V5a8SvCQh4RkpyJx8ga8nHWcDra5OqWVhyFsmme1YEINyK303
	rYu1rWrekogBHOJqBy4ZjENHa/+z25yK2HtKUwsjrteGrDqZugSzeus9PNll0RLL22r3BS3UxOc4S
	Dc72NEjw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xERJd-00000002V4Q-2js3;
	Wed, 07 Oct 2026 13:04:14 +0000
Date: Wed, 7 Oct 2026 06:04:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/12] xfs: always reset incore attr fork buffer when
 resetting fork
Message-ID: <asZDTVu2Bn-3OmzP@infradead.org>
References: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
 <179117965116.614350.4706792269274649096.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179117965116.614350.4706792269274649096.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Oct 04, 2026 at 10:56:35PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that the local format attr fork verifier depends on
> if_bytes being set correctly.  However, the fork reset function doesn't
> reset that correctly, which can cause post-repair verifier failures.
> Fix that.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

