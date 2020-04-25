Return-Path: <SRS0=0X6r=6J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1FD2C54FCB
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 13:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C4D02072B
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 13:35:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qdRz120j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgDYNfT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Apr 2020 09:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgDYNfS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Apr 2020 09:35:18 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28622C09B04B;
        Sat, 25 Apr 2020 06:35:17 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id s10so4860337plr.1;
        Sat, 25 Apr 2020 06:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=WtFCy3hcseFSbQx403+XzrPca2pip5g3GIxgGtgPBiI=;
        b=qdRz120jK3PqWqLYnezBPHZD8bqrfcjyeiGItE4RihHxo20Cax5+SkAaXUTKADkZa3
         nnO3jyjEtEQRXJAlnsCleYuMaEoqmZKA5bTycvC5cGv3kxIOfKkRIUBYGcfQA+uxtqy9
         w0LujAfVwewPXSwxEXGTcH6SInyk2sdShf3s0L8WP5erC7JhSbL8XtaMBAK9c3aq8VI6
         PGnF88QaoBbHAqB9YMkLt5xlnqFpb+32o6NlIxuf2kHknOjRVPuoEDKj5ss7JY6IgdYP
         OeEIEw4h47dhv8bUyovdvwkoHD2+2dXX1OZgHZnoKVLE+C1ukgamsF5g41AAKLFw/Oz6
         ouGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=WtFCy3hcseFSbQx403+XzrPca2pip5g3GIxgGtgPBiI=;
        b=Vl7+Wq4KO9QZi1X+yVdBhCnbhbmn6qFAZpxbNUNNY9YcTdqcvjm5fm/EuFgrgXRHmD
         DKRKo7YH9ZmY2ursYXbALHzuxa9e4aSVKZGPV4VuOG1mQdOObyEaRBo3jZh38nNAxpwe
         jMgK3HZMQxnnJwfLBXv3USw3vWJqVeSupNykEEcpTe6ZknLjxCQdwGc7jZPl7K7TOyj3
         VKo2odj+4Puufa2u+IF0VUEay8AreFOPl+kkI58I0M2RPsBAfp6OVx/frT/oPic85+RZ
         tKjBssZgj6aJduk5cwrrZpslF6iWKyDS8yJj7bd6DwxGnRR51JM9js+gDO7shrsT5o6j
         HuBA==
X-Gm-Message-State: AGi0PubIbvkx3u63Ov8jc0m9L6R01/8vseGJ2h5pmx7ta85lehq+XH3q
        cJEmlQKUEbJUk4K7ywWh6qg=
X-Google-Smtp-Source: APiQypLh5e6poq/yrcZYnImM4ZAM2Jm3RbN6bwfMIzYsZ3NnHiYuEG47OwMQ8AGBbM1pYq4DBZCdVQ==
X-Received: by 2002:a17:902:b598:: with SMTP id a24mr14304324pls.63.1587821715936;
        Sat, 25 Apr 2020 06:35:15 -0700 (PDT)
Received: from nishad ([106.51.232.103])
        by smtp.gmail.com with ESMTPSA id nm22sm7038441pjb.38.2020.04.25.06.35.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 25 Apr 2020 06:35:15 -0700 (PDT)
Date:   Sat, 25 Apr 2020 19:05:09 +0530
From:   Nishad Kamdar <nishadkamdar@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Joe Perches <joe@perches.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: Use the correct style for SPDX License Identifier
Message-ID: <20200425133504.GA11354@nishad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch corrects the SPDX License Identifier style in
header files related to XFS File System support.
For C header files Documentation/process/license-rules.rst
mandates C-like comments (opposed to C source files where
C++ style should be used).

