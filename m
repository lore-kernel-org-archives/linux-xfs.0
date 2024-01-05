Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FEF5243
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 04:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OnOyHY0Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=OnOyHY0YsfkpqTPioZka6dBW22
	xBnT2H9iJMEYtzZqvlDM7hu+HimgmOjUN4TAJI+97UQk9mkdnpdf2iV/UmQ82z38g+YTKWpQrySCi
	6fitxQY857YRykI+2qReIt/TGtRHrqZ8ZIh8DVuJVt+1FFTgXvrf5hpfkNLlGUxl9vfRHmDrhTy4D
	AOx7lQVTIXtaxBC6Sgo4pUWX7M77w4vsC/x+Z99UnaTRcOrg3rOGnwjyQk7UMyLov7ulYHDqPQHSr
	I5201cbNrkKuh8cWF/7/PrnRVChj22/IaDUdqErrtoJp5oOSKP65xvm02n8Eh2vfYTNn+iNmDDjTI
	a4IzUeiw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcIl-00Fwfq-1A;
	Fri, 05 Jan 2024 04:59:23 +0000
Date: Thu, 4 Jan 2024 20:59:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs_scrub: split up the mustfix repairs and
 difficulty assessment functions
Message-ID: <ZZeMq4fKTrv9hauC@infradead.org>
References: <170404999029.1797544.5974682335470417611.stgit@frogsfrogsfrogs>
 <170404999088.1797544.11934780065637381281.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404999088.1797544.11934780065637381281.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
