Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A82D534
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 04:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714366164; cv=none; b=H9f206TOWvDTxobsu9/L2ggSlhYsIHs1ZD0lO/CqJDEKO0GBcs0D91gJYUeC+TkicFlEafAhdKT0I0jco6g7byQr7bWKafAzyerjtruHzKrERjYdGHAA8eno4xjAMukiM7PtxoZyr6IS3/Y6qpl4JyvUg7XBEHrnyqYZsyH0fKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714366164; c=relaxed/simple;
	bh=loljjbKFSf/GhGVwr8U2axzZdOO9Wo34Dk7SdoRD9o4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sZTYkJhLycZKO/43DcgVk0of3nXfC49fJ+0YVcY1S8iPXSq9DNVltgHmasjsebJimkbGdpdx8xLGhlqhvmYf09EG7SUMyZ/laMweokgl014myDTiE4DL+6w50WmJIl9ZO5iEFZgzZ592FG20+htIGhFiI3RwsVsMnIx5cvPTenI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=C6hi/pE7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C6hi/pE7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=hqB91MgFgxuo24PCNYPHwu5onX3fhGaDzdT2qcFC05g=; b=C6hi/pE7KBMTDrvVEiOgJ5PlGD
	Zy4Q/H9wxjGvpLG9N6M/4ygsZhCdMA1udKzGtGgGPKdwJV/JnFNs8ajakc65HLJjWSQjUR5CHmR9r
	J3QN60Q3zASLBzYndCr7lkyGBo+JFsHFlCzPgKBxP7QtuF8MuCqOok5LgT8fv2Pg8kzRLQKTDPPNf
	2ecrTWOZlkCqJN1WMeuyBHkstiPHZom2V9NQaWvHsXxoyUMqg4b6m0Hw27pjD1mSZPIcob0LRVLj4
	v0C9TEr4W8nw6Aut+qFTLRPi9QA+GQajYXUsGZkfg5XVfLnMied1tddnb+38o8bE2CAvx2asoZx9n
	VBipx/Cw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1Ix7-00000001S4R-0vlt;
	Mon, 29 Apr 2024 04:49:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: optimize COW end I/O remapping v2
Date: Mon, 29 Apr 2024 06:49:09 +0200
Message-Id: <20240429044917.1504566-1-hch@lst.de>
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

this series optimizes how we handle unmapping the old data fork
extents when finishing COW I/O.  To get there I also did a bunch
of cleanups for helpers called by this code.

Changes since v1:
 - remove the racy if_bytes in xfs_reflink_end_cow_extent enirely
 - pass an unsigned value to xfs_quota_unreserve_blkres
 - rename xfs_iext_count_upgrade to xfs_iext_count_ensure
 - only check for XFS_ERRTAG_REDUCE_MAX_IEXTENTS once in
   xfs_iext_count_ensure
 - roll the transaction after 128 EFIs
 - use a different name for the irec of the remapped extent in
   xfs_reflink_end_cow_extent

Diffstat:
 libxfs/xfs_attr.c       |    5 -
 libxfs/xfs_bmap.c       |   21 +-----
 libxfs/xfs_bmap.h       |    2 
 libxfs/xfs_inode_fork.c |   57 +++++++----------
 libxfs/xfs_inode_fork.h |    6 -
 libxfs/xfs_trans_resv.h |    7 ++
 scrub/newbt.c           |    2 
 scrub/reap.c            |    2 
 scrub/repair.h          |    8 --
 xfs_aops.c              |    6 -
 xfs_bmap_item.c         |    4 -
 xfs_bmap_util.c         |   33 ++-------
 xfs_bmap_util.h         |    2 
 xfs_dquot.c             |    5 -
 xfs_iomap.c             |   13 +--
 xfs_quota.h             |   23 ++----
 xfs_reflink.c           |  160 ++++++++++++++++++++++++++----------------------
 xfs_rtalloc.c           |    5 -
 18 files changed, 159 insertions(+), 202 deletions(-)
