Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8E431F9A4
	for <linux-xfs@vger.kernel.org>; Wed, 27 May 2026 12:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779885597; cv=none; b=p6+BE+q3S9NVQmzhNd+VYLv0KRMW0CrEbmIcuyuErM1bRXBKbDMl6ShXKlVC9MCxfv38Vklix4RB5qj5YZl4ZMg3DV1ZadFBJLmfVrFz9ItqZhEzwdN2e9XpR4h/B4GPxYXIJFKBC12j7fEOmT6VRh16pqA3R+ixrJShasWdlPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779885597; c=relaxed/simple;
	bh=OyOUDVBCJRQwtlF/gn5FG0R61/CEzT20cWFuvwJzn9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GyCx4KikjLgKdXsjPdf9nBQsqUdHUDxIXFRUbFO70Z303q7zWR3H1pTXEwW+gm8tsEauZFu7tVtgbA5lpJ3VQb6L501CnrnzoHbURVOUQ9Vr7we639c+bH9uqUArgi3vuM6l17D9khNt5tYhU1UhISxAT5ZkClt8kmoYK7sRtNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=peZWX9xD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="peZWX9xD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Yrg5/N390jhBDfHr93OeOCv37oqPW3u6ZGI0MMqfMds=; b=peZWX9xDT8eAdfU+kOAn/x+u6C
	hGnb313pxolbDV8B6AqfaZur+mrd9FsAH74JMcXe2I8pPg8NiP929ynl2F84g5G3LeP3YBXQSp8ON
	J+sGM9lBY4RXlPs7Uo6FomUro85k7rDkTCJx0ludAPr10GyPipEvUpj3Z5hMJYkuRxQHGTnyqMavd
	RSkCsdWTvYAhHKJAgbaxxZEEWFCajkSr1/AZrj1WgcvxOAiqT1oHurQyX8jMNq0I1xHL0nuZiBpnl
	RsUPZ3obhl8O3p7yrOeCtPJYc6W1K4svVDpsCj+vtyt61ksHx5gN4c70UW+F+MAiyqIc2yO9Sbf5p
	eRlkfTqw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSDYB-000000047Dh-3Kao;
	Wed, 27 May 2026 12:39:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: drop the experimental warning for the zoned allocator
Date: Wed, 27 May 2026 14:39:30 +0200
Message-ID: <20260527123941.2319377-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260527123941.2319377-1-hch@lst.de>
References: <20260527123941.2319377-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The zoned allocator has been released with 6.15 on May 25, 2025.  It has
seen constant maintenance and improvements and no major issues, so
promote it out of the experimental category.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_message.c | 4 ----
 fs/xfs/xfs_message.h | 1 -
 fs/xfs/xfs_mount.h   | 2 --
 fs/xfs/xfs_super.c   | 1 -
 4 files changed, 8 deletions(-)

diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index fd297082aeb8..0243e509a468 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -149,10 +149,6 @@ xfs_warn_experimental(
 			.opstate	= XFS_OPSTATE_WARNED_LARP,
 			.name		= "logged extended attributes",
 		},
-		[XFS_EXPERIMENTAL_ZONED] = {
-			.opstate	= XFS_OPSTATE_WARNED_ZONED,
-			.name		= "zoned RT device",
-		},
 	};
 	ASSERT(feat >= 0 && feat < XFS_EXPERIMENTAL_MAX);
 	BUILD_BUG_ON(ARRAY_SIZE(features) != XFS_EXPERIMENTAL_MAX);
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index 49b0ef40d299..811b885f41c3 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -93,7 +93,6 @@ void xfs_buf_alert_ratelimited(struct xfs_buf *bp, const char *rlmsg,
 enum xfs_experimental_feat {
 	XFS_EXPERIMENTAL_SHRINK,
 	XFS_EXPERIMENTAL_LARP,
-	XFS_EXPERIMENTAL_ZONED,
 
 	XFS_EXPERIMENTAL_MAX,
 };
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index d964bae096ef..66a02d1b9ad7 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -580,8 +580,6 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
 #define XFS_OPSTATE_WARNED_METADIR	17
 /* Filesystem should use qflags to determine quotaon status */
 #define XFS_OPSTATE_RESUMING_QUOTAON	18
-/* Kernel has logged a warning about zoned RT device being used on this fs. */
-#define XFS_OPSTATE_WARNED_ZONED	19
 /* (Zoned) GC is in progress */
 #define XFS_OPSTATE_ZONEGC_RUNNING	20
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f8de44443e81..eac7f9503805 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1901,7 +1901,6 @@ xfs_fs_fill_super(
 			error = -EINVAL;
 			goto out_filestream_unmount;
 		}
-		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_ZONED);
 	}
 
 	if (xfs_has_reflink(mp)) {
-- 
2.53.0

