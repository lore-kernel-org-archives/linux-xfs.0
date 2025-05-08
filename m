Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B04678F37
	for <linux-xfs@vger.kernel.org>; Thu,  8 May 2025 04:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746677872; cv=none; b=Z8/1llgUoSX2gChQtWA6dUb4qV+pYiVGFbydj2bQMnEKzsL6wIm1ogL8vXvogpP8o8AH+Xh5RiBsgJf5LxM14JlAgqre+H9fikWQo6P4PoDBVQ52C/MofxXtSe5sG/I6mFdrNzTULIJ3ciYhC6A3h8fqcVCisyD3PaC6nTBUvBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746677872; c=relaxed/simple;
	bh=SwudvzbXDpQAbKSvq2MNfJNb2SsOppA7fW8agJvMKz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fdCV1H6nNQqSh6Wq6I989SVAEySOPdLvmdyNh6zqAI2NOlT2lXuD8Dyac94XCFCxwvc0tif3D3/ztadWPxQ+QqsPtp5gTZjnw4nTf+r98Iri/Bbq12BupwlPR6H/7VxyWnNn/ZRSq+2WhF4EujokaztP1MG+quHBSGELJvqGawU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=s5ja2k2y; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="s5ja2k2y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=u+upG9ormZw0wvxGuxC8ChqAXuTyAReRJx2+rBcr4zQ=; b=s5ja2k2yW7ALO71eIYlGPX9Pp2
	1XwW+qcUC7QFHyon/wgUvfnMl7k3eNMjyr1lRjBxqg2k0h5LH0ReIgrNUAbJCATjz+5hwIXgk08/j
	ofvzxB08Q8VLANM234GW5j5+skAuj6xE3ni618FRCqnFoEE8difwkUMsnY+hX4rfcNv0gY/0cA1Nv
	isco1D3x+asdAmRILMr2tLJAMLnZsGfDshWhAglGsvDSYYExnY+JXtC1DmLP6MxMvKjzj77G1Bewn
	CQ4k7N9lRfJaeUIvm853nBhA+xpjqyQYZ6l62p08so4jnL+lTO5i4f1LdzsOGRRAaEttY1GGyjusP
	dN/SACgg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCshj-0000000HH59-0ZBr;
	Thu, 08 May 2025 04:17:51 +0000
Date: Wed, 7 May 2025 21:17:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] XFS: Fix comment on xfs_trans_ail_update_bulk()
Message-ID: <aBwwb7zCngkhpfum@infradead.org>
References: <20250507095239.477105-1-cem@kernel.org>
 <20250507095239.477105-3-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507095239.477105-3-cem@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Lot of spurious capitalization in the subject.

> + * Items that are already in the AIL are first deleted from their current location

Overly long line.

> -			/* check if we really need to move the item */
> +			* check if we really need to move the item */

I think this got messed up when sending, as it won't even compile.

