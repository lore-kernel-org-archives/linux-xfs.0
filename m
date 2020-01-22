Return-Path: <SRS0=lPx5=3L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7961FC2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 16:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43F0B21835
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 16:48:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nleb1wkO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgAVQs6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jan 2020 11:48:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33098 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725943AbgAVQs6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jan 2020 11:48:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579711735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lPAZ3EcDwvLntz23EAdq/PHa8tpUXRKOttTLdnW5noE=;
        b=Nleb1wkOUUvBE+oHeJNBY7PaQn7577i8mRuVYCithu+0ZKm3igHf0Ta27++3EFVbdIVPxR
        Jwudj++t+HvgO6hm4H8xwRpgvT+ustaeS2xLoCXnpa4XsZqW7Q6fEUXnL2HTiZ5QxOuMuP
        8oEpeux9URBbhTd/skL1s65tFFzNr6E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-dsHJ4-LUNy-RF0h-x7cadw-1; Wed, 22 Jan 2020 11:48:53 -0500
X-MC-Unique: dsHJ4-LUNy-RF0h-x7cadw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66A6B1B18BC0
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 16:48:52 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D79D60BE0
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 16:48:52 +0000 (UTC)
Subject: [PATCH 2/2] libxfs: move header includes closer to kernelspace
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs <linux-xfs@vger.kernel.org>
References: <e0f6e0e5-d5e0-1829-f08c-0ec6e6095fb0@redhat.com>
Message-ID: <4d8501f5-4db1-9f46-bbf8-e2a7ae5726b6@redhat.com>
Date:   Wed, 22 Jan 2020 10:48:51 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <e0f6e0e5-d5e0-1829-f08c-0ec6e6095fb0@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Aid application of future kernel patches which change #includes;
not all headers exist in userspace so this is not a 1:1 match, but
it brings userspace files a bit closer to kernelspace by adding all
#includes which do match, and putting them in the same order.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/xfs_ag_resv.c b/libxfs/xfs_ag_resv.c
index 1fe13bf4..530455a5 100644
--- a/libxfs/xfs_ag_resv.c
+++ b/libxfs/xfs_ag_resv.c
@@ -7,10 +7,13 @@
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
+#include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_alloc.h"
+#include "xfs_errortag.h"
 #include "xfs_trace.h"
+#include "xfs_trans.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_btree.h"
 #include "xfs_refcount_btree.h"
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 1d25d14f..ec233d0d 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -17,6 +17,7 @@
 #include "xfs_rmap.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_alloc.h"
+#include "xfs_errortag.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_ag_resv.h"
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index d39c973a..57327deb 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -7,6 +7,7 @@
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
+#include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
@@ -14,6 +15,7 @@
 #include "xfs_alloc_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_trace.h"
+#include "xfs_trans.h"
 
 
 STATIC struct xfs_btree_cur *
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 7f11de3e..219736ac 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -13,6 +13,7 @@
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_bmap_btree.h"
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 0969f655..5efa2f0c 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -20,6 +20,7 @@
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_errortag.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "xfs_attr_leaf.h"
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 08a7e4eb..aae1d30f 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -14,7 +14,9 @@
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_btree.h"
+#include "xfs_errortag.h"
 #include "xfs_trace.h"
+#include "xfs_alloc.h"
 
 /*
  * Cursor allocation zone.
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index cff27a9b..c7a536ac 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -6,9 +6,13 @@
 #include "libxfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
 #include "xfs_defer.h"
 #include "xfs_trans.h"
+#include "xfs_inode.h"
 #include "xfs_trace.h"
 
 /*
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 9a104a76..31ac89a3 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -15,6 +15,7 @@
 #include "xfs_bmap.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_errortag.h"
 #include "xfs_trace.h"
 
 struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index 4a175bc3..5b372a23 100644
--- a/libxfs/xfs_dquot_buf.c
+++ b/libxfs/xfs_dquot_buf.c
@@ -8,9 +8,12 @@
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
+#include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_quota_defs.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
 
 int
 xfs_calc_dquots_per_chunk(
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 23bcc8c9..baa99551 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -17,6 +17,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_ialloc_btree.h"
 #include "xfs_alloc.h"
+#include "xfs_errortag.h"
 #include "xfs_bmap.h"
 #include "xfs_trans.h"
 #include "xfs_trace.h"
diff --git a/libxfs/xfs_iext_tree.c b/libxfs/xfs_iext_tree.c
index 568fb33b..f68091dc 100644
--- a/libxfs/xfs_iext_tree.c
+++ b/libxfs/xfs_iext_tree.c
@@ -3,14 +3,14 @@
  * Copyright (c) 2017 Christoph Hellwig.
  */
 
-// #include <linux/cache.h>
-// #include <linux/kernel.h>
-// #include <linux/slab.h>
 #include "libxfs_priv.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_bit.h"
 #include "xfs_log_format.h"
 #include "xfs_inode.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
 #include "xfs_trace.h"
 
 /*
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 4c90e198..c0cb5676 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -11,6 +11,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
+#include "xfs_errortag.h"
 #include "xfs_trans.h"
 #include "xfs_ialloc.h"
 #include "xfs_dir2.h"
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index a4b5686e..819faa63 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
+
 #include "libxfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
@@ -21,7 +22,6 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_attr_leaf.h"
 
-
 kmem_zone_t *xfs_ifork_zone;
 
 STATIC int xfs_iformat_local(xfs_inode_t *, xfs_dinode_t *, int, int);
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 5149b0f7..71d29486 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -15,6 +15,7 @@
 #include "xfs_bmap.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_alloc.h"
+#include "xfs_errortag.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_bit.h"
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index a52b50c3..c1561325 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -16,6 +16,7 @@
 #include "xfs_alloc.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
+#include "xfs_bit.h"
 #include "xfs_rmap.h"
 
 static struct xfs_btree_cur *
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 69a14d66..10a17e41 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -18,6 +18,7 @@
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_trace.h"
+#include "xfs_errortag.h"
 #include "xfs_inode.h"
 
 /*
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index f0b48a7d..5f3279d4 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -13,6 +13,7 @@
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
+#include "xfs_inode.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_trans.h"
 #include "xfs_trans_space.h"


