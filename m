Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9D93DAC11
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 07:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711609381; cv=none; b=eqCPN4jjbEfxh7eVM6d9k+uGJZMJr9HntwwQJJbbkJvVqMZvbX44JrkHko0GBRUmkpRiqb5srwKJbsNcUoO4X2oqWSsv9NgsGJmuBE+x4wIcIqFjsFGZy9XCxK8K5nMLR8LysGChZTIEOOGjgLAfH2LrDdbx3BOEIZN1vPly3bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711609381; c=relaxed/simple;
	bh=/I7hNsfpEfuqciWi+Ykr8bWFmcn+mC2nz2pRUCrYi6I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ka3lEsWPcikIXj+h/bVB4ZSsulbB13Nu/ClwMA5Nyq42ajWIA8N90G47f6ZTIBOKf5wcSDwfCvBYZJ+bx4Tf64YuW5kL+tKNhZgqO4wMWiCe3c01beKpnBejDjde/OYPp4hv7oWhngv27PurcKNPWQ2c5CXnlBqKp/Vo1zPdBjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EfS+2hCx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EfS+2hCx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=dwa4tFlWwGpYkalif4jby1KmLG8VtkmRrs28uOpH0ro=; b=EfS+2hCxuxoNiBTkYSG9Eo4rrU
	ozvcGcvK46WExX/a//nZXwQCe+oOR5KaPZb26pOusVUY/g48ZnSYfY3+enDDpcFFdszt1jBxN2I/A
	2hXNf52b8u1qQX1MOwi5j3CLUeTO6DrLcrYBTwwR/c/I7v4jueOj7whZlJvwc3xL0NlEy45W1Etai
	pDN9qXWNj4aHDaxdoY2zbV9gR+Nn4Ztp17nkEY/La5Y+Pm82HnkuRXOvurDozUtdlIPX+aBu02+ZO
	TizSAxhwU8AJUfClv5XhY+cpVgK800zm7koH7RNogiOEPBwwUVrjIa8KlYmLLJlcUGPKaXj1IQdTF
	6oXQBpDg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpjmt-0000000Cneq-0uJj;
	Thu, 28 Mar 2024 07:02:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: RFC: optimize COW end I/O remapping
Date: Thu, 28 Mar 2024 08:02:50 +0100
Message-Id: <20240328070256.2918605-1-hch@lst.de>
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

Note that this conflicts with both Darrick's repair work and my
RT delalloc series, so it will need a rebase after those are merged.

Diffstat:
 libxfs/xfs_attr.c       |    5 -
 libxfs/xfs_bmap.c       |   21 ++-----
 libxfs/xfs_bmap.h       |    2 
 libxfs/xfs_inode_fork.c |   62 +++++++++-----------
 libxfs/xfs_inode_fork.h |    4 -
 xfs_aops.c              |    6 --
 xfs_bmap_item.c         |    4 -
 xfs_bmap_util.c         |   33 ++---------
 xfs_bmap_util.h         |    2 
 xfs_dquot.c             |    5 -
 xfs_iomap.c             |   13 +---
 xfs_quota.h             |   21 ++-----
 xfs_reflink.c           |  144 ++++++++++++++++++++++++------------------------
 xfs_rtalloc.c           |    5 -
 14 files changed, 137 insertions(+), 190 deletions(-)
