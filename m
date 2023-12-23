Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C9BCA4C
	for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2023 10:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AovRIdHz"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1d3efb6bfa3so6911825ad.0
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2023 02:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703329033; x=1703933833; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0SyDqk7SyaGtyyw/H/r/kSSxy4Mm69juAFBmZfenT8I=;
        b=AovRIdHzHInGigdzkdv2tTE/ia3K5I1zRmlKD6La/TrkOwRrerDZrWZYZxe18cByb8
         wEjQ6G05Jsi75mM1Kufo14Vir3E382sy3XJDHGi/8ZWshfhhozP6sGu6NVpABQmWhJQx
         +qBtT+atkoanOJrUhngiuG8yBJb32KOk2L7yJ+4hnfD/QOMApOjvWkDG7m4d9MHtQR45
         T7TKC9rshE1OTPgqUsA27o1JTFGLt+U6LWfk3nmU0Jp5xbbw0Y717ATQjyiTBccfwGw1
         QgUx2zXUjhI25HOSiJriGCyTB5IcoYEphc2ko70k64xrEH/YxT5W6fPpjsj+PwQwVzML
         HCIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703329033; x=1703933833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0SyDqk7SyaGtyyw/H/r/kSSxy4Mm69juAFBmZfenT8I=;
        b=eAr4smz7jNJmpjLqPr4nH3pzz+VrVqZqnpWJ9T3c4ZokxFaIbQfUVAzUW1yp8JmkWs
         QoFFTSknSG9DKfTpQFqcu9jgkMrsdiK9NxUnIYHbk1ilTTkD3XYBt/exxwFnvRXnELmk
         9stetXxFAlijN4xRaldP29gGUj59JHyDLRwhkIQ8dw9h6Gd7Zng9s9HDQtVOFABnkxRQ
         cAhA0E2mHo3b1jLOF7Hv+Dc9SRQvHBNGI00Z+kdAQbgWqLDXPRu9DRSgmdxFdTUZi0wq
         y8OChNTY7PHX/6LDvtM2+3GWf0f6NeWkSz7PgIpaSsDn752hofSbvD9jP2gxsk5mCMPN
         nckg==
X-Gm-Message-State: AOJu0YwN6wV6fce4OQqsZ/LMtuogVwGcbriEPbo/hW4ddEV01CeQOu3U
	MIHsw6XTPX2t5CbOp9xogD80v/QmAal/4g==
X-Google-Smtp-Source: AGHT+IHsQYGjbhe2rNpJWOoze4XYZzpwR2s7BiVvHSSMqRYxQjf+IyFiluvI1rorm0XalY92wfgMnw==
X-Received: by 2002:a17:90b:4c09:b0:286:dfae:32f6 with SMTP id na9-20020a17090b4c0900b00286dfae32f6mr4538429pjb.1.1703329032859;
        Sat, 23 Dec 2023 02:57:12 -0800 (PST)
Received: from wj-xps.. ([43.224.245.227])
        by smtp.gmail.com with ESMTPSA id y31-20020a17090a53a200b0028649b84907sm9624490pjh.16.2023.12.23.02.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Dec 2023 02:57:12 -0800 (PST)
From: Jian Wen <wenjianhn@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Jian Wen <wenjianhn@gmail.com>,
	djwong@kernel.org,
	hch@lst.de,
	dchinner@redhat.com,
	Dave Chinner <david@fromorbit.com>,
	Jian Wen <wenjian1@xiaomi.com>
Subject: [PATCH v3] xfs: improve handling of prjquot ENOSPC
Date: Sat, 23 Dec 2023 18:56:32 +0800
Message-Id: <20231223105632.85286-1-wenjianhn@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231214150708.77586-1-wenjianhn@gmail.com>
References: <20231214150708.77586-1-wenjianhn@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, xfs_trans_dqresv() return -ENOSPC when the project quota
limit is reached. As a result, xfs_file_buffered_write() will flush
the whole filesystem instead of the project quota.

Fix the issue by make xfs_trans_dqresv() return -EDQUOT rather than
-ENOSPC. Add a helper, xfs_blockgc_nospace_flush(), to make flushing
for both EDQUOT and ENOSPC consistent.

Changes since v2:
  - completely rewrote based on the suggestions from Dave

Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Jian Wen <wenjian1@xiaomi.com>
---
 fs/xfs/xfs_dquot.h       | 13 +++++++++++
 fs/xfs/xfs_file.c        | 40 +++++++++++---------------------
 fs/xfs/xfs_icache.c      | 50 +++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_icache.h      |  7 +++---
 fs/xfs/xfs_inode.c       | 19 ++++++++-------
 fs/xfs/xfs_reflink.c     |  2 ++
 fs/xfs/xfs_trans.c       | 39 +++++++++++++++++++++++--------
 fs/xfs/xfs_trans_dquot.c |  3 ---
 8 files changed, 109 insertions(+), 64 deletions(-)

diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 80c8f851a2f3..c5f4a170eef1 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -183,6 +183,19 @@ xfs_dquot_is_enforced(
 	return false;
 }
 
+static inline bool
+xfs_dquot_is_enospc(
+	struct xfs_dquot	*dqp)
+{
+	if (!dqp)
+		return false;
+	if (!xfs_dquot_is_enforced(dqp))
+		return false;
+	if (dqp->q_blk.hardlimit - dqp->q_blk.reserved > 0)
+		return false;
+	return true;
+}
+
 /*
  * Check whether a dquot is under low free space conditions. We assume the quota
  * is enabled and enforced.
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e33e5e13b95f..4b6e90bb1c59 100644
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
@@ -785,32 +788,17 @@ xfs_file_buffered_write(
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
+		if (ret == -EDQUOT && xfs_dquot_is_enospc(ip->i_pdquot))
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
index c0f1c89786c2..e99ffa17d3d0 100644
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
 
+			if (xfs_dquot_is_enospc(target_dp->i_pdquot))
+				error = -ENOSPC;
+
 			nospace_error = error;
 			spaceres = 0;
 			error = 0;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index e5b62dc28466..cb036e1173ae 100644
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
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 305c9d07bf1b..1574d7aa49c4 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1217,15 +1217,21 @@ xfs_trans_alloc_inode(
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
+		if (error == -EDQUOT && xfs_dquot_is_enospc(ip->i_pdquot))
+			error = -ENOSPC;
+
 		goto out_cancel;
+	}
 
 	*tpp = tp;
 	return 0;
@@ -1260,13 +1266,16 @@ xfs_trans_alloc_icreate(
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
+		if (error == -EDQUOT && xfs_dquot_is_enospc(pdqp))
+			error = -ENOSPC;
+
 		xfs_trans_cancel(tp);
 		return error;
 	}
@@ -1340,14 +1349,19 @@ xfs_trans_alloc_ichange(
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
+			if (error == -EDQUOT && xfs_dquot_is_enospc(pdqp))
+				error = -ENOSPC;
+
 			goto out_cancel;
+		}
 	}
 
 	*tpp = tp;
@@ -1419,14 +1433,19 @@ xfs_trans_alloc_dir(
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
 
+		if (xfs_dquot_is_enospc(dp->i_pdquot))
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
2.34.1

