Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAFC11CBA
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 15:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709049107; cv=none; b=HDGC/ToPMijcfcf7oHSrKhp5Hc9L7zcLtVYn8+T2udxtlcL+uIBTOU6Fg8uBqVb52/uuKxT/mqZIqOVpUUdhFzlevDxes8HcsR0u8swa+c5FHizxDq+WGhJz/W2IisvWFp7TJeqGKXchc5R+CFfoGwrdTEOp8GS/U5jA6akKG5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709049107; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LOahkh1Lf9Ht65/5o7WKrfUFTOX8aZMfOtq8pCccHR3C65OwsjW1SjZRyYtQYwV0lZPrAGSF6s7dtIL47BXmBPplShdTmk8Q9H/xJfHkhV8OlhgMi6+23aVgT5YllyCwKlL4qK0LUHcOQA5IJeus+xLguKQHvy9ZTmiJ6YwsNgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lBZsBT5C; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lBZsBT5C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=lBZsBT5CT5EYJcp6hxPRdMb3G+
	lf3+yfDUVBsW6b1aKneiNloOY+q+x52jstAjnFY3+9d4MxusmYsCXe9zhXMi37ZXVvHFP/cKvfcb6
	G7j+tjJREihyIdKKfjn0xgGb4m933PEHuF5dgAO7xbc+GX1eksacBdeYZSsvFxwPyVIOyoPvwyl7j
	aumIRcqZKklD48d9n17Pi6Uk5stqXQQKHDpgc6E69agIXLhEc5B896jMrCewVaLi87SNQBTx2ZrEN
	J33CQgKAlVs+8tStTr+kx4LMSs4/I81/KWzFhvxg00B//HEVD2AVQTlwGU1+dZCdg+ZMCpnniCydX
	uweo3aNw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rezkA-00000005rcb-1BlJ;
	Tue, 27 Feb 2024 15:51:46 +0000
Date: Tue, 27 Feb 2024 07:51:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 6/6] xfs: refactor non-power-of-two alignment checks
Message-ID: <Zd4FEgLj3o1PMn5v@infradead.org>
References: <170900011118.938068.16371783443726140795.stgit@frogsfrogsfrogs>
 <170900011230.938068.18189033969735593047.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900011230.938068.18189033969735593047.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
