Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22AB6C43457
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 09:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9117208D5
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 09:30:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dwrnho29"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729399AbgJLJaK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 05:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729385AbgJLJaK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 05:30:10 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EECDC0613CE
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 02:30:09 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id l18so4588781pgg.0
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 02:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xf86IZJ2O3sKEIprAhp2qWm7Jz8QBRKVGV3tBB+AcuY=;
        b=dwrnho294tiL7R1Bl1BRXvCuBgC4XGh1ADb9+/2MHdLpBwKDASsvqGcNek5ki1HAAY
         ktTwZ9a+6FstxqgUEdYxB6/CDhTK2zZ08xtR+ZHA9IxKCIAbazJnBSw3n+TL9KMTUKmS
         r1rpJKcywWhNTuqZ2uCC8C/1BXpIoDpQrFj9MahJZh4Kcdljw1ry5GYenUytQQcq2wbD
         G0s44Z0JFNSOSb1e9Qtnb1h1znAb5mOrNo02QFCVYZonD+Ahh6p9MA1KjvUBp2QTP39v
         x69QmPFufR0m2s2QuWkladVloVzDfDV8D7eqggBE8d8As7Ofh4zJ1/dkHcC/orLLgrG1
         i+JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xf86IZJ2O3sKEIprAhp2qWm7Jz8QBRKVGV3tBB+AcuY=;
        b=Wllaez38HCU5EkiZJ1UudqpM0oqMG/pLYXeFlcIVw2gX3ZVVs9vIUyIem2Mkx/Eckl
         bh5RyieRbxnuUGGea9gtguMfvEJhiBDYKZNTXI75AD9fToajZuV4xBdpmHXwfx5TScmm
         xxWderD9FyvtiyYdPeR1Vr6x7o4E47cDffL7ukvFMtATlWY0gHum9DP63hI5+p+YhxxC
         dzSrVvm+bMVqNFqBU5NWVnZ7ZO9vnA3yKxEuAi2Bbs7hBV2aDyllxTUZGahMeL2vwbJS
         A1dL8NgZ25/UMWGN4ujxlLobQXwKVtdt1o8FOxhdlpG0c21FedEoRp8ZQUqM5pXdo/j5
         i1Vw==
X-Gm-Message-State: AOAM530Loiv2T0q+DaogI2BhiY28UGPeHaUDeLg9Zusi5W9OF0QsVCA2
        cAA7Qpe3en+/tqLaXvSWl2k7AdEjuZg=
X-Google-Smtp-Source: ABdhPJzKlu+26cCQs1KREC0/O4khzDO6tkeA5FeO4hvcutuMOL0u5etLIjVpefbeNfSUFNvRumkmCw==
X-Received: by 2002:a05:6a00:22d5:b029:155:c72b:50ce with SMTP id f21-20020a056a0022d5b0290155c72b50cemr8373655pfj.65.1602495008656;
        Mon, 12 Oct 2020 02:30:08 -0700 (PDT)
Received: from localhost.localdomain ([122.172.180.109])
        by smtp.gmail.com with ESMTPSA id z142sm19451985pfc.179.2020.10.12.02.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 02:30:08 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V6 01/11] xfs: Add helper for checking per-inode extent count overflow
Date:   Mon, 12 Oct 2020 14:59:28 +0530
Message-Id: <20201012092938.50946-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012092938.50946-1-chandanrlinux@gmail.com>
References: <20201012092938.50946-1-chandanrlinux@gmail.com>
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

