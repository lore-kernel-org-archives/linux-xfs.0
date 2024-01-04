Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7FF1DFE4
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 06:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JeN17CjX"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-5cdbc42f5efso29939a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 03 Jan 2024 22:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704349510; x=1704954310; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M3SP0PK/nw861ReZ3r8wNya8jJBgYfqa8HfYzyG/+yA=;
        b=JeN17CjXtv2irf2UcZFrnEgVr4XqA6HsMDXUqE8xl0+mofaJCZajJBCj6yeOf1S1YS
         iitm1q1Qo49GcZ5jK+/AN6CNSJSpyYU6Ar1cKOc+R2P9kMAlrxc9R8mOHZtaqSMRiMXV
         LL94q7x4JxhVr0x9qgE0WL+CjhqTkX5GJghGmGT+PhFMPXYQe91r3qz5zYTIb1vA17m7
         J6uuAgJAFt8AioS0EqkDszNNYmvFEuvEGJBGn0qhLEuqOHgYIEVL8Gk+Y7XJG2SXW/nH
         ODrtxPojefGxjAUd5bXl+xXYfXDkp/FUJkOrNkT7oUT5KLo/KO3hPjOKRxWjplY7GWSF
         dR5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704349510; x=1704954310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M3SP0PK/nw861ReZ3r8wNya8jJBgYfqa8HfYzyG/+yA=;
        b=dSI2mfGrsblMY3D4KxCCMe72rVYyWl8Qmt0ulFLoshqI8XtSz0MCKggD+bVwVNNxSR
         5e1RBSiJDlqfx1Znfi1ME8gdU+wDqZqhted5u9HYlIXHxCkdXPzFa68H1pledNl2xlbG
         ETBpeYokFAm/RvUXoN4zSQce9kp89/ooQMA++VibclTzx3iM28hWiTqSDIsdnpTWPPXV
         4yawGm96hc8lOMZjDT3+0wuHIODwDTPjEumxl1DoSG8MDojI9M5qft+kzknbQ3H1MHak
         +9cGj5Wy0uf8KE7/pAJA4KDGPe+2ZzihAVfSXd3LSojGwe3/sMO7zSLWRd++9snhkw5/
         9g9Q==
X-Gm-Message-State: AOJu0YznHmORQRlfrtx4ZC9uIdxNq4odbDaJWROOPSuBOTBDOft7TMqc
	hXOh+npxhXiihR6mBAMYxHf8IuJKhGStQw==
X-Google-Smtp-Source: AGHT+IHyZ+K+V1K1AnAad/GbnhezQnJs5GAYJUz63dv9UIuEHEu2ea8Df8Z2A8X461DVTSPsnvg9gg==
X-Received: by 2002:a05:6a00:399b:b0:6da:86e5:1648 with SMTP id fi27-20020a056a00399b00b006da86e51648mr341207pfb.0.1704349509935;
        Wed, 03 Jan 2024 22:25:09 -0800 (PST)
Received: from mi.mioffice.cn ([43.224.245.240])
        by smtp.gmail.com with ESMTPSA id fc29-20020a056a002e1d00b006da5f797249sm8198932pfb.130.2024.01.03.22.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jan 2024 22:25:09 -0800 (PST)
From: Jian Wen <wenjianhn@gmail.com>
X-Google-Original-From: Jian Wen <wenjian1@xiaomi.com>
To: linux-xfs@vger.kernel.org
Cc: Jian Wen <wenjianhn@gmail.com>,
	djwong@kernel.org,
	hch@lst.de,
	dchinner@redhat.com,
	Dave Chinner <david@fromorbit.com>,
	Jian Wen <wenjian1@xiaomi.com>
Subject: [PATCH v4] xfs: improve handling of prjquot ENOSPC
Date: Thu,  4 Jan 2024 14:22:48 +0800
Message-Id: <20240104062248.3245102-1-wenjian1@xiaomi.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231216153522.52767-1-wenjianhn@gmail.com>
References: <20231216153522.52767-1-wenjianhn@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jian Wen <wenjianhn@gmail.com>

