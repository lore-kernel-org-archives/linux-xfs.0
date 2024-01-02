Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717E3DDA7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SlsG5rvR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=SlsG5rvRPR35z8jk9q/hw+tYd4
	CnoDaoOALqHpQj1Ptqne6P5A+ky9gmLrorow+kQ3k26rcv3fUIdQhdTu+u40ALEDOJ9XqXOAlWhVV
	8l/JO3J7AWEmYGpX6GwHQTRtkWrhn3T+6sutjFutnZNfrCUcuAatm2C1AUuNU467/uuaF4oENMPG2
	qYr38IS8NQtbjSrVTAw4Y6/gbIVFyN0c/4gEWeJYvpBm/ylnVSloFbfy2VA0y57pFuIdjEs+txB5r
	E1VDRlpiTR1c1mAw1f64wqDQ7D1hvxwSaqwetZg18TUcsYJLXMtLeVTHkN5A8GIRpbuLlyfUbQT4m
	BTJzC5Lg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKcI2-007dYJ-07;
	Tue, 02 Jan 2024 10:46:30 +0000
Date: Tue, 2 Jan 2024 02:46:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: add a realtime flag to the bmap update log redo
 items
Message-ID: <ZZPphlSnKYxkEK9O@infradead.org>
References: <170404831869.1749931.14460733843503552627.stgit@frogsfrogsfrogs>
 <170404831907.1749931.14510682723075122416.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404831907.1749931.14510682723075122416.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
