Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2F6194C85
	for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2024 16:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727714543; cv=none; b=FCjU/3axTC8RlO+C5Yg75ay5T1iUHMwhetdIa5sUbCbSLocS5MiG8rYvABzWJbrZW4X5v18ANeDY9bnEjZSayErdUf7dLd/vqhiA1zvRZ7etjC5+y2CDd+yvIy5uH+rDG+WvGDaG9fTIjeL7LD1SYetkuGIVGaSjwTQm57ef79k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727714543; c=relaxed/simple;
	bh=4uT7v9/R63shHE9EmKtVr+NcO1ZGrYeqAJfiMgIo3r8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tIfV744S7fuZC0tQraDAl3wHdydH9iNtGGR79as0aJKHsZyJsg2qQKnmKL/Mnuny+K2Dl3jUBsBVIYdIbMyiNQSKi3qYLsm429w90IE/hIYyDoXP6F5mX4EFAipIxZSPb6MJDMOA6MR7rQqyE1xikXDWJsK/Tetxs8C9SAZ3xzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JNgn2K+7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JNgn2K+7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=oi2O6GABKXjTFAwJOEb+m+24s6VvPFfqNhc+x2GnsKg=; b=JNgn2K+7wMdRXyxLQ/iBlXrvwp
	y0HzV6vsbROQD8b+X2+bSgFm8FqWjl1pZQzjwxerKrdVlyw36BPM6MgIj9svfZ7DhaB3AGcV0P+v9
	6dTQdjFUGj+LX499U512yGV9LF8s+VaRZjvXyCFgnOult0ruFQkoxlSOYXEI/KGdCJRYISPLk8Wbs
	Bm6+sAEcuHp5LBaPjID0rUNlxiMBQfwQaXcofzIGB6FbYEvNwCol4FrBr5TL+N6ZFyHPRm28KWOsG
	v13M2Aqf5pSVLHg0uMatptRX8cTQE2qzOjMwA4HLCRjv0O8coemy1EoqOdJXj99Cu4Y74pX7blS2h
	Bnukdpow==;
Received: from 2a02-8389-2341-5b80-2b91-e1b6-c99c-08ea.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2b91:e1b6:c99c:8ea] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1svJTW-00000000GTT-3UlU;
	Mon, 30 Sep 2024 16:42:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: fix recovery of allocator ops after a growfs
Date: Mon, 30 Sep 2024 18:41:41 +0200
Message-ID: <20240930164211.2357358-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

auditing the perag code for the generic groups feature found an issue
where recovery of an extfree intent without a logged done entry will
fail when the log also contained the transaction that added the AG
to the extent is freed to because the file system geometry in the
superblock is only updated updated and the perag structures are only
created after log recovery has finished.

This version now also ensures the transactions using the new AGs
are not in the same CIL checkpoint as the growfs transaction.

Diffstat:
 libxfs/xfs_ag.c          |   69 +++-----------
 libxfs/xfs_ag.h          |   10 +-
 libxfs/xfs_ag_resv.c     |   18 +--
 libxfs/xfs_ialloc.c      |   14 +-
 libxfs/xfs_log_recover.h |    2 
 libxfs/xfs_rtbitmap.c    |    3 
 libxfs/xfs_sb.c          |   97 +++++++++++++++----
 libxfs/xfs_sb.h          |    3 
 libxfs/xfs_shared.h      |   18 ---
 scrub/rtbitmap_repair.c  |   26 ++---
 xfs_buf_item_recover.c   |   27 +++++
 xfs_fsops.c              |  102 ++++++++++++--------
 xfs_log_recover.c        |   30 ++++--
 xfs_mount.c              |    9 -
 xfs_rtalloc.c            |   98 ++++++++++---------
 xfs_trans.c              |  231 ++++++++++++-----------------------------------
 xfs_trans.h              |   15 +--
 xfs_trans_dquot.c        |    2 
 18 files changed, 368 insertions(+), 406 deletions(-)