Currently, xfs_trans_dqresv() return -ENOSPC when the project quota
limit is reached. As a result, xfs_file_buffered_write() will flush
the whole filesystem instead of the project quota.

Fix the issue by make xfs_trans_dqresv() return -EDQUOT rather than
-ENOSPC. Add a helper, xfs_blockgc_nospace_flush(), to make flushing
for both EDQUOT and ENOSPC consistent.

Changes since v3:
  - rename xfs_dquot_is_enospc to xfs_dquot_hardlimit_exceeded
  - acquire the dquot lock before checking the free space

Changes since v2:
  - completely rewrote based on the suggestions from Dave

Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Jian Wen <wenjian1@xiaomi.com>
---
 fs/xfs/xfs_dquot.h       | 22 +++++++++++++++---
 fs/xfs/xfs_file.c        | 41 ++++++++++++--------------------
 fs/xfs/xfs_icache.c      | 50 +++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_icache.h      |  7 +++---
 fs/xfs/xfs_inode.c       | 19 ++++++++-------
 fs/xfs/xfs_reflink.c     |  5 ++++
 fs/xfs/xfs_trans.c       | 41 ++++++++++++++++++++++++--------
 fs/xfs/xfs_trans_dquot.c |  3 ---
 8 files changed, 121 insertions(+), 67 deletions(-)

diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 80c8f851a2f3..d28dce0ed61a 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -183,6 +183,22 @@ xfs_dquot_is_enforced(
 	return false;
 }
 
