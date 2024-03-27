Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65175535BE
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 11:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711537405; cv=none; b=mlbvzfzt/vc5l1VXEU5tD7ZRPbFGZ9j1N6nVYWB0K6/Mdaun5hddYon+T0J8ErGBSFu68PXMJQYfoNm1S9KCYCu8CFMnlAfYt+eWClV5z0cj1H1KaMf8AokmCmLAhsXmWbm/YZ9HOWpsAjBI2q9g5WkfQKuyEdSkL/Bldji2kzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711537405; c=relaxed/simple;
	bh=fweOrhi5o4u3Y32FZzY06Fc+q87FHj2US2TtsuYNTLU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WVHG+vnH59p8d/XlC5CR4mViky5NOoCyKaFueDVQe5mEa4fznHBbGGI3edbMqrXJZmNBVZ+jlSes4OaApVlJh43fIIB3GDE1nPytfjAZgqrrUTu6UpdVQTzHRbHeCFO712UeJs42zPtsBPW6yFuLK9+ur1MLTxnBMnDTnnE4tAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1aV52Iwc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1aV52Iwc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=EFKlzEaYSs8G83Z6rvXsqaSK+q6qY2BGBF619G567Xg=; b=1aV52IwcFoZZOhwOq89WMLVmq2
	1uB7P+OwNBaF+QzqlXu9Vvi+aNg6Ns4kdF5UmdshvxYPAWDPZ5bFqSqli5t15REED9xhaPpkVTEd3
	Ic6ylrNjWeYRwBef8HGsYYOpALrFtBgU2ZRzVSKfFOQ5oB96gxByss/Gia0suLG/hvSauMySB8wep
	k1zfIvezMwg3s9cnS58MIePSLZ9SYM0mUz815saFOhgzlV7N1D590MYqyJ850rj05ggSjPTvdQkSQ
	M8eLI98ShkKGFlPGNZjkLxmpi9cgC/bJ2O7AJAVo2iDnNjTgngLgnBjfVO2LG6pXzvcg/VJNASFnv
	/LQr1wrg==;
Received: from [89.144.223.137] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpR3x-00000008WSE-2ni1;
	Wed, 27 Mar 2024 11:03:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: bring back RT delalloc support v5
Date: Wed, 27 Mar 2024 12:03:05 +0100
Message-Id: <20240327110318.2776850-1-hch@lst.de>
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
