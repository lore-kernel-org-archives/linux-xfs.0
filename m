Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C939430794;
	Mon,  7 Sep 2026 08:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788768304; cv=none; b=Xv9V65CBISMDhX0xsnSGXHFl5paU1sHLyYZnkI52SKAVjdNq4ViQI+xEfn/jd1xo59lCva4KjTq61vZSENWL8Plb3QdVpPD3xpxu4KA1PcJ6D5fWnRv05hPKyWIJioHwGqgbGt4fObdnRITRv4gwLBGgtd8s9rO6YWCk67kVn6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788768304; c=relaxed/simple;
	bh=5m1B4aJfXf5H5hsdLodfWQ9mjy7DVnphdpQJv2/UOqI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DD84wWG8gdXqDJ+uGNoZnKsY+KGrimjS9TDhrHL6Ok1hZRA+PG44ya/CPq9nczU2kpljqMdjQTdIIkvKfUkMkt6hKZkRqmdlBw1NRAwEUWlk1ZalAYkHJw1vOcBQnDao1S3nIyHap9mhSP2ClxETO8r4gt2QZ2UWTr+MK5lUxjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: cfc4e500aa9211f19a56ed5b684f684d-20260907
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:e97009ba-17e3-4291-a8af-612b61fc4278,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:99c7b48fa2e5c16f576352676cb42907,BulkI
	D:nil,BulkQuantity:0,SF:102|850|865|898,TC:nil,Content:0|15|50|99,EDM:-3,I
	P:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
	,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: cfc4e500aa9211f19a56ed5b684f684d-20260907
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1613542824; Mon, 07 Sep 2026 16:04:55 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: cem@kernel.org,
	darrick.wong@oracle.com,
	chandanrlinux@gmail.com
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH v2] xfs: bound logged region access in inode buffer recovery
Date: Mon,  7 Sep 2026 16:04:50 +0800
Message-Id: <20260907080450.314067-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xlog_recover_do_inode_buffer() reads the logged di_next_unlinked field
from a log record buffer at a computed offset:

        logged_nextp = item->ri_buf[item_index].iov_base +
                        next_unlinked_offset - reg_buf_offset;
        *buffer_nextp = *logged_nextp;

The only protection against reading past the log record buffer are
ASSERT()s, which compile away on non-DEBUG kernels.  The existing
XFS_IS_CORRUPT(*logged_nextp == 0) check also dereferences the pointer
before validating that the computed offset lies within the logged region.

A crafted log record can make the computed offset exceed iov_len, causing
an out-of-bounds read from the log record buffer during inode buffer
recovery.

Convert the relevant ASSERT-only checks into runtime corruption checks and
verify that the logged di_next_unlinked field lies entirely within the log
iovec before dereferencing it.

Fixes: 1094d3f12363 ("xfs: refactor log recovery buffer item dispatch for pass2 commit functions")
Cc: stable@vger.kernel.org
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
---
Change in v2:
 --Rebase top of for-next and re-send.
---
 fs/xfs/xfs_buf_item_recover.c | 40 ++++++++++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 7148716366ba..8e06a68db310 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -651,6 +651,9 @@ xlog_recover_do_inode_buffer(
 	int				inodes_per_buf;
 	xfs_agino_t			*logged_nextp;
 	xfs_agino_t			*buffer_nextp;
+	size_t				buf_size;
+	size_t				iov_len;
+	size_t				rel_off;
 
 	trace_xfs_log_recover_buf_inode_buf(mp->m_log, buf_f);
 
@@ -714,17 +717,48 @@ xlog_recover_do_inode_buffer(
 			return -EFSCORRUPTED;
 		}
 
+		buf_size = BBTOB(bp->b_length);
+		if (XFS_IS_CORRUPT(mp, reg_buf_bytes > buf_size ||
+			   reg_buf_offset > buf_size - reg_buf_bytes)) {
+			xfs_alert(mp,
+	"Bad inode buffer log bitmap region (off %d, len %d, buf_size %zu).",
+				reg_buf_offset, reg_buf_bytes, buf_size);
+			return -EFSCORRUPTED;
+		}
+
+		if (XFS_IS_CORRUPT(mp,
+				item->ri_buf[item_index].iov_base == NULL)) {
+			xfs_alert(mp, "NULL inode buffer log record.");
+			return -EFSCORRUPTED;
+		}
+
+		iov_len = item->ri_buf[item_index].iov_len;
+		if (XFS_IS_CORRUPT(mp, iov_len < reg_buf_bytes)) {
+			xfs_alert(mp,
+	"Bad inode buffer log record length (iov_len %zu, region len %d).",
+				iov_len, reg_buf_bytes);
+			return -EFSCORRUPTED;
+		}
+
 		ASSERT(item->ri_buf[item_index].iov_base != NULL);
 		ASSERT((item->ri_buf[item_index].iov_len % XFS_BLF_CHUNK) == 0);
 		ASSERT((reg_buf_offset + reg_buf_bytes) <= BBTOB(bp->b_length));
 
+		rel_off = next_unlinked_offset - reg_buf_offset;
+		if (XFS_IS_CORRUPT(mp, rel_off > iov_len ||
+			   sizeof(xfs_agino_t) > iov_len - rel_off)) {
+			xfs_alert(mp,
+	"Bad inode buffer log record offset (rel_off %zu, iov_len %zu).",
+				rel_off, iov_len);
+			return -EFSCORRUPTED;
+		}
+
 		/*
 		 * The current logged region contains a copy of the
 		 * current di_next_unlinked field.  Extract its value
-		 * and copy it to the buffer copy.
+		 * and copy it to the on disk inode buffer.
 		 */
-		logged_nextp = item->ri_buf[item_index].iov_base +
-				next_unlinked_offset - reg_buf_offset;
+		logged_nextp = item->ri_buf[item_index].iov_base + rel_off;
 		if (XFS_IS_CORRUPT(mp, *logged_nextp == 0)) {
 			xfs_alert(mp,
 		"Bad inode buffer log record (ptr = "PTR_FMT", bp = "PTR_FMT"). "
-- 
2.25.1

