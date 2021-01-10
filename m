Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 186C5C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:30:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCE5F229EF
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:30:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbhAJDaZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 22:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbhAJDaY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 22:30:24 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6BFC06179F
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jan 2021 19:29:44 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id g3so7748598plp.2
        for <linux-xfs@vger.kernel.org>; Sat, 09 Jan 2021 19:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UajVql0+fX8/PSAE042XQ9DAknMby2LMCreHtOKK9j0=;
        b=b6NVTV1QqZmWwigPTR7SRWNUpxT9yFQVYU5USqU5ShDholW0FCCm0YDPLuUyIiD/x9
         GNNI+MnxTbuk89ZmpAK/75Yw7HpAwGV0Mn+qVjQK1lEvyMBucv2CFh1/uZ+vmzzxuNZa
         C1BSGgWFf3tNfO0OI9Orjt+n/nVSXqYlDf5HXt3A5pOwQRNJbb9lwksi5OqY1vLTLqAw
         nbnwdB0XlhHUv5SaDuLyswTRmBM6LP78LS1DtasYKx3AwPLuzCrWGJ/rvOUEa5YKO1qh
         terx32Rngk9XVJ9EWOp/YtlxJKMTUgYu1Z6KUF6g3Z58FGKMu0zLJtA5D4pfL1U9qzM6
         V0Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UajVql0+fX8/PSAE042XQ9DAknMby2LMCreHtOKK9j0=;
        b=X2fMeMOz4suxeCKLxLu4KhaXQqhuBWhMusF4jYygU0P8okSYH2vlv7sO58Eq42+mAm
         5fnuD+A1QXVL+X3zNbmV7dOPQcIMvlFe4r2X8rridgFBnQqmxgLUovc/ve7ZN0aPTkmx
         uOlMQDkcGYK/nor/WUWjFNmGT8bm2+HCelZT0qWMd7RvUaUUc+8mMnqpbvUPz/CVREuN
         7rxOlCNGNF6eBpzexQ9P277xFdR6yLx63yr90mguPwJVPIjnBvwkRtxX+oDOSKfkLYDg
         M9LeeOA4INx3UJ5OwR5Em26aMaobUS5UmrnrG4TvawjJEjXn3e5Ewx7Zww1rgs8r+Dpe
         c85Q==
X-Gm-Message-State: AOAM531a18LxLKnthlxie1uEmGjcjdZsuvjzlJDKUmtqq7DgRAxCGa00
        eHONuma5rdsL+AS1948xOfRNIeJLfWj3bw==
X-Google-Smtp-Source: ABdhPJwABx3AhfRoeHIWbvxsD0i4cFL2MaNDgzA7GUeT84Sfv25oVqxMXXeUb2qORXWVlFRpBUEqfw==
X-Received: by 2002:a17:902:ff0e:b029:da:d4ee:eca3 with SMTP id f14-20020a170902ff0eb02900dad4eeeca3mr10910918plj.41.1610249383940;
        Sat, 09 Jan 2021 19:29:43 -0800 (PST)
Received: from localhost.localdomain ([122.179.92.100])
        by smtp.gmail.com with ESMTPSA id x6sm14079861pfq.57.2021.01.09.19.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 19:29:43 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        djwong@kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V13 01/16] xfs: Add helper for checking per-inode extent count overflow
Date:   Sun, 10 Jan 2021 08:59:13 +0530
Message-Id: <20210110032928.3120861-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210110032928.3120861-1-chandanrlinux@gmail.com>
References: <20210110032928.3120861-1-chandanrlinux@gmail.com>
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
2.29.2

