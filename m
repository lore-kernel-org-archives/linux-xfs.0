Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE465C4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Oct 2023 21:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjJ3VAT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Oct 2023 17:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjJ3VAS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Oct 2023 17:00:18 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07484E1
        for <linux-xfs@vger.kernel.org>; Mon, 30 Oct 2023 14:00:16 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1cc394f4cdfso12987655ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 30 Oct 2023 14:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1698699615; x=1699304415; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2Z3wPKwpvaT4TNMgb9jdr7QW/sfxwpkVZxLgfN5BY4M=;
        b=so1JsiX4C4v9x/1tulHXUOzghOa1SqoRjQLW7/lKKRy4FW9at8CUKmNUIY71lRZLpz
         SJQ/OrDLnOlNgMIzrP51YKBGE9ONghFH+hAV/00TAz605SArzHonLsi+B5qpBzkVvFKW
         V2PZt42jIqvxq1AblFw0YRXqyUkpasMw73nC0T4lfQaSHH4DUi5J5jjtSWA4ut3ch5By
         5t0Nqgib1SzUoq4FFUc9JtgiC82muVD30cxIawyYAaPvKRepvozu+4GBZgvrkQyRCoW7
         Bs436LTCbi6jNQZDrMFS0RlO5lbWxkXcH6cDiDIWht8zSjORWgsE95RTpW6+IYPh9y0k
         hVQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698699615; x=1699304415;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Z3wPKwpvaT4TNMgb9jdr7QW/sfxwpkVZxLgfN5BY4M=;
        b=Sr4R4/oq60dyhUex74iX7w0O7gZ2J1bfAHo0eSTDOMb1knCY68k5JNr9YQL1yw8PEp
         uMkw9ozeIDb+DelOMnerMJL4VA8o1M17LLyGqrxzTPtBHyIHQIF5HZ3STQnniyRSnl0f
         avsLvXpfj+5CGgSQhRDzaRZt4pTWI6PYSZ1LGCOFQxqmoVwgcrXvEUr6n6dXCCY9j1yH
         KPTKFfqg3BguvvlVwE+Gc3O6EyEuIxE5qG21IIOjwq85DceY5/hpM40jT2T1Hj9Pa9SG
         sSZN6kf/uIn3v2JwFo8GBRojfEwMy+kr/dc1t6OeLZbjnf9+FmQ3p4JVnAzuZ9ORGWv5
         WDrw==
X-Gm-Message-State: AOJu0Yx0b7djsrlA9ETILxTM5eCWvL8H69EEqHtifAQ7ITW3celGIGd6
        6CB9AYU/PmA4Vlpbn3qkkhptGLf1LH3dYxTGafQ=
X-Google-Smtp-Source: AGHT+IFo2oYacMWMoK/mC0AdKNooX3zqTWB3wEkpYtBA8zS1+KXhsOAcpHXzTGQcv94e9iUQrwh5kQ==
X-Received: by 2002:a17:902:f28b:b0:1ca:8169:e853 with SMTP id k11-20020a170902f28b00b001ca8169e853mr7524062plc.4.1698699614842;
        Mon, 30 Oct 2023 14:00:14 -0700 (PDT)
Received: from telecaster.thefacebook.com ([2620:10d:c090:500::4:49f])
        by smtp.gmail.com with ESMTPSA id s9-20020a170902ea0900b001cc5d23275csm953323plg.200.2023.10.30.14.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 14:00:14 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-xfs@vger.kernel.org
Cc:     kernel-team@fb.com, "Darrick J . Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v2] xfs: fix internal error from AGFL exhaustion
Date:   Mon, 30 Oct 2023 14:00:02 -0700
Message-ID: <68cd85697855f686529829a2825b044913148caf.1698699188.git.osandov@fb.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

We've been seeing XFS errors like the following:

