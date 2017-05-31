Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:37484 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751566AbdEaQUQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 May 2017 12:20:16 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 18/24] overlayfs: use uuid_t instead of uuid_be
Date: Wed, 31 May 2017 18:18:20 +0200
Message-Id: <20170531161826.23243-19-hch@lst.de>
In-Reply-To: <20170531161826.23243-1-hch@lst.de>
References: <20170531161826.23243-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 fs/overlayfs/copy_up.c   | 2 +-
 fs/overlayfs/overlayfs.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 5b795873f7fa..2a67e8c13098 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -233,7 +233,7 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
 	return err;
 }
 
-static struct ovl_fh *ovl_encode_fh(struct dentry *lower, uuid_be *uuid)
+static struct ovl_fh *ovl_encode_fh(struct dentry *lower, uuid_t *uuid)
 {
 	struct ovl_fh *fh;
 	int fh_type, fh_len, dwords;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index caa36cb9c46d..cb0fc450419b 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -55,7 +55,7 @@ struct ovl_fh {
 	u8 len;		/* size of this header + size of fid */
 	u8 flags;	/* OVL_FH_FLAG_* */
 	u8 type;	/* fid_type of fid */
-	uuid_be uuid;	/* uuid of filesystem */
+	uuid_t uuid;	/* uuid of filesystem */
 	u8 fid[0];	/* file identifier */
 } __packed;
 
-- 
2.11.0

