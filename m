Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A5614A624
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 07:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728892282; cv=none; b=DW1f2r92aSfgn3j5N6pkZRiNMLhpCr/DV1pAbHU3nEZYlip8EpkzftHED+leWZnFUyhpQLWghTPZ4ulpdauHTe93E03zwYV/SD/JGGUtQWoFITQzKrxgB7EryicbICBGKv6cEIdrxLaHUWA5qxobYsoMDAcUCBtYfcylyXEjcpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728892282; c=relaxed/simple;
	bh=Zf6oxqpEarmxD9L/Zhr5dMcmKqHDX2v4kGZIOarcjio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WprePPUidvvHdJq7HGf3hEZeG7lVKzzvG/7RAGV8Wa4q4T0h8Hk3MbiUOu6JdY1xVyDpiMbdCQ/Ez+IBAljW29QkragS1QttCDwJ7pUgkMPI+r+/TjRduATuKWMgmb3PRMaiPJ3UDZamX2HVsCeb8Vzl3NwtDZnx/Y4UJvvmG8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RJGBRqMR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RJGBRqMR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2NcOvr/gk2zx0fAiarLPOfSOilRmdWz29eHVQsgG8gk=; b=RJGBRqMRRCg5UIEGLUELUGI4QV
	BAaZoaLAA7pmQrHF1zVcUUmzRCkPqPfu3qtMFI1Pz8WAU1fjxO8Wv7dbAVKHWljYz6g15sRnZqPfS
	QWHGWW5++XnSgGoOSUTcMGQ4nfB3q09R0MKnwL9uM7tjTqgAiwwZEyc2upYGJj6UQ8xlzQ9q+t+Oc
	VaYgaGUlGLjM6J5Ccs6jbYmlvNdLQLKvRSjy99V98ux+YhG2GKXIziKPYnJILrJh5IUAJz1yAJC1s
	hmz4U0oo+zzQuvLWPBfR+vo08vq63hte+PL3boDtqDPBuWj5PLZmf7QbdbxuoVhq/w0qtFTUsMPhs
	1p2nVuKg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0FrM-000000048tv-2oKS;
	Mon, 14 Oct 2024 07:51:20 +0000
Date: Mon, 14 Oct 2024 00:51:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 01/28] xfs: constify the xfs_sb predicates
Message-ID: <ZwzNeI87b3KIizRx@infradead.org>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
 <172860642030.4176876.2795384731737477942.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172860642030.4176876.2795384731737477942.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 10, 2024 at 05:48:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Change the xfs_sb predicates to take a const struct xfs_sb pointer
> because they do not change the superblock.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
