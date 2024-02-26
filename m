Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5E854279
	for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 10:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708941867; cv=none; b=m4Qh8RvPFOBWhYHX1vdyZQn5O0tuWxzu5OYYWdBwDSkaODFruGhIOLAsFgQfgCsgBm7kL9OC9lw9NdUOXB3wcgKwyDZ59cD9bQYtwsQGS96pA+wX8AvCVYw50rwHMoFs2BMCZbL0snozQyS+pFytWwvMz4gqpvqgizb8kc29ArM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708941867; c=relaxed/simple;
	bh=KchEjYc5tFjpvq7Nt9OPUWxmmCFek7MJxwMwriyb5wk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TU7apNF7n68R6yES7yQeuqnus1I/7CfHcplPnZ5LVJrRqG52pJIWOHbIaofsF00xq/OfZAZlK3j+CoI0Xtt6a4NHxbvLkcz8OplZnkAwSel+qnQs+J5Ng6c5/XEqpIl5bXglK3hQXLX/qKbRQQ9xt7K/lLIdEa39iwucTfJt31A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xK47P4nI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xK47P4nI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=BroN5QImKjR2vhvtPcRFr2btY1obuQsNAJstrjDK2Dk=; b=xK47P4nIuvVgkaTA84IKaRq1Q0
	B2GP9snPFo2td406vzhxgqNPgyr9URViofXLkBeqRM5vnoxizZ1mjDFFinuNwGqjR+j/p4mgNsEPk
	IGvIyHRk1KjROcg/pQ1xminDkCavf1X2twjDis3KwvB3vWAyo3Ds+F8pAKnwTF0tHR90f//38atod
	BRanMCwgBHiaCu26i7lwhU1N9ZyP+66JKna9Ka+6H+lrXtlmdFEElps87ExD/LMSf8pJa760Jmagm
	upgdb4hyHulVDgX3/0rakvr6F+xpxd0aC/OBkzFFMPbWZb3ElVmc4plrYJMpiQL1JcO8sTOGGrAsy
	7OYNI+fw==;
Received: from 213-147-167-65.nat.highway.webapn.at ([213.147.167.65] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reXqS-0000000HWoh-1rSt;
	Mon, 26 Feb 2024 10:04:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: bring back RT delalloc support v3
Date: Mon, 26 Feb 2024 11:04:10 +0100
Message-Id: <20240226100420.280408-1-hch@lst.de>
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
 - drop gratuitous changes to xfs_mod_freecounter/xfs_add_freecounter
   that caused a warning to be logged when it shouldn't.
 - track delalloc rtextents instead of rtblocks in xfs_mount
 - fix commit message spelling an typos
 
Changes since v2:
 - keep casting to int64_t for xfs_mod_delalloc
 - add a patch to clarify and assert that the block delta in
   xfs_trans_unreserve_and_mod_sb can only be positive

Diffstat:
 libxfs/xfs_ag.c       |    4 -
 libxfs/xfs_ag_resv.c  |   24 ++---------
 libxfs/xfs_ag_resv.h  |    2 
 libxfs/xfs_alloc.c    |    4 -
 libxfs/xfs_bmap.c     |  102 ++++++++++++++++++++++++++++++--------------------
 libxfs/xfs_rtbitmap.c |   14 ++++++
 libxfs/xfs_shared.h   |    6 +-
 scrub/fscounters.c    |    4 +
 scrub/repair.c        |    5 --
 xfs_fsops.c           |   29 +++-----------
 xfs_fsops.h           |    2 
 xfs_inode.c           |    3 -
 xfs_iomap.c           |   44 ++++++++++++++-------
 xfs_iops.c            |    2 
 xfs_mount.c           |   74 +++++++++++++++++++-----------------
 xfs_mount.h           |   41 ++++++++++++++++----
 xfs_rtalloc.c         |    2 
 xfs_super.c           |   17 +++++---
 xfs_trace.h           |    1 
 xfs_trans.c           |   63 ++++++++++++++++--------------
 20 files changed, 255 insertions(+), 188 deletions(-)
