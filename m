Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:38777 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726715AbfGRM4A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jul 2019 08:56:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] iomap: hide iomap_sector with CONFIG_BLOCK=n
Date: Thu, 18 Jul 2019 14:55:01 +0200
Message-Id: <20190718125509.775525-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>, Andreas Gruenbacher <agruenba@redhat.com>, Hannes Reinecke <hare@suse.com>, Souptick Joarder <jrdr.linux@gmail.com>, linux-kernel@vger.kernel.org

When CONFIG_BLOCK is disabled, SECTOR_SHIFT is unknown:

In file included from <built-in>:3:
include/linux/iomap.h:76:48: error: use of undeclared identifier 'SECTOR_SHIFT'
        return (iomap->addr + pos - iomap->offset) >> SECTOR_SHIFT;

Since there are no callers in this case, just hide the function in
the same ifdef.

Fixes: db074436f421 ("iomap: move the direct IO code into a separate file")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/iomap.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index bc499ceae392..bb07f31e3b6f 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -70,11 +70,13 @@ struct iomap {
 	const struct iomap_page_ops *page_ops;
 };
 
+#ifdef CONFIG_BLOCK
 static inline sector_t
 iomap_sector(struct iomap *iomap, loff_t pos)
 {
 	return (iomap->addr + pos - iomap->offset) >> SECTOR_SHIFT;
 }
+#endif
 
 /*
  * When a filesystem sets page_ops in an iomap mapping it returns, page_prepare
-- 
2.20.0
