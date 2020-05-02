Return-Path: <SRS0=mmaA=6Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 992DFC3A5A9
	for <linux-xfs@archiver.kernel.org>; Sat,  2 May 2020 09:27:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AA1B24961
	for <linux-xfs@archiver.kernel.org>; Sat,  2 May 2020 09:27:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gOGbgFPX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgEBJ10 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 2 May 2020 05:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgEBJ1Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 May 2020 05:27:25 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9003C061A0C;
        Sat,  2 May 2020 02:27:23 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 18so2800846pfv.8;
        Sat, 02 May 2020 02:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=F/rjQ8OynBOGNpFlahQ89x4ZV8FjqstjPc2OpAmwWaY=;
        b=gOGbgFPXM2K5z5nI/Xn32wBxt7GqPpmjIS+rCFESay854EjTqTL9RXTPHry+WhCGk2
         rg5Z5Okiz1E02c3VIlY8HISoy+I2Pmx4Po0OAVQwuEDuQ7hCB9tV+7VKadbEDnnj/S/3
         JDB379pwqAyH5KGZmAV+RXYng3buODXMLzb1ztUGAcETdEjGyIMLfhSTY4szNJA08G0e
         AtwD+FktSsUpXiwBa4wkeogSPBchIxMLwx2cUmvvH9cwKdZAgxLaDrueuhywnviaEcQf
         Vh4/FfL543HkGzVy05Rjyt6vM/+6GI3nc3/IQfY6rQHDzQFCNVK7/msicxd7Ijflglkl
         faLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=F/rjQ8OynBOGNpFlahQ89x4ZV8FjqstjPc2OpAmwWaY=;
        b=PMDjaBJnR2iQMDuqdq1M8u1bq3rg/YPJ+m/aoshSib1gCFUPVqpQc/RWTj3Ci0w6w+
         wtmCPIABcwLZT22wo52OfqtjR/gs7HJ0FwEEkxnyq+maYqMILlkT7Un05yqsraK1nSX5
         jXTatMbJSdNd3qmJDuZz9Kb3PnW+SbRo8HtilLm28SPdu680B0U5m49bQF6F52lFjUp5
         8/rWDzX98aUdmuz5TBMn9Qabe8VQtMwhxdHQn42fsjEmkvbKsmnsYMj/UFLXAfjNLhRQ
         YiErsMO0Qeav6A5GuDs0FvWLmPQpEHRR7E0HHRi905jBiz7hbJdIQvWIY2a4AAzQdZM2
         L7nA==
X-Gm-Message-State: AGi0PuY2D5/MqWtou5zSYBxBQSrU5rPn4tKKl8iQVEjsqs1Xz5COU4EG
        rw3SPEhDXWqErgUQSJKPk4M=
X-Google-Smtp-Source: APiQypIfNw/JVJRZVlavV6GUm4sVXll7sE31CLIBgwLEcQBoHc7ayl9Ns/on4ULYMEAiHXYyT9LlQQ==
X-Received: by 2002:a63:d16:: with SMTP id c22mr7885855pgl.34.1588411642142;
        Sat, 02 May 2020 02:27:22 -0700 (PDT)
Received: from nishad ([106.51.232.103])
        by smtp.gmail.com with ESMTPSA id u188sm4040064pfu.33.2020.05.02.02.27.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 02 May 2020 02:27:21 -0700 (PDT)
Date:   Sat, 2 May 2020 14:57:14 +0530
From:   Nishad Kamdar <nishadkamdar@gmail.com>
To:     Chiristoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Joe Perches <joe@perches.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] xfs: Use the correct style for SPDX License Identifier
Message-ID: <20200502092709.GA20328@nishad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch corrects the SPDX License Identifier style in header files
related to XFS File System support. For C header files
Documentation/process/license-rules.rst mandates C-like comments.
(opposed to C source files where C++ style should be used).

Changes made by using a script provided by Joe Perches here:
https://lkml.org/lkml/2019/2/7/46.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
---
Changes in v2:
 - use up all 73 chars in commit description
