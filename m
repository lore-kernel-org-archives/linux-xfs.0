Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE14128370
	for <linux-xfs@vger.kernel.org>; Tue, 22 Oct 2024 05:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729576695; cv=none; b=L1tyKRIZ3aZcZXMuLb0Lzk+G75Jk+l3VX9tg00XOz27/fY6GNmWDS0IlZ3M1tklu2pzY60pC7wTyR8v96gqzlSUKy4HyuFi+QOyAVxOt6Z3UFlmWy/MQ1lcrymihFmgRK0EBekkBKabKVNIkeAgniO3bf0iKdPOhe7XZ9RFwBLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729576695; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QMVi+1jnCx3L/TJpcQe76CtAFkJanlHggmaqRQnFyzTFPsXQqaa+1V1TjIL6/A+TUvjqMrYaKVv2ZOYyhzG56oViBt5EIz+otZ40ZEWmKTztTT5M0Iw7HPLzlJqoQkoJarCjxP4cyHYx6tRMw4OTDNTlM3o5W/hNW3NeC0NfPoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dDhTh449; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dDhTh449"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=dDhTh449CkGDmRWWCDz9tvDiRd
	8lgzypvRndp1KnqxVpeO8BOLKuveZKEWdgJNN87XoqTsKZJmuybqaY1PTyUbKBAL7CLdQQsuaE1cG
	t8lCma+0djCaTkExeQnxXcQra8Qznp13O3PyczxH09KmFhWpnucRmNV1yBZZcSPGGxeX5tkjCqZY2
	lIZo4oIWzqi97g2+g5HKG29OLea+rs6DYFvvSjNUnlOiVjjtl14zi9NrShDkAOttoTDYNwPHwyp2w
	soVYmwRQf37xgl9FK7rMPM1kU+qfmQX5yYfHlfPyciU2zJKG/mT7ySmevgkl81V7MQcPboR5v2gRI
	yvEd6WHg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t37uH-00000009jL6-2S8f;
	Tue, 22 Oct 2024 05:58:13 +0000
Date: Mon, 21 Oct 2024 22:58:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/37] libxfs: port IS_ENABLED from the kernel
Message-ID: <Zxc-9YHJSDFYvPy1@infradead.org>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
 <172954783517.34558.6960888274382502007.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172954783517.34558.6960888274382502007.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

