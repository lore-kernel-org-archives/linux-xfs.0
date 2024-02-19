Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804701E53A
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 06:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708324486; cv=none; b=GRUZSG9l5hHgK0pqaF23kebKTVETaSKi6f2H1osp8qonp1iut6zRmMCzx/+kP6Cmjb86PCs8gVF49BD7YgyNyR4GsoJzooitS6yEfdEyDk6XJOz1l+0yLsMbJwPBqZJnRgjaR/bsUukv6/jYgWlJv07MYQRORKOLWMBDvqRFRfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708324486; c=relaxed/simple;
	bh=+MrNAU4++13/GvNLFgcKpyHUopLakVXyfNY1CABA3zs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sb4iIrHQmwWGLeC9SZ/E9aqZ4Om/hxdV3ZhAQBgtWWYigwbtlMdvi/fW9EMf1IEz6Sqb80jlPBy1sIMrbMWk9aSD3yADWge4CWhRiDBPWpWJ7i+tWq05jDvykHOBqaAfplRPJNhZ6UhLVfxskxsx02DMFvfuYFNZqecpTBglH4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wNW8dqtn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wNW8dqtn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=QTQdrve9/vBE1vaKJFUZV7PamRfjxE6Ibmix3yJ5tto=; b=wNW8dqtnk7ntrWsiQ7/dlbpQkv
	nAlwo2u0zDi76zSqeig4oecgBcKP70os4pKh9uAGwrjRnkWcnxC8pse1bbpMuW9w8drEPci8eR7O7
	5q12PCQQUR2LTi/5/LcNOggUy1iR1u+WHo4OoYNgMYvDFG1yAEnFPGle+YXGI1lXm6b3P8mwVgeZD
	NSonrE10co8dkERmYzuDcNlmypGvwYflPUYn6ODPDC0mwDY6gwNpAyc+XVdGY1f8SNaPe9hY9OmFC
	NtvnVznSCoCxbxtJHvQiKpJMkdUQVXkMmBsbzQSZLO8r44KemhctR21PkI2Mr3ziYY5M5yrccTCUr
	bzml5MBg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbxEi-00000009GJf-2u8A;
	Mon, 19 Feb 2024 06:34:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: bring back RT delalloc support
Date: Mon, 19 Feb 2024 07:34:41 +0100
Message-Id: <20240219063450.3032254-1-hch@lst.de>
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

this series adds back delalloc support for RT inodes, at least if the RT
extent size is a single file system block.  This shows really nice
performance improvements for workloads that frequently rewrite or append
to files, and improves fragmentation for larger writes.  On other workloads
it sometimes shows small performance improvements or flat performance.

Diffstat:
 libxfs/xfs_ag.c       |    4 -
 libxfs/xfs_ag_resv.c  |   24 ++--------
 libxfs/xfs_ag_resv.h  |    2 
 libxfs/xfs_alloc.c    |    4 -
 libxfs/xfs_bmap.c     |  102 ++++++++++++++++++++++++++-----------------
 libxfs/xfs_rtbitmap.c |   14 +++++
 libxfs/xfs_shared.h   |    6 +-
 scrub/fscounters.c    |    5 +-
 scrub/repair.c        |    5 --
 xfs_fsops.c           |   29 +++---------
 xfs_fsops.h           |    2 
 xfs_inode.c           |    3 -
 xfs_iomap.c           |   44 ++++++++++++------
 xfs_iops.c            |    2 
 xfs_mount.c           |  117 +++++++++++++++++++++++++-------------------------
 xfs_mount.h           |   41 ++++++++++++++---
 xfs_rtalloc.c         |    2 
 xfs_super.c           |   17 ++++---
 xfs_trace.h           |    1 
 xfs_trans.c           |   25 +++-------
 20 files changed, 252 insertions(+), 197 deletions(-)
