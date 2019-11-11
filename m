Return-Path: <SRS0=wiGc=ZD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32456C43331
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 21:36:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB8AE2173B
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 21:36:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C20wG0f4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKKVgp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Nov 2019 16:36:45 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45896 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbfKKVgp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Nov 2019 16:36:45 -0500
Received: by mail-wr1-f66.google.com with SMTP id z10so10965125wrs.12
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2019 13:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=K/dm1nlM77SeL5Mz5PgkpQGz45TfW5YdCu2uN/JWM24=;
        b=C20wG0f4bIweUE7eG7pBs05ILu97XWVfnbSVUjrfC00x+8mPxe5IwCbIgCeO1V3sNT
         kk/wgOHhsDPYXgnefkF3+CjGEpP9mS/4ooq3/PvusevZac/lh7rw0bUSO6gO2heB2L7k
         QMqXh+ZPtmUkSTwP+btWKFAUPToVOcvYoPSIwcHbXLnvpRl6+2uvheL+qF6pkO7EY/eh
         7kkcvl92Gob90q2L+2RmZq8XyfnZ+tV2705hxasjFVc/yJOM5TW5Z9TML6tdRSYLnPbG
         Txfcv3pt6JMjDBjO9l/Fxn21zU4bKqgo/9y0ohgIVNeRwZOUiOVsjX+l02FggW+bfOIL
         CubA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=K/dm1nlM77SeL5Mz5PgkpQGz45TfW5YdCu2uN/JWM24=;
        b=nlxNCAaVX5eR5JkXK20qww8N5OlSPzwtLWxJA3zBJarrk3TKGo0dW05x9xTObN3vP+
         Rm+AM+y7Cr7itOsBvHHXwObNkdPxMXJiVrK6Wyohd8mmLgiqp1zdU3QrCIRbM2zkcAT5
         kx61XcXe8n2qovqywKB0FEKhVLGhs4ZPxGK2K8C10SN70gzSfU4c47Xu5fFFjeSs3+nw
         ldCMpxQK02MP/FBlRe6+S3q3Y+9yuSFQ4Dp6W/PJ/vj/l/72rI0J68o2PhtUkNBovAH+
         V3jVEY+epvV/mOzmJ2QNujlG8WXedqPoMSqBEvsyaHCxnhLZksMIhxA2EQuIx5bCc9iz
         L5Ag==
X-Gm-Message-State: APjAAAVFCrGlbwWD8V0KImEo5g6iSlqLbZyzpKrrctBNLlKjWgcbYutV
        vBvLxpLzMcY9lQ2jrrRnAp6kf0qg
X-Google-Smtp-Source: APXvYqy8mUEHUAwcTd9yglWoEc4WXjszj2vXCaDyqo80UL0+r9PHEMUulA1UBz/wXhP9ThuHfltzdg==
X-Received: by 2002:adf:c449:: with SMTP id a9mr1576000wrg.240.1573508198938;
        Mon, 11 Nov 2019 13:36:38 -0800 (PST)
Received: from localhost.localdomain ([94.230.83.228])
        by smtp.gmail.com with ESMTPSA id 65sm34835343wrs.9.2019.11.11.13.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 13:36:38 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: [RFC][PATCH] xfs: extended timestamp range
Date:   Mon, 11 Nov 2019 23:36:30 +0200
Message-Id: <20191111213630.14680-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use similar on-disk encoding for timestamps as ext4 to push back
the y2038 deadline to 2446.

The encoding uses the 2 free MSB in 32bit nsec field to extend the
seconds field storage size to 34bit.

Those 2 bits should be zero on existing xfs inodes, so the extended
timestamp range feature is declared read-only compatible with old
on-disk format.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Hi,

This is a very lightly tested RFC patch.
Naming and splitting to patches aside, I'd like to know what folks think
about this direction for fixing y2038 xfs support.

With XFS_TIMESTAMP_DEBUG defined, it provides correct output for test
generic/402 (timestamp range test), when matching xfs expected timestamp
ranges to those of ext4 (_filesystem_timestamp_range).
And then the test (naturally) fails on corrupted fs check.

If this direction is acceptable, I will proceed with patching xfsprogs.

