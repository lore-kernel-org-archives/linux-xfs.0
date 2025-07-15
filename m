Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5A12CCC5
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 12:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752582352; cv=none; b=f8bg5V3mLe23krnQuEFm3nekv7rIe8uixyVq3ZqXCnf9y/ueAXu423TgucrtnEUI96TJwGcKqcekQbW+hp66uuG8PYBNfr51+ZCaZofaJkRnCCiDbIYzeg7eCbBmk2kkjOUSRjjDMCd6AIbpYYFQayGH2Xk1kYduV8xgDrXbwwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752582352; c=relaxed/simple;
	bh=hDVhj75CgXIlLtw03GpDqzrWadv/y6x0MdIZZGNj010=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KD5oaAhFX7elqWRVLPF/5Z1v+53CYvd26MPMuEjPlRRUjliLjD2QND7GmwrQWg1HBzd0zo8a+Mk2NVemWF7OhKV4vyr05TFpQ12YjFnAgoTQhzjiz80SNZzFlCC5lkoyYrrCOoWOJMBLIQLMwvX/MCuwTXukrDCSusLqMtBxRHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=alMnlLdP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="alMnlLdP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=27dO5cXps6fs95pw2mCqwHGAl7vaBZ/YqIWOGiY/Q+g=; b=alMnlLdPO0uXiOEe28Py0gjLOK
	u8lEgBo6/0hQjqEat0q+xUm8pZgyQU1jj1YGlSqwc8c4dph9HsWdqyLHaRsVqGSgLRD+dOStMaits
	JXyRuvD01E3Nig4UruiCx0ko2k4qoPHNH9qfU8YVEU8zp4yP/tFGbK5Ah18h3H2GpkQPBqXu88gUF
	In3WH8XN/j2UrFESyxd9TwV3URuDoXONzpDf92B1Ek161gtYCq/dRMz029K7EfpssSSNyoyXPKsIo
	NUJNWBK6gYlmu426000loGHkuIPRcUQ04HItJU89Rdz6N4Y/m97VA6orh0FV1Zvky+7bCMKx16eGj
	kHU0K7xA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubejE-000000053xj-1Eff;
	Tue, 15 Jul 2025 12:25:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: cleanup transaction allocation
Date: Tue, 15 Jul 2025 14:25:33 +0200
Message-ID: <20250715122544.1943403-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series cleans up the xfs_trans_alloc* and xfs_trans_reserve*
interfaces by keeping different code paths more separate and thus
removing redundant arguments and error returns.

A git tree is also available here:

    git://git.infradead.org/users/hch/xfs.git xfs-trans-cleanups

Gitweb:

    https://git.infradead.org/?p=users/hch/xfs.git;a=shortlog;h=refs/heads/xfs-trans-cleanups

Diffstat:
 libxfs/xfs_refcount.c |    4 -
 scrub/common.c        |    7 +
 scrub/common.h        |    2 
 scrub/dir_repair.c    |    8 --
 scrub/fscounters.c    |    3 
 scrub/metapath.c      |    4 -
 scrub/nlinks.c        |    8 --
 scrub/nlinks_repair.c |    4 -
 scrub/parent_repair.c |   12 ---
 scrub/quotacheck.c    |    4 -
 scrub/repair.c        |   16 ----
 scrub/repair.h        |    4 -
 scrub/rmap_repair.c   |    9 --
 scrub/rtrmap_repair.c |    9 --
 scrub/scrub.c         |    5 -
 xfs_attr_item.c       |    5 -
 xfs_discard.c         |   12 ---
 xfs_fsmap.c           |    4 -
 xfs_icache.c          |    5 -
 xfs_inode.c           |    5 -
 xfs_itable.c          |   18 ----
 xfs_iwalk.c           |   11 --
 xfs_log.c             |    6 -
 xfs_log_priv.h        |    4 -
 xfs_notify_failure.c  |    5 -
 xfs_qm.c              |   10 --
 xfs_rtalloc.c         |   13 ---
 xfs_trans.c           |  196 +++++++++++++++++++++++---------------------------
 xfs_trans.h           |    3 
 xfs_zone_gc.c         |    5 -
 30 files changed, 147 insertions(+), 254 deletions(-)
