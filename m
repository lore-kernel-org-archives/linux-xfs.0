Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563FA2E091B;
	Fri, 26 Jun 2026 06:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782454404; cv=none; b=CKiW3vkc2pBmQNuRO08gnCz6Pz1O5aQzq/7XRoPIF4coxXkZ1aNoYY3R5ULjlPWNIPgDdMnXThVF6MSBw0TnqQrxILAZPANpHCUR/Cy0TaqB2i0UsUpQgH9bUldJ2XSxsfcJCbbRYOYwZu57uxwoxfLIFoFnoS1yNftDECh7Uy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782454404; c=relaxed/simple;
	bh=XEFTZPiCt6d1dZwrRFmDhkyhM/8s5guHzfjWY/x4ryU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z8DX86SLyOp0ljGW5UmmK062aw6iXH7uzXwWbphK6RA3lXkq83ZPQiZy8ecpIECq2+wa+eAZdX91QA2xKg+sKE7AQHLZ7wxeK4l2HP8UPItE61Ed/uFNbN5O/nVCcUL7E3s1QbOhC0qoxpfc54wzGwg5heIEnMppIw17rf8/WC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GD7W1kPo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GD7W1kPo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=w5XOAl1sPWCIi0RU8LF2OUmSkKAllkd6Chy/m+uYErE=; b=GD7W1kPohddenSRGGozW+9YGCq
	Z2JCGMXa7Zw1pF7qF//drqgXwi4Pkt3guMIELkySFREvK1wVlwzQWA680qtDUNK+dumNnF8nMUVty
	vixYnciYq5FLZR/yhFJ3TP9TF0LdlmVlwhVa233ni4yQeRZXelMNk17c7C5FVZtB6HPL0kkLRQGEl
	wFmUcFmSIp5Q39Z0s0llFDF995xMCt2pIA4M/IVXCQhxNzpcfvCt9jMkeYoGNDOYah1yNwIFW7Nhs
	EBan1dJniDFwtAAv0PLmxLaPLUJepfxAx6ZyLY/0HzNt2oHewsg7ZcwK4nKBlthrbH7MtOXf8d62n
	A/JZFHQQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wczoU-0000000Aa0H-3QhE;
	Fri, 26 Jun 2026 06:13:18 +0000
Date: Thu, 25 Jun 2026 23:13:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	fuse-devel@lists.linux.dev, gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev
Subject: Re: [PATCH] iomap: Remove FGP_NOFS from iomap_get_folio()
Message-ID: <aj4YfvFKTMl-b_PZ@infradead.org>
References: <20260624174228.2015893-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624174228.2015893-1-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jun 24, 2026 at 06:42:26PM +0100, Matthew Wilcox (Oracle) wrote:
> FGP_NOFS is legacy; filesystems should be using memalloc_nofs_save/restore
> instead.  We have it here in iomap because it was buried in
> grab_cache_page_write_begin() and we didn't want to change this behaviour
> as part of the folio transition.
> 
> I have tested this with XFS and see no issues.  Other filesystems (cc'd)
> may need to make adjustments.  Please test with lockdep enabled.

I think the most interesting one to test here would be gfs2 as it has
rather alaborate locking in the write path.

