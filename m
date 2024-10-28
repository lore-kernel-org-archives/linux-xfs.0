Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5425E187FE0
	for <linux-xfs@vger.kernel.org>; Mon, 28 Oct 2024 08:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730104343; cv=none; b=us0vbWEQzW96+AALCqMVICZl47t3GFZ4Q/tNJDuczzc7Tdx/mm6mys8iszlFeQ1wuAbtMv5uSBBQaSV7V181kiy7gI5izOGwJj5nQwBud1S0E9EmBYQO1+583+cUJlZ6e7Xq37XJR/eVeQWkefAxlWHSIBIeMlqA1R9hOah96hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730104343; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eNNtCwS/YaODEQ3neP8qS5YK/3lblIQ4u3Cl5qH+GCvvbLXRLrKpYz+Xd+ke4wCWjYOkhgPEw1rcVii9KT7K2H94I2Aj27wUoP2Wq7rJWLQGL30W83w5wNKRtFPvBymgfhwtOKVfVpBFggEGgaTgLqC0NKg1vljZapZwJGwbmx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xj1P29JY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xj1P29JY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=xj1P29JYwAK8UtnnJ2ML5IBaJ5
	lNO1z0mgFdiW0OT8a+eom/5JsvZMIEwMOupNJHIivyWCEeo6nKMDNPWupqhmQS9wB83tD0W7j3XBQ
	fzpDhH8jqJVil7hIdtKIVmbq8lWxO91MN9FhUDY69/9XY78xElrNupigAUlu9rQbHRNk+ZyHvepZA
	ndM8td6QjQqpiN0jjLnG8DgH81N7/wGAIps1g7sPp70kaV63M5bHUb2TU31XYdEIW9sHjo9uKJzWG
	sEo1gNADlTPLz3zx/uc3/fdmfYpye/Jj9jVHuB5fZ/HpZC4npixBbiYxUE/x4VFUssUBlnilx5lZ2
	ALGoEckg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t5LAi-0000000A6eu-3t2N;
	Mon, 28 Oct 2024 08:32:20 +0000
Date: Mon, 28 Oct 2024 01:32:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, aalbersh@kernel.org, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 3/7] libxfs: remove unused xfs_inode fields
Message-ID: <Zx9MFFmrWjSNIUJO@infradead.org>
References: <172983773323.3040944.5615240418900510348.stgit@frogsfrogsfrogs>
 <172983773375.3040944.3625887079395000900.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172983773375.3040944.3625887079395000900.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

