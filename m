Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13DAAC55179
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 10:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADAF12076E
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 10:14:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UVeSNATr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgJ2KO1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 06:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgJ2KO0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 06:14:26 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA853C0613D2
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 03:14:26 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id w21so1935502pfc.7
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 03:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XmdKpghfLeanbz+IwL0BYKqdxi1X0QN/uaPdOmARGkM=;
        b=UVeSNATrgODuiZ5B98OOFXRTDsdUjNgOaN8BMXIg/+3xAxmzx//olhnrzT2lXWDeL9
         o5o8yObd2k3fubOxdSjIRRa/BVmec24qA5U9MpvQ/VSSulqa9GlVixo8DQNZSxdDOUEi
         4FZnRTvrASGlMhnl/+WwtVDcNcmJCD8mj3zjaT+4sAOUHvb1walCL/bJFX6tRIbvc6XG
         ZT6rrCntjlknR/2+rXjTOFChfTB3tTAwhsLRN2CNU3/xfegI9wSYZ08Isrq7e9+N98SJ
         z3A78faMbidRjM6p4zYUyiIvF1cwOOMcfFEe0EsRnIRZVd6Hd2ksCNJubJx4ubPuDati
         48Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XmdKpghfLeanbz+IwL0BYKqdxi1X0QN/uaPdOmARGkM=;
        b=n0jW7FLT7AU6Xmu7KGC/izGKTPxD6cpFRfbD4mX4sCtYfKWe2BWNjXTWGa1fYm0ClW
         5FPC8J5MsY3GpOFg/BcUlQunV3cDVdjl+7fuaqxFbNOqV6gg4KWqkA40HbnX2Y2Ie1yO
         SQvnaUejehIMt/sYiIwAC3yYdlLgTYG0SFFc4x24PwjkUq5QLkx+tpcdNnkvrNZq1h4x
         NTHv/w4JNHtnd0REQOzfqvZSM5cARUJCeOIKFsC9q4I1fE6MBlo0FzxwvfqCbXcO1k0j
         n4g+M1km5OQNqzFp+/J4dspxtmYdf3zk8E6CO+5aiTN54zbdO4pAn5ZHG0wyCOvPluGF
         a+kg==
X-Gm-Message-State: AOAM531muIiqqGkkUYljio1J80d1ui5Nyo0YBJpSzlRnlt5aaCH7pQvh
        xT7UMs3yOscAMv/G9qgz1jQnuwDJcys=
X-Google-Smtp-Source: ABdhPJz5NRn0u8ndcjUVVhjORlhJNimJrRmapcRm4lXaQM9BqXpiXjsYO41svHhWLNCgLZ0+mZ/7/A==
X-Received: by 2002:a63:5f05:: with SMTP id t5mr3337233pgb.172.1603966466045;
        Thu, 29 Oct 2020 03:14:26 -0700 (PDT)
Received: from localhost.localdomain ([122.179.67.57])
        by smtp.gmail.com with ESMTPSA id s9sm2488073pfh.67.2020.10.29.03.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:14:25 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com, Christoph Hellwig <hch@lst.de>
Subject: [PATCH V8 01/14] xfs: Add helper for checking per-inode extent count overflow
Date:   Thu, 29 Oct 2020 15:43:35 +0530
Message-Id: <20201029101348.4442-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029101348.4442-1-chandanrlinux@gmail.com>
References: <20201029101348.4442-1-chandanrlinux@gmail.com>
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

