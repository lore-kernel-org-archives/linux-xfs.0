Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748D0382391
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 05:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774849294; cv=none; b=TK9roZS78u76EsQ46nxUl8q03l4SKujPiKfQ8315oXsWbmaoGKn9gAH4ota28DyfGArWR/29Y9YEaL4hSxY3kqO3h/jLlFOl0jX3B+OH+hWsQKjCMb7lR2ifa29i+xyXy8ehHRUSFZNWhAcFwWOtc7LZ/zYsWvGuS16hZ1eyI9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774849294; c=relaxed/simple;
	bh=9riKc0tS4xp0JuVlNIV/WyXhcsD0griM0i7HbCh1ucI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpxKCD1hnJX1+90Z+nKP7b/Wqh32doYtp93VrfwQcEm7ohO0VIRZpHVqzQPQ27H/08SzLpBOCFQV9AvfN4wCUf8YKF2q6nUm0linmFwjJ8jNZKP5B9KEU1nJ4ywqy9v7tKQjM2ZNKhdfvjLRyoSYCUmiZVcVaR1I2/kYBE5G/UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HlumhwaB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HlumhwaB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7x9s1ez2jJ7vgszhUETkwD4qaC22wGs30zFLsfZ7qkA=; b=HlumhwaBONQo/+d2g2ibrG6oYv
	BE3sIxhl/GiTV5q1ty9vmRGrd4dYLSW8OmIjeDr+FnilCV5JMhXPCmQ2/EPBJQe7rAUSTSvuggyaB
	xj+gD56mTai3EHnMzNNoxkSnF+37EyQkAzK1v7zkSjd0lJF9PqfKDyoHNRFA2L68tlsdk6bCHxeEb
	UTOGZepJjFmX+25LbuWPlM4JcyOKHaPRoYKIQPqcI/xGszO1Oj8nVPWcJskgiS/I/ouknfvkVYTjx
	ttOg1YullCatsJF3A00SNmEeHd8j7XITZ6Tr0H2pURzZ3ZFyxfEDTY/o9S20+3NGXUZiUZz0RZBPF
	Ja1UblIA==;
Received: from [81.201.198.26] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w75NS-0000000AeOW-1mvv;
	Mon, 30 Mar 2026 05:41:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs: expose the number of open zones in sysfs
Date: Mon, 30 Mar 2026 07:40:59 +0200
Message-ID: <20260330054111.3855818-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330054111.3855818-1-hch@lst.de>
References: <20260330054111.3855818-1-hch@lst.de>
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
index 746ea60eed3f..eb3085421276 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -550,6 +550,10 @@ For zoned file systems, the following attributes are exposed in:
 	is limited by the capabilities of the backing zoned device, file system
 	size and the max_open_zones mount option.
 
+  nr_open_zones			(Min:  1  Default:  Varies  Max:  UINTMAX)
+	This read-only attribute exposes the current number of open zones
+	used by the file system.
+
   zonegc_low_space		(Min:  0  Default:  0  Max:  100)
 	Define a percentage for how much of the unused space that GC should keep
 	available for writing. A high value will reclaim more of the space
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 6c7909838234..43a02c622b6d 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -13,6 +13,7 @@
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
 #include "xfs_mount.h"
+#include "xfs_zone_priv.h"
 #include "xfs_zones.h"
 
 struct xfs_sysfs_attr {
@@ -718,6 +719,17 @@ max_open_zones_show(
 }
 XFS_SYSFS_ATTR_RO(max_open_zones);
 
+static ssize_t
+nr_open_zones_show(
+	struct kobject		*kobj,
+	char			*buf)
+{
+	struct xfs_zone_info	*zi = zoned_to_mp(kobj)->m_zone_info;
+
+	return sysfs_emit(buf, "%u\n", zi->zi_nr_open_zones);
+}
+XFS_SYSFS_ATTR_RO(nr_open_zones);
+
 static ssize_t
 zonegc_low_space_store(
 	struct kobject		*kobj,
@@ -751,6 +763,7 @@ XFS_SYSFS_ATTR_RW(zonegc_low_space);
 
 static struct attribute *xfs_zoned_attrs[] = {
 	ATTR_LIST(max_open_zones),
+	ATTR_LIST(nr_open_zones),
 	ATTR_LIST(zonegc_low_space),
 	NULL,
 };
-- 
2.47.3

