Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569BD182A2
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 08:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Rg8pOh3F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Rg8pOh3FdVetrozop/CBrMM8VK
	+9MCRUa3aq7FTIArxHvHN520l55E03xT69gmYR2lv3it2d5uizqgCxHtXAEvkzj9Xvdezo5wwrjQl
	jCxQRNl//lFFOET7EW/JyZ+nv9p9b9GTNLcALxJYLJ52Ed0MZVgZV6IkQ3PV6fkkfACyet7N9tbn3
	zxerYVqbaVer+mWNp0YM8IYtrwa66vtLsBjKRVOWvBIGaLDV5XxeUa5OseeMs7+6JvLgJbcQ6F3z1
	H1+ULFNPs8nMuXA1v1VRzpr+5zcgUV2L2hf+Dz56xg7+47ZHS6VRWLfAkGuQILFIb6jIFAADQ1wcy
	a8z+Bavg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKwz5-00A8Ir-0B;
	Wed, 03 Jan 2024 08:52:19 +0000
Date: Wed, 3 Jan 2024 00:52:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH 4/9] xfs: make GFP_ usage consistent when allocating
 buftargs
Message-ID: <ZZUgQ0nDHEzPxn60@infradead.org>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
 <170404829643.1748854.8931317156367817589.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404829643.1748854.8931317156367817589.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
