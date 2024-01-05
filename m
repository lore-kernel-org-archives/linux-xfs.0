Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3D15228
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 04:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZL6bYudB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ZL6bYudBJkPmXA+0OFBC6o4JOE
	HgT3HiXOEGvVv0zhELwO9GvM/8VKz3esBvfGYcDbeyddU64iuNvcK5KIs7oqgDwyhUNThAHh1UwbN
	VoYCxGKQsU98DAZaZqumJ/Gap0+7v1W7n3ELyUhewGzC8/6/gEQGZknB43ehYO8SfpoIaG+y6ANhH
	VC8vFiqbIUPPSvjTcQ87AKQFb7uCJ7Gv7zcRqx4vKn4ss8qTTUZ7kOBduhG5KuktYRAdm32pazZxK
	JCDXxYz6HDQAVLt2ufv9rDCniEu4I2Wil38CoaRxgbUtCrx4dAKwzUqKOFku3VIVKzaSBTukACtOJ
	N0F7uGAg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLc94-00Fw82-2q;
	Fri, 05 Jan 2024 04:49:22 +0000
Date: Thu, 4 Jan 2024 20:49:22 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs_scrub: fix author and spdx headers on scrub/
 files
Message-ID: <ZZeKUrCQ9v5d2K6y@infradead.org>
References: <170404989091.1791307.1449422318127974555.stgit@frogsfrogsfrogs>
 <170404989107.1791307.8796926188438152942.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404989107.1791307.8796926188438152942.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