---
 fs/xfs/kmem.h                      | 2 +-
 fs/xfs/libxfs/xfs_ag_resv.h        | 2 +-
 fs/xfs/libxfs/xfs_alloc.h          | 2 +-
 fs/xfs/libxfs/xfs_alloc_btree.h    | 2 +-
 fs/xfs/libxfs/xfs_attr.h           | 2 +-
 fs/xfs/libxfs/xfs_attr_leaf.h      | 2 +-
 fs/xfs/libxfs/xfs_attr_remote.h    | 2 +-
 fs/xfs/libxfs/xfs_attr_sf.h        | 2 +-
 fs/xfs/libxfs/xfs_bit.h            | 2 +-
 fs/xfs/libxfs/xfs_bmap.h           | 2 +-
 fs/xfs/libxfs/xfs_bmap_btree.h     | 2 +-
 fs/xfs/libxfs/xfs_btree.h          | 2 +-
 fs/xfs/libxfs/xfs_da_btree.h       | 2 +-
 fs/xfs/libxfs/xfs_da_format.h      | 2 +-
 fs/xfs/libxfs/xfs_defer.h          | 2 +-
 fs/xfs/libxfs/xfs_dir2.h           | 2 +-
 fs/xfs/libxfs/xfs_dir2_priv.h      | 2 +-
 fs/xfs/libxfs/xfs_errortag.h       | 2 +-
 fs/xfs/libxfs/xfs_format.h         | 2 +-
 fs/xfs/libxfs/xfs_fs.h             | 2 +-
 fs/xfs/libxfs/xfs_health.h         | 2 +-
 fs/xfs/libxfs/xfs_ialloc.h         | 2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.h   | 2 +-
 fs/xfs/libxfs/xfs_inode_buf.h      | 2 +-
 fs/xfs/libxfs/xfs_inode_fork.h     | 2 +-
 fs/xfs/libxfs/xfs_log_format.h     | 2 +-
 fs/xfs/libxfs/xfs_log_recover.h    | 2 +-
 fs/xfs/libxfs/xfs_quota_defs.h     | 2 +-
 fs/xfs/libxfs/xfs_refcount.h       | 2 +-
 fs/xfs/libxfs/xfs_refcount_btree.h | 2 +-
 fs/xfs/libxfs/xfs_rmap.h           | 2 +-
 fs/xfs/libxfs/xfs_rmap_btree.h     | 2 +-
 fs/xfs/libxfs/xfs_sb.h             | 2 +-
 fs/xfs/libxfs/xfs_shared.h         | 2 +-
 fs/xfs/libxfs/xfs_trans_resv.h     | 2 +-
 fs/xfs/libxfs/xfs_trans_space.h    | 2 +-
 fs/xfs/libxfs/xfs_types.h          | 2 +-
 fs/xfs/mrlock.h                    | 2 +-
 fs/xfs/scrub/bitmap.h              | 2 +-
 fs/xfs/scrub/btree.h               | 2 +-
 fs/xfs/scrub/common.h              | 2 +-
 fs/xfs/scrub/dabtree.h             | 2 +-
 fs/xfs/scrub/health.h              | 2 +-
 fs/xfs/scrub/repair.h              | 2 +-
 fs/xfs/scrub/scrub.h               | 2 +-
 fs/xfs/scrub/trace.h               | 2 +-
 fs/xfs/scrub/xfs_scrub.h           | 2 +-
 fs/xfs/xfs.h                       | 2 +-
 fs/xfs/xfs_acl.h                   | 2 +-
 fs/xfs/xfs_aops.h                  | 2 +-
 fs/xfs/xfs_bmap_item.h             | 2 +-
 fs/xfs/xfs_bmap_util.h             | 2 +-
 fs/xfs/xfs_buf.h                   | 2 +-
 fs/xfs/xfs_buf_item.h              | 2 +-
 fs/xfs/xfs_dquot.h                 | 2 +-
 fs/xfs/xfs_dquot_item.h            | 2 +-
 fs/xfs/xfs_error.h                 | 2 +-
 fs/xfs/xfs_export.h                | 2 +-
 fs/xfs/xfs_extent_busy.h           | 2 +-
 fs/xfs/xfs_extfree_item.h          | 2 +-
 fs/xfs/xfs_filestream.h            | 2 +-
 fs/xfs/xfs_fsmap.h                 | 2 +-
 fs/xfs/xfs_fsops.h                 | 2 +-
 fs/xfs/xfs_icache.h                | 2 +-
 fs/xfs/xfs_icreate_item.h          | 2 +-
 fs/xfs/xfs_inode.h                 | 2 +-
 fs/xfs/xfs_inode_item.h            | 2 +-
 fs/xfs/xfs_ioctl.h                 | 2 +-
 fs/xfs/xfs_ioctl32.h               | 2 +-
 fs/xfs/xfs_iomap.h                 | 2 +-
 fs/xfs/xfs_iops.h                  | 2 +-
 fs/xfs/xfs_itable.h                | 2 +-
 fs/xfs/xfs_linux.h                 | 2 +-
 fs/xfs/xfs_log.h                   | 2 +-
 fs/xfs/xfs_log_priv.h              | 2 +-
 fs/xfs/xfs_mount.h                 | 2 +-
 fs/xfs/xfs_mru_cache.h             | 2 +-
 fs/xfs/xfs_ondisk.h                | 2 +-
 fs/xfs/xfs_qm.h                    | 2 +-
 fs/xfs/xfs_quota.h                 | 2 +-
 fs/xfs/xfs_refcount_item.h         | 2 +-
 fs/xfs/xfs_reflink.h               | 2 +-
 fs/xfs/xfs_rmap_item.h             | 2 +-
 fs/xfs/xfs_rtalloc.h               | 2 +-
 fs/xfs/xfs_stats.h                 | 2 +-
 fs/xfs/xfs_super.h                 | 2 +-
 fs/xfs/xfs_symlink.h               | 2 +-
 fs/xfs/xfs_sysctl.h                | 2 +-
 fs/xfs/xfs_sysfs.h                 | 2 +-
 fs/xfs/xfs_trace.h                 | 2 +-
 fs/xfs/xfs_trans.h                 | 2 +-
 fs/xfs/xfs_trans_priv.h            | 2 +-
 92 files changed, 92 insertions(+), 92 deletions(-)

diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 6143117770e9..fc87ea9f6843 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/libxfs/xfs_ag_resv.h b/fs/xfs/libxfs/xfs_ag_resv.h
index c0352edc8e41..f3fd0ee9a7f7 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.h
+++ b/fs/xfs/libxfs/xfs_ag_resv.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index a851bf77f17b..6c22b12176b8 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.h b/fs/xfs/libxfs/xfs_alloc_btree.h
index 047f09f0be3c..a5b998e950fe 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.h
+++ b/fs/xfs/libxfs/xfs_alloc_btree.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 0d2d05908537..db4717657ca1 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000,2002-2003,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 6dd2d937a42a..5be6be309302 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000,2002-2003,2005 Silicon Graphics, Inc.
  * Copyright (c) 2013 Red Hat, Inc.
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index 6fb4572845ce..e1144f22b005 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/libxfs/xfs_attr_sf.h b/fs/xfs/libxfs/xfs_attr_sf.h
index aafa4fe70624..bb004fb7944a 100644
--- a/fs/xfs/libxfs/xfs_attr_sf.h
+++ b/fs/xfs/libxfs/xfs_attr_sf.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000,2002,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/libxfs/xfs_bit.h b/fs/xfs/libxfs/xfs_bit.h
index 99017b8df292..a04f266ae644 100644
--- a/fs/xfs/libxfs/xfs_bit.h
+++ b/fs/xfs/libxfs/xfs_bit.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000,2002,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index f3259ad5c22c..6028a3c825ba 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index 29b407d053b4..72bf74c79fb9 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000,2002-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 8626c5a81aad..10e50cbacacf 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 53e503b6f186..6e25de6621e4 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000,2002,2005 Silicon Graphics, Inc.
  * Copyright (c) 2013 Red Hat, Inc.
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 08c0a4d98b89..059ac108b1b3 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
  * Copyright (c) 2013 Red Hat, Inc.
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 7c28d7608ac6..d119f0fda166 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 033777e282f2..e55378640b05 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 01ee0b926572..44c6a77cba05 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 79e6c4fb1d8a..9c58ab8648f5 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
  * Copyright (C) 2017 Oracle.
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 592f1c12ad36..f2228d9e317a 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 245188e4f6d3..84bcffa87753 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: LGPL-2.1
+/* SPDX-License-Identifier: LGPL-2.1 */
 /*
  * Copyright (c) 1995-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 272005ac8c88..99e796256c5d 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * Copyright (C) 2019 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
diff --git a/fs/xfs/l