+static inline bool
+xfs_dquot_hardlimit_exceeded(
+	struct xfs_dquot	*dqp)
+{
+	int64_t freesp;
+
+	if (!dqp)
+		return false;
+	if (!xfs_dquot_is_enforced(dqp))
+		return false;
+	xfs_dqlock(dqp);
+	freesp = dqp->q_blk.hardlimit - dqp->q_blk.reserved;
+	xfs_dqunlock(dqp);
+	return freesp < 0;
+}
+
 /*
  * Check whether a dquot is under low free space conditions. We assume the quota
  * is enabled and enforced.
@@ -191,11 +207,11 @@ static inline bool xfs_dquot_lowsp(struct xfs_dquot *dqp)
 {
 	int64_t freesp;
 
+	xfs_dqlock(dqp);
 	freesp = dqp->q_blk.hardlimit - dqp->q_blk.reserved;
-	if (freesp < dqp->q_low_space[XFS_QLOWSP_1_PCNT])
-		return true;
+	xfs_dqunlock(dqp);
 
-	return false;
+	return freesp < dqp->q_low_space[XFS_QLOWSP_1_PCNT];
 }
 
 void xfs_dquot_to_disk(struct xfs_disk_dquot *ddqp, struct xfs_dquot *dqp);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e33e5e13b95f..c19d82d922c5 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -24,6 +24,9 @@
 #include "xfs_pnfs.h"
 #include "xfs_iomap.h"
 #include "xfs_reflink.h"
+#include "xfs_quota.h"
+#include "xfs_dquot_item.h"
+#include "xfs_dquot.h"
 
 #include <linux/dax.h>
 #include <linux/falloc.h>
@@ -785,32 +788,18 @@ xfs_file_buffered_write(
 	trace_xfs_file_buffered_write(iocb, from);
 	ret = iomap_file_buffered_write(iocb, from,
 			&xfs_buffered_write_iomap_ops);
-
-	/*
-	 * If we hit a space limit, try to free up some lingering preallocated
-	 * space before returning an error. In the case of ENOSPC, first try to
-	 * write back all dirty inodes to free up some of the excess reserved
-	 * metadata space. This reduces the chances that the eofblocks scan
-	 * waits on dirty mappings. Since xfs_flush_inodes() is serialized, this
-	 * also behaves as a filter to prevent too many eofblocks scans from
-	 * running at the same time.  Use a synchronous scan to increase the
-	 * effectiveness of the scan.
-	 */
-	if (ret == -EDQUOT && !cleared_space) {
-		xfs_iunlock(ip, iolock);
-		xfs_blockgc_free_quota(ip, XFS_ICWALK_FLAG_SYNC);
-		cleared_space = true;
-		goto write_retry;
-	} else if (ret == -ENOSPC && !cleared_space) {
-		struct xfs_icwalk	icw = {0};
-
-		cleared_space = true;
-		xfs_flush_inodes(ip->i_mount);
-
-		xfs_iunlock(ip, iolock);
-		icw.icw_flags = XFS_ICWALK_FLAG_SYNC;
-		xfs_blockgc_free_space(ip->i_mount, &icw);
-		goto write_retry;
+	if (ret == -EDQUOT || ret == -ENOSPC) {
+		if (!cleared_space) {
+			xfs_iunlock(ip, iolock);
+			xfs_blockgc_nospace_flush(ip->i_mount, ip->i_udquot,
+						ip->i_gdquot, ip->i_pdquot,
+						XFS_ICWALK_FLAG_SYNC, ret);
+			cleared_space = true;
+			goto write_retry;
+		}
+		if (ret == -EDQUOT && xfs_dquot_hardlimit_exceeded(
+				ip->i_pdquot))
+			ret = -ENOSPC;
 	}
 
 out:
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index dba514a2c84d..d2dcb653befc 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -64,6 +64,10 @@ static int xfs_icwalk_ag(struct xfs_perag *pag,
 					 XFS_ICWALK_FLAG_RECLAIM_SICK | \
 					 XFS_ICWALK_FLAG_UNION)
 
+static int xfs_blockgc_free_dquots(struct xfs_mount *mp,
+		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
+		struct xfs_dquot *pdqp, unsigned int iwalk_flags);
+
 /*
  * Allocate and initialise an xfs_inode.
  */
@@ -1477,6 +1481,38 @@ xfs_blockgc_free_space(
 	return xfs_inodegc_flush(mp);
 }
 
+/*
+ * If we hit a space limit, try to free up some lingering preallocated
+ * space before returning an error. In the case of ENOSPC, first try to
+ * write back all dirty inodes to free up some of the excess reserved
+ * metadata space. This reduces the chances that the eofblocks scan
+ * waits on dirty mappings. Since xfs_flush_inodes() is serialized, this
+ * also behaves as a filter to prevent too many eofblocks scans from
+ * running at the same time.  Use a synchronous scan to increase the
+ * effectiveness of the scan.
+ */
+void
+xfs_blockgc_nospace_flush(
+	struct xfs_mount	*mp,
+	struct xfs_dquot	*udqp,
+	struct xfs_dquot	*gdqp,
+	struct xfs_dquot	*pdqp,
+	unsigned int		iwalk_flags,
+	int			what)
+{
+	ASSERT(what == -EDQUOT || what == -ENOSPC);
+
+	if (what == -EDQUOT) {
+		xfs_blockgc_free_dquots(mp, udqp, gdqp, pdqp, iwalk_flags);
+	} else if (what == -ENOSPC) {
+		struct xfs_icwalk	icw = {0};
+
+		xfs_flush_inodes(mp);
+		icw.icw_flags = iwalk_flags;
+		xfs_blockgc_free_space(mp, &icw);
+	}
+}
+
 /*
  * Reclaim all the free space that we can by scheduling the background blockgc
  * and inodegc workers immediately and waiting for them all to clear.
@@ -1515,7 +1551,7 @@ xfs_blockgc_flush_all(
  * (XFS_ICWALK_FLAG_SYNC), the caller also must not hold any inode's IOLOCK or
  * MMAPLOCK.
  */
-int
+static int
 xfs_blockgc_free_dquots(
 	struct xfs_mount	*mp,
 	struct xfs_dquot	*udqp,
@@ -1559,18 +1595,6 @@ xfs_blockgc_free_dquots(
 	return xfs_blockgc_free_space(mp, &icw);
 }
 
-/* Run cow/eofblocks scans on the quotas attached to the inode. */
-int
-xfs_blockgc_free_quota(
-	struct xfs_inode	*ip,
-	unsigned int		iwalk_flags)
-{
-	return xfs_blockgc_free_dquots(ip->i_mount,
-			xfs_inode_dquot(ip, XFS_DQTYPE_USER),
-			xfs_inode_dquot(ip, XFS_DQTYPE_GROUP),
-			xfs_inode_dquot(ip, XFS_DQTYPE_PROJ), iwalk_flags);
-}
-
 /* XFS Inode Cache Walking Code */
 
 /*
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 905944dafbe5..c0833450969d 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -57,11 +57,10 @@ long xfs_reclaim_inodes_nr(struct xfs_mount *mp, unsigned long nr_to_scan);
 
 void xfs_inode_mark_reclaimable(struct xfs_inode *ip);
 
-int xfs_blockgc_free_dquots(struct xfs_mount *mp, struct xfs_dquot *udqp,
-		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp,
-		unsigned int iwalk_flags);
-int xfs_blockgc_free_quota(struct xfs_inode *ip, unsigned int iwalk_flags);
 int xfs_blockgc_free_space(struct xfs_mount *mp, struct xfs_icwalk *icm);
+void xfs_blockgc_nospace_flush(struct xfs_mount *mp, struct xfs_dquot *udqp,
+			struct xfs_dquot *gdqp, struct xfs_dquot *pdqp,
+			unsigned int iwalk_flags, int what);
 int xfs_blockgc_flush_all(struct xfs_mount *mp);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c0f1c89786c2..0dcb614da7df 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -27,6 +27,8 @@
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
+#include "xfs_dquot_item.h"
+#include "xfs_dquot.h"
 #include "xfs_filestream.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
@@ -1007,12 +1009,6 @@ xfs_create(
 	 */
 	error = xfs_trans_alloc_icreate(mp, tres, udqp, gdqp, pdqp, resblks,
 			&tp);
-	if (error == -ENOSPC) {
-		/* flush outstanding delalloc blocks and retry */
-		xfs_flush_inodes(mp);
-		error = xfs_trans_alloc_icreate(mp, tres, udqp, gdqp, pdqp,
-				resblks, &tp);
-	}
 	if (error)
 		goto out_release_dquots;
 
@@ -2951,14 +2947,21 @@ xfs_rename(
 	if (spaceres != 0) {
 		error = xfs_trans_reserve_quota_nblks(tp, target_dp, spaceres,
 				0, false);
-		if (error == -EDQUOT || error == -ENOSPC) {
+		if (error == -EDQUOT) {
 			if (!retried) {
 				xfs_trans_cancel(tp);
-				xfs_blockgc_free_quota(target_dp, 0);
+				xfs_blockgc_nospace_flush(target_dp->i_mount,
+							target_dp->i_udquot,
+							target_dp->i_gdquot,
+							target_dp->i_pdquot,
+							0, error);
 				retried = true;
 				goto retry;
 			}
 
+			if (xfs_dquot_hardlimit_exceeded(target_dp->i_pdquot))
+				error = -ENOSPC;
+
 			nospace_error = error;
 			spaceres = 0;
 			error = 0;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index e5b62dc28466..a94691348784 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -25,6 +25,8 @@
 #include "xfs_bit.h"
 #include "xfs_alloc.h"
 #include "xfs_quota.h"
+#include "xfs_dquot_item.h"
+#include "xfs_dquot.h"
 #include "xfs_reflink.h"
 #include "xfs_iomap.h"
 #include "xfs_ag.h"
@@ -1270,6 +1272,9 @@ xfs_reflink_remap_extent(
 	if (!quota_reserved && !smap_real && dmap_written) {
 		error = xfs_trans_reserve_quota_nblks(tp, ip,
 				dmap->br_blockcount, 0, false);
+		if (error == -EDQUOT && xfs_dquot_hardlimit_exceeded(
+				ip->i_pdquot))
+			error = -ENOSPC;
 		if (error)
 			goto out_cancel;
 	}
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 305c9d07bf1b..3b930f3472c5 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1217,15 +1217,22 @@ xfs_trans_alloc_inode(
 	}
 
 	error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks, force);
-	if ((error == -EDQUOT || error == -ENOSPC) && !retried) {
+	if (error == -EDQUOT && !retried) {
 		xfs_trans_cancel(tp);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		xfs_blockgc_free_quota(ip, 0);
+		xfs_blockgc_nospace_flush(ip->i_mount, ip->i_udquot,
+					ip->i_gdquot, ip->i_pdquot,
+					0, error);
 		retried = true;
 		goto retry;
 	}
-	if (error)
+	if (error) {
+		if (error == -EDQUOT && xfs_dquot_hardlimit_exceeded(
+				ip->i_pdquot))
+			error = -ENOSPC;
+
 		goto out_cancel;
+	}
 
 	*tpp = tp;
 	return 0;
@@ -1260,13 +1267,16 @@ xfs_trans_alloc_icreate(
 		return error;
 
 	error = xfs_trans_reserve_quota_icreate(tp, udqp, gdqp, pdqp, dblocks);
-	if ((error == -EDQUOT || error == -ENOSPC) && !retried) {
+	if (error == -EDQUOT && !retried) {
 		xfs_trans_cancel(tp);
-		xfs_blockgc_free_dquots(mp, udqp, gdqp, pdqp, 0);
+		xfs_blockgc_nospace_flush(mp, udqp, gdqp, pdqp, 0, error);
 		retried = true;
 		goto retry;
 	}
 	if (error) {
+		if (error == -EDQUOT && xfs_dquot_hardlimit_exceeded(pdqp))
+			error = -ENOSPC;
+
 		xfs_trans_cancel(tp);
 		return error;
 	}
@@ -1340,14 +1350,20 @@ xfs_trans_alloc_ichange(
 		error = xfs_trans_reserve_quota_bydquots(tp, mp, udqp, gdqp,
 				pdqp, ip->i_nblocks + ip->i_delayed_blks,
 				1, qflags);
-		if ((error == -EDQUOT || error == -ENOSPC) && !retried) {
+		if (error == -EDQUOT && !retried) {
 			xfs_trans_cancel(tp);
-			xfs_blockgc_free_dquots(mp, udqp, gdqp, pdqp, 0);
+			xfs_blockgc_nospace_flush(mp, udqp, gdqp, pdqp, 0,
+						error);
 			retried = true;
 			goto retry;
 		}
-		if (error)
+		if (error) {
+			if (error == -EDQUOT && xfs_dquot_hardlimit_exceeded(
+					pdqp))
+				error = -ENOSPC;
+
 			goto out_cancel;
+		}
 	}
 
 	*tpp = tp;
@@ -1419,14 +1435,19 @@ xfs_trans_alloc_dir(
 		goto done;
 
 	error = xfs_trans_reserve_quota_nblks(tp, dp, resblks, 0, false);
-	if (error == -EDQUOT || error == -ENOSPC) {
+	if (error == -EDQUOT) {
 		if (!retried) {
 			xfs_trans_cancel(tp);
-			xfs_blockgc_free_quota(dp, 0);
+			xfs_blockgc_nospace_flush(dp->i_mount, ip->i_udquot,
+						ip->i_gdquot, ip->i_pdquot,
+						0, error);
 			retried = true;
 			goto retry;
 		}
 
+		if (xfs_dquot_hardlimit_exceeded(dp->i_pdquot))
+			error = -ENOSPC;
+
 		*nospace_error = error;
 		resblks = 0;
 		error = 0;
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index aa00cf67ad72..7201b86ef2c2 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -700,8 +700,6 @@ xfs_trans_dqresv(
 
 error_return:
 	xfs_dqunlock(dqp);
-	if (xfs_dquot_type(dqp) == XFS_DQTYPE_PROJ)
-		return -ENOSPC;
 	return -EDQUOT;
 error_corrupt:
 	xfs_dqunlock(dqp);
@@ -717,7 +715,6 @@ xfs_trans_dqresv(
  * approach.
  *
  * flags = XFS_QMOPT_FORCE_RES evades limit enforcement. Used by chown.
- *	   XFS_QMOPT_ENOSPC returns ENOSPC not EDQUOT.  Used by pquota.
  *	   XFS_TRANS_DQ_RES_BLKS reserves regular disk blocks
  *	   XFS_TRANS_DQ_RES_RTBLKS reserves realtime disk blocks
  * dquots are unlocked on return, if they were not locked by caller.
-- 
2.25.1

