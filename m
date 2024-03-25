Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A48E14F9CC
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 02:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711333459; cv=none; b=Xd12rhQpk3vr6cmP0XnvYb9xp6Z52r+XXgi2A4emVSY85DLJFm7M8+SHtKdKfbeHPvKE0zA1xL+KeyXKJxp4IJgGVkJ49v3mnsoi39lB5uGBOGCWxXQ2uj48/uLWdlKkQFSjsslyq6c4j/M/Q7f2b7uV+Mpe1oXsABQqrQvK8x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711333459; c=relaxed/simple;
	bh=ZtfAnMwm+T6KXxab9UcIbO4h3toNntyAT7NvQhxooMw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pjpIKwDgizyIRgAwqDjWYE94ni4pZ3wmr/wDwLzuXg3jMc+j4fEYQToUNhKOP7Dmr/3/lbT8oN8Yzv+YGJwZJ6/PSK/NXGkZtDjlbzXhgy9JlXDYRDS2Q+cRbvbJylXoJf/HU6RErvPTmGaq+x8S4okYxDSLOHhHh0jImZIECIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Nj22hyp0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Nj22hyp0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=ipwBWF9GvJgqnNquJGrCFcF/nSxKqDtXCjhGKgoj01M=; b=Nj22hyp0vlC6du8OhdmbhFHMxy
	JunIRm7DRVdisNEnjZ5xiLagISSW6W7SEhWOL+lNB/zr7KA7ZBje3YKP0CVfiAaxSd/rnSgDsJ5Iv
	B1xwJn/RervipoliFPLrOSzW+apsR2VonPVO+k0gtnfXsKR8FiXQCFa+xzv02qSDleSv0c12uiBEq
	sNnMUJ51JTFEjLO9h7Q3+iplJJCoz/8EQ7nlLz2YhqtKPSr7YUtlwnwgP70wWbb4+VsM4hNF8udLX
	O4JU3A1oqOzM4wLszT5asb5mqm5oY/BFTf5DNd7yPzOK7EtGlt/knHvm6eZtk8lDmUGmhHdgRzd0f
	1Vh/e18w==;
Received: from [210.13.83.2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1roa0W-0000000EeNp-3YQZ;
	Mon, 25 Mar 2024 02:24:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: bring back RT delalloc support v4
Date: Mon, 25 Mar 2024 10:24:00 +0800
Message-Id: <20240325022411.2045794-1-hch@lst.de>
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
to files, and improves fragmentation for larger writes.  On other
workloads it sometimes shows small performance improvements or flat
performance.

Changes since v3:
 - fix a bug in splitting RT delalloc reservations
 - fix online repair of RT delalloc fscounters
 - adjust the freespace counter refactoing to play nicer with an
   upcoming series of mine

Changes since v3:
 - drop gratuitous changes to xfs_mod_freecounter/xfs_add_freecounter
   that caused a warning to be logged when it shouldn't.
 - track delalloc rtextents instead of rtblocks in xfs_mount
 - fix commit message spelling an typos
 
Changes since v2:
 - keep casting to int64_t for xfs_mod_delalloc
 - add a patch to clarify and assert that the block delta in
   xfs_trans_unreserve_and_mod_sb can only be positive

Diffstat:
 libxfs/xfs_ag.c           |    4 -
 libxfs/xfs_ag_resv.c      |   24 ++-------
 libxfs/xfs_ag_resv.h      |    2 
 libxfs/xfs_alloc.c        |    4 -
 libxfs/xfs_bmap.c         |  118 ++++++++++++++++++++++------------------------
 libxfs/xfs_rtbitmap.c     |   14 +++++
 libxfs/xfs_shared.h       |    6 +-
 scrub/fscounters.c        |    8 ++-
 scrub/fscounters.h        |    1 
 scrub/fscounters_repair.c |    3 -
 scrub/repair.c            |    5 -
 xfs_fsops.c               |   29 +++--------
 xfs_fsops.h               |    2 
 xfs_inode.c               |    3 -
 xfs_iomap.c               |   44 +++++++++++------
 xfs_iops.c                |    2 
 xfs_mount.c               |   85 +++++++++++++++++++--------------
 xfs_mount.h               |   36 ++++++++++----
 xfs_rtalloc.c             |    2 
 xfs_super.c               |   17 ++++--
 xfs_trace.h               |    1 
 xfs_trans.c               |   63 ++++++++++++------------
 22 files changed, 260 insertions(+), 213 deletions(-)
