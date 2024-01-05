Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2DA566E
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="h+aAGncG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=h+aAGncGBCvn90OCt+8BHf7TEq
	PkHFxaL3fTyGza7XctUNm5o4z7DxixvVFgNw0Ceu5vW5ZvS44a28/8o6aBzRJJb19yj4DoYlNBJ7f
	jLiMoChNOuRn/RgNpZ6eHgDLOQF6qeEs0I3QJxHI2PMRKoYO2yhYjXk8Ap+m8lLM3IHPDsNi118bL
	jzSD7nih03q7FCzl9bvZfntPfvSIwAWoOTMpEpD7G+8sBblWozmsr0TbgKuzxXVGHNEVgUgdoFvw7
	jdx/1G9pME2ofqFuTZZ+PeZZFpBp9Du3fK4siksCCvdWWrClII/5KFiV7C9M2ICxTUu5OetHxinEw
	BzfGQcaQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLd6P-00G0hH-09;
	Fri, 05 Jan 2024 05:50:41 +0000
Date: Thu, 4 Jan 2024 21:50:41 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: support deferred bmap updates on the attr fork
Message-ID: <ZZeYsXdvkhypyAKk@infradead.org>
References: <170404832261.1750058.14588057130952880290.stgit@frogsfrogsfrogs>
 <170404832281.1750058.12497248988958085816.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404832281.1750058.12497248988958085816.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
