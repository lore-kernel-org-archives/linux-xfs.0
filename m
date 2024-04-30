Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F7817592
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481373; cv=none; b=tELLLQfPpByQZ467rxFQP82btvi7AAqxGwn0fVySUo0FAP8gZWLEAaavBswjB17lbJSajX0L6T1Lsj917QNhZFidyUrtXfbDfFlohwUFmILV5txj2BwjM6ZwzoLibhV3WxDA6qmXT9tn7pfz0ZpSpskS4WSeXBZfJuHnu4UocXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481373; c=relaxed/simple;
	bh=gyd1Fsj690mtj9XKPYmW+BMPPjzHyCtymkLSTz53mB4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cxEqbvrExWNQpgyD3TxA0QFUPJieVRl7WN3zqyZZ8Eq7tRlbcleMGQClNlCE6QID19aPBz3fE+xEONL3gV3DZDnoxxo78DouWxJlQXNUImg45l5BvBjH8Lmdc08mRTOAu1RvvSFP9fvKiKEwVkAn3RpHKOMeWLvyNpPy3TIkuGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bJW+oEQv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bJW+oEQv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Ld1JpV/yPjKL872rF3tWu+SqUiuHErxvF8uyRNOBdt0=; b=bJW+oEQv9LzcAm+UmXiweBdmIN
	m/CNjewSn0UtKCRtweSQhFpZe1ItQoG1tDl1FfKHLyzlMEAmaYoqdf5qM/M57Wuw6GcFHtfqIH2rC
	Zn1wH/w+x6KpiJi9SLMp0xDX8wMHf4yUf9gUlAqWDM5mMChTXEw03c9Z/74DKZ9VMOaRCn2bmftVA
	B27F8aTZ73wsiqy+cDwG4KvOYgFI4NrH7BfspSqJNBGlgIPpcXYQPeHPJ7/PUpNP+elQB4XkoOdCg
	3S3o40WKcS/i748IQhW5pxSpjcecxDnNGya/xRXSOu8zzJ3vSnRgJnjCsNnMFANxFI2wJNDB77WTo
	KxAFctqA==;
Received: from [2001:4bb8:188:7ba8:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1mvJ-00000006NgQ-381w;
	Tue, 30 Apr 2024 12:49:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: optimize local for and shortform directory handling
Date: Tue, 30 Apr 2024 14:49:10 +0200
Message-Id: <20240430124926.1775355-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series optimizes the local fork handling by making ownership of the
memory used for the local fork more flexible and thus removing various
extra buffer allocations.

Diffstat:
 xfs_attr_leaf.c  |   14 -
 xfs_bmap.c       |   13 -
 xfs_bmap.h       |    2 
 xfs_dir2_block.c |   46 ----
 xfs_dir2_priv.h  |   17 +
 xfs_dir2_sf.c    |  570 ++++++++++++++++++++++---------------------------------
 xfs_exchmaps.c   |    8 
 7 files changed, 260 insertions(+), 410 deletions(-)
