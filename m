Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DBB1095A
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 04:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="22K66QS9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=22K66QS98C1Tp/CQSK69Rt4vka
	qq7c52zSjjpcDYdycEs9+L2YmVB1bBySFCTuas4BxYfVw5DSEpDnJpD300quU6XPTZlKDck/bmHV/
	b0Gm62+nkk6QDLyIE5iUsnO9/lYxLv+qNQnYnt5WZ+wv039xsf3OBkagLUPhHUgsry0EqM5zcg6hy
	2d7+z4HGRPfRd6YByRFPMwWCQxliJHTTJMU9uMHQcTbGLYu8hCi7F9qolKf3LvQApGQi5hoqJDz+g
	Cs135G87ap6UynthbXbNnWzcCWs3FTRXmzUBYneLTAn8fR0x3dRZ85ZCGrUIg/5kCeG77hi5SojjA
	CVx50Wyg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcDM-00FwPS-1i;
	Fri, 05 Jan 2024 04:53:48 +0000
Date: Thu, 4 Jan 2024 20:53:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs_scrub: scan whole-fs metadata files in parallel
Message-ID: <ZZeLXMiksvmG37+M@infradead.org>
References: <170404989741.1793028.128055906817020002.stgit@frogsfrogsfrogs>
 <170404989782.1793028.4618744915363324711.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404989782.1793028.4618744915363324711.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
