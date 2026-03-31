Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48CE4035AF
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 15:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774970904; cv=none; b=hiU7sBUAquAjKSJYvdqm422PA4J4wcbSDVJi7W7ejzRrQpho40bSaLAMm97i+LiFLJaW473WQTf7knQvYY7K4ng1VNIJmwTAgat32Ebwjqd7e8qMJTK+F2Z37RFpVlWmkFsJlbBMfKaYgny/CH6ZjoH00wfZDng/Tjm48dK4Z1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774970904; c=relaxed/simple;
	bh=/gdU+wapGQwjBAuX7i1ilzxHoMud6EKd1FnUeHHrVzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ijeo4ZtfhX75G9f9ilw6aqPgwOQ7XdMpgmLX4KtioCMXDukgNuoL42RTFMh0Pwv/hXw+8GEjzVJFw3XS/F/a7bnBw2VAcE+fWS2Zf7Uf2pUkmwca8aEfgagFX92w36J5+BSqIJdqQyWSFMVIMIYOrzqWTabw1CrkilQMChNoZjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Pbg0OMuh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Pbg0OMuh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=90U+cZ5Z14iuoSnp0cWm14CSPb8vtqMyq4rfT3zdfM4=; b=Pbg0OMuhNmyjf0vxGyrBJ9VxmK
	yRvC91WTOK2LjSclLx870okBLW0bjT7vztBJnHYHmPOenW2kQN3c8lUc75+Wdb5jlqUR9OIfcGIl0
	NjDSJ7KfRhOsU/SAoYHjXxYebqLjTIqBgOmFZwtq/inYpvWROO93l4+JCUCo8XvKSdICcvSjZKIo+
	7wePnpQ3wsxWT4N/rR3DDYlwyb0R3UBDmZQVLR2OaixvHCGlWsKKRYThgiMwQNKKysQePAC3Ab5lC
	pTRqWwhiot6QuPUG/EI+894srsd2G/0+cV4SQ0fEs7AbJP/TZFOiUHWYaf26nhjTUyTegxGQAQCZu
	abQAC3WA==;
Received: from [2a02:1210:321a:af00:3fa:89ae:5c22:a910] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7b0w-0000000DBFV-0uCV;
	Tue, 31 Mar 2026 15:28:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 8/9] xfs: expose the number of open zones in sysfs
Date: Tue, 31 Mar 2026 17:27:30 +0200
Message-ID: <20260331152751.4048218-9-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260331152751.4048218-1-hch@lst.de>
References: <20260331152751.4048218-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a sysfs attribute for the current number of open zones so that it
can be trivially read from userspace in monitoring or testing software.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/admin-guide/xfs.rst |  4 ++++
 fs/xfs/xfs_sysfs.c                | 13 +++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
index 746ea60eed3f..acdd4b65964c 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -550,6 +550,10 @@ For zoned file systems, the following attributes are exposed in:
 	is limited by the capabilities of the backing zoned device, file system
 	size and the max_open_zones mount option.
 
+  nr_open_zones			(Min:  0  Default:  Varies  Max:  UINTMAX)
+	This read-only attribute exposes the current number of open zones
+	used by the file system.
+
   zonegc_low_space		(Min:  0  Default:  0  Max:  100)
 	Define a percentage for how much of the unused space that GC should keep
 	available for writing. A high value will reclaim more of the space
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 4527119b2961..676777064c2d 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -13,6 +13,7 @@
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
 #include "xfs_mount.h"
+#include "xfs_zone_priv.h"
 #include "xfs_zones.h"
 #include "xfs_zone_alloc.h"
 
@@ -719,6 +720,17 @@ max_open_zones_show(
 }
 XFS_SYSFS_ATTR_RO(max_open_zones);
 
+static ssize_t
+nr_open_zones_show(
+	struct kobject		*kobj,
+	char			*buf)
+{
+	struct xfs_zone_info	*zi = zoned_to_mp(kobj)->m_zone_info;
+
+	return sysfs_emit(buf, "%u\n", READ_ONCE(zi->zi_nr_open_zones));
+}
+XFS_SYSFS_ATTR_RO(nr_open_zones);
+
 static ssize_t
 zonegc_low_space_store(
 	struct kobject		*kobj,
@@ -756,6 +768,7 @@ XFS_SYSFS_ATTR_RW(zonegc_low_space);
 
 static struct attribute *xfs_zoned_attrs[] = {
 	ATTR_LIST(max_open_zones),
+	ATTR_LIST(nr_open_zones),
 	ATTR_LIST(zonegc_low_space),
 	NULL,
 };
-- 
2.47.3

