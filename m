Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34AC226185
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733809165; cv=none; b=J1awPFmqYz2xe6Sq9AcTkZnUOuphnnsqM7FVhmnIhSmPArvijRXyvACHAKOvgUWUIV1MW6wamCE0YfYhCsoss8GHSW5/ZL4c3X6Z2WlbrFanCPab+b4nzSPbUoYQdCCoATPVgv+R/mDANOY3tcYhs8h/s+uf+Lgsl+E+twNMTHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733809165; c=relaxed/simple;
	bh=StmVYBblR6R6vKqPbwFY5DA3FqRDx74oHMKS7ls6Y5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o8heWFsW/qpSyaKIZBJJWCGAd26k9yLUacnS0htmcA+DqGKPB/nCMDGiu0ZAmatWyA1YJwtVZ3LtU+QcZBqNQI0I/Fos4Y+CQyAx1ZD+thgkYpBE2RFjSP3NdcUNfJi8jFBe1A2giJ/BckgoUXGQ4kdOitilnrfdf/W/akqluXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2NMad79N; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2NMad79N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=StmVYBblR6R6vKqPbwFY5DA3FqRDx74oHMKS7ls6Y5M=; b=2NMad79NxokWxa5QnYrkPS3t0F
	raNfLt3KabndwumbPyH9lGFBF9/xoHbzRP9sVN0k0QsVsm0VFBIAImNZSxPRfx/164Qm2m83JDxAc
	3zPfw9oWAUZsUyXmvNxRxP3tgH8cwdpQ5bqGZiqxrfLL4IknkoDI+sdymuX6Su4t8Mp6tlZEz7S2v
	CtK07JnuVYi//M0ITdsCiHMs0DEbjg8yASD8N8TSJMo5zYGs+LM30hY8d7Dm/K/plgqRdZ7N+9xbB
	jfLpABFZjkVCQcDtaSkpXCDeHwKTVnBGtwIvtZUYTBCK25sgr5mCA+TyqvoJbUP/yppNNJ1XJ49eP
	G1IYp1sA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsxw-0000000AIQH-1DmN;
	Tue, 10 Dec 2024 05:39:24 +0000
Date: Mon, 9 Dec 2024 21:39:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/50] xfs_db: fix the rtblock and rtextent commands for
 segmented rt block numbers
Message-ID: <Z1fUDDP9jKCSVgUB@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752326.126362.1070873250646267314.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752326.126362.1070873250646267314.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

s/fix/enable/ ?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

