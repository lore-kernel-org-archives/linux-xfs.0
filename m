Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2B03B52EB
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 12:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772022856; cv=none; b=FsktSOUV0AYmMZBEZT8nvzGUVXp3+eSwLfnGIG1P4CHeFAXl0UeA9v8gz5IcFp9GAKX/VBT8GJy1G7G/bsXodFSIoFLQb7tXIiLfR1cRHsbuBHCJxOfOWR2yqprDwpb61DdXugPDA6ZYc2gR9wGVgNCLsxccOBTWDN7WXOY4nGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772022856; c=relaxed/simple;
	bh=0mtD9CmkWDZavnxYYz3V6W0iOPSaXA/KRWaDRF23czM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mdriCA4s/69Ai793o54K3QXfO7pTtgduM5gquB6oW2kXCVq0zd59p73oBIkogebhwlDJIH8iDBOTCCCRQ/FULFsv6EUPYANtnbwgnKLuPneVV7H1TwqAQq6yyeFACFW9MmlBym4+8/3BaQo7j5uOLTKjdsa1h0+Yccero+BQ/7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 7ABD3180F2E7;
	Wed, 25 Feb 2026 13:34:04 +0100 (CET)
Received: from trufa.intra.herbolt.com.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id aYDwFDzsnmne3Q8AKEJqOA
	(envelope-from <lukas@herbolt.com>); Wed, 25 Feb 2026 13:34:04 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: djwong@kernel.org
Cc: cem@kernel.org,
	hch@infradead.org,
	linux-xfs@vger.kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH v2] xfs: Use xarray to track SB UUIDs instead of plain array.
Date: Wed, 25 Feb 2026 13:33:24 +0100
Message-ID: <20260225123322.631159-3-lukas@herbolt.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Removing the plain array to track the UUIDs and switch
xarray makes it more readable.

Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
---
changes v2:
	add mutex to protect changes in xarray
	add m_uuid_table_index into xfs_mount to tract xarray index 

 fs/xfs/xfs_mount.c | 88 +++++++++++++++++++++++++---------------------
 fs/xfs/xfs_mount.h |  3 ++
 2 files changed, 51 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 0953f6ae94ab..165cc101d9fd 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -43,17 +43,48 @@
 #include "xfs_zone_alloc.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
-static int xfs_uuid_table_size;
-static uuid_t *xfs_uuid_table;
+static DEFINE_XARRAY_ALLOC(xfs_uuid_table);
+
+/*
+ * Helper fucntions to store UUID in xarray.
+ */
+static int
+xfs_uuid_insert(
+	uuid_t		*uuid,
+	unsigned int	*index)
+{
+	return xa_alloc(&xfs_uuid_table, index, uuid,
+			xa_limit_32b, GFP_KERNEL);
+}
+
+static uuid_t *
+xfs_uuid_search(
+	uuid_t		*new_uuid)
+{
+	unsigned long	index = 0;
+	uuid_t		*uuid;
+
+	xa_for_each(&xfs_uuid_table, index, uuid) {
+		if (uuid_equal(uuid, new_uuid))
+			return uuid;
+	}
+	return NULL;
+}
+
+static void
+xfs_uuid_delete(
+	uuid_t		*uuid,
+	unsigned int	index)
+{
+	ASSERT(uuid_equal(xa_load(&xfs_uuid_table, index), uuid));
+	xa_erase(&xfs_uuid_table, index);
+}
 
 void
 xfs_uuid_table_free(void)
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
@@ -65,7 +96,7 @@ xfs_uuid_mount(
 	struct xfs_mount	*mp)
 {
 	uuid_t			*uuid = &mp->m_sb.sb_uuid;
-	int			hole, i;
+	int			ret;
 
 	/* Publish UUID in struct super_block */
 	super_set_uuid(mp->m_super, uuid->b, sizeof(*uuid));
@@ -78,31 +109,16 @@ xfs_uuid_mount(
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
-
-	if (hole < 0) {
-		xfs_uuid_table = krealloc(xfs_uuid_table,
-			(xfs_uuid_table_size + 1) * sizeof(*xfs_uuid_table),
-			GFP_KERNEL | __GFP_NOFAIL);
-		hole = xfs_uuid_table_size++;
-	}
-	xfs_uuid_table[hole] = *uuid;
 	mutex_unlock(&xfs_uuid_table_mutex);
+	if (unlikely(xfs_uuid_search(uuid))) {
+		xfs_warn(mp, "Filesystem has duplicate UUID %pU - can't mount",
+				uuid);
+		return -EINVAL;
+	}
 
-	return 0;
-
- out_duplicate:
+	ret = xfs_uuid_insert(uuid, &mp->m_uuid_table_index);
 	mutex_unlock(&xfs_uuid_table_mutex);
-	xfs_warn(mp, "Filesystem has duplicate UUID %pU - can't mount", uuid);
-	return -EINVAL;
+	return ret;
 }
 
 STATIC void
@@ -110,22 +126,14 @@ xfs_uuid_unmount(
 	struct xfs_mount	*mp)
 {
 	uuid_t			*uuid = &mp->m_sb.sb_uuid;
-	int			i;
 
 	if (xfs_has_nouuid(mp))
 		return;
 
 	mutex_lock(&xfs_uuid_table_mutex);
-	for (i = 0; i < xfs_uuid_table_size; i++) {
-		if (uuid_is_null(&xfs_uuid_table[i]))
-			continue;
-		if (!uuid_equal(uuid, &xfs_uuid_table[i]))
-			continue;
-		memset(&xfs_uuid_table[i], 0, sizeof(uuid_t));
-		break;
-	}
-	ASSERT(i < xfs_uuid_table_size);
+	xfs_uuid_delete(uuid, mp->m_uuid_table_index);
 	mutex_unlock(&xfs_uuid_table_mutex);
+	return;
 }
 
 /*
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b871dfde372b..4a2f2a30fbff 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -342,6 +342,9 @@ typedef struct xfs_mount {
 
 	/* Hook to feed dirent updates to an active online repair. */
 	struct xfs_hooks	m_dir_update_hooks;
+
+	/* Index of uuid record in the uuid xarray. */
+	unsigned int            m_uuid_table_index;
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
-- 
2.53.0

