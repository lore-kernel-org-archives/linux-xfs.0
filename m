Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B94EAC0
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XJhyceZ9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=XJhyceZ9iMfSmLVtwc+H7eENZP
	IxqHNBw3AB3+VTi4e6+NDMyz5OW0cPvDVEhvqmCBfS6BW1igHt39LyaxHbO5lJpisefX0X0dF2pw/
	M5GOcxNVf2OI0Xe/5n7UWWXM2XXJ9/yuH1DsFmKVNzSyVJK2gZQUqYvfk5SqiCgShVykHE7byUqIM
	pidW/CYP9hXVV71wo6n7Mw2EnUzt9hgKn8aqtzPDb76wD23KjtOfYPGphCv5dnmSKmPdenzGhnoVV
	jriT72RUEC6bv13usjXzTy9l9rc8rOhP6xWDHaimIYIhRo8Qy07zX9q19/ITs/RYPFXIZ4w9BmCxX
	isYlUSXQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKc8b-007cBj-1d;
	Tue, 02 Jan 2024 10:36:45 +0000
Date: Tue, 2 Jan 2024 02:36:45 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: initialize btree blocks using btree_ops
 structure
Message-ID: <ZZPnPa6uY8/2dsM3@infradead.org>
References: <170404830490.1749286.17145905891935561298.stgit@frogsfrogsfrogs>
 <170404830576.1749286.7003453850155892897.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404830576.1749286.7003453850155892897.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
