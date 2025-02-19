Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A958C0B;
	Wed, 19 Feb 2025 06:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739945011; cv=none; b=iVRxp0J+GuwX/fKIrKBBtQr60Jxagf4dPupA37kHCchb/qW3wfvDbx62v5z4R+7m1h1CK1k+EUAuwZ4eC1JGDf+ZKY79q6jeUCWY11txjlQSipyC75qfdoKBHL5fHpK8GkWwns+Fqwgiqmgq+n351Ts8+OH2QX8+DdCXqAojmqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739945011; c=relaxed/simple;
	bh=MFIZpMLuJEZQWZ35FeIMrr+oYTE6aAji4ZKDxQDaorU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pOOgoi1P5sUxOZsw5bnBPCN4moQTXO73zlGV66rNPozpJelaiUJhiHJimO9oZmLqsSDfRg0ObhQEu5LXVbJUsDPSixyfOwOrMRCL7S8Dm72JQ+xPEIbUlsjqbnSwQQT+H98TLFxbQbwVTNPOViVMiT73WvXfydPDM4Pe/WnAtSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qMHjAnm7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qMHjAnm7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/0k+0kbJjDcrRSxf309WUntcqjDNwNOs0/OO6W9j/EQ=; b=qMHjAnm70DjAzO7hV7c9oPnK03
	eoJr4vnSAGlsX++4H2FDPrwqPdn5E02SROJqigd4k2AyGxXRZ30/BEumgtSlAFB9I8u3dQmMGvOwM
	FxkXHa9s6obWqAiUyTeBzfTn592bYXFPtDGzsTZYho00UjwePJ+kfBub+TDzHaJwhhJsGcaTpw08j
	Kqzb7kb8polSLNPJl6YALmrAFymrmfZBdSqaH7WrbSKHPhAcuQbgnhtszLoZY5SqMD0Ho6GnENjGP
	3JeQdbTFk4ro0MhLIA/BvCEFS91q5CG7Zb1G0tw1lS0CJcnsrvbia3xeuP8t4ZvR774D4glkMv7qG
	FHsIOn0w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkdBB-0000000AzCW-1eEj;
	Wed, 19 Feb 2025 06:03:29 +0000
Date: Tue, 18 Feb 2025 22:03:29 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs/{030,033,178}: forcibly disable metadata
 directory trees
Message-ID: <Z7V0MdDvssKYROff@infradead.org>
References: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
 <173992588098.4078751.13636667598878254024.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992588098.4078751.13636667598878254024.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 18, 2025 at 04:53:58PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The golden output for thests tests encode the xfs_repair output when we
> fuzz various parts of the filesystem.  With metadata directory trees
> enabled, however, the golden output changes dramatically to reflect
> reconstruction of the metadata directory tree.
> 
> To avoid regressions, add a helper to force metadata directories off via
> MKFS_OPTIONS.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

