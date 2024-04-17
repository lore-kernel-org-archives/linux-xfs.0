Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37511422A2
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 15:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713367189; cv=none; b=SZJmOHZQ8QKWilIt4C/WWt8OQlX/J1BlmtoLrVPabS/fwAvMxFuPu4QfGTWGdospt17RX26TY508derd2PLc4fl6N80PgtbIAe/+IAUxANyrXwprXoHXOyuBvuSXD20n+5Qc58v1NQJHBMfRCVnfETzMjyz/eU25pwtnqGI2A5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713367189; c=relaxed/simple;
	bh=tnWdDXpFb4ydye/1KDzS7Vi5keob1y25yWUOL2876PI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O3SK6tLZyek5Gj4dNfMYvsk8gR3bs+MCjTgNdP6iNHNh74pMaW4hCeEDTwZXcCMArkyhaAg/YpqR+e2d40knDhVo7IrZXqOwB+XDirkDUgMiPsv5dsVKvdFWhzkvaVLfgxOScWsixI1SSitrD0kkevlnv2u6X5iJl9Xsa8bE+No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TamGoFKw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TamGoFKw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HLdinmK49r73J263sPRhV6Et9wYUd+d9dCvxU1HIWfs=; b=TamGoFKwjTvf/nVQwY/mpx4aZK
	N+hKABBokj3/rfLMRyCvDXoaS6bmymRVjb2kF38IeaxPGEFoqscTBVgcdBRjzleQEm/NsQeCaE9eN
	cT4D9SUq+arZpTJlnN/Pbw5Sc5Un9Dy5ZbVp1f50Ez5Bxcaus/AxBH2Q+I2N8EjKLN9dltvZgUftU
	Y8U0GdMLGlw/gGr6llKlz9l8IYrEgpe/LH3o30O5hzZhoLSLomOiHMlemcwB1UbeWv1+UbxFhZxYa
	vOzXySZcMjstkRAwXF37YP+tNhUfgauKuEEOQdjmRXI7JvF5VoFaIhGvJYpkV/ycJCqoojlaJGkoJ
	Ew+esl+w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rx74d-0000000GYNL-1UU6;
	Wed, 17 Apr 2024 15:19:47 +0000
Date: Wed, 17 Apr 2024 08:19:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsprogs v6.7.0 released
Message-ID: <Zh_ok7hsmUTpiihC@infradead.org>
References: <fcm36zohx5vbvsd2houwjsmln4kc4grkazbgn6qlsjjglyozep@knvfxshr2bmy>
 <20240417151834.GR11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417151834.GR11948@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 17, 2024 at 08:18:34AM -0700, Darrick J. Wong wrote:
> > on the list and not included in this update, please let me know.
> 
> Ah well, I was hoping to get
> https://lore.kernel.org/linux-xfs/171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs/
> and
> https://lore.kernel.org/linux-xfs/20240326192448.GI6414@frogsfrogsfrogs/
> in for 6.7.

Shouldn't we have a 6.8 follow pretty quickly anyway?

