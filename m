Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:60694 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933582AbdEONqo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 May 2017 09:46:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/2] dax: hide block device code in #ifdef
Date: Mon, 15 May 2017 15:44:00 +0200
Message-Id: <20170515134508.2713243-1-arnd@arndb.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.com>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org

We allow configurations with CONFIG_BLOCK=n and CONFIG_DAX=y, which now
results in a link error:

drivers/dax/super.c: In function 'bdev_dax_pgoff':
drivers/dax/super.c:50:26: error: implicit declaration of function 'get_start_sect'; did you mean 'get_task_cred'? [-Werror=implicit-function-declaration]

The two obvious ways to avoid the link error are to either add an #ifdef
around the code that was moved from fs/block_dev.c, or to disallow the
configuration. I could not see if there is or is not a reason to support
this combination of options, but in case there is, the #ifdef is the
safer choice.

Fixes: ef51042472f5 ("block, dax: move "select DAX" from BLOCK to FS_DAX")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/dax/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index ebf43f531ada..6ed32aac8bbe 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -44,6 +44,7 @@ void dax_read_unlock(int id)
 }
 EXPORT_SYMBOL_GPL(dax_read_unlock);
 
+#ifdef CONFIG_BLOCK
 int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
 		pgoff_t *pgoff)
 {
@@ -112,6 +113,7 @@ int __bdev_dax_supported(struct super_block *sb, int blocksize)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(__bdev_dax_supported);
+#endif
 
 /**
  * struct dax_device - anchor object for dax services
-- 
2.9.0

