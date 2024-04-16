Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DC839FD0
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 04:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713243301; cv=none; b=cJVl3CVIDMdmKXNFhqOcemyIpBs/Tpp7YF5nQS9KRVUwmgDmcMdYYJ10NcmsoMQ8k6nII+yKOv0C+xAhXUJUAYLZuI7VcyR3CqHM9WEgZiNyQSk5Q4jc9ZoL45hit1Z2N8UzPtLzpghpW1MuUNhNCOUOmA+chB/9hersHS3ni2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713243301; c=relaxed/simple;
	bh=LkPXDiWkej06YpJ6lL223qOaZ2owdYIk15+H8+chv14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dsjk09nAiZyPCzGoVgB11Oek1AqAoXkNb1PNzOnuhSQMG8qUgf2TS8uQAIlSYhFT1OVkKrABIt6knN2l8PrCERbJPxVAHuXfClh3pzgpgoLxjDOBlb+ELRaBSETFC56Yz6LqTet2PcEYrcSOOFuLgbIaJvb/+0sWZmaf1Sonvxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gW97eCpJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gW97eCpJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bBf/dGw+yepCTVQp7R06Kc/S+ehorleUodnr8GoIeUg=; b=gW97eCpJ5O5+O57e3mSNlD4H1i
	riIGCdms7XpusyT67YPdSE6NvfcpXoQdl+CW2CullMecIu9ZmYd5cKedXSGprbMFG+wrevGw4kXkW
	DtWDL6TZJqnuHBrU9YWslBWKhp962muDn9hCHCaVpQnkeNk+26nrj+VsjYtc6QSB9vBe/h83g9vAj
	5A0Xggu7Ly7DwndYl4rRPcwQnuUdCWfW8hAaZGlUrMDrsm4rPfmo6wSNuRENSDnSb4R9Y6qZInc2r
	0AOCAALS6IX1YYSfF4aF8ULuIIUjNMIe2WJE9NJLvzxJzCu652J0JCN0WGKloSyGYuhJMmeKOg2ni
	jqc/Scgg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwaqS-0000000Arzv-1bZi;
	Tue, 16 Apr 2024 04:55:00 +0000
Date: Mon, 15 Apr 2024 21:55:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, cmaiolino@redhat.com, linux-xfs@vger.kernel.org,
	hch@infradead.org
Subject: Re: [PATCH 090/111] libxfs: partition memfd files to avoid using too
 many fds
Message-ID: <Zh4EpDiu1Egt-4ii@infradead.org>
References: <171322882240.211103.3776766269442402814.stgit@frogsfrogsfrogs>
 <171322883514.211103.15800307559901643828.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171322883514.211103.15800307559901643828.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Apr 15, 2024 at 06:00:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make it so that we can partition a memfd file to avoid running out of
> file descriptors.

Not a fan of this, but I guess there is a real need somewhere because
we run out of the number of open fds otherwise?  Given that repair
generally runs as root wouldn't it make more sense to just raise the
limit?

