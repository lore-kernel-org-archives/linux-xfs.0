Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BBC13CABC
	for <linux-xfs@vger.kernel.org>; Tue,  3 Sep 2024 04:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725337715; cv=none; b=ndCfIGEjeqeL/z/fv7TkifAzkgsH67SSbNCBbJBJgM8NugTOQUffiVhtT/9GW45r7t+DvuxTwLWyl7J5UCfJ5YvAetxyptCgJ7mWA1L6ILiJX/xL8oeOF+jaf5XwQyVx8WLJAWcW2gMW9NecakrFcUref8Z1C2axrEOdjDZx0FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725337715; c=relaxed/simple;
	bh=/LLSeENJhOJUYfstdsQZOiGbusTsRcnHZ6WkeScd+LU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JZfkawJxRiiIUSoMzLAr7soyW3jbs/riVPIlAd6eUcQdOzCyTu86LtQM3F5cVPVvw/Nv8NBsfWak+hYCnSDzm6IOQKMn9FrYOBVbrXELCWCzoiz2xCe2xje6yNzcyCKf4OHwXRSHzz7vuptCo0pbt58OR3u4T5g7+D295RIryB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=X5bPUPRH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X5bPUPRH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=EcTYvvY9C0QDsb3sD1WTUfOWKXIq/i9GKetmxP3fec0=; b=X5bPUPRHwTfpTqAtF1QsVEnmOy
	9GIYvk7PFHv44Y67i1mmmsexRH2e3c9sCSLcDdIsRUaaebklxO/qiqA88ZyYiDP9k437WTZG7Ekgk
	co/B705PBgqun/jLED1z9WmXhVl6Noqb7g1z0ORcd0/4SyQcn+smckUYE+vLY/fGyoxnRj48YQrR0
	vSXnlPKsBhtBeYWpvQFlOOV+/5p5RTDiY2BPpP9FhcnCe38clgotUkzMBNZ3/ySZXMoZrcwP3dtd3
	7JS6u5PgtPEqDk9r6+vc1aZFcQUkpyZbRjtyMfZh5fqwE6HZG/ZfsNB0kU4kudlr2ARjvxJHoWxU2
	pVvHJbpA==;
Received: from ppp-2-84-49-240.home.otenet.gr ([2.84.49.240] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1slL9Z-0000000GI4o-11Yk;
	Tue, 03 Sep 2024 04:28:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: fix a DEBUG-only assert failure in xfs/538 v3
Date: Tue,  3 Sep 2024 07:27:42 +0300
Message-ID: <20240903042825.2700365-1-hch@lst.de>
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

when testing with very small rtgroups I've seen relatively frequent
failures in xfs/538 where an assert about the da block type triggers
that should be entirely impossible to trigger by the expected code
flow.

It turns out for this two things had to come together:  a bug in the
attr code to uses ENOSPC to signal a condition that is not related
to run out free blocks, but which can also be triggered when we
actually run out of free blocks, and a debug in the DEBUG only
xfs_bmap_exact_minlen_extent_alloc allocator trigger only by the
specific error injection used in this and a few other tests.

This series tries to fix both issues and clean up the surrounding
code a bit to make it more obvious.

Changes since v2:
 - add back a missing -ENOSPC return from xfs_attr_node_try_addname
 - add another patch to fix potential -ENOSPC confusing from
   xfs_attr_node_try_addname

Changes since v1:
 - fix build for !DEBUG builds
 - improve a comment
 - fix a comment typo

Diffstat;
 xfs_attr.c      |  190 +++++++++++++++++++++++---------------------------------
 xfs_attr_leaf.c |   40 ++++++-----
 xfs_attr_leaf.h |    2 
 xfs_bmap.c      |  134 ++++++++++++---------------------------
 xfs_da_btree.c  |    5 -
 5 files changed, 151 insertions(+), 220 deletions(-)
