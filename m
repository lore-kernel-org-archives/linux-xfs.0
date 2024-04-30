Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46ABF171672
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481767; cv=none; b=fZNfj6SBNX2AeV9V6ywH1us+3S9XIYfqafyJRfZLsvCLd6i/l3cFYUKx2TGTFofGImHcpqsxx+cwDwJHGFPsJPnDs4gQkqMbr4kxvCAaAI/Zhc52071Czo6i/8lCTq1x4Tl2ZT7qq8c0BMyyL6qvTGB3PGASfZp7iGAxXLOPvKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481767; c=relaxed/simple;
	bh=cr+H9GosGEmKp/7uOBqQEyN791enorrnCy7o651NFkU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZYpxoSZXcxY8deerflokgB4E7xSNC1zq7w7AGW6thR8xHUQMWScyLYZr5QU0nGCvZeCqsw0z4ZPf7CthKOLhKofUqWHFoc3iC/hFRdOqAlSscQ5DlFi9LYeTUiFg0Y1V05Qtv6BvfVAtIaulDdu5LJGMBAWuqMID/8aPO80gm2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oy3vJLDj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oy3vJLDj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=U/WlF7fpb5/kIbe1/Sg2VEsVkGXb5tRm/pLw3WCLUBw=; b=oy3vJLDjmRO6GhRUg+OzVD8wH7
	Oo54frAqzjtG632JYYkkdHBVckRtzHcVy3XGd6rF7v00WDVecu32zl1ftb6TYFMDWdIezOjVfydso
	uH7BTe2OwD/oiQmd6Nn5/iCKRmkasfKlssU29nZjCOojPHBTDhuiEoenTB38sx5RwCZV5kwbtt9QA
	1/ujAUhGLyvKiU9ByF2QYjp0HTEhJwqDGafrdlGmIWhkLC2swkKIYnlzj9bWM0u40dps1+GQJ616h
	W4k1TBemsKB66YBd7eb0hPkcMNaXZkOyAGMLqoT+qUnG4PK/VC2Cp0R0dbKOhBF5em0t4EdG12U4h
	vMHPbtrw==;
Received: from [2001:4bb8:188:7ba8:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1n1g-00000006P4J-3nPf;
	Tue, 30 Apr 2024 12:56:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: iext handling fixes and cleanup
Date: Tue, 30 Apr 2024 14:55:59 +0200
Message-Id: <20240430125602.1776108-1-hch@lst.de>
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

this series fixes two unlikely to hit iext handling bugs in
xfs_reflink_end_cow and then cleanups up the iext count updgrade
handling.

It has been split from a larger series that needs more work.

Diffstat:
 libxfs/xfs_attr.c       |    5 ----
 libxfs/xfs_bmap.c       |    5 ----
 libxfs/xfs_inode_fork.c |   57 +++++++++++++++++++++---------------------------
 libxfs/xfs_inode_fork.h |    6 +----
 xfs_bmap_item.c         |    4 ---
 xfs_bmap_util.c         |   24 ++++----------------
 xfs_dquot.c             |    5 ----
 xfs_iomap.c             |    9 +------
 xfs_reflink.c           |   23 +++++--------------
 xfs_rtalloc.c           |    5 ----
 10 files changed, 45 insertions(+), 98 deletions(-)
