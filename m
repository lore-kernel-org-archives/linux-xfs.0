Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA86330337
	for <linux-xfs@vger.kernel.org>; Fri, 30 Jan 2026 15:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769787778; cv=none; b=gpGdkSEzo96XiFZ2YC3cp7VFtggVHkcxOyAxu1nK69fJLxTNNcQDbte4RhKoA4herVTQg0GVz6UKiB2v6/2vagBhdLGp3Bs6i218z+J6aRNB7c4WSiAnLtaSwLP/sXDS3pE+ibe++tXpMkx5dkhuajQVnkYKvWunkUHtcXjcypQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769787778; c=relaxed/simple;
	bh=c3ghH7mQd6Ddq1mPeMsxo4Cr0y09DVBSncPKie0n0u4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwKoXbL4vYDIdRQ0e1/bSLQG6u/5jfxs+AQeVmAL4r/7eVBNRFyAhZLu1QbraT7UEX/GcJuAQQz+P9wZcttR0br2Ipq8xYztEkfUikPXtcW3nIWQZosQCWOLTJ7Xsto3+sb4RSK0yHD5b1BlpfWk1QGZKfI9QJ6WgYOUiGEoJW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id B3E7E180F2D5;
	Fri, 30 Jan 2026 16:42:52 +0100 (CET)
Received: from trufa.intra.herbolt.com.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id 6oFZDmHRfGnyPBkAKEJqOA:T2
	(envelope-from <lukas@herbolt.com>); Fri, 30 Jan 2026 16:42:52 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH] xfs: Use xarray to track SB UUIDs instead of plain array.
Date: Fri, 30 Jan 2026 16:42:08 +0100
Message-ID: <20260130154206.1368034-4-lukas@herbolt.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260130154206.1368034-2-lukas@herbolt.com>
References: <20260130154206.1368034-2-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Removing the plain array to track the UUIDs and switch
xarray to make more readable.

Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
---
 fs/xfs/xfs_mount.c | 87 +++++++++++++++++++++++-----------------------
 fs/xfs/xfs_mount.h |  3 +-
 fs/xfs/xfs_super.c |  2 +-
 3 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 0953f6ae94ab..35c0d411e0cb 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -42,18 +42,48 @@
 #include "scrub/stats.h"
 #include "xfs_zone_alloc.h"
 
-static DEFINE_MUTEX(xfs_uuid_table_mutex);
-static int xfs_uuid_table_size;
-static uuid_t *xfs_uuid_table;
+static DEFINE_XARRAY_ALLOC(xfs_uuid_table);
+
+/*
+ * Helper fucntions to store UUID in xarray.
+ */
+STATIC int
+xfs_uuid_insert(uuid_t *uuid)
+{
+	uint32_t index = 0;
+
+	return xa_alloc(&xfs_uuid_table, &index, uuid,
+			xa_limit_32b, GFP_KERNEL);
+}
+
+STATIC uuid_t
+*xfs_uuid_search(uuid_t *new_uuid)
+{
+	unsigned long index = 0;
+	uuid_t *uuid = NULL;
+
+	xa_for_each(&xfs_uuid_table, index, uuid) {
+		if (uuid_equal(uuid, new_uuid))
+			return uuid;
+	}
+	return NULL;
+}
+
+STATIC void
+xfs_uuid_delete(uuid_t *uuid)
+{
+	unsigned long index = 0;
+
+	xa_for_each(&xfs_uuid_table, index, uuid) {
+		xa_erase(&xfs_uuid_table, index);
+	}
+}
 
 void
-xfs_uuid_table_free(void)
+xfs_uuid_table_destroy(void)
 {
-	if (xfs_uuid_table_size == 0)
-		return;
-	kfree(xfs_uuid_table);
-	xfs_uuid_table = NULL;
-	xfs_uuid_table_size = 0;
+	ASSERT(xa_empty(&xfs_uuid_table));
+	xa_destroy(&xfs_uuid_table);
 }
 
 /*
@@ -65,7 +95,6 @@ xfs_uuid_mount(
 	struct xfs_mount	*mp)
 {
 	uuid_t			*uuid = &mp->m_sb.sb_uuid;
-	int			hole, i;
 
 	/* Publish UUID in struct super_block */
 	super_set_uuid(mp->m_super, uuid->b, sizeof(*uuid));
@@ -78,29 +107,9 @@ xfs_uuid_mount(
 		return -EINVAL;
 	}
 
-	mutex_lock(&xfs_uuid_table_mutex);
-	for (i = 0, hole = -1; i < xfs_uuid_table_size; i++) {
-		if (uuid_is_null(&xfs_uuid_table[i])) {
-			hole = i;
-			continue;
-		}
-		if (uuid_equal(uuid, &xfs_uuid_table[i]))
-			goto out_duplicate;
-	}
+	if (!xfs_uuid_search(uuid))
+		return xfs_uuid_insert(uuid);
 
-	if (hole < 0) {
-		xfs_uuid_table = krealloc(xfs_uuid_table,
-			(xfs_uuid_table_size + 1) * sizeof(*xfs_uuid_table),
-			GFP_KERNEL | __GFP_NOFAIL);
-		hole = xfs_uuid_table_size++;
-	}
-	xfs_uuid_table[hole] = *uuid;
-	mutex_unlock(&xfs_uuid_table_mutex);
-
-	return 0;
-
- out_duplicate:
-	mutex_unlock(&xfs_uuid_table_mutex);
 	xfs_warn(mp, "Filesystem has duplicate UUID %pU - can't mount", uuid);
 	return -EINVAL;
 }
@@ -110,22 +119,12 @@ xfs_uuid_unmount(
 	struct xfs_mount	*mp)
 {
 	uuid_t			*uuid = &mp->m_sb.sb_uuid;
-	int			i;
 
 	if (xfs_has_nouuid(mp))
 		return;
+	xfs_uuid_delete(uuid);
+	return;
 
-	mutex_lock(&xfs_uuid_table_mutex);
-	for (i = 0; i < xfs_uuid_table_size; i++) {
-		if (uuid_is_null(&xfs_uuid_table[i]))
-			continue;
-		if (!uuid_equal(uuid, &xfs_uuid_table[i]))
-			continue;
-		memset(&xfs_uuid_table[i], 0, sizeof(uuid_t));
-		break;
-	}
-	ASSERT(i < xfs_uuid_table_size);
-	mutex_unlock(&xfs_uuid_table_mutex);
 }
 
 /*
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b871dfde372b..c3a5035c1fb6 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -689,7 +689,8 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
 	return (xfs_agblock_t) do_div(ld, mp->m_sb.sb_agblocks);
 }
 
-extern void	xfs_uuid_table_free(void);
+extern void xfs_uuid_table_destroy(void);
+
 uint64_t	xfs_default_resblks(struct xfs_mount *mp,
 			enum xfs_free_counter ctr);
 extern int	xfs_mountfs(xfs_mount_t *mp);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index bc71aa9dcee8..fc9d2e5acf96 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2723,7 +2723,7 @@ exit_xfs_fs(void)
 	xfs_mru_cache_uninit();
 	xfs_destroy_workqueues();
 	xfs_destroy_caches();
-	xfs_uuid_table_free();
+	xfs_uuid_table_destroy();
 }
 
 module_init(init_xfs_fs);

base-commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
-- 
2.52.0

