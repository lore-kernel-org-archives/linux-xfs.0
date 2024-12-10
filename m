Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3EF79FD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 04:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733806792; cv=none; b=QODIWBHjcV4MOkBL3vj7HTW3fTiAu/3Tl5unfklgFcFumBOtrZ7pmIqQN7YeJgvsUH9el4mK+2HNW2L+7NuYoYOmsBc750OIpsZn26mhvU9hRlNy8bdCnKOiejiviCqzPuWMO48kuT3eMJu77uWpLGdshyYL47WpKAgKs7fRbzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733806792; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=szbIw+ABC6EsDz5QkcKt/8d48Lw/4MVnMMRpOV00iyCH+ikvXYE10sFrRLbn6xQbKJ3JgjJcupVbuf89su0J0s44ExFz79UhUyXbO1posPte5nqKpwOkaAxRrMhP08gpnlvvYt1lb9JJeGQ6lknB9Mp3bW1/BnDz2sqKpr2xT1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iacACWrq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iacACWrq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=iacACWrqceeDwDnN29KHZTj9Lt
	AOcQfenuIEnW5Jj2+ZIBXUGGBd1BS8h+gx/miAixULU71rWBRDEycvs3tkfvFMHOmtqaTXXQwzkaf
	tJlP8rkCGlpQSdZs1UJeTyQF8qUODx6s5Q2awV8viW7bRp4AUUAPOcamuPQaW7XGDKigXlFcyUD6a
	LnthwrKDIKbFlxJjOf5RbhTizj1URs41edK6raNcrbY+hTNaBWtiIizGltJfbE6V5xWO4CNLDJLlP
	4Yaw73dDdTsN8AM2+0pVs0twlj7pgWAwlXLQoIPRpyaZyv1Hxa/GvTyW06EEyJSrdPtAK9fa/OXOT
	RQ3pSNzw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsLe-0000000AEpt-1ZmI;
	Tue, 10 Dec 2024 04:59:50 +0000
Date: Mon, 9 Dec 2024 20:59:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/41] xfs_db: show the metadata root directory when
 dumping superblocks
Message-ID: <Z1fKxsvh_RcLEztu@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748437.122992.17222124628944235085.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748437.122992.17222124628944235085.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

