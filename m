Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7374B524B
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 04:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zMd3qV/4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=zMd3qV/44YkQrslHj8FgFe/4bJ
	L0MEVJUxATmy5I0AVrhLUYHYFFzlCIbcKtS+wWTsXNJ/oz/WtlWs60P3YOP5YN1o2vdYQpcwXzrU5
	dlF0uRZTW8WkS6PiRvE9oL+Z5m722T1tbKP2Kk/X/52s4Hwqpy0/CQkaiKVKjsV9laANas5PuXwfD
	ZPwJr44eMsBRusyBPMONYoSlOyEHUpj0p4MGC/6paQW9vE16NFD7+EwCJ/Zo0vbuzxbeo8GlYEEAv
	7iYOzRkMec89eAbY4WwoxPBzkXc+GmrifdwfjfWhH3gbfuG/srCkxp8VldXaQgTqz9/5cTFJ/Q8y3
	HFXL7xWg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcG3-00FwXp-0K;
	Fri, 05 Jan 2024 04:56:35 +0000
Date: Thu, 4 Jan 2024 20:56:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs_scrub: remove ALP_* flags namespace
Message-ID: <ZZeMA9r48Tis9ABx@infradead.org>
References: <170404998642.1797322.3177048972598846181.stgit@frogsfrogsfrogs>
 <170404998686.1797322.5266294710113595532.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404998686.1797322.5266294710113595532.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
