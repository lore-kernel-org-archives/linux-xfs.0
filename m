Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EEC3033F6
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 06:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771483480; cv=none; b=jOC5JcToiAW2KVNBF/hzpOCt/ZNSLhUBAUrRWlbZDVaN/cjsVu7awFpNoiQu8HxnwJdwS0oFnx2Sd5qfLznHOWu/tuMAMsS8SFiC+KQxvq7LgAy89Xv7j80093EEpkQlhOxWYJtfLWeO8zEiUN8eENQrkDRi/cGfJphfQHvN91I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771483480; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SvTCKlr/pbw2O6m8li3cvELxVr02gz/E2nr60d4CBCiP0CQR+k62bSOLVzFxIcsv+IAP/V5gaC54tGWu0z6/Doy3IKqKZFyDzBCiV1j+kfMbeNiJDEJ76YnOlFnu5LfgSQHhhfMATCgSnHRtz+8/+Q359H8du9WyaLtTN+KYOF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ClHNIMqz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ClHNIMqz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ClHNIMqzMGlNtOh5RmPttAyerb
	H/FvGXzckWdWIXC3Oo0MewaKuEdhszQlhQcIWj9MbEtFDvXzY5phCytjgdRkj6kZvwkIqWYdQ46j6
	QKJrzsDW5CrDFm/wqjvtw5ihhvnprSP8zJf0cpuyawH2DluVYHMk0p2arDUfLHzUwNaD5dNEpBymW
	ojygY8gGH/4X87EDCNGkXotC/tmazTxjqttemjKRgwd1D/JyOhD2s/KQ/3UxUFhzjwQPDEQlJAfOm
	TJ8LEITZTDy3CDSzCK96N6o2D6+sV+ulNwXnu95jaGlTINyIJoBkyjafz0G0YEZly7NmvQJM3Ly66
	yMh0A80w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsxmA-0000000Ayzt-38np;
	Thu, 19 Feb 2026 06:44:38 +0000
Date: Wed, 18 Feb 2026 22:44:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, samsun1006219@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: don't report half-built inodes to fserror
Message-ID: <aZaxVgGBI4AeAZae@infradead.org>
References: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
 <177145925538.401799.9155847221857034016.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177145925538.401799.9155847221857034016.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

