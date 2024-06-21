Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14DB12C498
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718944754; cv=none; b=gDudxpLv7kpwUUjJKTnSymFNlzeKM/dS474bRIPGd85/n7Qv8/nlS15talWSNOCd/UeUeX7j2v09Sm2OLrLxhMFKkoSmOSadd78EksG2vebKdGNlyz2bu5wKcso2mNb9zYI49m0r5XagqC7qIEBxR0Gou15r4TOU/WdRZZcfLbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718944754; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CX8hA2GH+zvZIMOrwrNMSO2fpajrceQwkeORPx9f1myKvCtW7NvW9C2GxivkLSfL0wgKN++rP8y0jxbNK/XTQMkYOM/VwxTXSj4eK+EYQ9/N4O+ZJqfh95ayJoj6B3EKrnCQaXuUgZ3aDhTbq6km5gHpxPdsbPG9h0VdUo42cnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ROl5zb5j; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ROl5zb5j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ROl5zb5jL3Y6KaigVw+UdFegTG
	zBVUk18NzRcG40pAyyiIHzHphh+9PKIHo/4WnnO+UsLwY3mOWQd5ehDdpyWV5PUzXLQAiz66LuvSW
	08BhfWvO417MgY9OhBOEOkS71u5/jAtfNk4epfZGMgYqEBQ6Jsx62yeTEdI8BfVi8tVLIqRCs14Vh
	J7zNX9RbYNOIvOuEMXJVVu+UCIYUayklkOgjHoEyGDH0/+PxAVUJzy3z/hKoCQVOtRpc3Tihp0iT4
	mJAiHX3np/+8zRlrpfbv4Va7Af/cNdkUvjd5TXhD1VGNAT2VLZd4kZFeyKwJ52s6K/NdhGbRLBmYF
	YYWcHJ1A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKW3M-00000007fPk-2cUJ;
	Fri, 21 Jun 2024 04:39:12 +0000
Date: Thu, 20 Jun 2024 21:39:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/24] xfs: pack icreate initialization parameters into a
 separate structure
Message-ID: <ZnUD8FW3j9rbPI5U@infradead.org>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
 <171892417998.3183075.10914239409938164350.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892417998.3183075.10914239409938164350.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

