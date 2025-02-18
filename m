Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD68C1FFC75
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866435; cv=none; b=KIw+sNsVhmu5aPnqDyRgdX5mJYNLwp/EVj1kHr4qCr/bMIGa6xy7h+CopCfVWP4WqQVppYqCjCepxC0qO2DVJ8RPIR2dp8jkAQfi2PXvK54KxB1gwoTQnfHgJswO+OJPlrnvXhf4TblMRZzwtOvBHuaux5irX8cvZkn5DpX9p9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866435; c=relaxed/simple;
	bh=+zNkolnJcNK4OfYqc9+a81ddN3LPK2eBP9EfpDHa4Es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFvRyXA2kJzCmH8+zdQlEWsvP+RkxgHc4DiTxVLybqOvoAKTrFmlPbaZ6uNcH4JNYq8v41M/ABqpwnpBwF9wcezseUwcgDbcOEZUZ2IBVJVYYmbyPOMIK/Qcc/cKBM978xE470FaSUZZZyOKrSgMD2plkyxqVv/yF+yeOaa0iG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nEuvMsv9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nEuvMsv9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rca43ilGus7vL3Pavz9Gxuc11hGjxrLOjoVH6QMwRfw=; b=nEuvMsv9VYpB3PhCKObmko9WUo
	crCGMHpArEYUst3UcWF/0UFJt4kPWbtRi8y7CGOcFcxO6D1ZofaQzkhpIQwiYV1gt7M1SKfstAFb+
	efJx1nCSf5Fbda/q3MCuYkXkKGQfm80e8fes8E41pM7myfvK9dqKe+mDrnB61XZF2WojkyEBXlS2P
	8sx8GakTM+rVp9JewFFziOuGvtL1TzWUhmrrDil0eEN5J8seyrEaiXkjdTvnHmOkyCrFp5LcZq0KA
	zNddhHfcro2+Ok9VxqyqIBr9FXVpvN0OxO3kEqgitPnYsvmBqA/d8q38J1VQlNytfXroMTZd+nyHS
	nEGo7rGA==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkIjp-00000007Cru-0SqP;
	Tue, 18 Feb 2025 08:13:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 38/45] xfs: enable the zoned RT device feature
Date: Tue, 18 Feb 2025 09:10:41 +0100
Message-ID: <20250218081153.3889537-39-hch@lst.de>
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

Enable the zoned RT device directory feature.  With this feature, RT
groups are written sequentially and always emptied before rewriting
the blocks.  This perfectly maps to zoned devices, but can also be
used on conventional block devices.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index f67380a25805..cee7e26f23bd 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -408,7 +408,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_NREXT64 | \
 		 XFS_SB_FEAT_INCOMPAT_EXCHRANGE | \
 		 XFS_SB_FEAT_INCOMPAT_PARENT | \
-		 XFS_SB_FEAT_INCOMPAT_METADIR)
+		 XFS_SB_FEAT_INCOMPAT_METADIR | \
+		 XFS_SB_FEAT_INCOMPAT_ZONED)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
-- 
2.45.2

