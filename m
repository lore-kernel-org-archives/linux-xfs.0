Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601FF22B59B
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866339; cv=none; b=hzv3Rn+gaGk+QiM9w95Hn0eYtJkLc7I3Gfi3XJAe+rMfW8LrAIhDFaCRi/gpoBHMBE//ow/dqS7ulvHS6t4A3cgw6vTcYQkQeakD0yyqtS678uP2+I9rCOeYfm3d/8xFNQxaY3cIZvXAXLVYufXpHx3RMXM6FrvEStrtlqk5wKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866339; c=relaxed/simple;
	bh=V0V99rj7tDsJHT/BGLYR0qsu++nl4CRh9h8Dhe0u7/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBfOqGcdHVPtX9ZkoBt1QCgrjn2j67jnomudOofkuYkKwc8dZCQ6lhxot4ccRmLoeO5xJEQtOzjtr36LOl7zwvNXw7t2FxjKc8OqrwwGiaXYgMpdCvgDbDdoFGaLD4pjTSy7hDF7gnd4+sVW6w0NkBg/hRHMOhdz7v6IG27HR3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ID/DVenB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ID/DVenB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QCYVeYoS0d39fTzsKVjJggX73WYo+AoJS3AWTEAryx8=; b=ID/DVenBiOviEDURnuZGDV29w1
	Qa8WuWI7WMMp2ikMpP4xGI+C8vhOuJ10M48A2jx2AKImVbg12ZUX1QlN1MQr1+bti0QsSVFUBz2yn
	yzzcLIKxrwyL4lrPsCn6u7brqGj/X0UugsaKrKQrCxtXENWqFy7f1GPmg8oxjOvELemIe0ph99Nnu
	R0kDpOiRliNSkM1+GZKEgiIgK671DmWi9ulbV749oFcHhzhQQ19W+4OWS5LFccdon3jH8X2L8VxVx
	Mf+anbiAwfFl5+mNZDCSSevGC7oGJN5rkoJ61E84uvC++kIFLtt1F3nCZ9kHJJsRdRGd4vaZ0iaAy
	UNk2BYUQ==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkIiH-00000007CLk-2dGz;
	Tue, 18 Feb 2025 08:12:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 08/45] xfs: reduce metafile reservations
Date: Tue, 18 Feb 2025 09:10:11 +0100
Message-ID: <20250218081153.3889537-9-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250218081153.3889537-1-hch@lst.de>
References: <20250218081153.3889537-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

There is no point in reserving more space than actually available
on the data device for the worst case scenario that is unlikely to
happen.  Reserve at most 1/4th of the data device blocks, which is
still a heuristic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_metafile.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_metafile.c b/fs/xfs/libxfs/xfs_metafile.c
index 88f011750add..225923e463c4 100644
--- a/fs/xfs/libxfs/xfs_metafile.c
+++ b/fs/xfs/libxfs/xfs_metafile.c
@@ -260,6 +260,7 @@ xfs_metafile_resv_init(
 	struct xfs_rtgroup	*rtg = NULL;
 	xfs_filblks_t		used = 0, target = 0;
 	xfs_filblks_t		hidden_space;
+	xfs_rfsblock_t		dblocks_avail = mp->m_sb.sb_dblocks / 4;
 	int			error = 0;
 
 	if (!xfs_has_metadir(mp))
@@ -297,6 +298,8 @@ xfs_metafile_resv_init(
 	 */
 	if (used > target)
 		target = used;
+	else if (target > dblocks_avail)
+		target = dblocks_avail;
 	hidden_space = target - used;
 
 	error = xfs_dec_fdblocks(mp, hidden_space, true);
-- 
2.45.2

