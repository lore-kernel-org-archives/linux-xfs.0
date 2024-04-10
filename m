Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199AF8F44
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712725726; cv=none; b=KDQpVwpZwLveJ7BrOLHcbQsgdsX9TzuPmO5QayxfM2jm1qu/H/HbVNyv2QtVSIUu43SULXLN8i79wGZMcO7sj368Ph+FTDeWJ89wFCn31Z/au7JSwtBr7AmCrFhs/wVFtcmjTbBdqFCvFgbJyfenzO0qQ/xMV29z2C722F3W5dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712725726; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=izcwGHrhiyHS1Duv9Fo5TDrzLOsrWK8Ii/cUxuv6RGfzHh/EweNvMOio3qADRWiG6NXWu63ed/EPxCJGwFX6TdZYtRrpsKDU+J+mUTYeBQfBHRbQj2fIlV4dlz0U1opC7mzWjGcNP2r/5KERL5qfBNqPYJiQgJunmHg1R54mqEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=w/rgdB1w; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="w/rgdB1w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=w/rgdB1w/gAdEGbSIVBtuvYbzc
	iGSbBIQ8SaQJ2A9PRuVt3jzX6tZ5KDXKM6+1iUQRmcAWqHRAnq9Q6uAWzRplxJj5cArYTeWyIQnPk
	iHwxVvPwamAv3ApVfkjLNl7disk8IMzDotQ6SH8or0HTshHGf5N1v7jaIlQGKc1tgp5xFzWJL7Rsk
	EKqhUFXrDnwSIyLjUKMGYfUo7Apt8A2ebBtcrPOa6nUiJbus2ipQSJFOXCIRtvkNu1/6zXBRM1++p
	kJnd7KehUzP3+fbXqQEsKUbS0049IRIDvnUECFtRiePgoLuSl/8VevkfdNYAVex7FgI6nN8x6XvsH
	dKPO3w4g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQCS-000000057og-37cX;
	Wed, 10 Apr 2024 05:08:44 +0000
Date: Tue, 9 Apr 2024 22:08:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs: use local variables for name and value length
 in _attri_commit_pass2
Message-ID: <ZhYe3H0QM32UHDb2@infradead.org>
References: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
 <171270969015.3631545.13851851506156175786.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270969015.3631545.13851851506156175786.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
