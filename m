Return-Path: <SRS0=fxM9=DK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 064F0C46466
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Oct 2020 05:56:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8D93206CA
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Oct 2020 05:56:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zes5p3Lc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725681AbgJCF4t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 3 Oct 2020 01:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJCF4t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Oct 2020 01:56:49 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14074C0613D0
        for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2020 22:56:49 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o25so2333689pgm.0
        for <linux-xfs@vger.kernel.org>; Fri, 02 Oct 2020 22:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xf86IZJ2O3sKEIprAhp2qWm7Jz8QBRKVGV3tBB+AcuY=;
        b=Zes5p3Lc+TfVvsaBO+U3bSPhZwN1NyTBvNP86tzo1QwtP27p7YdoNzxiiKQuK96w1Z
         TJPX2klXbE8C0LNF4cwUkUMtkTG+b7l2fgqEIPRMT/r/JTJkN4UCLZRXhL+ShQABK1IK
         cPMW+oqmZte99qdiYbcp2tzSqreOR4h5Jzq3wMTOMTwIdeGJtiYNKu4+2u28KFqDncqF
         WYZAiWUJvhyXJLBxVXKL2ucMnnDfEuV+ytxj3c7E1r7mQMmg/paP1sSbSGBbiNhYjBC1
         ltEyuqKERfjCtfxlxybLRt3PvxBqMqrZwSJ1aXwULtZlN43V919JHhBT2LWMPV3j3ECH
         77bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xf86IZJ2O3sKEIprAhp2qWm7Jz8QBRKVGV3tBB+AcuY=;
        b=dBumDLIE1JdvXLFQ1KlQbz43UIalb6javuJNgKS/NYqim9gai+v4xeJ/SZ0IvVTiqq
         5IGx3WHhwQ6/0AwrJ86QGAnwddK8eZI6c4YqWJNxoJlgf6sGviRfwxoks3Kauwfr03Qk
         Bl/DuJdCvxjt5nRElsX27I8ZPVQB12yHEoU3xMOcW0vvG0ah/sWdljOy5/GqJlB0waLX
         zfcr/zTgnjG6r0gFRcHU/OD/slezuEYeKsXQ9TAeBr77wg3hlrMVKZC/RUgjoZGLkcby
         VzmhJydKR+DU8rqw+MK24hSJ3N9+y1YRItyM5DcJNK4n76bbQ/J1n4x5JxhlGIP2FsjN
         +ylQ==
X-Gm-Message-State: AOAM530cYfacHfmPFOB0+755hgHzzK3J3ZJ8IbbQNuZFpOC8im5t9F/3
        YB3TtGhwMylc3BanRm/xpV+P8/84YCs=
X-Google-Smtp-Source: ABdhPJzen9JOGAAkE1oEpgv4CReHJ1V06RHPV4GTq6qDbf5eu242M6mvZ1gTQ1vv5c22OTodfwtrdw==
X-Received: by 2002:a63:ff4e:: with SMTP id s14mr5244711pgk.137.1601704608123;
        Fri, 02 Oct 2020 22:56:48 -0700 (PDT)
Received: from localhost.localdomain ([122.171.168.96])
        by smtp.gmail.com with ESMTPSA id 125sm4106664pff.59.2020.10.02.22.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 22:56:47 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V5 01/12] xfs: Add helper for checking per-inode extent count overflow
Date:   Sat,  3 Oct 2020 11:26:22 +0530
Message-Id: <20201003055633.9379-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201003055633.9379-1-chandanrlinux@gmail.com>
References: <20201003055633.9379-1-chandanrlinux@gmail.com>
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

