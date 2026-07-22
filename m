Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9256B3905E0;
	Wed, 22 Jul 2026 08:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784710727; cv=none; b=ovzDQ6yLBhNFFmkxl5bxe3wy79UNqD5PPa+l91/P5dJpmrAOOSJsfmdsVKTkLYryKR1vb6Rz1HyvXVYEpG6s4gkX4TwK9PSfjIXi2Low2Hkv/BMPr/QXt4iQ5/Tpnx6UvH5cTVMjUzq6HHFHo/BdZSygA8NVvzhCL13keKi3OGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784710727; c=relaxed/simple;
	bh=g4f0uLfJnz6+JvgeGBOL+GFEBL+Gp47Uvp67b0rzags=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PRvpAKkiHma5xG2bSBh4C+LSyrGXuyck+ZBMncK3izM7DOnNjucUTw0IxrEnoBIgn/IwLLFPyGMMcywTjN8AQZTJm6AXJOXfffD5X1ANTGk+IRHo1yCOhmeReZdZHfcjFHivx2CSG+1BDEj4zE+XrBzShcwkOEbXualuaTfPh2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mWKxpFqI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mWKxpFqI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=g4f0uLfJnz6+JvgeGBOL+GFEBL+Gp47Uvp67b0rzags=; b=mWKxpFqI6zV+Cu1ST/PGCmkZ90
	RF3srEBh0PZPlEYjg7cm0nk9VrO0bT2bBgzj+Pq7YHub8GYYqC87w18qoBX5kXPwqYmDtVCT46myL
	uGDuI29awC3Wle1vAjFAJFQFD4DB9sV39N3JtB9X0RE1leolFNTcAS3oBBvt+G52K6Oby7AWTfByf
	mp4/W+6prf1X2a2OswdmBnL9/XRCD1sdiJ97rSD6Z+CEie8YPXbC/phncOJEm2nzHiDCnOtuUC+sU
	+TTrO7PO6W5WPJaQHf75sbtm8y/JSwSdJWoVfnbt7+jRZuX0dna53PITuXcMHFn4V4fm7N4kq0uXf
	sAMrqkLA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmSmn-0000000BJYF-0th4;
	Wed, 22 Jul 2026 08:58:41 +0000
Date: Wed, 22 Jul 2026 01:58:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Yun Zhou <yun.zhou@windriver.com>, djwong@kernel.org, hch@infradead.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: fix compilation warnings in xfs_sync_sb_buf when
 CONFIG_XFS_RT=n
Message-ID: <amCGQTUW34EqflCj@infradead.org>
References: <20260722042841.220534-1-yun.zhou@windriver.com>
 <amCBowU-Q-QrGYoX@andromeda.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amCBowU-Q-QrGYoX@andromeda.toxiclabs.cc>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jul 22, 2026 at 10:49:03AM +0200, Carlos Maiolino wrote:
> We don't need a fix for a patch that is still in linux-next... Merge it
> against your original patch and re-send it. I'll just replace the old
> patch

And please turn the stub into an inline function to avoid the ugly
void casting.

