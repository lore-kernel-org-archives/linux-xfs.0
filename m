Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183061CA80
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 06:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712729681; cv=none; b=YotGnSqxtM1ZKqEq4Zn7MN2M0Xo8bZ65x1gdmRBoCAFEATbfI7e5EkZ0CvRq8l0qbaPBfugxzXwjxnv636g8a9V+e65+FA91dLFlMls9EngtV7G7q8zKxxslSbn4nrN8ZwGA7QkGWU3M08/dnM4ztYVbDUsD+ud1bkzcsRJEUB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712729681; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rs7+qvOEUWo3ppDDtgFAX3gabswAXN/Pm1c3x4JIgAAKKvJ0wOrO/9uPQJkRGGELlA65zl0M4olcWKZGCxE4RzhzmHAzu2MbpvWBdlSpoKt4OyDciGMj2A7HSjVS16XM1xnx6qa8wxiBIHvyM6TvcGxGSLcjeVd6rLN9fOa3Cz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qVAfgUTg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qVAfgUTg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=qVAfgUTgGmsNJ/I0qx/LrmeKeq
	i7rONarCQYI7jnf/SeNBMuJ29sQoYmLGnY/d79v16eMG/bLBbzJdrveRzemvzB+TmcUuvqJannSGk
	AG9lr73faI2BCni1b5ynXD1vWzpAUMfoAgE5nw5gNw9r+5b0BKS1JG5iu5MA5gGrp7QhhgP79v+jb
	E7Jx0cHnffidf3+AshTwoL1ky21NVtRNwW0KtfKanozya/IBtlTC/yS0te3FcX/kA217vMDREyav+
	aRvwMykW/G0v6EOQua14Vrkmhmh4rIxwByEhw32gHxYpWVKceGemC+RqjTb1okN5Ppvqhlj6NrmK3
	EgAeEIfA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruREF-00000005L5f-2LK9;
	Wed, 10 Apr 2024 06:14:39 +0000
Date: Tue, 9 Apr 2024 23:14:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: check parent pointer xattrs when scrubbing
Message-ID: <ZhYuT_9JFtJKsLlV@infradead.org>
References: <171270970449.3632713.16827511408040390390.stgit@frogsfrogsfrogs>
 <171270970567.3632713.8784234263889465896.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270970567.3632713.8784234263889465896.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

