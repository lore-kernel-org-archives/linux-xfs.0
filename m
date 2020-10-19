Return-Path: <SRS0=Yj0O=D2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82E4FC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 06:41:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32BBD22260
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 06:41:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QkqG+KLH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgJSGlO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Oct 2020 02:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgJSGlO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Oct 2020 02:41:14 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DC5C061755
        for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2020 23:41:14 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id hk7so5093072pjb.2
        for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2020 23:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=muy6wMcrNuR8gPubUATlN8GUSP+GDUcpmrnL7WzPYjQ=;
        b=QkqG+KLHJJNKXdJlYH3bpbcqyr6xCf39QSCv+PfG8dp3JteooL8alQayrNd3CbhTeF
         85NI3bOAQ9GjYTlK4Qhs3RoUbI5gMMHrBKmtJzN4b6kpCI3XkuLwRi3I9oSCeVmZpT0L
         nreKdao2Mc6AHkyr9lvVb026Szp5mMDjc9sWlBMcHHBuSJVIm2aTIOKxerDipylbR0BD
         LJzmnhDPrhnZBPvwPmVeTA6ZKKlbJg+SFbVb5C7XecvmSm+uAzghJy1brpyY9Z4wo+Ds
         D+Oz9r5e1StbhBuo2g1YDWyFpt7CszRQHOFeFhzUwM5ZrVlqrPlj4ACFIbFD2Q1NgBDj
         3FRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=muy6wMcrNuR8gPubUATlN8GUSP+GDUcpmrnL7WzPYjQ=;
        b=jIDuAu9ix080pa0jjhGp6L+lq96arbE+0znc0U4noEOHvp9CTTdOB98y+eq4jT0p8F
         5QrloL9UrQKtgMAzkH+QA88EhD5lj8NpQYv7kNhfevhJNIBj4Py4741917JO2N8qXUXm
         1dLF6q2XZEVLlqc7RSed4yetqeloufl3pxmfk/xpkdFwgdaST/XPRih5mC+/1zIQisbw
         1palE/OikVcIoT7MZuyW6UsIeD/UvW2gPULsr3nDWv7hCuQQ2UDmN99J31Ixru42P+dg
         P1mGDzFqgDGB6L2tuL7Q153s6fwDnHR/wn9WXsgOl34gWkB+Q8iG02qurXQLJyjHrQwY
         OZXQ==
X-Gm-Message-State: AOAM532JIaYHStleH/bTldsarhmTdIJBa+sCud2wbgFi0yTEZcR3sDd0
        r5WDacPAFBnf7ttP03wQaZ+fphySFjc=
X-Google-Smtp-Source: ABdhPJz3AWRPjycVjrsz2AKwSCM8q8JTAX8u7qJxNf3vwIlouqjOWBTI68WQ68dw+RrS1/tOoBVCdA==
X-Received: by 2002:a17:90a:cb91:: with SMTP id a17mr15505424pju.220.1603089673743;
        Sun, 18 Oct 2020 23:41:13 -0700 (PDT)
Received: from localhost.localdomain ([122.179.121.224])
        by smtp.gmail.com with ESMTPSA id w74sm11164189pff.200.2020.10.18.23.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 23:41:13 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH V7 01/14] xfs: Add helper for checking per-inode extent count overflow
Date:   Mon, 19 Oct 2020 12:10:35 +0530
Message-Id: <20201019064048.6591-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201019064048.6591-1-chandanrlinux@gmail.com>
References: <20201019064048.6591-1-chandanrlinux@gmail.com>
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

