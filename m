Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950653624CE
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 09:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781255908; cv=none; b=UUZ1e/ECOCWWUj+4rvhRCqHD2FW8jy0KThqgPGtmGAOVVP3aG5QaRK7wxk8nVaY28XMtv6Wz+hamubDa23MaOC3EiFipIzH14AJQZiOwhYaWSc5nH9rryW1bOkuiakN3e/6i+4F0PHxpJL3xzo9QbUTm4VS5KWhpkB+w1zr1dhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781255908; c=relaxed/simple;
	bh=E9I/iJZAq3OWXfj+aXS63SqOM4Q9SPBIbbO/GO5dBzk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ICy64REIFerdjCnc2QrGxu9FKtrmwA2R6UKEih8Rtg3yKaAnzpJSacb9ztzLZUSUlBFKQh3Y/s98BBUqWqNoLrjXysq8b6x8z0SJXI3hC557tlpHM9er+YEZ2LWOR0s5kR2RwHTJUNfX/Rp15+/geKLkLpomsDM7K/+T89PNFso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: a74a8b76663f11f1aa26b74ffac11d73-20260612
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:0261d20f-9050-4ec1-9a9e-935c65c837a7,IP:10,
	URL:0,TC:0,Content:100,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACT
	ION:release,TS:135
X-CID-INFO: VERSION:1.3.12,REQID:0261d20f-9050-4ec1-9a9e-935c65c837a7,IP:10,UR
	L:0,TC:0,Content:100,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACT
	ION:quarantine,TS:135
X-CID-META: VersionHash:e7bac3a,CLOUDID:c93f9f26f58611ff70c981b8b40086be,BulkI
	D:260612171821883Y6K66,BulkQuantity:0,Recheck:0,SF:10|66|78|127|850|865|89
	8,TC:nil,Content:3|15|50,EDM:5,IP:-2,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:
	nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,AR
	C:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ASC,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a74a8b76663f11f1aa26b74ffac11d73-20260612
X-User: sangyao@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sangyao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 228280803; Fri, 12 Jun 2026 17:18:20 +0800
From: Yao Sang <sangyao@kylinos.cn>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	hch@lst.de,
	Yao Sang <sangyao@kylinos.cn>
Subject: [PATCH] xfs: add a data I/O shutdown reason
Date: Fri, 12 Jun 2026 17:17:43 +0800
Message-Id: <20260612091743.256304-1-sangyao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The zoned writeback shutdown path added for failed zoned data writes uses
SHUTDOWN_META_IO_ERROR because there is no shutdown reason for data I/O
errors.

That makes the shutdown look like a metadata failure even though the
failed I/O was user data writeback. Add a data I/O shutdown reason and
use it for unrecoverable zoned writeback errors.

Wire the new reason into the shutdown trace output and the health
monitoring event mask so userspace can distinguish data writeback
shutdowns from metadata and log I/O failures.

Signed-off-by: Yao Sang <sangyao@kylinos.cn>
---
This is a follow-up to the accepted zoned writeback shutdown fix:

xfs: shut down zoned file systems on writeback errors
https://lore.kernel.org/all/20260611015305.1583003-1-sangyao@kylinos.cn/

It also addresses Christoph's follow-up suggestion to use a dedicated
shutdown reason for unrecoverable data writeback errors instead of
reporting this path as a metadata I/O error.

 fs/xfs/libxfs/xfs_fs.h | 1 +
 fs/xfs/xfs_aops.c      | 2 +-
 fs/xfs/xfs_fsops.c     | 3 +++
 fs/xfs/xfs_healthmon.c | 1 +
 fs/xfs/xfs_mount.h     | 4 +++-
 5 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 185f09f327c0..4223a51a8c3d 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -1089,6 +1089,7 @@ struct xfs_health_monitor_inode {
 #define XFS_HEALTH_SHUTDOWN_CORRUPT_INCORE	(1u << 3)
 #define XFS_HEALTH_SHUTDOWN_CORRUPT_ONDISK	(1u << 4)
 #define XFS_HEALTH_SHUTDOWN_DEVICE_REMOVED	(1u << 5)
+#define XFS_HEALTH_SHUTDOWN_DATA_IO_ERROR	(1u << 6)
 
 /* shutdown */
 struct xfs_health_monitor_shutdown {
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 2a0c54256e93..19412fa95953 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -147,7 +147,7 @@ xfs_end_ioend_write(
 		 * available.
 		 */
 		if (is_zoned) {
-			xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
+			xfs_force_shutdown(mp, SHUTDOWN_DATA_IO_ERROR);
 			goto done;
 		}
 		if (ioend->io_flags & IOMAP_IOEND_SHARED) {
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 8d64d904d73c..0decf3a02bed 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -516,6 +516,9 @@ xfs_do_force_shutdown(
 	} else if (flags & SHUTDOWN_DEVICE_REMOVED) {
 		tag = XFS_PTAG_SHUTDOWN_IOERROR;
 		why = "Block device removal";
+	} else if (flags & SHUTDOWN_DATA_IO_ERROR) {
+		tag = XFS_PTAG_SHUTDOWN_IOERROR;
+		why = "Unrecoverable Data I/O Error";
 	} else {
 		tag = XFS_PTAG_SHUTDOWN_IOERROR;
 		why = "Metadata I/O Error";
diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index 4521ffdab9f1..1e9bae340c1e 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -684,6 +684,7 @@ static const struct flags_map shutdown_map[] = {
 	{ SHUTDOWN_CORRUPT_INCORE,	XFS_HEALTH_SHUTDOWN_CORRUPT_INCORE },
 	{ SHUTDOWN_CORRUPT_ONDISK,	XFS_HEALTH_SHUTDOWN_CORRUPT_ONDISK },
 	{ SHUTDOWN_DEVICE_REMOVED,	XFS_HEALTH_SHUTDOWN_DEVICE_REMOVED },
+	{ SHUTDOWN_DATA_IO_ERROR,	XFS_HEALTH_SHUTDOWN_DATA_IO_ERROR },
 };
 
 static inline unsigned int
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 66a02d1b9ad7..5fd45426356f 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -666,13 +666,15 @@ void xfs_do_force_shutdown(struct xfs_mount *mp, uint32_t flags, char *fname,
 #define SHUTDOWN_CORRUPT_INCORE	(1u << 3) /* corrupt in-memory structures */
 #define SHUTDOWN_CORRUPT_ONDISK	(1u << 4)  /* corrupt metadata on device */
 #define SHUTDOWN_DEVICE_REMOVED	(1u << 5) /* device removed underneath us */
+#define SHUTDOWN_DATA_IO_ERROR	(1u << 6) /* unrecoverable data write failed */
 
 #define XFS_SHUTDOWN_STRINGS \
 	{ SHUTDOWN_META_IO_ERROR,	"metadata_io" }, \
 	{ SHUTDOWN_LOG_IO_ERROR,	"log_io" }, \
 	{ SHUTDOWN_FORCE_UMOUNT,	"force_umount" }, \
 	{ SHUTDOWN_CORRUPT_INCORE,	"corruption" }, \
-	{ SHUTDOWN_DEVICE_REMOVED,	"device_removed" }
+	{ SHUTDOWN_DEVICE_REMOVED,	"device_removed" }, \
+	{ SHUTDOWN_DATA_IO_ERROR,	"data_io" }
 
 /*
  * Flags for xfs_mountfs
-- 
2.25.1

