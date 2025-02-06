Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6DF22541B
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824393; cv=none; b=MAG1PMTPcN5x3OENQUEYQDZkXfq90wjJwX5DDw6SVI6cWER3/khP0ztE/OBj3BpVb5T3xweeRNfs1vuwNF3YVZdOstgNHQjrk6GjBtrhxVm7cS8+RWzFxmiTpPZqfT1c+NQsDs/xCx75QpM/7qoz5Wd2w0uI4PvGtuMqNLCipkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824393; c=relaxed/simple;
	bh=wsGEYcARNmFH1gr3eKJ7DqoywzNdr+gb9WM8VwmAX3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZZ5lj0kHfueUHZSd5wxm0y6TWp+SHsIvKqVxECH+5EXISGnm60J+UfgfYnvkPd5R52IQebaOyYbW0Ja0FhWDGDGBDoI6GPAiYKz61PRihgxPLY7gn0gyIFOhA0rhggeqjLjJkBAXrUDBcAwZU+zgDJX+GGgsix8U7prIkmztdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=464ToHek; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="464ToHek"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Dnl3SlxNETk3bOn2qINl1QWQR5EdLGvESQCRNDuUlcE=; b=464ToHekM8s/bbl7xyzaSwbSOJ
	6k+HvRbZHdih9R2l/g8uKwdmRzOhrefvtueU8MFWzEtyXsmdPntQbDeMkElkSkdJDZFy2qM59si61
	D3TjRsjkWgw9TNlnp/Tv8VbL01uqZMmp8NTMG3YT4ktsEQrBljuo1V3ACCxzRJHDUNDHWnZ5cVoP9
	f5zUPel6HXRvzRWnWLz+Puo6oLI6XYlm6ETXpW+P1rAMqo8AbgDiLyHiLzsI3aW56veEK1L5Y50Zb
	O99cTm9o89kBWF15Yq9KcPnDD348FdbDLjbMshzIXXvXSDRODO4RHrQzGe1cmswJmejIZxSFyy7aM
	Q0VsHtlw==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfveh-00000005Qda-3plA;
	Thu, 06 Feb 2025 06:46:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 27/43] xfs: wire up zoned block freeing in xfs_rtextent_free_finish_item
Date: Thu,  6 Feb 2025 07:44:43 +0100
Message-ID: <20250206064511.2323878-28-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
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

