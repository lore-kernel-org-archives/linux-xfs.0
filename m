Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1CE22B584
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866376; cv=none; b=PktmhzE+Nya7TrX4xGpzpbjq/SJiHrkC7TracEL1Vpkd0qc1MMjhdZm+7xtxDnHqu0wX22U/yZJFqnclLq8RBv5CeoDhLJcjnyqm2+GSu36untpudJCDhy7EdzX8pA/ShdwuBHD/1TOJzmnx55eI3mkuVQVH+BPAQjD34CVUpnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866376; c=relaxed/simple;
	bh=4k58kD67nZvC2dmdEKeXXx4m6ifY2FvzapN63EAU80U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avhZGj/j/XKyKCaSuoFxkPR8Gw0G3Y1V3voLOJGcNva9Wm1rgAAsDMjC/LPLP7VEG2KVs2645pgXnija7V9eRI6sv06VUrQPkoMKZEPVVQTk6HN2ypYf3zFrVwPPjyuE+hf2NfRgKMGSMf3O49jx0uFem2VIO6A9b3hENnsZaTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zBSYWUg6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zBSYWUg6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nDMKuLKHDFqGDB4I12oNhDo6qyA124YPibheK11TMGw=; b=zBSYWUg6vXE2EOQqrV972qbdmO
	/956XvTRK4XQkIOVIgS/BRuwDSFfc/vr58ZfePZY47q6aEu87UnAP7bamR1sE6LpbN7WmKNJynwxd
	gub+09Cv47wBAr8sy0vEiUOTGhjvbnIGFpKFnC0YxEab80+mupbNY5tPCfwurE7jx749Oa4Ces7JP
	eLX6GHI7r0VqmOoHEJUhtZ13ugcnawYIp+IvqLauO9bNimvPKl863mPEceBRxWnvkUZF3M6xiG+vD
	JrfHBHHNHZsSpNWC8pwHFtoFK+HmtBNvZMKdTVJqIZ+X3WON2fGPDyxr8r2s1rfqRLjaLapu6ABsl
	NNZw2PZg==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkIis-00000007CYY-0yDl;
	Tue, 18 Feb 2025 08:12:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 22/45] xfs: skip zoned RT inodes in xfs_inodegc_want_queue_rt_file
Date: Tue, 18 Feb 2025 09:10:25 +0100
Message-ID: <20250218081153.3889537-23-hch@lst.de>
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

The zoned allocator never performs speculative preallocations, so don't
bother queueing up zoned inodes here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index c9ded501e89b..2f53ca7e12d4 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -2073,7 +2073,7 @@ xfs_inodegc_want_queue_rt_file(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 
-	if (!XFS_IS_REALTIME_INODE(ip))
+	if (!XFS_IS_REALTIME_INODE(ip) || xfs_has_zoned(mp))
 		return false;
 
 	if (xfs_compare_freecounter(mp, XC_FREE_RTEXTENTS,
-- 
2.45.2

