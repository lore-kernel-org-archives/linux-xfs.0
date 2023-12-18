Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E8163A8
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 04:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mNH3xT+X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=52U5e4RwNtXw588LvxCFkAXExc0qAipq/AzdUTrg0Vc=; b=mNH3xT+X8I4WrjlZKSzDP064np
	WRuPXnZChK0ZMDxVfgccPSWLUlY2QXx3jUstV+YCRFHZj/PfRiqjqrWM7QHg+qu8WOd1xmQCyAh7N
	oAJCZGh9cFyrhRtV04x9EMd86PDCZPEJNRgb7d5Z+dkLfJpNJ5mV820Ox3JZbKCAFPROGYBLZtFZj
	Dbi3YWllCQGRYyHd0NIAB0BKjpCCfzzLQD6pVvvmqFef0Sy3HLZgi2CqjFK2sHnFg6k1ZppvJXDyK
	UCY+FQAOUb875GzXCpIZv3jCq/ch/KoIfjhCDa0lbgxyKmOK2+p7p7LXUEWqVZPZMTJ7nxXeUqxh2
	zoGMnSRQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rF5iA-0095Kt-1c;
	Mon, 18 Dec 2023 04:58:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 22/22] xfs: rename xfs_bmap_rtalloc to xfs_rtallocate_extent
Date: Mon, 18 Dec 2023 05:57:38 +0100
Message-Id: <20231218045738.711465-23-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231218045738.711465-1-hch@lst.de>
References: <20231218045738.711465-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Now that the xfs_rtallocate_extent name has been freed, use it for what
so far is xfs_bmap_rtalloc as the name is a lot better fitting.

Also drop the !CONFIG_XFS_RT stub as the compiler will eliminate the
call for that case given that XFS_IS_REALTIME_INODE is hard wire to
return 0 in the !CONFIG_XFS_RT case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c |  2 +-
 fs/xfs/xfs_bmap_util.h   | 15 +--------------
 fs/xfs/xfs_rtalloc.c     |  2 +-
 3 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 46a9b22a3733e3..245f7045da15c4 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4091,7 +4091,7 @@ xfs_bmap_alloc_userdata(
 		}
 
 		if (XFS_IS_REALTIME_INODE(bma->ip))
-			return xfs_bmap_rtalloc(bma);
+			return xfs_rtallocate_extent(bma);
 	}
 
 	if (unlikely(XFS_TEST_ERROR(false, mp,
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 77ecbb753ef207..233bbbd2a4676d 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -16,20 +16,7 @@ struct xfs_mount;
 struct xfs_trans;
 struct xfs_bmalloca;
 
-#ifdef CONFIG_XFS_RT
-int	xfs_bmap_rtalloc(struct xfs_bmalloca *ap);
-#else /* !CONFIG_XFS_RT */
-/*
- * Attempts to allocate RT extents when RT is disable indicates corruption and
- * should trigger a shutdown.
- */
-static inline int
-xfs_bmap_rtalloc(struct xfs_bmalloca *ap)
-{
-	return -EFSCORRUPTED;
-}
-#endif /* CONFIG_XFS_RT */
-
+int	xfs_rtallocate_extent(struct xfs_bmalloca *ap);
 int	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip,
 		xfs_off_t start_byte, xfs_off_t end_byte);
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 4b2de22bdd70cc..6344e499af8e27 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1312,7 +1312,7 @@ xfs_rtalloc_align_minmax(
 }
 
 int
-xfs_bmap_rtalloc(
+xfs_rtallocate_extent(
 	struct xfs_bmalloca	*ap)
 {
 	struct xfs_mount	*mp = ap->ip->i_mount;
-- 
2.39.2

