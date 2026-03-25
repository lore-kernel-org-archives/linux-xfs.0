Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114E63CEBA5;
	Wed, 25 Mar 2026 12:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774442636; cv=none; b=HdZlqvvB5x+qAg0/xS+WzOjWJeOB0swNIgEMrwDczpb6LyEg1vkK7j4Wd17LPGMqv9XKfQenY0tdKYkTcctyGUJncL6Ar3F8R070SzICy7BE5k/e0VSDmcQA3DKMvuzMXJ3rB7fD9fhkspvMuxHj6eVNs4GLDzAO1fOt5I3TGO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774442636; c=relaxed/simple;
	bh=P2st27FduWOKUuPltXFpdPPjpon9JhnO8jOTTyeeExk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D/H0iu+Krx4ZevcVJc2rDpMlcOfnWkhAj+XIQjeoK8TMcy50+TuSLaSTPV/HJQTeebx/kLXhRsvt5m+x+suJBrEv/0xOTeh3UUII9F8Y8YwOjOzs5FuDPAilsWzlYL9hzAcgqNMoWmoxohd20ZGG9P4y4AVacpQ1dEWoM6/apuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=lzWTimfE; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lzWTimfE"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1774442634; x=1805978634;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=P2st27FduWOKUuPltXFpdPPjpon9JhnO8jOTTyeeExk=;
  b=lzWTimfEqxHqvFkHF9lNU3YaFhEvw5KgcOdbbUxPdptCA2yWXUzFFf7n
   b8KYIqtaQay46VmsQeRnNtfOw+A4zH1Cy4ixCRH3LT6m0HxKjDkrkB0YD
   YeCb8JR+BS+M3qpqlvjVjynRYp3HgKpTK7JXgTOb2xvMlnFQXRAYgR+SA
   tbxsIyOZyJcZW7+AlEm+aQVD2q1XLhTwaIvaURydQVTqpy6+7YDrm8Acj
   6mzEy/MAPq4M/VontCSM6gErGa0wAoK/yeuFtDWNCTr+yfDQzxRI+9Gk6
   hP8oKl3Xt1N4z8sNViR50vH8+hOeNep400VByR7LmuPOkeTH7wOLCXKWM
   g==;
X-CSE-ConnectionGUID: t+1L1/bfRcCAW3SaaJQE8g==
X-CSE-MsgGUID: hd4tVdALQz24dPkBa3CgUQ==
X-IronPort-AV: E=Sophos;i="6.23,140,1770566400"; 
   d="scan'208";a="143710495"
Received: from unknown (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 25 Mar 2026 20:43:53 +0800
IronPort-SDR: 69c3d86c_eoUiGHM+9tPRSAM1VzidqHP7ehpZ6yzes3P+psQ8WMScmDL
 WpHVPxYmjjq4JdEkMljNJlg8jwriSozJ8d/JTfw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Mar 2026 05:43:24 -0700
WDCIronportException: Internal
Received: from unknown (HELO gcv.wdc.com) ([10.224.20.47])
  by uls-op-cesaip01.wdc.com with ESMTP; 25 Mar 2026 05:43:21 -0700
From: Hans Holmberg <hans.holmberg@wdc.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org,
	Hans Holmberg <hans.holmberg@wdc.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] xfs: start gc on zonegc_low_space attribute updates
Date: Wed, 25 Mar 2026 13:43:12 +0100
Message-ID: <20260325124312.26349-1-hans.holmberg@wdc.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Start gc if the agressiveness of zone garbage collection is changed
by the user (if the file system is not read only).

Without this change, the new setting will not be taken into account
until the gc thread is woken up by e.g. a write.

Cc: <stable@vger.kernel.org> # v6.15
Fixes: 845abeb1f06a8a ("xfs: add tunable threshold parameter for triggering zone GC")
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---

v2:
- Added a new helper to wake up the gc thread in stead of unparking it,
  which is required to make this work properly.
- Added protection against races with unmounts as sysfs gets torn down
  after the zone info struct is freed. This also avoids unneded
  wakeups during remount.
- Added fixes and stable cc tags as provided by Darrick.

v1: https://lore.kernel.org/linux-xfs/20260320130256.35225-1-hans.holmberg@wdc.com/

 fs/xfs/xfs_sysfs.c      |  7 ++++++-
 fs/xfs/xfs_zone_alloc.h |  4 ++++
 fs/xfs/xfs_zone_gc.c    | 17 +++++++++++++++++
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 6c7909838234..4527119b2961 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -14,6 +14,7 @@
 #include "xfs_log_priv.h"
 #include "xfs_mount.h"
 #include "xfs_zones.h"
+#include "xfs_zone_alloc.h"
 
 struct xfs_sysfs_attr {
 	struct attribute attr;
@@ -724,6 +725,7 @@ zonegc_low_space_store(
 	const char		*buf,
 	size_t			count)
 {
+	struct xfs_mount	*mp = zoned_to_mp(kobj);
 	int			ret;
 	unsigned int		val;
 
@@ -734,7 +736,10 @@ zonegc_low_space_store(
 	if (val > 100)
 		return -EINVAL;
 
-	zoned_to_mp(kobj)->m_zonegc_low_space = val;
+	if (mp->m_zonegc_low_space != val) {
+		mp->m_zonegc_low_space = val;
+		xfs_zone_gc_wakeup(mp);
+	}
 
 	return count;
 }
diff --git a/fs/xfs/xfs_zone_alloc.h b/fs/xfs/xfs_zone_alloc.h
index 4db02816d0fd..8b2ef98c81ef 100644
--- a/fs/xfs/xfs_zone_alloc.h
+++ b/fs/xfs/xfs_zone_alloc.h
@@ -51,6 +51,7 @@ int xfs_mount_zones(struct xfs_mount *mp);
 void xfs_unmount_zones(struct xfs_mount *mp);
 void xfs_zone_gc_start(struct xfs_mount *mp);
 void xfs_zone_gc_stop(struct xfs_mount *mp);
+void xfs_zone_gc_wakeup(struct xfs_mount *mp);
 #else
 static inline int xfs_mount_zones(struct xfs_mount *mp)
 {
@@ -65,6 +66,9 @@ static inline void xfs_zone_gc_start(struct xfs_mount *mp)
 static inline void xfs_zone_gc_stop(struct xfs_mount *mp)
 {
 }
+static inline void xfs_zone_gc_wakeup(struct xfs_mount *mp)
+{
+}
 #endif /* CONFIG_XFS_RT */
 
 #endif /* _XFS_ZONE_ALLOC_H */
diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 0ff710fa0ee7..a8f71231f351 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -1171,6 +1171,23 @@ xfs_zone_gc_stop(
 		kthread_park(mp->m_zone_info->zi_gc_thread);
 }
 
+void
+xfs_zone_gc_wakeup(
+	struct xfs_mount	*mp)
+{
+	struct super_block      *sb = mp->m_super;
+
+	/*
+	 * If we are unmounting the file system we must not try to
+	 * wake gc as m_zone_info might have been freed already.
+	 */
+	if (down_read_trylock(&sb->s_umount)) {
+		if (!xfs_is_readonly(mp))
+			wake_up_process(mp->m_zone_info->zi_gc_thread);
+		up_read(&sb->s_umount);
+	}
+}
+
 int
 xfs_zone_gc_mount(
 	struct xfs_mount	*mp)
-- 
2.34.1

