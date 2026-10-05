Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB6C480357
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 12:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791205021; cv=none; b=N4ztKMJ3oVjHtv21tUlSOumSM479HNOJN1M5Qt7Lwb+/oRJIrdWSCOUpmS1B4Bm5zCIot/574VmpDYvYZk4vYPBQI1/vOvRHL/kHi+5dTlSXjmiAn/yjb/SKppPsbbW1/DEI38HMXryk7rXGGiA8ZJOSqCARvhSV+Th8yhFnp6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791205021; c=relaxed/simple;
	bh=H6GPgPKns9O/v848dXOJyPekJxp3GAGZA5Fw+Wmw3ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aa5wsnP4mqwIh9aQrYB7M0YnJm/G9MpixRvhRE640hfw/160VrX0kXt+J98CW4QWg0/uc2Dhd754WPObhq89rTcv8OGpnHcl7skvTW/CkrQ+nwJnmXKe7qjCY22iDRjfjLSRV35TImghRUq9quhX4lWDeanQzwY0Qu7slTWSMkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zm6TLHOH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zm6TLHOH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cGkghryYJCjAQEQ/ahfrCdX+PpPsvxx+24uvIwWrXZ4=; b=zm6TLHOH/zByUVOenn8ysDDyNb
	a1iajhPFlOU7IuoKn8F8oC/Sx39dSh3OBcHVBHdifWZaPWVdupkMVssyY4WX+sX3pe6rw/0ZLChXs
	uiVX95Cce06OGNQhjekn9UN6Np6PYFU83UgGuQCwy3pMCIauO4e7P3Stg/0rAB4uFyZeTAS1AwhFG
	7jrJtL8DQSHM4SQkg/nrzJEAaNBwMLpsqL6Hip8QIrXka4BVO/rfiFWkurbzr8TFuhsIMgyyzF5XM
	JsqM4X92924jAIzLyPJiwEE/elKztX397OS0PDoN66c1l6LRNFd744b1LyDSbXaOQGerKcxVPAlc4
	77RR+A9w==;
Received: from 2a02-8389-2301-9f00-88fd-fcdd-06aa-821c.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:88fd:fcdd:6aa:821c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xDiFW-0000000GR5w-3I6F;
	Mon, 05 Oct 2026 12:56:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong " <djwong@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 06/13] libxfs: remove the unused xfs_inode_log_item.ili_fsync_fields field
Date: Mon,  5 Oct 2026 14:56:16 +0200
Message-ID: <20261005125637.1340355-7-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261005125637.1340355-1-hch@lst.de>
References: <20261005125637.1340355-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

To prepare for reusing the kernel version of the struct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/logitem.c         | 1 -
 libxfs/stubs/xfs_trans.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index 6e56e476d1ea..d09ff75e9ce2 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -231,7 +231,6 @@ xfs_inode_item_precommit(
 	 * (ili_fields) correctly tracks that the version has changed.
 	 */
 	spin_lock(&iip->ili_lock);
-	iip->ili_fsync_fields |= (flags & ~XFS_ILOG_IVERSION);
 	if (flags & XFS_ILOG_IVERSION)
 		flags = ((flags & ~XFS_ILOG_IVERSION) | XFS_ILOG_CORE);
 
diff --git a/libxfs/stubs/xfs_trans.h b/libxfs/stubs/xfs_trans.h
index 9b6a47988147..fcd58930cc85 100644
--- a/libxfs/stubs/xfs_trans.h
+++ b/libxfs/stubs/xfs_trans.h
@@ -40,7 +40,6 @@ struct xfs_inode_log_item {
 	unsigned int		ili_dirty_flags;	/* dirty in current tx */
 	unsigned int		ili_last_fields;	/* fields when flushed*/
 	unsigned int		ili_fields;		/* fields to be logged */
-	unsigned int		ili_fsync_fields;	/* ignored by userspace */
 	spinlock_t		ili_lock;
 };
 
-- 
2.53.0

