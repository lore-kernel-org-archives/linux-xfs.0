Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39F8189F57
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081074; cv=none; b=L0WqpkwHRGVvdwucFBhYwDsmXU50s9SV0cpCwr+cBqd5X3Mmy8Gz//YZ2yP7KE7yK0ku+ESk1ZLPOXBK9qJGIeylHDiUWL6zvCm7ooOJ7wImL0mdzgMvC3yaUjuwsr9q64tUWYG9p19CKUULtqWuw9+4NZPluQJgvExeMEi8CiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081074; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oVnVujtn1xnBN7uq7ZUt3EGiwFLYuoCDR34nH/65eF5HaNiKMxsrefr4xBBhMFqsxyH0wGTNZEcDXLI88nZZTzTzLoloQQedcH82WIUrgAUhSVVDH9Y5zkOy5HPpyWbb+PmUkMszmmbzYItzSuvTU27XsTmXRYeiRkO/eAun+3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wX8W7B68; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wX8W7B68"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=wX8W7B6836n5kK5RVfEx5R3Jqe
	wy2JIPvSFtBeliyCnDoa9whKojw+Q2h2GVcDXEpEytfPEQGPqkWcRj2riGHKsx/InVjiikCSu5FCd
	Oe7O7z5LGVfNnHMx8qAlBOY7/HMmmodN18KzQPd8HCR8m7Am1zI+QTQGzqvPnbiL19KQfRceWq/+1
	oAe/nfBzdnoHoMJYPbT4GN9ZJ9MfLLtvPnxIQ7qRyHwltkB7wUzifngGIAZ/STCj45sxmZR4dFg1M
	kPlBhPsMP0qIMNdYd58O1uUQGoCzCXdgebZq8iUFu5yZrAMI+VLl1d1qAcShntRdjk+PQQwSyDzmV
	0jnz5ZqA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1hY-00000003CKH-2gdf;
	Fri, 13 Dec 2024 09:11:12 +0000
Date: Fri, 13 Dec 2024 01:11:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/43] xfs: add metadata reservations for realtime
 refcount btree
Message-ID: <Z1v6MJ2Cwuf8CBLG@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405124756.1182620.5073398272904938121.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405124756.1182620.5073398272904938121.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

