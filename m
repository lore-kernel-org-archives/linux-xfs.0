Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11D2145329
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 18:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709057308; cv=none; b=DqPQrAdcpu3MveON8KwXIcbLWa1lUhEtHePKrYECq15UupKi0Axbk3+6YaeYFNpAYO7mqacRSm5Eyx5LbT3O8jGpNYC/dBmQUOVF70+e55Q/e2jnVmWKiiqyJ7HgsN/ruR6UGyaxJJqwHjf6dzFKfxDsG+gvAs0XeS+yzz3lGlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709057308; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LbL8VcUmsYm+U6O+TESy3u8wjcDlgqfUefeFFG9IWp4HNAxz7jK/I4Nk0RjqtWcibzlsxPcCucubH1lPmRgtCYtGfci1wTXxbVxS/HxLVS/bdGSbIoRvR/gssnE2LSczXCZrsZPS7DVFWD8pG/ploqNOpJxOK1Y/oBJmg5j3iNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rS1nadK1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rS1nadK1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=rS1nadK1XfDAegaOw1Ft9KT7mu
	kWNNMz08MaSqjdzTnb8G1f+YmYx6vvLmYN4gzJ64mHI9byF04+8E/sLiVeLb0uiagC53cMEOyZ8C0
	ldv65OkZYAXlzlDC0O2FtfLmjf7XHZuMCcz/0cCJ5SbttMDIY74dJKCQdO2VkPVyIPfCATl12q7ui
	XeSAbhkyW6355NHW6Qhcz1qSqCp8lTZzu/HZsGu8qbPKpI3wVn99R8NqQMo+KqIQ4qrPoPJk5r9iN
	5DK5otabR8UVNUFnX8sGE8n7BjfmnCrgmK5gtVFHZiq1cZoE+h6m8yrfHmSEOaVIsdE1zKyG9BxZj
	Mld7TYzQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rf1sQ-00000006MZ1-153m;
	Tue, 27 Feb 2024 18:08:26 +0000
Date: Tue, 27 Feb 2024 10:08:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/2] xfs: only clear log incompat flags at clean unmount
Message-ID: <Zd4lGuhHgzzKzn68@infradead.org>
References: <170900010739.937966.5871198955451070108.stgit@frogsfrogsfrogs>
 <170900010761.937966.6721745858174555329.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900010761.937966.6721745858174555329.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
