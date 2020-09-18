Return-Path: <SRS0=2mLC=C3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD132C43464
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 09:48:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B48221D7F
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 09:48:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iV48oUbk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgIRJsV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Sep 2020 05:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgIRJsU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Sep 2020 05:48:20 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83B2C06174A
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 02:48:20 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id d19so2738393pld.0
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 02:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xf86IZJ2O3sKEIprAhp2qWm7Jz8QBRKVGV3tBB+AcuY=;
        b=iV48oUbk2j7+9Z8b9usy5iCQmTA1zu+xJKI91RRykaOP2KAt6yzT6T8yU02j48qacR
         FmhRkFkWU/McwJenvMSiWXgnwyTGf0RGM2CUg7nNgIfhWNBJD64Vjkam9nhuTVNQilYA
         rbVxkIVtq6rvd71P3A9w9MsBfvswzL2RIqyTuErVCKUmvGbzoTnBHTQ08kbQAXm3jw+J
         94ohZRn6IA4vRPUBXyWcvRtj5wwlHWickrXFBjdXCOYQlGcFwQ0HIyGLY13YGGOYSRkv
         9eQONrOAJdIF+c6DAtQIROOSP8kae1j4Ss2hrRzZ8bFqTlXGZUasWbkmVq38dbOx+LFy
         rjtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xf86IZJ2O3sKEIprAhp2qWm7Jz8QBRKVGV3tBB+AcuY=;
        b=hGCGwBaa9E7jnuIZAXyMWJsFpcJwE8blHKhPJkz+Inf89nraULairluhuqhAHlaEvF
         i7VEhVGo0ptk+CRBIklGTa6TK7zj8rLs0zplCUyFAeeDfaOYuQ2RucuDDC5NynJX1OJo
         bj6cYM3RIKZtmJVv5lUtRBY+uBM3IUGqssNZa+FV3H36Gc8gLoVo366VOELd5LmA6ino
         mO+69d21lZFAHc/RG0A8KbsTC7mme2oOhLT5jhAHhJC7CSBwJkRdZw6oPw+YnYembNTZ
         l8gfyxR6/epqJQ0EJwUJegJc0hB0gvEu/FDC9tRaepkHz/X1rXw+TvVkkohEqD+QQg1V
         VAlQ==
X-Gm-Message-State: AOAM530zDyP3rDj6ngMb+J9Wt9dz3P7XUmvrSy4pR5LmzinZ+pUQpSrc
        Xjj7dXzTEy0KJOR/+DsWc7/eZwU99vI=
X-Google-Smtp-Source: ABdhPJyk4/4LicWM78uCSmxi+JSw33+DEkL0fk8ByzHlapnWtgkNP1nhO24YG2wBZc2appI+wuQEoA==
X-Received: by 2002:a17:90a:d18b:: with SMTP id fu11mr11911325pjb.203.1600422500046;
        Fri, 18 Sep 2020 02:48:20 -0700 (PDT)
Received: from localhost.localdomain ([122.179.62.164])
        by smtp.gmail.com with ESMTPSA id s24sm2227194pjp.53.2020.09.18.02.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 02:48:19 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V4 01/10] xfs: Add helper for checking per-inode extent count overflow
Date:   Fri, 18 Sep 2020 15:17:50 +0530
Message-Id: <20200918094759.2727564-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200918094759.2727564-1-chandanrlinux@gmail.com>
References: <20200918094759.2727564-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.c | 23 +++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_fork.h |  2 ++
 2 files changed, 25 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 7575de5cecb1..8d48716547e5 100644
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

