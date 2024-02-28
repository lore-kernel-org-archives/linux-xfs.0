Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0456C15B0EA
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 17:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709142066; cv=none; b=mDxP3c0Y6swIRmvSN70huFb2Oas9FY3/ZBuwcHcrHGsSmkxGMHM2DtJ3mCjFbbFTov/DNA5GKOd09NssM1Cs0RipbnNt4PAHQLEHnvU8EbkRsNCd+f6y8MngsKU4KF5Z9tWBdKEr/WHWNzsePOQSXl5aiZ8Tb0OgMyKlp2Zhyss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709142066; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tcutRTsrvWuCb+z2qL4OsCoz1XGT1IWBDk7h5Af7qQuh+q7Cg5sJNJlyaTjuO3IlRJJK+RClAZHEyOE4BOjkWaIe/m2kTCJuqVWOpPg2c0aP/acmH6QmfzmbwHy3N0h2TK4uiT0fjXHTlk5WAiLV//pKs8I1nw0buzyJJ9QHksk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QXksUXB0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QXksUXB0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=QXksUXB0vPE1a9p2gjQ+eZ+ZIP
	20KZ3OCqenXGy/FBu1uiN7CM8MN1kxooxepphtWkPae90XfUCboMFopz+Ijziv2OqdRksCKUc575S
	TRFn0Vppu4Z4sFmqELtwx9i1f6nJj/PIHnBoJ4oa98BoxmbDb/eareN0512eX7Q6R2gbdgUtbjk8T
	tWw6M1e0uFuHKhBatOlZoatJfGmfqWh6AI4CLO17/Q2sR57WLwU3hiWwTSJKYE4760FF2GaML8lib
	JnLDtGJXbP+I8nd94eSoBEterbL8tsOlfiDC7sf3j/PmOrP1GjEq/jMRvLOQsZkh3AluYVTRUBC7v
	0kI2Sdeg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfNvU-0000000AKhY-25xR;
	Wed, 28 Feb 2024 17:41:04 +0000
Date: Wed, 28 Feb 2024 09:41:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/3] xfs: hoist AGI repair context to a heap object
Message-ID: <Zd9wMBAoxmeLxZ1D@infradead.org>
References: <170900015625.939876.13962340231526041298.stgit@frogsfrogsfrogs>
 <170900015665.939876.5778128292096427949.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900015665.939876.5778128292096427949.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