I'd also like to hear your thoughts about migration process.
Should the new feature be ro_compat as I defined it or incompat?
In pricipal, all user would need to do is set the feature flag, but
I am not aware of any precedent of a similar format upgrade in xfs.

Thanks,
Amir.

 fs/xfs/libxfs/xfs_format.h      |  14 ++-
 fs/xfs/libxfs/xfs_inode_buf.c   |  36 ++++----
 fs/xfs/libxfs/xfs_log_format.h  |   4 +-
 fs/xfs/libxfs/xfs_timestamp.h   | 151 ++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_trans_inode.c |   7 +-
 fs/xfs/scrub/inode.c            |  11 ++-
 fs/xfs/xfs_inode.c              |   4 +-
 fs/xfs/xfs_inode_item.c         |  13 ++-
 fs/xfs/xfs_iops.c               |   5 +-
 fs/xfs/xfs_itable.c             |   3 +-
 fs/xfs/xfs_super.c              |   5 +-
 11 files changed, 208 insertions(+), 45 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_timestamp.h

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index c968b60cee15..227a775a9889 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -449,10 +449,12 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
 #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
 #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
+#define XFS_SB_FEAT_RO_COMPAT_EXTTIME  (1 << 3)		/* extended time_max */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
-		 XFS_SB_FEAT_RO_COMPAT_REFLINK)
+		 XFS_SB_FEAT_RO_COMPAT_REFLINK | \
+		 XFS_SB_FEAT_RO_COMPAT_EXTTIME)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
@@ -546,6 +548,12 @@ static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
 }
 
+static inline bool xfs_sb_version_hasexttime(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_EXTTIME);
+}
+
 /*
  * end of superblock version macros
  */
@@ -824,8 +832,8 @@ typedef struct xfs_agfl {
 		   xfs_daddr_to_agno(mp, (d) + (len) - 1)))
 
 typedef struct xfs_timestamp {
-	__be32		t_sec;		/* timestamp seconds */
-	__be32		t_nsec;		/* timestamp nanoseconds */
+	__be32	t_sec;		/* timestamp seconds */
+	__be32	t_nsec_epoch;	/* timestamp nanoseconds | extra epoch */
 } xfs_timestamp_t;
 
 /*
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 28ab3c5255e1..aaf411da6263 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -17,6 +17,7 @@
 #include "xfs_trans.h"
 #include "xfs_ialloc.h"
 #include "xfs_dir2.h"
+#include "xfs_timestamp.h"
 
 #include <linux/iversion.h>
 
@@ -204,6 +205,7 @@ xfs_inode_from_disk(
 {
 	struct xfs_icdinode	*to = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
+	struct xfs_sb		*sbp = &ip->i_mount->m_sb;
 
 
 	/*
@@ -233,12 +235,9 @@ xfs_inode_from_disk(
 	 * a time before epoch is converted to a time long after epoch
 	 * on 64 bit systems.
 	 */
-	inode->i_atime.tv_sec = (int)be32_to_cpu(from->di_atime.t_sec);
-	inode->i_atime.tv_nsec = (int)be32_to_cpu(from->di_atime.t_nsec);
-	inode->i_mtime.tv_sec = (int)be32_to_cpu(from->di_mtime.t_sec);
-	inode->i_mtime.tv_nsec = (int)be32_to_cpu(from->di_mtime.t_nsec);
-	inode->i_ctime.tv_sec = (int)be32_to_cpu(from->di_ctime.t_sec);
-	inode->i_ctime.tv_nsec = (int)be32_to_cpu(from->di_ctime.t_nsec);
+	xfs_timestamp_di_decode(sbp, &inode->i_atime, &from->di_atime);
+	xfs_timestamp_di_decode(sbp, &inode->i_mtime, &from->di_mtime);
+	xfs_timestamp_di_decode(sbp, &inode->i_ctime, &from->di_ctime);
 	inode->i_generation = be32_to_cpu(from->di_gen);
 	inode->i_mode = be16_to_cpu(from->di_mode);
 
