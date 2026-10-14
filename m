Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D389F5172DB
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 13:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791984067; cv=none; b=QRFlD3wGnj/mCwn3mYTQT120T1YyyuQhzBmMNBKUrw4/rUftjqIGddGwE6QBVQ4XGaddBkjuRIsFKg6/f2/d14zGY4vIH+Cqrn5qIpcJGw6KVAfhrpzrMiY5hHHd6bY3vTwfQLqH55hOY1TIfOBdgBbKcM1E+dMR+j9DolfPGbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791984067; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l1E/hPHj+pnrSRDiU5Fn1Z+E/XtktwudtyAqZUqXB8ePV9MPyhd4muO515cr7hLCocA5zO1YpC4Jyg/mWrdHlC0fnn9ND8NKA6sb4YZm6xaTB9MYl0WlOALcjii+yaXfhZn9ujoqrxeA8ylOupZafSZjSZMj1aVMPcixGpGuJQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DJEIH5d2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DJEIH5d2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=DJEIH5d2XQ+XT0jHrlT+Wp4iQ/
	zGeaUqtAZioass2M5W+xvRFgYaPf23+ZnLp1awIo9ZYXW7qZxM2dh7CHbrHt4FBNDPZ4SKpWJQnNH
	jufvYsF+51a47lAWpTgEsXbzwFY6TdRkRpd/wEDK544Fj7+mOdAIhwDtOBGNC68+uqGi9IvHjBN7m
	Y7sj7NYXb04URhofzVUm42+gnoJ7zoichRpayZvSCaGkc2rBrUDKP30ysfAmWQZ6w6ChmVk5x27jc
	4vOD0ZA3kSzgMblCAzsxFwHr55wtzDGGvI4B6rnlsQoHFAloGobsAJTf261/LHhGY0ZewvGC6su2I
	/0QU3JNQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGyuk-0000000FZYS-44fH;
	Wed, 14 Oct 2026 13:21:03 +0000
Date: Wed, 14 Oct 2026 06:21:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, djwong@kernel.org,
	hch@lst.de
Subject: Re: [PATCH 2/2] xfs: add missing cursor stat checks after
 xfs_btree_delete
Message-ID: <as-BvtQ_T6ykeOTh@infradead.org>
References: <20261013211851.641256-1-sandeen@redhat.com>
 <20261013211851.641256-3-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013211851.641256-3-sandeen@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

