Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4C53C2780
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 14:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772549137; cv=none; b=t6cKA66aM6BPRjlaPmrXnahbdDPUovS2YV4FtHBk2Tp1C+oCnvV1jsRFAg/XkJ+3dFP0b+Po9Bsq38VaRssau1roj4nzpuZuWN2cxz4wrXhm526IrFb2QitBA3wdcBHA8819Q+pE+1L+tFmJ5rNxODZh8OXniLD5QVgJQ8mYcXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772549137; c=relaxed/simple;
	bh=0mKaz+qRfCYEftF3npw1c7ilWB6fs5wml1ot5DKMvpA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hbWfQkWhIvpUG0J5o8c0kATrU+2QgFWFLzRUmNYHery37AFVmagB0DkUb0hHiDkHfoNFK1/ibWFCXLz5DvZIMy6icv52uz1HhfMCwFpB8HAY2RBsd5EnpthmamuKwjva6AnaDhtodBwT1yn4HvpBBEwdmAhtIcPoerg3Ha6XmBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hFfIUjr6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hFfIUjr6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nODP4b0RfxPeVOCHSSwe4ibGA0LhZKl9C+fHuEHwWho=; b=hFfIUjr6/h5SL4D/zqiooQH7yY
	aRbGdmFQawb4JiPjQLzGptnxSgm0/TkziA584TTupnbkybwhGHtwu7eMGvocZ12vGcYkqxhHUDQKl
	HP+IXulju+PR/zx375BReMbsHRzTL0wrR2J1r6a1tZrLjyXB6rFjY9WORDeNSEBMmUZn5AdjAl+sy
	+8yRVz96X5kiOK72ct6ivNbX6prjOhbfoBkFP4KNe02cXSxeLIfKlgXTsYVdklXo7Nu3tLcKlDf8o
	drNK+LNEZIFe4V5MRq1BRZ6/3QASfznE27f4OMdn6dvAx1cz6YBMpw8PxCzv0Cl4jf3kUd/rflUTI
	vMW9yCjA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxR0C-0000000FM1h-2F1w;
	Tue, 03 Mar 2026 14:45:36 +0000
Date: Tue, 3 Mar 2026 06:45:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, dlemoal@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/36] xfs: split and refactor zone validation
Message-ID: <aab0ENuLXPSADWVS@infradead.org>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
 <177249638091.457970.11956003361714341028.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249638091.457970.11956003361714341028.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

FYI, I have a whole series to make better use of this new API in
xfs_repair.  But I guess just doing the bulk conversion as part of the
sync might be ok.  Looks quick from a first glance, but I've not 100%
verified it.