@@ -257,7 +256,8 @@ xfs_inode_from_disk(
 		inode_set_iversion_queried(inode,
 					   be64_to_cpu(from->di_changecount));
 		to->di_crtime.t_sec = be32_to_cpu(from->di_crtime.t_sec);
-		to->di_crtime.t_nsec = be32_to_cpu(from->di_crtime.t_nsec);
+		to->di_crtime.t_nsec_epoch =
+			be32_to_cpu(from->di_crtime.t_nsec_epoch);
 		to->di_flags2 = be64_to_cpu(from->di_flags2);
 		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
 	}
@@ -271,6 +271,7 @@ xfs_inode_to_disk(
 {
 	struct xfs_icdinode	*from = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
+	struct xfs_sb		*sbp = &ip->i_mount->m_sb;
 
 	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
 	to->di_onlink = 0;
@@ -283,12 +284,9 @@ xfs_inode_to_disk(
 	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
 
 	memset(to->di_pad, 0, sizeof(to->di_pad));
-	to->di_atime.t_sec = cpu_to_be32(inode->i_atime.tv_sec);
-	to->di_atime.t_nsec = cpu_to_be32(inode->i_atime.tv_nsec);
-	to->di_mtime.t_sec = cpu_to_be32(inode->i_mtime.tv_sec);
-	to->di_mtime.t_nsec = cpu_to_be32(inode->i_mtime.tv_nsec);
-	to->di_ctime.t_sec = cpu_to_be32(inode->i_ctime.tv_sec);
-	to->di_ctime.t_nsec = cpu_to_be32(inode->i_ctime.tv_nsec);
+	xfs_timestamp_di_encode(sbp, &inode->i_atime, &to->di_atime);
+	xfs_timestamp_di_encode(sbp, &inode->i_mtime, &to->di_mtime);
+	xfs_timestamp_di_encode(sbp, &inode->i_ctime, &to->di_ctime);
 	to->di_nlink = cpu_to_be32(inode->i_nlink);
 	to->di_gen = cpu_to_be32(inode->i_generation);
 	to->di_mode = cpu_to_be16(inode->i_mode);
@@ -307,7 +305,8 @@ xfs_inode_to_disk(
 	if (from->di_version == 3) {
 		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
 		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
-		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
+		to->di_crtime.t_nsec_epoch =
+			cpu_to_be32(from->di_crtime.t_nsec_epoch);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
 		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(ip->i_ino);
@@ -338,11 +337,11 @@ xfs_log_dinode_to_disk(
 	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
 
 	to->di_atime.t_sec = cpu_to_be32(from->di_atime.t_sec);
-	to->di_atime.t_nsec = cpu_to_be32(from->di_atime.t_nsec);
+	to->di_atime.t_nsec_epoch = cpu_to_be32(from->di_atime.t_nsec_epoch);
 	to->di_mtime.t_sec = cpu_to_be32(from->di_mtime.t_sec);
-	to->di_mtime.t_nsec = cpu_to_be32(from->di_mtime.t_nsec);
+	to->di_mtime.t_nsec_epoch = cpu_to_be32(from->di_mtime.t_nsec_epoch);
 	to->di_ctime.t_sec = cpu_to_be32(from->di_ctime.t_sec);
-	to->di_ctime.t_nsec = cpu_to_be32(from->di_ctime.t_nsec);
+	to->di_ctime.t_nsec_epoch = cpu_to_be32(from->di_ctime.t_nsec_epoch);
 
 	to->di_size = cpu_to_be64(from->di_size);
 	to->di_nblocks = cpu_to_be64(from->di_nblocks);
@@ -359,7 +358,8 @@ xfs_log_dinode_to_disk(
 	if (from->di_version == 3) {
 		to->di_changecount = cpu_to_be64(from->di_changecount);
 		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
-		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
+		to->di_crtime.t_nsec_epoch =
+			cpu_to_be32(from->di_crtime.t_nsec_epoch);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
 		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(from->di_ino);
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index e5f97c69b320..08f9d119e0d5 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -369,8 +369,8 @@ static inline int xfs_ilog_fdata(int w)
  * information.
  */
 typedef struct xfs_ictimestamp {
-	int32_t		t_sec;		/* timestamp seconds */
-	int32_t		t_nsec;		/* timestamp nanoseconds */
+	int32_t t_sec;		/* timestamp seconds */
+	uint32_t t_nsec_epoch;	/* timestamp nanoseconds | extra epoch */
 } xfs_ictimestamp_t;
 
 /*
diff --git a/fs/xfs/libxfs/xfs_timestamp.h b/fs/xfs/libxfs/xfs_timestamp.h
new file mode 100644
index 000000000000..b514a9f40704
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_timestamp.h
@@ -0,0 +1,151 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 CTERA Networks.
+ * All Rights Reserved.
+ */
+#ifndef __XFS_TIMESTAMP_H__
+#define __XFS_TIMESTAMP_H__
+
+//#define XFS_TIMESTAMP_DEBUG
+
+#ifdef XFS_TIMESTAMP_DEBUG
+#define XFS_TIMESTAMP_EXTENDED(sbp) 1
+#else
+#define XFS_TIMESTAMP_EXTENDED(sbp) xfs_sb_version_hasexttime(sbp)
+#endif
+
+/*
+ * We use 2 unused msb of 32bit t_nsec to encode time ranges beyond y2038.
+ *
+ * We use an encoding that preserves the times for extra epoch "00":
+ *
+ * extra  msb of                         adjust for signed
+ * epoch  32-bit                         32-bit tv_sec to
+ * bits   time    decoded 64-bit tv_sec  64-bit tv_sec      valid time range
+ * 0 0    1    -0x80000000..-0x00000001  0x000000000 1901-12-13..1969-12-31
+ * 0 0    0    0x000000000..0x07fffffff  0x000000000 1970-01-01..2038-01-19
+ * 0 1    1    0x080000000..0x0ffffffff  0x100000000 2038-01-19..2106-02-07
+ * 0 1    0    0x100000000..0x17fffffff  0x100000000 2106-02-07..2174-02-25
+ * 1 0    1    0x180000000..0x1ffffffff  0x200000000 2174-02-25..2242-03-16
+ * 1 0    0    0x200000000..0x27fffffff  0x200000000 2242-03-16..2310-04-04
+ * 1 1    1    0x280000000..0x2ffffffff  0x300000000 2310-04-04..2378-04-22
+ * 1 1    0    0x300000000..0x37fffffff  0x300000000 2378-04-22..2446-05-10
+ */
+
+#define XFS_TIMESTAMP_NSEC_BITS		30
+#define XFS_TIMESTAMP_NSEC_MASK		((1U << XFS_TIMESTAMP_NSEC_BITS) - 1)
+#define XFS_TIMESTAMP_NSEC(nsec_epoch)	((nsec_epoch) & XFS_TIMESTAMP_NSEC_MASK)
+#define XFS_TIMESTAMP_EPOCH_SHIFT	XFS_TIMESTAMP_NSEC_BITS
+#define XFS_TIMESTAMP_EPOCH_BITS	(32 - XFS_TIMESTAMP_NSEC_BITS)
+#define XFS_TIMESTAMP_EPOCH_MASK	(((1U << XFS_TIMESTAMP_EPOCH_BITS) \
+					  - 1) << XFS_TIMESTAMP_EPOCH_SHIFT)
+#define XFS_TIMESTAMP_SEC_BITS		(32 + XFS_TIMESTAMP_EPOCH_BITS)
+
+#define XFS_TIMESTAMP_SEC_MIN		S32_MIN
+#define XFS_TIMESTAMP_SEC32_MAX		S32_MAX
+#define XFS_TIMESTAMP_SEC64_MAX		((1LL << XFS_TIMESTAMP_SEC_BITS) \
+					 - 1  + S32_MIN)
+#define XFS_TIMESTAMP_SEC_MAX(sbp) \
+	(XFS_TIMESTAMP_EXTENDED(sbp) ? XFS_TIMESTAMP_SEC64_MAX : \
+					XFS_TIMESTAMP_SEC32_MAX)
+
+
+static inline int64_t xfs_timestamp_decode_sec64(int32_t sec32,
+						 uint32_t nsec_epoch)
+{
+	int64_t sec64 = sec32;
+
+	if (unlikely(nsec_epoch & XFS_TIMESTAMP_EPOCH_MASK)) {
+		sec64 += ((int64_t)(nsec_epoch & XFS_TIMESTAMP_EPOCH_MASK)) <<
+			XFS_TIMESTAMP_EPOCH_BITS;
+#ifdef XFS_TIMESTAMP_DEBUG
+		pr_info("%s: %lld.%d epoch=%x sec32=%d", __func__, sec64,
+			XFS_TIMESTAMP_NSEC(nsec_epoch),
+			(nsec_epoch & XFS_TIMESTAMP_EPOCH_MASK), sec32);
+#endif
+	}
+	return sec64;
+}
+
+static inline int64_t xfs_timestamp_sec64(struct xfs_sb *sbp, int32_t sec32,
+					  uint32_t nsec_epoch)
+{
+	return XFS_TIMESTAMP_EXTENDED(sbp) ?
+		xfs_timestamp_decode_sec64(sec32, nsec_epoch) : sec32;
+}
+
+static inline bool xfs_timestamp_nsec_is_valid(struct xfs_sb *sbp,
+					       uint32_t nsec_epoch)
+{
+	if (!XFS_TIMESTAMP_EXTENDED(sbp) &&
+	    (nsec_epoch & XFS_TIMESTAMP_EPOCH_MASK))
+		return false;
+
+	return XFS_TIMESTAMP_NSEC(nsec_epoch) < NSEC_PER_SEC;
+}
+
+static inline bool xfs_timestamp_is_valid(struct xfs_sb *sbp,
+					  xfs_timestamp_t *dtsp)
+{
+	return xfs_timestamp_nsec_is_valid(sbp,
+				be32_to_cpu(dtsp->t_nsec_epoch));
+}
+
+static inline void xfs_timestamp_ic_decode(struct xfs_sb *sbp,
+					   struct timespec64 *time,
+					   xfs_ictimestamp_t *itsp)
+{
+	time->tv_sec = xfs_timestamp_sec64(sbp, itsp->t_sec,
+					   itsp->t_nsec_epoch);
+	time->tv_nsec = XFS_TIMESTAMP_NSEC(itsp->t_nsec_epoch);
+}
+
+static inline void xfs_timestamp_di_decode(struct xfs_sb *sbp,
+					   struct timespec64 *time,
+					   xfs_timestamp_t *dtsp)
+{
+	time->tv_sec = xfs_timestamp_sec64(sbp, be32_to_cpu(dtsp->t_sec),
+					   be32_to_cpu(dtsp->t_nsec_epoch));
+	time->tv_nsec = XFS_TIMESTAMP_NSEC(be32_to_cpu(dtsp->t_nsec_epoch));
+}
+
+static inline int32_t xfs_timestamp_encode_nsec_epoch(int64_t sec64,
+						      int32_t nsec)
+{
+	int32_t epoch = ((sec64 - (int32_t)sec64) >> XFS_TIMESTAMP_EPOCH_BITS) &
+			XFS_TIMESTAMP_EPOCH_MASK;
+
+#ifdef XFS_TIMESTAMP_DEBUG
+	if (epoch)
+		pr_info("%s: %lld.%d epoch=%x sec32=%d", __func__, sec64, nsec,
+			epoch, (int32_t)sec64);
+#endif
+	return (nsec & XFS_TIMESTAMP_NSEC_MASK) | epoch;
+}
+
+static inline int32_t xfs_timestamp_nsec_epoch(struct xfs_sb *sbp,
+					       int64_t sec64, int32_t nsec)
+{
+	return XFS_TIMESTAMP_EXTENDED(sbp) ?
+		xfs_timestamp_encode_nsec_epoch(sec64, nsec) : nsec;
+}
+
+static inline void xfs_timestamp_ic_encode(struct xfs_sb *sbp,
+					   struct timespec64 *time,
+					   xfs_ictimestamp_t *itsp)
+{
+	itsp->t_sec = (int32_t)time->tv_sec;
+	itsp->t_nsec_epoch = xfs_timestamp_nsec_epoch(sbp, time->tv_sec,
+						      time->tv_nsec);
+}
+
+static inline void xfs_timestamp_di_encode(struct xfs_sb *sbp,
+					   struct timespec64 *time,
+					   xfs_timestamp_t *dtsp)
+{
+	dtsp->t_sec = cpu_to_be32(time->tv_sec);
+	dtsp->t_nsec_epoch = cpu_to_be32(xfs_timestamp_nsec_epoch(sbp,
+						time->tv_sec, time->tv_nsec));
+}
+
+#endif /* __XFS_TIMESTAMP_H__ */
diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index a9ad90926b87..48c9c9e3654d 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -8,10 +8,13 @@
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_inode_item.h"
+#include "xfs_timestamp.h"
 
 #include <linux/iversion.h>
 
@@ -67,8 +70,8 @@ xfs_trans_ichgtime(
 	if (flags & XFS_ICHGTIME_CHG)
 		inode->i_ctime = tv;
 	if (flags & XFS_ICHGTIME_CREATE) {
-		ip->i_d.di_crtime.t_sec = (int32_t)tv.tv_sec;
-		ip->i_d.di_crtime.t_nsec = (int32_t)tv.tv_nsec;
+		xfs_timestamp_ic_encode(&ip->i_mount->m_sb, &tv,
+					&ip->i_d.di_crtime);
 	}
 }
 
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 6d483ab29e63..981f86387dc3 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -17,6 +17,7 @@
 #include "xfs_reflink.h"
 #include "xfs_rmap.h"
 #include "xfs_bmap_util.h"
+#include "xfs_timestamp.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
@@ -293,11 +294,9 @@ xchk_dinode(
 	}
 
 	/* di_[amc]time.nsec */
-	if (be32_to_cpu(dip->di_atime.t_nsec) >= NSEC_PER_SEC)
-		xchk_ino_set_corrupt(sc, ino);
-	if (be32_to_cpu(dip->di_mtime.t_nsec) >= NSEC_PER_SEC)
-		xchk_ino_set_corrupt(sc, ino);
-	if (be32_to_cpu(dip->di_ctime.t_nsec) >= NSEC_PER_SEC)
+	if (!xfs_timestamp_is_valid(&mp->m_sb, &dip->di_atime) ||
+	    !xfs_timestamp_is_valid(&mp->m_sb, &dip->di_mtime) ||
+	    !xfs_timestamp_is_valid(&mp->m_sb, &dip->di_ctime))
 		xchk_ino_set_corrupt(sc, ino);
 
 	/*
@@ -403,7 +402,7 @@ xchk_dinode(
 	}
 
 	if (dip->di_version >= 3) {
-		if (be32_to_cpu(dip->di_crtime.t_nsec) >= NSEC_PER_SEC)
+		if (!xfs_timestamp_is_valid(&mp->m_sb, &dip->di_crtime))
 			xchk_ino_set_corrupt(sc, ino);
 		xchk_inode_flags2(sc, dip, ino, mode, flags, flags2);
 		xchk_inode_cowextsize(sc, dip, ino, mode, flags,
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a92d4521748d..ca1538b31170 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -35,6 +35,7 @@
 #include "xfs_log.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_reflink.h"
+#include "xfs_timestamp.h"
 
 kmem_zone_t *xfs_inode_zone;
 
@@ -851,8 +852,7 @@ xfs_ialloc(
 		inode_set_iversion(inode, 1);
 		ip->i_d.di_flags2 = 0;
 		ip->i_d.di_cowextsize = 0;
-		ip->i_d.di_crtime.t_sec = (int32_t)tv.tv_sec;
-		ip->i_d.di_crtime.t_nsec = (int32_t)tv.tv_nsec;
+		xfs_timestamp_ic_encode(&mp->m_sb, &tv, &ip->i_d.di_crtime);
 	}
 
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 726aa3bfd6e8..2b5db9af6a9d 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -18,6 +18,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
 #include "xfs_error.h"
+#include "xfs_timestamp.h"
 
 #include <linux/iversion.h>
 
@@ -303,6 +304,7 @@ xfs_inode_to_log_dinode(
 {
 	struct xfs_icdinode	*from = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
+	struct xfs_sb		*sbp = &ip->i_mount->m_sb;
 
 	to->di_magic = XFS_DINODE_MAGIC;
 
@@ -315,12 +317,9 @@ xfs_inode_to_log_dinode(
 
 	memset(to->di_pad, 0, sizeof(to->di_pad));
 	memset(to->di_pad3, 0, sizeof(to->di_pad3));
-	to->di_atime.t_sec = inode->i_atime.tv_sec;
-	to->di_atime.t_nsec = inode->i_atime.tv_nsec;
-	to->di_mtime.t_sec = inode->i_mtime.tv_sec;
-	to->di_mtime.t_nsec = inode->i_mtime.tv_nsec;
-	to->di_ctime.t_sec = inode->i_ctime.tv_sec;
-	to->di_ctime.t_nsec = inode->i_ctime.tv_nsec;
+	xfs_timestamp_ic_encode(sbp, &inode->i_atime, &to->di_atime);
+	xfs_timestamp_ic_encode(sbp, &inode->i_mtime, &to->di_mtime);
+	xfs_timestamp_ic_encode(sbp, &inode->i_ctime, &to->di_ctime);
 	to->di_nlink = inode->i_nlink;
 	to->di_gen = inode->i_generation;
 	to->di_mode = inode->i_mode;
@@ -342,7 +341,7 @@ xfs_inode_to_log_dinode(
 	if (from->di_version == 3) {
 		to->di_changecount = inode_peek_iversion(inode);
 		to->di_crtime.t_sec = from->di_crtime.t_sec;
-		to->di_crtime.t_nsec = from->di_crtime.t_nsec;
+		to->di_crtime.t_nsec_epoch = from->di_crtime.t_nsec_epoch;
 		to->di_flags2 = from->di_flags2;
 		to->di_cowextsize = from->di_cowextsize;
 		to->di_ino = ip->i_ino;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 4c7962ccb0c4..aa294597d16f 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -21,6 +21,7 @@
 #include "xfs_dir2.h"
 #include "xfs_iomap.h"
 #include "xfs_error.h"
+#include "xfs_timestamp.h"
 
 #include <linux/xattr.h>
 #include <linux/posix_acl.h>
@@ -556,8 +557,8 @@ xfs_vn_getattr(
 	if (ip->i_d.di_version == 3) {
 		if (request_mask & STATX_BTIME) {
 			stat->result_mask |= STATX_BTIME;
-			stat->btime.tv_sec = ip->i_d.di_crtime.t_sec;
-			stat->btime.tv_nsec = ip->i_d.di_crtime.t_nsec;
+			xfs_timestamp_ic_decode(&mp->m_sb, &stat->btime,
+						&ip->i_d.di_crtime);
 		}
 	}
 
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 884950adbd16..3e55cf029414 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -19,6 +19,7 @@
 #include "xfs_error.h"
 #include "xfs_icache.h"
 #include "xfs_health.h"
+#include "xfs_timestamp.h"
 
 /*
  * Bulk Stat
@@ -98,7 +99,7 @@ xfs_bulkstat_one_int(
 	buf->bs_ctime = inode->i_ctime.tv_sec;
 	buf->bs_ctime_nsec = inode->i_ctime.tv_nsec;
 	buf->bs_btime = dic->di_crtime.t_sec;
-	buf->bs_btime_nsec = dic->di_crtime.t_nsec;
+	buf->bs_btime_nsec = XFS_TIMESTAMP_NSEC(dic->di_crtime.t_nsec_epoch);
 	buf->bs_gen = inode->i_generation;
 	buf->bs_mode = inode->i_mode;
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b3188ea49413..b940ce6dac07 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -35,6 +35,7 @@
 #include "xfs_refcount_item.h"
 #include "xfs_bmap_item.h"
 #include "xfs_reflink.h"
+#include "xfs_timestamp.h"
 
 #include <linux/magic.h>
 #include <linux/fs_context.h>
@@ -1438,8 +1439,8 @@ xfs_fc_fill_super(
 	sb->s_maxbytes = xfs_max_file_offset(sb->s_blocksize_bits);
 	sb->s_max_links = XFS_MAXLINK;
 	sb->s_time_gran = 1;
-	sb->s_time_min = S32_MIN;
-	sb->s_time_max = S32_MAX;
+	sb->s_time_min = XFS_TIMESTAMP_SEC_MIN;
+	sb->s_time_max = XFS_TIMESTAMP_SEC_MAX(&mp->m_sb);
 	sb->s_iflags |= SB_I_CGROUPWB;
 
 	set_posix_acl_flag(sb);
-- 
2.17.1

