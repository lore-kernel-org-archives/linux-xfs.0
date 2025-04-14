Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F72D1401C
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609063; cv=none; b=LVwdD7kQt9kl3xnn4xfkZv2ZcVXQMIlxAhE8xx2urBCxckHP5YC9NpO0bzN1RF9LT42aHYFHK+gA/EF7gfNc1KfvK4ekTz1O8BxfxQ3Lk4G+2PVmbM6Z3zH0ovLwdHjsanLR+0Z72/+arS960wMZYND1FcBV3QUg/n4bmxz1iG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609063; c=relaxed/simple;
	bh=mHe7+omtdxlpUXHWn9WtW0JuorViH9sGGtNxeWmEapQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GoBdpqtkWTyfQNT5oQChUbKoCNdrJJ6MIFj8UmACHT+gLuTwBc/fGoHxBRgE4o33VzW7JXFTGPYqEhU9KA0Q5GE8/5SFX6VeSG4z5l4VFvbEYJ7sWpNrdyo6GAVnOHKCfu07MKvLK4DyEKYGe5qvscQ8w5OveTTjPA234cogudE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Vid9rrmk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Vid9rrmk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=sq3ujub7ZRr+xZFGhYsSE6kA+oNJPpGrlrfZBiknOEA=; b=Vid9rrmk3vP41T62UrT6ALprNJ
	bqNSEL2JBJ99/84oj0Vwj8UAInwb4wWw11U7tGEX0QbQl+X1B08cl9hKMVRSfnvzb7FtW7xNeHnKb
	saXRK5LjUl7KtDGVgrNUXu4Zx7+2UnCMdQobWW/H7ew4ewW5b7seNcfT126hXZqepoZXCFNlwULQn
	+rY7cuYFc1CXHvIBh1TxUvjl4RTvcInALpfiOWwoQ4NQ+rmDMSuUv6swVO7XPt+Bt5yvFSorsy/N4
	ymg/hqiXqhalamyy04TAJI68s2KbkIdKCI9Fj6D6z0Vz3OGV2Bzs4N+uv+UNXL/4vN/ebWn67sJ8R
	JUCTUOlw==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CVp-00000000iJd-10Ed;
	Mon, 14 Apr 2025 05:37:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 23/43] xfs: enable the zoned RT device feature
Date: Mon, 14 Apr 2025 07:36:06 +0200
Message-ID: <20250414053629.360672-24-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250414053629.360672-1-hch@lst.de>
References: <20250414053629.360672-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: be458049ffe32b5885c5c35b12997fd40c2986c4

Enable the zoned RT device directory feature.  With this feature, RT
groups are written sequentially and always emptied before rewriting
the blocks.  This perfectly maps to zoned devices, but can also be
used on conventional block devices.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_format.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index f67380a25805..cee7e26f23bd 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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
2.47.2

