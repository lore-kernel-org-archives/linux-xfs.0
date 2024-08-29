Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA2F1870
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 04:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724904538; cv=none; b=WuCEeK/hrzGj4ouoBe2o33TyRpGeyRCZpM+aJBA5PMsKbXc+rxXHGUqGqgfGybrY7Buz6ryikUYeMoy7BpjENGELtvA2je2/4XKEnRtM1ZxQeR8wdI84m7634H2AjH2dyAeW3n634NzjnCHa3Lq814QhmZrxRJA1uHlRBPme2oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724904538; c=relaxed/simple;
	bh=LZO95rJTjW+RnGNKcoum1CuAGFemyNihU1vTUaxvkw4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nrZWhOXwYq9T/9KDIeWSEnZqcQTAAmjz1ktHg/6e9fVbDFKyN3xc98zmgO0RYFbSBPOmZA4OfVOsGrqATWRsMtZlJRaoVhfc8f7zUi68FNajdOTOEOYZspFDdvCNIwr99vv/I8end2YHiSeiQTRH9FvwwpNMu5E536BXDSMO9u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D+RgeKUB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D+RgeKUB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=286OKrNE2I/4f74xzopmm7i++DKdF0rkPov0nstmrUg=; b=D+RgeKUBJE6IevHyESM+rWMq0G
	r+A6+Y293q1OkchtCNrU6sulBRjm5RDAYdOJpH6t8dGwpi2CFzISNbiPhe/fzBAlrUlrxmehQazje
	1zuTL5iID8JAU1CfNvlhyFn2c4Y8hcOmAmHaUTuvkiOBU6fl8pzjUFoGa45ByhvcPrd+rx73116mc
	JVqTCE/IU1KjR12oixxUPMB95Dtu4kz0XFQ+sRLLpMId/N7PPgBLsYxnqrbHarYm9zgv2Jy23ugfM
	iR8YDay20ZdnJQE3tNERBgloplgMFyvOnD9Vpqy2r6QGw61A6iIlmXn8idMf1+swXT/lzDJWhAokx
	DBeZycjQ==;
Received: from ppp-2-84-49-240.home.otenet.gr ([2.84.49.240] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sjWSs-00000000RwJ-3gha;
	Thu, 29 Aug 2024 04:08:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: convert XFS perag lookup to xarrays v3
Date: Thu, 29 Aug 2024 07:08:36 +0300
Message-ID: <20240829040848.1977061-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

for a project with the pending RT group code in XFS that reuses the basic
perag concepts I'd much prefer to use xarrays over the old radix tree for
nicer iteration semantics.

This series converts the perag code to xarrays to keep them in sync and
throws in the use of kfree_rcu_mightsleep in the same area.

Changes since v2:
 - fix a comment (which gets removed in a later patch)

Changes since v1:
 - use xa_insert instead of reinventing it
 - split API changes into separate patches
 - simplify tagged iteration
 - use the proper xa_mark_t type for marks to make sparse happy

Diffstat:
 libxfs/xfs_ag.c |   94 +++++---------------------------------------------------
 libxfs/xfs_ag.h |   14 --------
 xfs_icache.c    |   85 +++++++++++++++++++++++++++++++++++---------------
 xfs_mount.h     |    3 -
 xfs_super.c     |    3 -
 xfs_trace.h     |    4 +-
 6 files changed, 72 insertions(+), 131 deletions(-)
