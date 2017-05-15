Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39916 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934797AbdEOPnW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 May 2017 11:43:22 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/17] uuid: don't export guid_index and uuid_index
Date: Mon, 15 May 2017 17:42:55 +0200
Message-Id: <20170515154308.26739-5-hch@lst.de>
In-Reply-To: <20170515154308.26739-1-hch@lst.de>
References: <20170515154308.26739-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

These are only used in uuid.c and vsprintf.c and aren't something modules
should use directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 lib/uuid.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/lib/uuid.c b/lib/uuid.c
index f80dc63f6ca8..003bf6823003 100644
--- a/lib/uuid.c
+++ b/lib/uuid.c
@@ -22,9 +22,7 @@
 #include <linux/random.h>
 
 const u8 guid_index[16] = {3,2,1,0,5,4,7,6,8,9,10,11,12,13,14,15};
-EXPORT_SYMBOL(guid_index);
 const u8 uuid_index[16] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
-EXPORT_SYMBOL(uuid_index);
 
 /***************************************************************
  * Random UUID interface
-- 
2.11.0

