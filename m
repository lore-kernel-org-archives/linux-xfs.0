Return-Path: <SRS0=hW3p=B6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07E83C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 05:44:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D75622075E
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 05:44:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s0WNr0Oo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgHTFoN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 01:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgHTFoL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 01:44:11 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53588C061757
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2020 22:44:10 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id g33so631871pgb.4
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2020 22:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TAmXYEMXGu7IwTZlJVbpCTIERA0KfgjTZYIkKIzuPJY=;
        b=s0WNr0OoFDT+rIanjV+BDjD4yn0SyETBeA+vh/xkN0zeP/I4YbdplzYvDGsW6pKvmk
         NdTgirwiIobEO+pjJBUZdkM6uQNrAErtObKn2ObcicLY8dRvZp2TdbN+5DFPsEOGKBKf
         Muu5M2WLmSkcfhFg3fWusWI6jK/uj4xCnGaI94r8wtRJsnwiDQv5LSQ7/xDd/ch91I29
         uMGBFrgEj26lki/XKYkQ2PWUQe0RkG7K4mghzv/kCXQY1QwEpmv4P7xc4bB9M1eKlxpu
         0NA0vp970NH9j7LvFNLHIgof6R5yyqvlzC2KgP8giL9UnKaDGTG7cUT1egNvyv2nIpGV
         Oo0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TAmXYEMXGu7IwTZlJVbpCTIERA0KfgjTZYIkKIzuPJY=;
        b=lz45PfUTzVgfP6ZEplkAFCrryAjEZkaXOfdTdUPoCulz0iGvMWT4mRMTRfm/IZ55aT
         +9LM+8cRtA95vNrPch8zKuO2tf4ZAmek50BXOhUXGV2OdVOaPPKjBrzLOTwQg6TvZPif
         aiTMsqlOvRVfjpurr6BAnpSwT31ed+CR3ihXiKBsBGe/J5pTuDwV08HT+jdH1xFLojGS
         t6yBQdY0DB1pBhntCun5lEoKDSTGai0A1MmrfWMs25ORCtR0dc+RtB13pPJb/HQwqn5L
         ITBENMWKDb7IhVN+SKd3NM1hLMjGEdycR9kZM+isfmy1GyMwP9khE7kT7C38j7Q3Mw2O
         jmKA==
X-Gm-Message-State: AOAM532mMLHCDg2Pi3fUgMPxgCusYzw8zcK/5jht+XBcPTMSa76VFOub
        1l7bWMuHKtVDogUbV8DRqsOGUP2arfQ=
X-Google-Smtp-Source: ABdhPJxSjUX7iFslp1Q3+Cnzdme4BmCtv4MezLh+1WHKgd2siUWboJsxOulnXaoHnoNdk6qrsw773Q==
X-Received: by 2002:aa7:9ac2:: with SMTP id x2mr1062084pfp.57.1597902249393;
        Wed, 19 Aug 2020 22:44:09 -0700 (PDT)
Received: from localhost.localdomain ([122.171.166.150])
        by smtp.gmail.com with ESMTPSA id l4sm1044034pgk.74.2020.08.19.22.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 22:44:08 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org
Subject: [PATCH V3 01/10] xfs: Add helper for checking per-inode extent count overflow
Date:   Thu, 20 Aug 2020 11:13:40 +0530
Message-Id: <20200820054349.5525-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820054349.5525-1-chandanrlinux@gmail.com>
References: <20200820054349.5525-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS does not check for possible overflow of per-inode extent counter
fields when adding extents to either data or attr fork.

For e.g.
1. Insert 5 million xattrs (each having a value size of 255 bytes) and
   then delete 50% of them in an alternating manner.

2. On a 4k block sized XFS filesystem instance, the above causes 98511
   extents to be created in the attr fork of the inode.

   xfsaild/loop0  2008 [003]  1475.127209: probe:xfs_inode_to_disk: (ffffffffa43fb6b0) if_nextents=98511 i_ino=131

3. The incore inode fork extent counter is a signed 32-bit
   quantity. However the on-disk extent counter is an unsigned 16-bit
   quantity and hence cannot hold 98511 extents.

4. The following incorrect value is stored in the attr extent counter,
   # xfs_db -f -c 'inode 131' -c 'print core.naextents' /dev/loop0
   core.naextents = -32561

This commit adds a new helper function (i.e.
xfs_iext_count_may_overflow()) to check for overflow of the per-inode
data and xattr extent counters. Future patches will use this function to
make sure that an FS operation won't cause the extent counter to
overflow.

Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.c | 23 +++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_fork.h |  2 ++
 2 files changed, 25 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 0cf853d42d62..3a084aea8f85 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -23,6 +23,7 @@
 #include "xfs_da_btree.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_attr_leaf.h"
+#include "xfs_types.h"
 
 kmem_zone_t *xfs_ifork_zone;
 
@@ -728,3 +729,25 @@ xfs_ifork_verify_local_attr(
 
 	return 0;
 }
+
+int
+xfs_iext_count_may_overflow(
+	struct xfs_inode	*ip,
+	int			whichfork,
+	int			nr_to_add)
+{
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	uint64_t		max_exts;
+	uint64_t		nr_exts;
+
+	if (whichfork == XFS_COW_FORK)
+		return 0;
+
+	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
+
+	nr_exts = ifp->if_nextents + nr_to_add;
+	if (nr_exts < ifp->if_nextents || nr_exts > max_exts)
+		return -EFBIG;
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index a4953e95c4f3..0beb8e2a00be 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -172,5 +172,7 @@ extern void xfs_ifork_init_cow(struct xfs_inode *ip);
 
 int xfs_ifork_verify_local_data(struct xfs_inode *ip);
 int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
+int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
+		int nr_to_add);
 
 #endif	/* __XFS_INODE_FORK_H__ */
-- 
2.28.0

