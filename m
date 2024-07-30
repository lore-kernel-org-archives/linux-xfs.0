Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C30145FEF
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 21:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722375490; cv=none; b=lozS1+Ub2JkjIAgzbBnV5NcVjWmcNpn+8EMjHqeCqzaD0bbPwD34KR+MAERrfGpkPs+Cyz1z1VSTdkTF5VUdOxycRDglR2YXmT5V8tgBO1SUInSi0IcPt7s+KjFilLh2WCWEsV7ffINAIa3bKyJVREduk44BCGZamrTGrJObSVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722375490; c=relaxed/simple;
	bh=k0+uuzCDSDiyZaa1LratvMV78pXDL1xGZUNROA2rSOw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E4kz5PnZzEz67ET5LmsA9zgUZCIsj6HctotLT49fum5EhRuZwH/Y/MOBNNYa83vZcyVKD0wrv68MEwRVJGQknu/otNJE+E05NJfHP7cr/YFwmVPVJP8OzlM6+XYBGUTV7oj801bXN50vELa32aqdjcCtIlDIbbermreXoFDiAd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HfUbt5E9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HfUbt5E9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1F1/3/nlL4jVDotZSWWAk/sYZAddKjqS8bLVYmA2KUE=; b=HfUbt5E9QNFPvR97jywl7i5SVg
	wLqpf7akVo/fnrBH94+dngHaU9+CO2YJivAfhI9b3sxpeF7yhP3Ib+/ZlbfJ7XjFxIh9+sQLSayWr
	XlG7DiAmCA3fUfTx1+MQcjZurnwv9BNU7/X4zyAfvgJXja+dzRf+WlFgD6IGTY/ctbaIamd3YfhYp
	5t0YM0zp8sp6zKtAPdW+rpl2f9e3LdOY8q5OvsW3PSQY+nVGK0Ilc4kKiK0CVtv5zSFqNgZNo3HeS
	Q2n3K9maFwHCI4beGeAxuQjSKuvMKlIMVZht2RP2EfjMLu6GEIKnpEN432XqtLJd1gVXSnDR3WqkN
	0X6A/rwA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sYuXo-0000000GYwZ-24DF;
	Tue, 30 Jul 2024 21:38:08 +0000
Date: Tue, 30 Jul 2024 14:38:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] libxfs: hoist listxattr from xfs_repair
Message-ID: <ZqldQN-v18yCGQPM@infradead.org>
References: <172230940561.1543753.1129774775335002180.stgit@frogsfrogsfrogs>
 <172230940631.1543753.17382323806715632348.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172230940631.1543753.17382323806715632348.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jul 29, 2024 at 08:20:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Hoist the listxattr code from xfs_repair so that we can use it in
> xfs_db.

I guess there isn't much of a point in sharing with the kernel listattr
code?

But maybe that is for later, for now this trivial move looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
