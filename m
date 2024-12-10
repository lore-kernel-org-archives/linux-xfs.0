Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41197228C8C
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810173; cv=none; b=tu95pwDIv7oj60g01n4qVV/5XepsJirW8N5Ua+qFoU1j1oGpBaRGs2qOrIO/mqUuyZAJgQNyLyeH1Hn+J6qemac7+vbP2rMVJE8FCnIo1m0+FEE3Fs83HkFNOzMMxuEvKS2B2war/8JEe6YAstOilQTEkaK7pjY1IXGpm9nC/d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810173; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lc//sIhcSaTZUHMtgtKa1qsgk5Sfnr1spEtGTsN/D4Evjs12Ikzm7cRY9VSV8Qtg1dxOXLcCyXqkyWouq1aRc4Z4z0Au5XmwUHT0xwCQg4ld5Z8bdpAXe/If6p0njIagcnqhjDC6iwQrca7TLgKk5j1KbnuNdZ0YDuCsXuHPbBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GMnE3Iuv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GMnE3Iuv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=GMnE3IuvTmyVeSbOVTZ/0XzAdu
	WUul/MZQPRAzXPL5iugRRvz0wByt+8tfiBmt71CiMfm1GFZdgHZ2K1nDA432GksK3UccvilcJuSRo
	6YPa+ymEoV66f8ydkSnIriTxAQY3+MvePvjzjwdEmQGHQy/c1b0kSxDnL+8WzBLqOHTYMKb6zkgQZ
	IMPxX+YuLQekbfyKCtVgWafib7vSTDJYTSRBlXRaBHzbHwlBgfNwGr5f+2wFOO0NhjJrdUvesUu83
	YjkOIwwYezTuZwoxPS9IVwyZgH42cqygmVBhRqgdltT3xUSPzlVgKYGkr3vGXXvgWHilwg0QXOBmO
	DZdvJT8A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKtEB-0000000AKSa-3r6u;
	Tue, 10 Dec 2024 05:56:11 +0000
Date: Mon, 9 Dec 2024 21:56:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 39/50] xfs_io: add a command to display allocation group
 information
Message-ID: <Z1fX-43ZfCIekdFW@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752541.126362.17388723323168247273.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752541.126362.17388723323168247273.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

