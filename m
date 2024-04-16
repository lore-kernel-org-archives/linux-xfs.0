Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEAF37160
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 05:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713244560; cv=none; b=DbpDpKQfADlg3KAeBalHXqKgsESXSEcXNY4128U+Uwik8Hkap6OxKdxFWNBTvyrC4mF2U5Z2WqApn+hF/G1688r9V4wZx5C+LVIEcLcqdIZPAx12951f4G+sf3cXWsBxuIqd+CBo8SHd/ggnOB1d3OKsYLPgdNTXLa1pwDnTpYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713244560; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CGOOQ71eb1hJF8CapDKSkfj5bwUotiN25ZXirUeNC5cBgMS+sN1eAQo/l3za2+cH856U7TSmkpZxFdkKVbZJ+l9ho5Wv15/17DaKaDI5Pzip4IOD+6DLnn8H2xWG9MPGv1r7MMzIf66bHvrnfEGWvd6kATZFFps1uu/YyA6w8/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3+PcIKX0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3+PcIKX0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=3+PcIKX06w90fIXhEbfSdjgSUl
	LEKo2yOTLrf0ALK9P6mJcQQu6xTODsl0ciRsjylJL4RhaPmYdtaXkdOOri3vhaJx+kmetppVR0hPU
	r568eGEbFyubDo+UQyaj0amknRrpSTmIniI1MunkcsqbGV/lgTb4+T+2D0RvzL2JdyBprnaFYg/cN
	R/61WCdipU2PIuHhL549zHNdb1ipwiwwt/UxpKM3mETvYLnmzZsDB+i6kRic2URPU0deVUa3QQLUI
	ZPyKcD8NBG31qIFkLh7PFIm6zqfbKPn/aQyIQ/6em96uNV1a6mEunsF7u9nMNhlKtrh9dx+0XDbEg
	jcGVMyBA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwbAk-0000000Auxu-3Kdb;
	Tue, 16 Apr 2024 05:15:58 +0000
Date: Mon, 15 Apr 2024 22:15:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: allison.henderson@oracle.com, hch@infradead.org,
	linux-xfs@vger.kernel.org, catherine.hoang@oracle.com, hch@lst.de
Subject: Re: [PATCH 08/31] xfs: refactor xfs_is_using_logged_xattrs checks in
 attr item recovery
Message-ID: <Zh4Jjkheq2oFhSbF@infradead.org>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
 <171323027916.251715.1558174624449458545.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171323027916.251715.1558174624449458545.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

