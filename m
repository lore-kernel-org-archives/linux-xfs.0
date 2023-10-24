Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D743C07545
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Oct 2023 23:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344604AbjJXXhs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Oct 2023 19:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343883AbjJXXhs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Oct 2023 19:37:48 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FF610D1
        for <linux-xfs@vger.kernel.org>; Tue, 24 Oct 2023 16:37:43 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-5b8c39a2dceso1875762a12.2
        for <linux-xfs@vger.kernel.org>; Tue, 24 Oct 2023 16:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1698190662; x=1698795462; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pEXTJasS7lMVWqiykpP08AID7S+AxarKOST+NJtixKY=;
        b=NzLAaLi2AKV9HYI8+5f0e7s5iC1DioAGuTahKrXAZBi14wcSeE8gAMltOBks2IpQ9x
         Uo25dCTQkl4LKm+x9vQWPm8UCr2iiUaD5ZZ3uFQF6dPwHidCL7Tu6JoDhQ11XpKYQTub
         GduR7WbNjOdd/Wox48Kh+WCJyKD8FGiQpPs7MM61Bx1GUqrMhnS4TBnHIS4/gYJzryoB
         eF5A+XPui/ZDaDT3BLyzyk21OcZEPmUhkua5HfHJQkwDUSHAMM/Lzgh3fLZQXXtUp79E
         gKw33OwmJEwPVdJhX7AMNolm5Ku9pHUueQUFBIFkBog0MpZU2cV0Bb40sE2mJw8m4fZp
         YKtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698190662; x=1698795462;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pEXTJasS7lMVWqiykpP08AID7S+AxarKOST+NJtixKY=;
        b=kU8E8Bucowg1gNY8T8JZpHNNVlIzdS+7kLdQS0Dsn06c70i8WpV2haxtKmvf8tC2aO
         qjIXsOSmwg8dGeTPUo6wuGjKoHpnjCM0t5eXYsQad40fPCGxCGpdrynvOq5WlymKzkFX
         UDkt+C3YsfzNNjjj/QidQe+Mx6Lh1pt1YK1kWBgO3ciMwnozdJ51OXf6hl20Mv86CFZI
         F34/ONQ8CzytgDQCpTEo7vJAVPNYCimq7ZXbPHMqmNsdGcjXOfJzhPaJCsd/G5DP8VNn
         UJexb4CUD4IEeuuUb+Z21DDX7V+Qwq3Q6MjkNzJ7/0+q6YdqfmH3Uie1H7a1Z+x9EuJ9
         mtfg==
X-Gm-Message-State: AOJu0Yw1XuH1t+hQiekjnzRJTeT2ewYi5Ot8b6VsgxofzeO3wh/fILEr
        4FFa7rji/I5CU8ao9TgkVkyZbGZSvqdavWcygRQ=
X-Google-Smtp-Source: AGHT+IFocuIfpcJbcMwhwAy2Sj5VUpE2Kjt5/VKHpYoP2ZdNrAZTE1eWmKj3Zqo/LiqwfEZLFrgGUA==
X-Received: by 2002:a05:6a21:7189:b0:15d:8409:8804 with SMTP id wq9-20020a056a21718900b0015d84098804mr3661219pzb.57.1698190662096;
        Tue, 24 Oct 2023 16:37:42 -0700 (PDT)
Received: from telecaster.hsd1.wa.comcast.net ([2620:10d:c090:400::4:4dbb])
        by smtp.gmail.com with ESMTPSA id e1-20020a630f01000000b005b856fab5e9sm7631127pgl.18.2023.10.24.16.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 16:37:41 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-xfs@vger.kernel.org
Cc:     kernel-team@fb.com
Subject: [PATCH] xfs: fix internal error from AGFL exhaustion
Date:   Tue, 24 Oct 2023 16:37:33 -0700
Message-ID: <013168d2de9d25c56fe45ad75e9257cf9664f2d6.1698190191.git.osandov@fb.com>
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

Our filesystems don't have the rmapbt enabled, so if both the bnobt and
cntbt are 2 levels, the free list is 6 blocks. If a single operation
causes both the bnobt and cntbt to split from 2 levels to 3 levels, this
will allocate 6 new blocks and exhaust the free list. Then, when the
next operation tries to refill the freelist, it allocates space. If the
allocation does not use a full extent, it will need to insert records
for the remaining space in the bnobt and cntbt. And if those new records
go in full leaves, the leaves need to be split. (It's guaranteed that
none of the internal nodes need to be split because they were just
split.)

Fix it by adding an extra block of slack in the freelist for the
potential leaf split in each of the bnobt and cntbt.

P.S. As far as I can tell, this bug has existed for a long time -- maybe
back to xfs-history commit afdf80ae7405 ("Add XFS_AG_MAXLEVELS macros
...") in April 1994! It requires a very unlucky sequence of events, and
in fact we didn't hit it until a particular sparse mmap workload updated
from 5.12 to 5.19. But this bug existed in 5.12, so it must've been
exposed by some other change in allocation or writeback patterns.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
Hi,

This patch is based on v6.6-rc7. I've also replied with a regression
test for fstests.

Thanks,
Omar

 fs/xfs/libxfs/xfs_alloc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 3069194527dd..2cbcf18fb903 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2275,12 +2275,16 @@ xfs_alloc_min_freelist(
 
 	ASSERT(mp->m_alloc_maxlevels > 0);
 
-	/* space needed by-bno freespace btree */
+	/*
+	 * space needed by-bno freespace btree: one per level that may be split
+	 * by an insert, plus one more for a leaf split that may be necessary to
+	 * refill the AGFL
+	 */
 	min_free = min_t(unsigned int, levels[XFS_BTNUM_BNOi] + 1,
-				       mp->m_alloc_maxlevels);
-	/* space needed by-size freespace btree */
+				       mp->m_alloc_maxlevels) + 1;
+	/* space needed by-size freespace btree, same as above */
 	min_free += min_t(unsigned int, levels[XFS_BTNUM_CNTi] + 1,
-				       mp->m_alloc_maxlevels);
+				       mp->m_alloc_maxlevels) + 1;
 	/* space needed reverse mapping used space btree */
 	if (xfs_has_rmapbt(mp))
 		min_free += min_t(unsigned int, levels[XFS_BTNUM_RMAPi] + 1,
-- 
2.41.0

