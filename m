Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD1A1465A8
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 11:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713784826; cv=none; b=Xwn61nz1E3ouJMg+KgcH+hPwaleRXSp+mMdJ3Utr+aP2tyKyt8XrT6LAcbGV9rxZa8zwodigVMSeYE/rLLWyypp0kohxKsbO7HtW3hWv04rLB2FcCtuHQmPBZMczXvXTor+6s9ewad2LmVzQIY6Z7qFHhVBPvUF353+hO4xQWD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713784826; c=relaxed/simple;
	bh=wOYbc5N/q+FQSrvxYEn661gAyH0dr7dP4mkFMHd14fM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kYZU2IExVD4djLSRmbdqrnlXRY6O6GWiyjysNts1jN9+AbkUmezixLk4ZhgnTnRjrcSOvvnquHObhmZeoINck4gbIi4CeN44m6HjgkdfiRu+iihzUht3zii/uwaFZAhqDzjyZxT4Ah6PX+705lHp/KUgF5U4sCppHToxR7logVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nHVAP14N; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nHVAP14N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=ZJkvAY9Yc+0zCf2Z+of+IQ9e+xfMBVQx5uVl1S3N+Aw=; b=nHVAP14NQkU9pGuIoHJ5xIpvsv
	4UfbLPirGIuPRAD2iX6i76xWzW6AqhM9VJ+5Iwt3cR07xUGK7jjVDMDkKpyhKPI70YBrYH/17WlxF
	/h85Cx4nEyM4UGNhS28hxJtPaTKeMnFcCbWojht4LfNiXLrvJKdVJ7TelCFT9wYe7bo0J6J4eRSQJ
	dTBZ8NI5nOLyioYjTm/DDIme1Gbd1c+F97VUcXvV+2HUWmgHi4+/yq4jv4Vzl3u2Tc/DGl5NwHi7d
	+wMMzOwLxMMW7EQSspBrWT8Um7ZaePEPlZvDmEDGcwWbuM3qe41xrXvdLrQFyAsXWE0gNdoB6lAIB
	Yg92KZfQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ryrih-0000000DKuw-2tN9;
	Mon, 22 Apr 2024 11:20:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: bring back RT delalloc support v6
Date: Mon, 22 Apr 2024 13:20:06 +0200
Message-Id: <20240422112019.212467-1-hch@lst.de>
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

Changes since v5:
 - rebased to current xfs for-next (aka fixed a trival conflict due to
   two #include statements added in the same place)

Changes since v4:
 - fix a bug in the fix for splitting RT delalloc reservations
 - rework where rtbitmap locking happens in the bunmapi patch to
   avoid churn with a series in development, stealing a patch from
   Darrick's giant patch queue in the process

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
 libxfs/xfs_ag_resv.c      |   24 +------
 libxfs/xfs_ag_resv.h      |    2 
 libxfs/xfs_alloc.c        |    4 -
 libxfs/xfs_bmap.c         |  152 ++++++++++++++++++++++------------------------
 libxfs/xfs_rtbitmap.c     |   57 +++++++++++++++++
 libxfs/xfs_rtbitmap.h     |   17 +++++
 libxfs/xfs_shared.h       |    6 +
 scrub/common.c            |    1 
 scrub/fscounters.c        |   12 ++-
 scrub/fscounters.h        |    1 
 scrub/fscounters_repair.c |    3 
 scrub/repair.c            |    5 -
 xfs_fsmap.c               |    4 -
 xfs_fsops.c               |   29 ++------
 xfs_fsops.h               |    2 
 xfs_inode.c               |    3 
 xfs_iomap.c               |   44 +++++++++----
 xfs_iops.c                |    2 
 xfs_mount.c               |   85 +++++++++++++++----------
 xfs_mount.h               |   36 ++++++++--
 xfs_rtalloc.c             |   22 ++----
 xfs_super.c               |   17 +++--
 xfs_trace.h               |    1 
 xfs_trans.c               |   63 +++++++++----------
 25 files changed, 348 insertions(+), 248 deletions(-)
