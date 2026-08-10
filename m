Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26593101D4
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 15:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786375305; cv=none; b=GQ7S1a7hFDG9ER7hsXQOD8pspoIlYi6rGLrU5a6HtxxoDM521ypujPonSLMu3pF0tEO/PSwnmTii6PXWUyMn0Mm5o0v3d1H40uB4DpPmbf8ErgZIOP5EtMeOVE1U/6ShpeGAxq2TeWW1Mra9tqjIRTiMSylmVK76t9ts9hnHi1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786375305; c=relaxed/simple;
	bh=tOQUiiUAzAUJV+cGBZWpanhdN9wnYBftyhbhir8f6u8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NrACNwxTwy5tMwpeCTg4zuhaiKPZqxXyBUrjJ0XrSMIwkZ00p/v0AHvHAd1zr7i6qx81QvAh/Iucqy2GhqJmtBkjKI3FZGvSjTWwn98GQCh1GN6e49JydSFUft89jTEbRUJJuDWJrlhl03P//lDLxxoFpvJWTGGgrFIsbyYs1Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SNWWsPOv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SNWWsPOv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51241F000E9;
	Mon, 10 Aug 2026 15:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786375304;
	bh=1VD5JL7l+IgGYHj7Obt9KoYDX5xKdUB8p5lgMcClY0g=;
	h=From:To:Cc:Subject:Date;
	b=SNWWsPOvE7jMzTLYuBTtGJD//oEt+kf22rnCfRsaDjn8CD7am+tG/TQckrr+JKWfY
	 +IqkA7f4NF0u5Y02fn+M4z2vc9f7ZmH3wCCJFpDFj2tvGZrxsZ5m0Bz8DR5l4kqIne
	 Xpcl6C7WBUYM2U/Bva0UhJptsYY00YjO1lZL8wJridbVm5HQeicU+WrcHm/TllRWN3
	 f0HVqKlY95oACRb/qdw2ZwitVqhSnq6NgJHyKSC1ZpCOtoGtD2TSQpSaciZLzht9e/
	 4g6vV17VCEjjXxA52ULUDePejSXmXjFJoxBSIdJhRltPQ2ci7Y2jxEHcf30gKQQDIL
	 g+juNwhv39nzg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	djwong@kernel.org,
	hch@lst.de,
	cem@kernel.org
Subject: [PATCH] xfs: fix IOMAP_F_DIRTY flag overwrite in zoned DIO
Date: Mon, 10 Aug 2026 17:21:31 +0200
Message-ID: <20260810152132.495705-1-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Missing IOMAP_F_DIRTY prevents completion handlers from updating i_size
on the direct IO path, the flag is set but was overwritten by
IOMAP_F_ANON_WRITE latter. The writeback path for buffered IO doesn't
seem to require IOMAP_F_DIRTY and looks like an error.

Fixes: 2e2383405824 ("xfs: implement direct writes to zoned RT devices")
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_aops.c  | 1 -
 fs/xfs/xfs_iomap.c | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 51293b6f331f..01a981bf126e 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -632,7 +632,6 @@ xfs_zoned_map_blocks(
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
 	wpc->iomap.type = IOMAP_MAPPED;
-	wpc->iomap.flags = IOMAP_F_DIRTY;
 	wpc->iomap.bdev = mp->m_rtdev_targp->bt_bdev;
 	wpc->iomap.offset = offset;
 	wpc->iomap.length = XFS_FSB_TO_B(mp, count_fsb);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 225c3de88d03..45eef1b815b3 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1081,11 +1081,10 @@ xfs_zoned_direct_write_iomap_begin(
 	}
 
 	iomap->type = IOMAP_MAPPED;
-	iomap->flags = IOMAP_F_DIRTY;
 	iomap->bdev = ip->i_mount->m_rtdev_targp->bt_bdev;
 	iomap->offset = offset;
 	iomap->length = length;
-	iomap->flags = IOMAP_F_ANON_WRITE;
+	iomap->flags = IOMAP_F_DIRTY | IOMAP_F_ANON_WRITE;
 	return 0;
 }
 
-- 
2.54.0

