Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10623B2FC2
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 15:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786376283; cv=none; b=aUsPUpBonB9f663K3TjbxCM+behp+d4n5K0tx9snHH9TLx8XH/DwGckmkvjbD6mQx01G/z2cpsRifqlwDFSOPREZrUbJsOBpYfP1DJ1msccVRu9PsMWGWcgS2RsruU8QkFNjJR6I0fAb66nva9o6e+FqvehvI9t8B+2KMS2qffo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786376283; c=relaxed/simple;
	bh=Hu/71fJpSgnJGRFN90q8WP3XrLihw1UMSZLJQm65I38=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mR1Rp0U/39EWTZXydGny3Pmtw4fZ3yx9JScFTCpWY4LqR4KeUlZfGi2AwfKnKmX194rnehRBjiP8lBDi4AwQ608bgpS+KaBQyVMaMfhJ7prT/YN6QwHFUiFqalUmCpTwKNmsrxeQoWhqw+Vyf+A7Dw8l9hJlihHAJXMyltkAL5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wsm7CA4g; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wsm7CA4g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Z7cSNazigzCpZKOj3tfcGd/dQnu5wc3NO6Ju5qJhyew=; b=wsm7CA4gWEN3Ll2WTyIdRVTgzv
	8S0fqzJR6J+C3YyPmgZcUxvExvzcLxlhW55+xHE5mnta0tJ/SG+kQGmweaBLBnLLSet1QEYWCBTp0
	SC1ZNgDE2gSgDDkN5j3I1zasBliFElCNpkHTFxmN91a34rXiJIZiaIMMDBEBQfjF1DiOsjRldCi5g
	l/ea+ACr+3EzQCqUSCGAy4GRIwQ7oa4qp6F4hRP/kzak5OY+AZyh1Iz9LTnXUOMKDT2UxID331eFn
	fNkGi9lC+Y8RHkFBDv0hRoRBwPLIStgG6Rc0bjk3c7MTfiIFWB7IBBAvm9GD+BlaOq9Y8OOSU5Ut0
	byySAvLg==;
Received: from [12.156.71.108] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtS4d-0000000CHoW-3ucg;
	Mon, 10 Aug 2026 15:38:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: zoned xfs updates
Date: Mon, 10 Aug 2026 08:37:41 -0700
Message-ID: <20260810153759.466417-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Carlos,

this series as a bunch of zones fixes, and a trivial code movement to
move the ioend code into it's own file.

Andrey just sent a basically identical version of the third patch, but
I'm including here as this is the series I tested.  Feel free to take his
version and take my indendent reimplementation as a reviewed-by.

Diffstat:
 Makefile         |    1 
 xfs_aops.c       |  188 -------------------------------------------------------
 xfs_aops.h       |    1 
 xfs_file.c       |    2 
 xfs_ioend.c      |  184 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 xfs_ioend.h      |   16 ++++
 xfs_iomap.c      |    7 --
 xfs_iomap.h      |   14 ++++
 xfs_zone_alloc.c |   56 ++++++++++++----
 9 files changed, 263 insertions(+), 206 deletions(-)
