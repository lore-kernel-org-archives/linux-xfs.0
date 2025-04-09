Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C1425A638
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185538; cv=none; b=I4+88Udru31E2Eq3dfRLj4Wsf2BwYZIfgBs3Egy+Nh0iEvk+qrtgWmzsI01EjQt6k714TgUZG7Zs0hpRet6Na6ivqZNMPOjFOyUING9AvHxXnwqWrF0DhtuRbzVixvBuxohsFhXXIc07BzZtqRsg8+HI/owskQ4hpUJlbnNVk0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185538; c=relaxed/simple;
	bh=ulgw5aITOQNLRrjRdAc+DXb8YYI7UM7ZAJAO8KyPvro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fz29sdFnqVbAWbsRXxgWL8Lo3ekuE9QEABfpwbGEKxPN5bJzWWGWzzrfRb79n6VNBLZU7k/zPzb90n73zJbrPUosboh1FpOIJUUlL/oFaw8uhYrzimxKOpuzUOQ9qOLXjL9A3jgh5vJfyuWqQK7PmLAkEPCM9Z+nXCOvXZj44EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rly24jfy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rly24jfy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Vi6vaMMWsbWHPTIZbPzPc6j3m5fg984aZHIvOoZyvRs=; b=rly24jfy63uOhEL/mPNls06ykg
	991N95IxKbqgeQFXZ+czwppyfRYnLtSW3UQImrRW+d8zRfs/qkXmFiHf0INvJ48OYv1W/6w8UftF+
	Fm8clbJn71PwFubK5MsUmZ+p2+uDKrx1FQh9wpLOQpr/u/K5h8vG2oZB3517a/RxGalJt0KIVWf2b
	wpyXdwkjYBR0p1kPTcyMDaEo3I+3EYzRyDfE1ijcLexgeSoRF4ZQKkrxRVpXD89dDUAj6JykfLnvK
	MwyyYjWeKbuqhxndSz4BqM1l6Rmf808+rTyMZGICNgMGY0xN79sXfUkHb1j2cwMX+UVSOCThdioCw
	ZVf2qWDA==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QKl-00000006Upl-0Cz0;
	Wed, 09 Apr 2025 07:58:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 44/45] xfs_mdrestore: support internal RT devices
Date: Wed,  9 Apr 2025 09:55:47 +0200
Message-ID: <20250409075557.3535745-45-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250409075557.3535745-1-hch@lst.de>
References: <20250409075557.3535745-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Calculate the size properly for internal RT devices and skip restoring
to the external one for this case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mdrestore/xfs_mdrestore.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index d5014981b15a..95b01a99a154 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -183,6 +183,20 @@ verify_device_size(
 	}
 }
 
+static void
+verify_main_device_size(
+	const struct mdrestore_dev	*dev,
+	struct xfs_sb			*sb)
+{
+	xfs_rfsblock_t			nr_blocks = sb->sb_dblocks;
+
+	/* internal RT device */
+	if (sb->sb_rtstart)
+		nr_blocks = sb->sb_rtstart + sb->sb_rblocks;
+
+	verify_device_size(dev, nr_blocks, sb->sb_blocksize);
+}
+
 static void
 read_header_v1(
 	union mdrestore_headers	*h,
@@ -269,7 +283,7 @@ restore_v1(
 
 	((struct xfs_dsb*)block_buffer)->sb_inprogress = 1;
 
-	verify_device_size(ddev, sb.sb_dblocks, sb.sb_blocksize);
+	verify_main_device_size(ddev, &sb);
 
 	bytes_read = 0;
 
@@ -432,14 +446,14 @@ restore_v2(
 
 	((struct xfs_dsb *)block_buffer)->sb_inprogress = 1;
 
-	verify_device_size(ddev, sb.sb_dblocks, sb.sb_blocksize);
+	verify_main_device_size(ddev, &sb);
 
 	if (sb.sb_logstart == 0) {
 		ASSERT(mdrestore.external_log == true);
 		verify_device_size(logdev, sb.sb_logblocks, sb.sb_blocksize);
 	}
 
-	if (sb.sb_rblocks > 0) {
+	if (sb.sb_rblocks > 0 && !sb.sb_rtstart) {
 		ASSERT(mdrestore.realtime_data == true);
 		verify_device_size(rtdev, sb.sb_rblocks, sb.sb_blocksize);
 	}
-- 
2.47.2

