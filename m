Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD8435E94F
	for <linux-xfs@vger.kernel.org>; Fri,  8 May 2026 08:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778230466; cv=none; b=qNqsVr1BsHegEBl+AJBZbMhWLP52ub97fit+Z+TV9mwa7fgm2FHWKPTPKI9Ja/eJh4p4n8uj3OtKDmykkvuurXWbSHbWlowLSeOAKKDARe/ib5Loil16RhIpnWYlqZcs/bWLhmoush42gv/k9RSy9MMvp1ARCtpI86o0rXJwZ5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778230466; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eJwEn90T3gVr6VhG48CwNWywCoYfWNg+zmDwawgLMZ4JoKYBvIoPMAZjlgjR+730oufB8HeMjEpjna4OlXZUBfRVJZ7qVgHWnbtOnv07gUezB/Ts6tfuPL6H8B6wKTFZsjLYS9Qd70hBIjDefrAM7XU7X8nYCK3tF6f9GgigAYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cGoILYvg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cGoILYvg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=cGoILYvggOrHB7o05VAFCM6WnL
	bDQ7pSDxZY6tdTwxE+TlrWgrLPvDFiNQdr5r5WNDrMGn61ls1Cp6tUbbYl+TXP3FyvMV9LCtUJ+CE
	uyhG/BKGzJRsdqEyoEG4uwiDAB1ZqdXvtgw6+jPfA4xiC1hbZOkbNqjrTPWMSpN0t9iMCUDR5H68x
	PiiADwnGtiCefXq028fQrUQ1DL7I9kGWgGHMPD9etvOw9hBoKhmyebppVWfcIAXq3szIoO9s0azJL
	OepMCWYSFwqWaSi+VzKsQ3QXAddXmR9pBoUH6yX4lMJMMvZA1rjYV0ARlBJWK5P+2Mv6eX9xl7D8k
	lSb9iRXA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wLGyW-00000006309-2an1;
	Fri, 08 May 2026 08:54:24 +0000
Date: Fri, 8 May 2026 01:54:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: update release.sh with fixes from xfsdump
Message-ID: <af2kwGelpk7SC3Yu@infradead.org>
References: <20260507150602.1453418-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260507150602.1453418-1-aalbersh@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

