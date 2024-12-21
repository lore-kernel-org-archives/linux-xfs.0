Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C569C10E3
	for <linux-xfs@vger.kernel.org>; Sat, 21 Dec 2024 08:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734768141; cv=none; b=Lx73+wxjI7bHISZ1Wo/c4K+VrYa4SBHNa23+RSePp/EIMjt/3HygCSF3lAM+THmMZajYmJpGn3a1H1m86QdEmOc/D14yyff0dh7BpyXv31aSx9V43PtAUSrLs/3z/kDo0syV7iDoUWDsGuHJM9Fuv7kFXp1TbvcvMVD4pwgdoQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734768141; c=relaxed/simple;
	bh=vtkq5qkCTZFcC4NbPZf83CKyXF7XAyPvbKysJfgq+0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jsFzMlzUxZJnPcOgmYexiPyLmXr0S0VM9knSm/WSwK5QaM+GceQ4j1pXZREPk1KDOcrjO7y6UA/e88OxHQMRz0Va61CYVoYyaT8qxAhNhwaQVFsFTXvTVc1xLeq9etcBL3RIK5GwSGwFkx01lUlph4UuuzKFRMkKFE6E5ZvLTTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rryjsu/W; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rryjsu/W"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vtkq5qkCTZFcC4NbPZf83CKyXF7XAyPvbKysJfgq+0M=; b=rryjsu/W7lx2eteFfZobMuQmHd
	ol8tiMjJPPGB8boMiPsOSQ8IpUrFKQ1B9pRdThgiCkXevo+NrjejdbvrZGCLL3nXLKEXIDcbntmow
	tZdHGRsPhEitOAuJ86jmbvpVP/o9Iv94BJ9qi1UHS4dg5yyY3uQO/sQ7k71M7YoMNE7iP8NmGLhhj
	Z6sQrj70FWOK/zZN+CDKJvF5u+fLTRwFv/73fua1qoNJN0DSumhj78ZaoW4rFVBmwskr6k6XFJjve
	/qaT02TWAsk1N04gNwA5x7Wn4TKv1GpgNY/vTHWxg87BtxGQ+8KOy7luqkfrlad8kiZ2bk7f6MaEt
	P2xNpyIQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tOuRG-00000006hxa-1Bh1;
	Sat, 21 Dec 2024 08:02:18 +0000
Date: Sat, 21 Dec 2024 00:02:18 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/3] xfs_db: drop the metadata checking code from blockget
Message-ID: <Z2Z2Clqzll5pdeLM@infradead.org>
References: <173463582894.1574879.10113776916850781634.stgit@frogsfrogsfrogs>
 <173463582913.1574879.1807844163819986251.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173463582913.1574879.1807844163819986251.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Finally..

Reviewed-by: Christoph Hellwig <hch@lst.de>

