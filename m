Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D984C129
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 06:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712729143; cv=none; b=E9TbADugFngtBmvah1LHD/ouxfRX/iq8lZ7xum/iTmUCOxLDjTlXWE7gxa2p5nIR6pe3fKkx0tBGVmRM78txBhlHNlfbwMFdPYylkBVaS4F2Ftp6x2hQY+htlTVLmGt3tyP5Z0rNt5qw7xeidpvkaXZSPKB8em2UMibNuz/jKvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712729143; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WFG5X0swmPUzkkX1/v7ax1JO/QaZNQ1YWmUvVX93+gNZGJbPTEHxBd3iMEThRZuAhxgq0BpbRhx4N0x9/IK9ANZ1ryyN2UC6Kkc8DKCtIu+Hf1Qg/M4bvvY0jUPAes6/Jv3A8g+P+KVVbgWU9aRBvFd4CfRLdEQFDV0tIGsoysY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=he/tpl6v; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="he/tpl6v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=he/tpl6vibMMX/Po09hxVhbEgY
	UMCjb86C0hpLh+sbKL0zwT8F0Wlp3zGrZLNCF8V2hVoP7U6vPRh/DGprCdarq+hrR/gxwBT0C5HL7
	lJQCjscNJPILMQL8fM68QkMGoXgFs/O9wEwaj9b6K726aunPiTxUYhzF9s4LE1dfoeznCFE3BSayb
	Ef7srIsRr/wqo8RKdSFB990YUdhyxdjUk5gdPxn1ni+m0on8Cxb4eeb4b8zG4aP6piVhkCoZu0z3u
	Ic3yvkNOlM4R/KMDH84PCcCddRfdm2cGaYRfQmGuAxrG3hV10SRglCvFUL5bBZZbN4lrmAyWgQxWH
	+shMWvig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruR5Z-00000005ImT-3DxQ;
	Wed, 10 Apr 2024 06:05:41 +0000
Date: Tue, 9 Apr 2024 23:05:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 30/32] xfs: fix unit conversion error in
 xfs_log_calc_max_attrsetm_res
Message-ID: <ZhYsNQQjH7yXXSo5@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270970059.3631889.4894608923555781612.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270970059.3631889.4894608923555781612.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

