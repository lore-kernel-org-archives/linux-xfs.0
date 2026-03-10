Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA9B3D0934
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 12:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773145891; cv=none; b=inwY0erPJTjZpNxC5Fpi22Ynqz8OsmYwcthNG0PV5VLpL3PqTd9TK63PU3W2HBBO3C1EWhWWGv7x/HGuKGDBfmvNBc+9GmnwwuCSjqFWjwfH6jyltF5qR9vy8ALRrZiPyqwaTZWErYEgpLgFChY5V6hCuhTgDx1Rh283QWBA06Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773145891; c=relaxed/simple;
	bh=vTj3qG2yeOsecD1NLDh6MdNhz7G0toqV2IBANTebgfw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KP6EfC9waASPe9bSDGKIclwSJ1TYb+RAPZW8GVGn0tdjR/5GZzugiojBhh0c7pWy/bW2Vrzna3DOhzU1eDZlnEWmSJNUC8gHmell8batvjqwOIiygOhoGuPM+GxNgTUCow/OnE745G2Nz++JezLh963YgvyCjwoMdgyA2L7Lywk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id BC32C180F14A;
	Tue, 10 Mar 2026 13:31:22 +0100 (CET)
Received: from trufa.intra.herbolt.com.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id 883vKhoPsGnm1B4AKEJqOA
	(envelope-from <lukas@herbolt.com>); Tue, 10 Mar 2026 13:31:22 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	hch@infradead.org,
	djwong@kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH v3 REBASE] xfs: Use xarray to track SB UUIDs instead of plain array.
Date: Tue, 10 Mar 2026 13:30:22 +0100
Message-ID: <20260310123021.715566-2-lukas@herbolt.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Removing the plain array to track the UUIDs and switch
to xarray makes it more readable.

Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
---
 changes v3:
	fix locking/unlocking mistakes
	removing wrapper function xfs_uuid_insert()
	rebase xfs/for-next

 fs/xfs/xfs_mount.c | 76 ++++++++++++++++++++++------------------------
 fs/xfs/xfs_mount.h |  3 ++
 2 files changed, 40 insertions(+), 39 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 9c295abd0a0a..b183d04da998 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -44,17 +44,36 @@
 #include "xfs_healthmon.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
-static int xfs_uuid_table_size;
-static uuid_t *xfs_uuid_table;
+static DEFINE_XARRAY_ALLOC(xfs_uuid_table);
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
@@ -66,7 +85,7 @@ xfs_uuid_mount(
 	struct xfs_mount	*mp)
 {
 	uuid_t			*uuid = &mp->m_sb.sb_uuid;
-	int			hole, i;
+	int			ret;
 
 	/* Publish UUID in struct super_block */
 	super_set_uuid(mp->m_super, uuid->b, sizeof(*uuid));
@@ -80,30 +99,17 @@ xfs_uuid_mount(
 	}
 
 	mutex_lock(&xfs_uuid_table_mutex);
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
+	if (unlikely(xfs_uuid_search(uuid))) {
+		xfs_warn(mp, "Filesystem has duplicate UUID %pU - can't mount",
+				uuid);
+		mutex_unlock(&xfs_uuid_table_mutex);
+		return -EINVAL;
 	}
-	xfs_uuid_table[hole] = *uuid;
-	mutex_unlock(&xfs_uuid_table_mutex);
 
-	return 0;
-
- out_duplicate:
+	ret = xa_alloc(&xfs_uuid_table, &mp->m_uuid_table_index, uuid,
+				xa_limit_32b, GFP_KERNEL);
 	mutex_unlock(&xfs_uuid_table_mutex);
-	xfs_warn(mp, "Filesystem has duplicate UUID %pU - can't mount", uuid);
-	return -EINVAL;
+	return ret;
 }
 
 STATIC void
@@ -111,22 +117,14 @@ xfs_uuid_unmount(
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
index ddd4028be8d6..d964bae096ef 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -346,6 +346,9 @@ typedef struct xfs_mount {
 
 	/* Private data referring to a health monitor object. */
 	struct xfs_healthmon __rcu	*m_healthmon;
+
+	/* Index of uuid record in the uuid xarray. */
+	unsigned int		m_uuid_table_index;
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)

base-commit: 54fcd2f95f8d216183965a370ec69e1aab14f5da
-- 
2.53.0

