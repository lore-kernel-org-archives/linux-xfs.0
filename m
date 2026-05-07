Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009952E7F25
	for <linux-xfs@vger.kernel.org>; Thu,  7 May 2026 05:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778132116; cv=none; b=PmfpsaTncgU5iNYW/W8MqMFuBUlWZWcUZaxpbnlCAfU7+WWzCToJrtVUHh93zxfDnfy+XEjJCjtt+PicNWAszX16rGHR+Kr+t3Ne1sXFuEXjPux3oaK97vbFYGuxcV/JJyN/lGUvxNiICUJOWr0nCuIyplTULFRpzXjkeLUIBtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778132116; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hlJt3MC7c/f957GxoLDXBRMm/TLlxhzdYfgQebkdnrRz0xNDeGk1v3zFWmflU5qzaJr+n6+lT+j5F/Rz3M7ad4Tx5Jet08MK2xD+Rbu8EWpekX7cMlgNyncdclLJbSuIPxKv7VmGRgZx/s+IUMaeL+Q7W9/A4vrvr4IJaYixWqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aymnRF/T; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aymnRF/T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=aymnRF/TIVOwMkQkqeVmqZrY/k
	4zeN+ix0exskwKx4mpPGdNcUyCLuJzKHSX1Egu0azLaGtVQr6DF87Om4JqvVb70dB2DGV3WKm5pac
	48RS+a/dhs80YyQRB4YDLHHpXE8KXsS+9QDuWUhQaipMuuxk4T+S5z+prOcZv6m+WKHZwm13AqL5a
	WVXhir/D8iixNFzT+9fgBGURfd3PhY7zrprhJ7uSEj4xzXByHrzrIdOL9FYK5HJEp6ZRiv1o6X337
	a2hsbRNZsyhdDlmHXwfZuA90F/HDpntf20But1YA+zdzvISkRQDMRc3dY4/aPIZuApoGqeqobgSso
	g/kHRkrA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wKrOD-00000002owT-3Pd7;
	Thu, 07 May 2026 05:35:13 +0000
Date: Wed, 6 May 2026 22:35:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Gedalya <gedalya@gedalya.net>, Andrey Albershteyn <aalbersh@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_scrub: drop the warning about mixed bidirectional
 codepoints in names
Message-ID: <afwkkZVYIrnsy6sN@infradead.org>
References: <20260504170852.GH7751@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504170852.GH7751@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

