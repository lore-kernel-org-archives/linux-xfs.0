Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43361FDE33
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866403; cv=none; b=I4EGH0QoYpIBvpkRJfjBr16D4SaZXJ1n1FGv3eAKLBnamEFM8kX8AEudKZcVj9FnYTwotJJZYlaEJVEGR7yxe32p4uXtN9/tT/4H62K1a5fluHi6PPPyLxRpaqWTW2P83znZrIu5yzX1+FtGQtPNcGsjPLy2OfSRyjeY2c0cPZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866403; c=relaxed/simple;
	bh=wsGEYcARNmFH1gr3eKJ7DqoywzNdr+gb9WM8VwmAX3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZZeKsc3Nu5KUtt7XARuyuHWdJ+PbOHSYtr8is4hMmlqsnl1ls9a5WEnSuTohALHfZjzCNAxlCND4WP8g3WNPaWrpVHyQ52bi1vOGzsvKRQX2jsy2ZBYZsQK1pHGjmSLI2UghzLqF+9id4HJ/s8WQoh0t1/78F+HPZBG88Mssqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YrJlrFJ5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YrJlrFJ5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Dnl3SlxNETk3bOn2qINl1QWQR5EdLGvESQCRNDuUlcE=; b=YrJlrFJ51H45p8sj1K3DH2RWbh
	qCqqAlRVxVjGCWG3mym6bInoZ7GTFT+6DTjuSnXtUfzSngrjGrAbZE1wk7GZRNeF8k0zIK0R5s/ti
	YlpF9ZhwcjVZ8qVdTK6k9keuH5HC58BfjsZBDznBVb7vZgKhLzPPbJ662p8xBJrW+JLecAs3btHWM
	uYBr3kyjzg7SXCbB5tD3uiDnnlHbXURiqg09mwxoFgULP722Aucq81c3UZp/5ZRXv/U6PrxYenrxp
	9Uu0Q7RmZb7eC7GjfSDc2lQ7ERRsLkpCu6N3du3GP7uUrUwHyDmfJP46Z8KZuDN4bubx+Am62Geho
	NCD405gA==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkIjJ-00000007ChD-0FoZ;
	Tue, 18 Feb 2025 08:13:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 29/45] xfs: wire up zoned block freeing in xfs_rtextent_free_finish_item
Date: Tue, 18 Feb 2025 09:10:32 +0100
Message-ID: <20250218081153.3889537-30-hch@lst.de>
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

Make xfs_rtextent_free_finish_item call into the zoned allocator to free
blocks on zoned RT devices.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_extfree_item.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index a25c713ff888..777438b853da 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -29,6 +29,7 @@
 #include "xfs_inode.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_rtgroup.h"
+#include "xfs_zone_alloc.h"
 
 struct kmem_cache	*xfs_efi_cache;
 struct kmem_cache	*xfs_efd_cache;
@@ -767,21 +768,35 @@ xfs_rtextent_free_finish_item(
 
 	trace_xfs_extent_free_deferred(mp, xefi);
 
-	if (!(xefi->xefi_flags & XFS_EFI_CANCELLED)) {
-		if (*rtgp != to_rtg(xefi->xefi_group)) {
-			*rtgp = to_rtg(xefi->xefi_group);
-			xfs_rtgroup_lock(*rtgp, XFS_RTGLOCK_BITMAP);
-			xfs_rtgroup_trans_join(tp, *rtgp,
-					XFS_RTGLOCK_BITMAP);
-		}
-		error = xfs_rtfree_blocks(tp, *rtgp,
-				xefi->xefi_startblock, xefi->xefi_blockcount);
+	if (xefi->xefi_flags & XFS_EFI_CANCELLED)
+		goto done;
+
+	if (*rtgp != to_rtg(xefi->xefi_group)) {
+		unsigned int		lock_flags;
+
+		if (xfs_has_zoned(mp))
+			lock_flags = XFS_RTGLOCK_RMAP;
+		else
+			lock_flags = XFS_RTGLOCK_BITMAP;
+
+		*rtgp = to_rtg(xefi->xefi_group);
+		xfs_rtgroup_lock(*rtgp, lock_flags);
+		xfs_rtgroup_trans_join(tp, *rtgp, lock_flags);
 	}
+
+	if (xfs_has_zoned(mp)) {
+		error = xfs_zone_free_blocks(tp, *rtgp, xefi->xefi_startblock,
+				xefi->xefi_blockcount);
+	} else {
+		error = xfs_rtfree_blocks(tp, *rtgp, xefi->xefi_startblock,
+				xefi->xefi_blockcount);
+	}
+
 	if (error == -EAGAIN) {
 		xfs_efd_from_efi(efdp);
 		return error;
 	}
-
+done:
 	xfs_efd_add_extent(efdp, xefi);
 	xfs_extent_free_cancel_item(item);
 	return error;
-- 
2.45.2