Changes made by using a script provided by Joe Perches here:
https://lkml.org/lkml/2019/2/7/46.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
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
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 72b3468b97b1..97fe14f7224a 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
index 35bbd978c272..68473e50fce3 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 9b373dcf9e34..e6f81df47304 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 668ee942be22..184f610bda35 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index e3400c9c71cd..061ea55e99ff 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 3bf671637a91..8a496865c066 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index b2113b17e53c..44f95a55c969 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 209795539c8d..fea2b39ffcc6 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
index 69dc515db671..2a3a3de25fde 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.h
+++ b/fs/xfs/libxfs/xfs_refcount_btree.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index abe633403fd1..79cff528f12c 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index 115c3455a734..03994234c138 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2014 Red Hat, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 92465a9a5162..67b61ffc3a88 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index c45acbd3add9..cab93df941e4 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * Copyright (c) 2013 Red Hat, Inc.
diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
index 7241ab28cf84..2d162a45a67d 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index 88221c7a04cc..df7296eef2d4 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 397d94775440..b0d3d1c016c6 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/mrlock.h b/fs/xfs/mrlock.h
index 79155eec341b..9d48729a295e 100644
--- a/fs/xfs/mrlock.h
+++ b/fs/xfs/mrlock.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index 900646b72de1..e023a5da5b59 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
diff --git a/fs/xfs/scrub/btree.h b/fs/xfs/scrub/btree.h
index 5572e475f8ed..11a7d85d8589 100644
--- a/fs/xfs/scrub/btree.h
+++ b/fs/xfs/scrub/btree.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * Copyright (C) 2017 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 2e50d146105d..e229ae0058d5 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * Copyright (C) 2017 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
diff --git a/fs/xfs/scrub/dabtree.h b/fs/xfs/scrub/dabtree.h
index 1f3515c6d5a8..930fedadbf82 100644
--- a/fs/xfs/scrub/dabtree.h
+++ b/fs/xfs/scrub/dabtree.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * Copyright (C) 2017 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
diff --git a/fs/xfs/scrub/health.h b/fs/xfs/scrub/health.h
index d0b938d3d028..94b361a55210 100644
--- a/fs/xfs/scrub/health.h
+++ b/fs/xfs/scrub/health.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * Copyright (C) 2019 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 04a47d45605b..3654497c19f5 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index ad1ceb44a628..abfae0f326f7 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * Copyright (C) 2017 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index e46f5cef90da..fd178a54015e 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * Copyright (C) 2017 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
diff --git a/fs/xfs/scrub/xfs_scrub.h b/fs/xfs/scrub/xfs_scrub.h
index 2897ba3a17e6..1f3277bb5258 100644
--- a/fs/xfs/scrub/xfs_scrub.h
+++ b/fs/xfs/scrub/xfs_scrub.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * Copyright (C) 2017 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
diff --git a/fs/xfs/xfs.h b/fs/xfs/xfs.h
index f6ffb4f248f7..d8b47f5e5949 100644
--- a/fs/xfs/xfs.h
+++ b/fs/xfs/xfs.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
index c042c0868016..6c369d1b424f 100644
--- a/fs/xfs/xfs_acl.h
+++ b/fs/xfs/xfs_acl.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2001-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index e0bd68419764..0451b9142cae 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2005-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
index ad479cc73de8..4aa0317f759c 100644
--- a/fs/xfs/xfs_bmap_item.h
+++ b/fs/xfs/xfs_bmap_item.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 9f993168b55b..c3193c5777b6 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 9a04c53c2488..40ebad228431 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 30114b510332..afd823495575 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index fe3e46df604b..303d31ad40dd 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_dquot_item.h b/fs/xfs/xfs_dquot_item.h
index 2b86a43d7ce2..69ab72056724 100644
--- a/fs/xfs/xfs_dquot_item.h
+++ b/fs/xfs/xfs_dquot_item.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2003 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 1717b7508356..afefe1eed419 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_export.h b/fs/xfs/xfs_export.h
index 64471a3ddb04..5efc62f15bd0 100644
--- a/fs/xfs/xfs_export.h
+++ b/fs/xfs/xfs_export.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index 990ab3891971..daff5522ce70 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
  * Copyright (c) 2010 David Chinner.
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index 16aaab06d4ec..bc2147c43dbe 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_filestream.h b/fs/xfs/xfs_filestream.h
index 5cc7665e93c9..af23117808d0 100644
--- a/fs/xfs/xfs_filestream.h
+++ b/fs/xfs/xfs_filestream.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2006-2007 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_fsmap.h b/fs/xfs/xfs_fsmap.h
index c6c57739b862..56a4209b3a4f 100644
--- a/fs/xfs/xfs_fsmap.h
+++ b/fs/xfs/xfs_fsmap.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * Copyright (C) 2017 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index 92869f6ec8d3..6ae609e44c16 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 48f1fd2bb6ad..bb9e28d1bea6 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_icreate_item.h b/fs/xfs/xfs_icreate_item.h
index a50d0b01e15a..6bf905409447 100644
--- a/fs/xfs/xfs_icreate_item.h
+++ b/fs/xfs/xfs_icreate_item.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2008-2010, Dave Chinner
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index c6a63f6764a6..5d1b98e53f11 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 07a60e74c39c..2c54fff9f05a 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index bab6a5a92407..37a989521d40 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2008 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_ioctl32.h b/fs/xfs/xfs_ioctl32.h
index 053de7d894cd..7577f76b72c3 100644
--- a/fs/xfs/xfs_ioctl32.h
+++ b/fs/xfs/xfs_ioctl32.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2004-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 7d3703556d0e..8678f6cc398b 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2003-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_iops.h b/fs/xfs/xfs_iops.h
index 4d24ff309f59..4f351dfca5bb 100644
--- a/fs/xfs/xfs_iops.h
+++ b/fs/xfs/xfs_iops.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index 96a1e2a9be3f..2361437cbd4d 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2001 Silicon Graphics, Inc.  All Rights Reserved.
  */
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 9f70d2f68e05..ae1e3e662690 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 1412d6993f1e..3f7b51c79280 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index ec22c7a3867f..0949a3a3bc81 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b2e4598fdf7d..ef02c3303afe 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_mru_cache.h b/fs/xfs/xfs_mru_cache.h
index f1fde1ecf730..afed2815ffa9 100644
--- a/fs/xfs/xfs_mru_cache.h
+++ b/fs/xfs/xfs_mru_cache.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2006-2007 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 5f04d8a5ab2a..af6e4c74ffe9 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2016 Oracle.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 4e57edca8bce..f9c593515fc7 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index aa8fc1f55fbd..907a8ec17ec4 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
index e47530f30489..73d7f8134eef 100644
--- a/fs/xfs/xfs_refcount_item.h
+++ b/fs/xfs/xfs_refcount_item.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 3e4fd46373ab..68f25e9ade2a 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
index 8708e4a5aa5c..da9de7662bfa 100644
--- a/fs/xfs/xfs_rmap_item.h
+++ b/fs/xfs/xfs_rmap_item.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 93e77b221355..47573fc80ddc 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index 34d704f703d2..4c44a5725612 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
index b552cf6d3379..a5cd53e0277a 100644
--- a/fs/xfs/xfs_super.h
+++ b/fs/xfs/xfs_super.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_symlink.h b/fs/xfs/xfs_symlink.h
index b1fa091427e6..40052fc1e649 100644
--- a/fs/xfs/xfs_symlink.h
+++ b/fs/xfs/xfs_symlink.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2012 Red Hat, Inc. All rights reserved.
  */
diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
index 8abf4640f1d5..c1a59e5a81ca 100644
--- a/fs/xfs/xfs_sysctl.h
+++ b/fs/xfs/xfs_sysctl.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2001-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_sysfs.h b/fs/xfs/xfs_sysfs.h
index e9f810fc6731..56676cd7fe8b 100644
--- a/fs/xfs/xfs_sysfs.h
+++ b/fs/xfs/xfs_sysfs.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2014 Red Hat, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a4323a63438d..ecb0036c9436 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2009, Christoph Hellwig
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 752c7fef9de7..e127e7d0bf67 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 35655eac01a6..0005021f7f6a 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2000,2002,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
-- 
2.17.1

