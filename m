Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13F8443C32
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 15:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789141783; cv=none; b=sb32L7oC6KgUU4KptfukpORTNV67Hs2Ss4VBlKfWW0gAvN4FUWzcl74PiVC97tpdYtYQQAI0VgGnkabB5Bc6jmgcqsxrTGSFp4qiLy/l9wid3/AtyEmY4xFskj6UieAvtxEHcrSWb9cswr+zFsWbZXiI96jrVQ0PKdzHLJ7e1X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789141783; c=relaxed/simple;
	bh=Xdz877NMKxLZ8TOanS993TA5aykrzveez+xL1TyIg4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yj1GRXR2uNxx89AI5q9wUaRs7rphPF3FQkB0nDI2WiQU/d2DVxANtT9cKwkFLpJsfge8ir02v6kJxwW0ObSxSDG6C54QKxW2bmGQxwbfJh034lJ41Z6rcDJuQbNrGGQMXFOJknowNXt+SozwxC8wE2Sz0KxgjgNXqiyKRJrH5/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vHN8SrPH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vHN8SrPH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jMPqKTHPEoWz+4nS5bk6nS4Kt3jdR+XHejJQmCMZrpI=; b=vHN8SrPHHmXnxHX1XrrbrOLQvw
	TRqbhxz3TZ5hgPqV6o9/QzpA1R/s5LTyBKr6cAuAQ4X6wbiDId6Pt0yVokpYwrd/9/ZgjxPfCXEaK
	phPbUiaG+28iRo+tVPUyZGA3I6Gbr01kk2QR7VtPk97Y6HfV1b8ae0h4ypkLcIETxxSfpmVpWyDut
	aEloD6jDhVT8Q4k6lCzbxBwkRiHtExQt6ji0WKeHP3EfrvVP141SIenWCpBnItwGQyZ0csb2J6FMf
	6aCS9eIntXNRTv+CnpjCbNMW5swOWX0lwfDO8nAESvtvOaR8XWrKeEo18nZdDO+4GEoyTfnBIqKyp
	amK0KLYg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x53VU-0000000H8Pi-3eqF;
	Fri, 11 Sep 2026 15:49:40 +0000
Date: Fri, 11 Sep 2026 08:49:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] makecfg: add a few more file related options
Message-ID: <aqQjFPaZMbPVIoip@infradead.org>
References: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
 <178892910659.4047311.5368828900056094997.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178892910659.4047311.5368828900056094997.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 08, 2026 at 11:02:04PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a few more configuration options for directory and inode related
> options that might cause user-observable behavior changes.

Why not add those to the original patch?  What makes them different?

