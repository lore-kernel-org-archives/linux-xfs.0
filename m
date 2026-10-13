Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEE52E2840;
	Tue, 13 Oct 2026 07:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791876760; cv=none; b=MAlu4klC7fIt7RZO17+IPrNZtrPxA5RAEX7/XhjSiYC0rwUyic8UFUwgBqgQ6vbpEuFh5MsWxq/TFvhp5aq4/tNGWZe9krhu3wj+2yUuwFLx35tx4/xp4y7hFANGvhz1phinUmZTALYBl/4BOl+9JqRqO2c/7rr1UGW9R5+YuF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791876760; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ilaoFo3wgrA0i5bhqgKfuLvjjIcFwhn06KzFAEf+et6psmLPK6sDTkTKMK9Sh9MNZeZlMe3PWe3nq667klx3hQrnd7QG6ZUzRgLGzsBtJhUIMxBkHnOGzBwYGSjMd7tpcGJW3mbUI/qRanavV0DPt56daB5xuO6EOaJjpi6qR8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LhNVTP/Q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LhNVTP/Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=LhNVTP/QttLGfqMBLPl6dX4G0L
	bwRwAIZUdjgmTE4fKr3UDA5Tm+jIaAYOkC1jmS1adQ6UiLzdHnM85eVA7t8ZzI3q7FnK5sBIzMPVX
	SDoW+p3RAooTsO7Ee7F1nVa6gE4wEH2Lnls1k5H0gTS4f9dS2J16C7Z+61E/SYamv+VFhC6SmcRfq
	EkvuLzDop7OAJlIjDol/csijhc4w5EJDpQL0WWsZJgWNIBG52P3M3r8tDPbvtbHBFeHA5iqfTgY83
	jvgXEgA0x6iLuG5GY7KotmdEjwyPzgJnt2zoxoGzvlEfBM6hkFnEKxOUHaCDiuy9G29TaOe8MsT14
	y5U+7h6A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGWzy-0000000CDpS-3pvj;
	Tue, 13 Oct 2026 07:32:35 +0000
Date: Tue, 13 Oct 2026 00:32:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@kernel.org, norbert@doyensec.com, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: add regression test for exchangerange-to-eof
 reflux
Message-ID: <as3ekslKLTGEWPqZ@infradead.org>
References: <179185007428.1732194.3790285770700324388.stgit@frogsfrogsfrogs>
 <179185007547.1732194.10384749018435886624.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179185007547.1732194.10384749018435886624.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

