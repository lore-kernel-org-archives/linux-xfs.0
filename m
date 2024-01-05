Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2831566A
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E/cEa2/c"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=E/cEa2/czc6TPURaWrsCbuYmcE
	KVpmhi7elvk65EiYSNra+1q+8iPxYTJg6mpIe1U8olwLRs87Mfop/QHGwV8rKWWJ6FIbNduNp9/Xw
	PR1xhJa3pB+JxPwByOG2kH83Ul+jG33l/H4+nWkHTAXvKJkpHZ9AKqVDjPss1XqS5vb3r58MxKgUS
	bxl+dh7vKdlGE4SJIF3MNgbaqPM6I634709SfDDMKETOor7bc0FGSVzoOYb5c0u5XXlpKx9kAqbnN
	Q3dlxgU30eksmMKIa57iIFCf2vvnVu74tJLgt0Dg7wSp65nNl0rC6ZTk1Tw9bPCw8QbdHNtYpFpBQ
	yioOi2+w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLd0R-00G0LV-1T;
	Fri, 05 Jan 2024 05:44:31 +0000
Date: Thu, 4 Jan 2024 21:44:31 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/11] xfs: report inode corruption errors to the health
 system
Message-ID: <ZZeXP08AOzUdzbH8@infradead.org>
References: <170404828253.1748329.6550106654194720629.stgit@frogsfrogsfrogs>
 <170404828410.1748329.12890166621662444693.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404828410.1748329.12890166621662444693.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

