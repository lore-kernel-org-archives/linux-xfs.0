Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C2D566A
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="azMn7g68"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5Y7kltGc1At9F2egI+YnZu/uM8CmoEsVVuAdkKHbVCc=; b=azMn7g68mWi8nJH0+BCYJH111s
	Lb62lygGkgmZbqxujpYmJN+HyMF8Pz/eynHGaEIWQ9oteSkGXeeadEGydepA8CW7mfZKVknC9VESI
	aWbIzZqULKCPSCNNw/E9gJYAvrwSLGR6znE4SMUb4+dhj7UTG+U/3Fp+7zkxLiac2rB/IHZSJXATb
	ZxjlDda9br3E3vcq0jZLNvQe/msLGH5sw4FDwQtP5ALK67z79fg+aQIIrJspSwi/qVc2D/czYle7n
	8z/+wNHIlILYXRk9VZWc5yBJ+ukSpyKldncZNF3Kv7fg223quD0rMxPDDkZPUfeN6tHl7x6nmgax/
	7m/bd38w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcrg-00FzUK-33;
	Fri, 05 Jan 2024 05:35:28 +0000
Date: Thu, 4 Jan 2024 21:35:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: repair cannot update the summary counters when
 logging quota flags
Message-ID: <ZZeVIByA69C6XLXt@infradead.org>
References: <170404827380.1748002.1474710373694082536.stgit@frogsfrogsfrogs>
 <170404827460.1748002.10713217958407192887.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404827460.1748002.10713217958407192887.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	bp = xfs_trans_getsb(sc->tp);
> +	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> +	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_SB_BUF);
> +	xfs_trans_log_buf(sc->tp, bp, 0, sizeof(struct xfs_dsb) - 1);

We now have a multiple copies of this code sequence and it would probably
be good to have a helper for it.  Given that the current xfs_log_sb
is a bit misnamed I'd be alsmost tempted to use the name just for
this and split the lazy counter updates into a separate helper.
That also makes it very clear that we'd need to explicitly opt into
syncing them and prvent accidental bugs like this one.  But I'd also
be fine with another name instead of duplicating it here and in the
pending imeta code.