XFS: Internal error i != 1 at line 3526 of file fs/xfs/libxfs/xfs_btree.c.  Caller xfs_btree_insert+0x1ec/0x280
...
Call Trace:
 xfs_corruption_error+0x94/0xa0
 xfs_btree_insert+0x221/0x280
 xfs_alloc_fixup_trees+0x104/0x3e0
 xfs_alloc_ag_vextent_size+0x667/0x820
 xfs_alloc_fix_freelist+0x5d9/0x750
 xfs_free_extent_fix_freelist+0x65/0xa0
 __xfs_free_extent+0x57/0x180
...

This is the XFS_IS_CORRUPT() check in xfs_btree_insert() when
xfs_btree_insrec() fails.

After converting this into a panic and dissecting the core dump, I found
that xfs_btree_insrec() is failing because it's trying to split a leaf
node in the cntbt when the AG free list is empty. In particular, it's
failing to get a block from the AGFL _while trying to refill the AGFL_.

If a single operation splits every level of the bnobt and the cntbt (and
the rmapbt if it is enabled) at once, the free list will be empty. Then,
when the next operation tries to refill the free list, it allocates
space. If the allocation does not use a full extent, it will need to
insert records for the remaining space in the bnobt and cntbt. And if
those new records go in full leaves, the leaves (and potentially more
nodes up to the old root) need to be split.

Fix it by accounting for the additional splits that may be required to
refill the free list in the calculation for the minimum free list size.

P.S. As far as I can tell, this bug has existed for a long time -- maybe
back to xfs-history commit afdf80ae7405 ("Add XFS_AG_MAXLEVELS macros
...") in April 1994! It requires a very unlucky sequence of events, and
in fact we didn't hit it until a particular sparse mmap workload updated
from 5.12 to 5.19. But this bug existed in 5.12, so it must've been
exposed by some other change in allocation or writeback patterns. It's
also much less likely to be hit with the rmapbt enabled, since that
increases the minimum free list size and is unlikely to split at the
same time as the bnobt and cntbt.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
Changes since v1 [1]:

- Updated calculation to account for internal nodes that may also need
  to be split.
- Updated comments and commit message accordingly.

1: https://lore.kernel.org/linux-xfs/ZTrSiwF7OAq0hJHn@dread.disaster.area/T/

 fs/xfs/libxfs/xfs_alloc.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 3069194527dd..3949c6ad0cce 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2275,16 +2275,35 @@ xfs_alloc_min_freelist(
 
 	ASSERT(mp->m_alloc_maxlevels > 0);
 
+	/*
+	 * For a btree shorter than the maximum height, the worst case is that
+	 * every level gets split and a new level is added, then while inserting
+	 * another entry to refill the AGFL, every level under the old root gets
+	 * split again. This is:
+	 *
+	 *   (current height + 1) + (current height - 1)
+	 * = (new height)         + (new height - 2)
+	 * = 2 * new height - 2
+	 *
+	 * For a btree of maximum height, the worst case is that every level
+	 * under the root gets split, then while inserting another entry to
+	 * refill the AGFL, every level under the root gets split again. This is
+	 * also:
+	 *
+	 *   2 * (new_height - 1)
+	 * = 2 * new height - 2
+	 */
+
 	/* space needed by-bno freespace btree */
 	min_free = min_t(unsigned int, levels[XFS_BTNUM_BNOi] + 1,
-				       mp->m_alloc_maxlevels);
+				       mp->m_alloc_maxlevels) * 2 - 2;
 	/* space needed by-size freespace btree */
 	min_free += min_t(unsigned int, levels[XFS_BTNUM_CNTi] + 1,
-				       mp->m_alloc_maxlevels);
+				       mp->m_alloc_maxlevels) * 2 - 2;
 	/* space needed reverse mapping used space btree */
 	if (xfs_has_rmapbt(mp))
 		min_free += min_t(unsigned int, levels[XFS_BTNUM_RMAPi] + 1,
-						mp->m_rmap_maxlevels);
+						mp->m_rmap_maxlevels) * 2 - 2;
 
 	return min_free;
 }
-- 
2.41.0

