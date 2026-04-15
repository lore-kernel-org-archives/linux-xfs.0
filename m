Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6B914BF92
	for <linux-xfs@vger.kernel.org>; Wed, 15 Apr 2026 05:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776231376; cv=none; b=tgZxrSghSvCM/tt0dkac6rE14vBM6Jw+7hqNK76RmFaEvidprbYK+EkEmOAgEivOt1WDWvPqV9Pn2ILnCwpp7IBza8L14hRrOk1I7bU/B7z8Ge55cmRECjzdBF5ZRpoy7xxPqyd6HRqfYvTrWlTjTr8cXulQK3lSVOTompC1iNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776231376; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vc9gzuANhzsJ/ZUzGAmlNJxcomwm4IShdEz4soQ16FU1o0R3eDgGdgxFUjIFS0M6EmueGKh+b4OBARy4OThJssRPj/KChGu9Wv+l5pi6NeH0gncNuy8UAuy333Cj75Pq0k5Zs8gauDhphefMf91RwdcLSjfbhu3F46ap+gfn8M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LxjEuuXI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LxjEuuXI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=LxjEuuXIyEly+H3tpvbzk71Hcs
	LbXMqsWV4MeWluPtRMWSte3YhHUvyCFIWIB/c4HCwjW+s67CZpaLNjyf33QKkrb7wGT5hm6xkZZzH
	TrFX7F9leZ86GWL85Vt5FyIYJOh1S75i419ShlyaldGbYHAhpx5RsswxphuPRJ+em6FVVmz14f28f
	V53t7MHoz9+msd41xeYEiaIrDRiGnR0HNaoZHzncuT8b7EY7P86X5yZmn0tbizDQgcKa9H4dvkHQa
	gx1/j8+G3FXgF8zm7+M4ZoIEOKBq4upQafrAzFIojEdlUJ50QVKITmVTFevX0nxxnwh7v4HBfnkCT
	81xzajfQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCsv8-00000000beT-2P9M;
	Wed, 15 Apr 2026 05:36:14 +0000
Date: Tue, 14 Apr 2026 22:36:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_scrub: warn about unicode variation selectors in
 names
Message-ID: <ad8jzpvuLG8yleO1@infradead.org>
References: <20260413145700.GJ1048989@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413145700.GJ1048989@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

