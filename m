Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9765639E196
	for <linux-xfs@vger.kernel.org>; Tue, 24 Feb 2026 13:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771941593; cv=none; b=nKLgFMqcYUjmKw7V61G+8jix76QALe9OQ30UsP+c1QePxLGZg1T6ATxiV0q3cYwc8ksf53Xhjn80uW1+W2cHNUDcOFijLVO5bFAMjYPEcXZe1Edgm8utH/3pKOxGJP5StwF8On21rIAdFFaU9cMFbk6B2UcNWR0jsyhAxcGZBBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771941593; c=relaxed/simple;
	bh=jVlObTSDe43jbwLZe5tm2RcGqDDIAd9SmSjgdVofDdw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V4wvjBeTJLsTLClEjjlYrmMwVpJhvuBqGQV+YK7W7JNKxN5/kdCX/oM1iKQWN2TlyWKI6RF/p2sb+0tcef2r6ILDLZqthTxqKBeBCOCAvqYxe96MzdLqET4VtQGM1pHF4pVSGnw1KJXZsJ4mRrerBDXSkuKN1nzWFo7KzmBRpWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DIt+vpkD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DIt+vpkD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=w7KYe5hws4MlaJCybyvqmF/kaneN0RBsgqTgeWP+YyA=; b=DIt+vpkD0gLmx1y1YuvX5LOslA
	eAYwUUg690X5a+GZfrMAo5asTEKyTq9kW1CdWvZ6zbB6GaU3LtVuzzRLnGEx5YgzefGiSTzyO1+DN
	PFCgLMMFbmjRBHrmTEiVutI/W/dFUsmcQkNvtbi31as/NdogXh9SdRqdd2Jk3C0shxJufinGgzgkH
	QpbYQspIqGKaMQTWKvh1o8nMXZa3udnFxgB/wHVcp8WEP4vDEI5vJrdvsW+XGhX/Z8UZEIlBQzzqf
	tSeenUqn0EznLKds8S1bFJ2C/Eu9lkf0vCjm3rjAUPnWXw9ktrBkZQ3+/mzMEGTRSWgZGc+5Yb57G
	y1a8GgFA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vusww-00000002AlY-3yeJ;
	Tue, 24 Feb 2026 13:59:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: fix inode stats with lots of metafiles v2
Date: Tue, 24 Feb 2026 05:59:34 -0800
Message-ID: <20260224135942.364932-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

the second patch fixes the active inode/vnode count on file systems with
lots of metafiles, i.e. on SMR hard disks.

The first patch cleans up the counters a bit to prepare for that.

Changes since v1:
 - fix a commit message spelling error

Subject:
 libxfs/xfs_inode_buf.c |    4 ++++
 libxfs/xfs_metafile.c  |    5 +++++
 xfs_icache.c           |    9 ++++++---
 xfs_stats.c            |   17 +++++++++++------
 xfs_stats.h            |   19 ++++++++++---------
 xfs_super.c            |    4 ++--
 6 files changed, 38 insertions(+), 20 deletions(-)
