Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545D014A8C
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712728330; cv=none; b=cjWd6Zk6ST8CUdVWUeJnixGgw73QlfqADItMwI8GC6caoNc4mgip/PCtEc6Y85DMlHpxMPNWwkIfVaJmPCH5bEYgrmrq3lFluQzSsaYqHqkPRr8lCD9mysJ7AJvbJJYouk2Y1uohUDggkyLkmMEVy+f14Z9svOtfe6bPtey/fE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712728330; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hKFaa0ibgAbTrXFGpbTCLDZMW/D+fgoyrfB9SaN0P30BLZEMSnqOvAPCUxMmmd7WYh2SubLw7MsFD32UU9B7ADsmzFfweQhGgd/vlIxpbf4ReRPZQrCkKP6s/Sbw9bkxMSTumB1ZXvOBxyCOb14RFC7IJTFSx7vGEfAcIiUN3+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VTyCYGiX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VTyCYGiX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=VTyCYGiXRWNQLLbqxiRJfVCqRw
	CxWV9Q4BD6eIpzuNtT3NWiO9b6B3mezLSzkdyfRa34gcsM4ORpYLl2h5055RW3NxDiVKuX020nCfc
	/U+sdFk8jo87fwML9nOlyPu76Rb45FKCI8nIOFBbloJtvVkILcCr86mOhr4j3RHNIGRc9m6nFW2oW
	j9Rtdc0bIM+zhbvAmx7nnwUZmmiEOpXQOFV2lFHig8/QWotKSxuj0Ex+EyGtAsYHVdk3OYsA5lyfK
	4zoVlxwORh2kYzHDURHeQ42PG8gc7WJiN1SWIYWMEB/4YkWYNqCZ0pgpGvhf+kLig5ECpwqTKXPUT
	4a3rEHvg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQsT-00000005GYL-08wk;
	Wed, 10 Apr 2024 05:52:09 +0000
Date: Tue, 9 Apr 2024 22:52:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/32] xfs: move handle ioctl code to xfs_handle.c
Message-ID: <ZhYpCR6HTbFpfZ_0@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969974.3631889.581031520799249475.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270969974.3631889.581031520799249475.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

