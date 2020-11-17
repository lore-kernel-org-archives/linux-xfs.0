Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42F2C6379F
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 13:45:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8153724199
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 13:45:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ol2YuILF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733188AbgKQNow (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Nov 2020 08:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733185AbgKQNov (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Nov 2020 08:44:51 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5337C0617A6
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 05:44:51 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id 81so7717493pgf.0
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 05:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XmdKpghfLeanbz+IwL0BYKqdxi1X0QN/uaPdOmARGkM=;
        b=ol2YuILF0ncOBz3+Zamh0fkdCq2//KkMrEdD+PHM5Yo5I0MfyTxvZPB/ime1DTj7vq
         HbgCndbVU3CKxHTYCCF2Zs/m9NBtForwPNwd1/fZ9XXD6Xob1LkqMJkm1pe79iRMkE/t
         v2KzbsL8IulZua7naW9Au3vcX+dB9Rywg5kIokEHxk7FoK71w/jnunup+a4GOsRraOgt
         UjJIUDo9/CphZciO26qQmgqfAJZfsijVmpm21xb3AUTYmh53ksqjLdiUXKvrSRGKeG56
         f4Mn66ejIAtH3HytYedN/hJcaaeDzjSB6QckRYULpYaBdgP4+zhk3ow+PiPvmME8IhF+
         39JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XmdKpghfLeanbz+IwL0BYKqdxi1X0QN/uaPdOmARGkM=;
        b=hArtQgECtMgiCkmr5/bYvwiLhuMgxcvxepWwLtySPMpkSYxS56pktemrSHxT23ti5m
         V3y2uRQg4qBlrNQ+Br9oSRRDe0ztELy4Da7NOv8xuPJVVv6IXpxiQHKTcAxScVJNJfFg
         QdIIHwgUcZTHGB8++9dj63IZq2QBeaKdIr78zOLGQVf53ATWs9i7vUyAApZoNUHutNF/
         nVIEr0SSy+Ks+w6L28nOzB5z73p1upkNenKfuv4C7BkuA9pt8xqWh8s9OYGEXx2mMYZt
         a6z88RV2nhxtTEgIXWnb3kGSlLaPHcX+dBXdY0HrTzNvtJD3/GtTw3bvVokKYA2wccRp
         l7NQ==
X-Gm-Message-State: AOAM533rYFnsUl57wzMpZqjOG3fYqp0fquHHkRVT/8TDGT8buLeE8C05
        74ODio1ftt/eUoPTOzHocfrwY6iGMAk=
X-Google-Smtp-Source: ABdhPJzv+aovbgg7GLS4z15ytL3kZMLp1U8elvj15ETlJniuHSopxBGqQWrSr3y6HEGLO9bY2Llk+g==
X-Received: by 2002:a63:f84d:: with SMTP id v13mr3550851pgj.234.1605620691039;
        Tue, 17 Nov 2020 05:44:51 -0800 (PST)
Received: from localhost.localdomain ([122.179.49.210])
        by smtp.gmail.com with ESMTPSA id y3sm3669399pjb.18.2020.11.17.05.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 05:44:50 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        Allison Henderson <allison.henderson@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH V11 01/14] xfs: Add helper for checking per-inode extent count overflow
Date:   Tue, 17 Nov 2020 19:14:03 +0530
Message-Id: <20201117134416.207945-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117134416.207945-1-chandanrlinux@gmail.com>
References: <20201117134416.207945-1-chandanrlinux@gmail.com>
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
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

