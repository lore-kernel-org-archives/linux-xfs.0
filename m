Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1894B31CA4E
	for <linux-xfs@vger.kernel.org>; Thu,  7 May 2026 05:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778132160; cv=none; b=d9SV64p+mhAzSUhxFBniP32OS4Dit/GYGctwUP2UeGSXYHFcWAe/KigT+Iav03k9jL14QwCW0RJt9vh/gQlaADYJ7hJqXB4khA2LYyVjqgwcQ5tl1V58jXkVc3Sd4FI0otu92e2NDg0Lc4as8u1ppMrCFG8PNjD1VhitLvqTkvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778132160; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ot5lVyEgOOvpUwWIrWTi/Md+wWrtnYvOyHdK5S9ys7DaeELwRjlXCI/eOq0WRMr8BuQLwtmjMgVRba64HTXRctQeQ9Fq0N9xIQc8/yrgYDGRQCtyf1iGyVRVVAj+hhdDNZmFmquJ+ZVlTeMoqY471nuxHXCRFx2HxEa1fgUbX+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=L2dnlSKQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L2dnlSKQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=L2dnlSKQR4zUalYVxw7M0coQC0
	Ru8ftgIJqZiknuQYFKKIDItH2i+HemUl2YdoMbEIgWjVkj+cXtf+TTA30d8IaaYUCw+uRJpAiv3sw
	50yn670KAhhZDcVM/uaX1GlT8gjzQbHxcxXLxMx+/0ECfi3WA5U6wXyvLF3frRU+hjdc/t0VWu56s
	Kz8Tb9++phTXVabutWTeaVZPda0KRw6hs9SQRQfVuEWFzNXmLPLOdo4QppRDozVPHYskOzcGV+MMB
	U6VfAHuLTy211cjFIjP2S1xqaBoowcX1/Bn12TlFLYtP1YhBR+dvu4IjVVRehH4EzIi7WJi7iZ26L
	w1p+J5uQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wKrOw-00000002p08-1YwQ;
	Thu, 07 May 2026 05:35:58 +0000
Date: Wed, 6 May 2026 22:35:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Patrick Fischer <patrick.fischer@siedl.net>,
	Andrey Albershteyn <aalbersh@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_scrub_all: fix deadlock if lsblk produces a lot of
 output
Message-ID: <afwkvonCgS-OGM3W@infradead.org>
References: <20260430155406.GF7751@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430155406.GF7751@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

