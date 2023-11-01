Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32F46C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Nov 2023 16:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbjKAQly (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Nov 2023 12:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbjKAQly (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2023 12:41:54 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84C3119
        for <linux-xfs@vger.kernel.org>; Wed,  1 Nov 2023 09:41:50 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 98e67ed59e1d1-2809fb0027cso18067a91.2
        for <linux-xfs@vger.kernel.org>; Wed, 01 Nov 2023 09:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1698856910; x=1699461710; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+HQu4Or3ihYEZWL6Sbg8MV4PBpkSeSfJ+coTzqGyWIg=;
        b=TqVtAn1oXUkQ6bMIW9Aq4JlQueAh3VtTbxjX6l+2iNfy0PEeGlOh0GKUL+2j2/gbmo
         psedec+ACM7OsUS4P/NPDMhH0zWCQCHAqcEMsM9HU+sg6GFBu5IvYKUBMju/oLgy+dWZ
         1Fn/LJzi6XVLw6yUgfaSMFKKPo8yedz6X2c0VtdObwxNhie9CQgX7b4X1rm0A4DiugZ5
         qNK64r6o4OVZdpBnTgyI5tfbNCdF4Y7+qlapyLhl7PJrIOcycYZw2+CBab6owUEf+mGV
         /q6wjP0LQ2/9jB87p/Xd+6U1WqT4R/9lFz50vxOPVHC+QwX+h12QqUBzUZ+FXhwNsQwC
         5y7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698856910; x=1699461710;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+HQu4Or3ihYEZWL6Sbg8MV4PBpkSeSfJ+coTzqGyWIg=;
        b=pUrDvYeASPnfEpk3KYAfeIw4aTu5ffNe0edOHR4sgyTRrTXG/pQGJTGDJuvUAfXXbE
         wDzN+1VHV7sUAUBVOQ2rttN8+LzZTqxu18yjigKdHhQ6dVxTyNIrtWpmjqlK1iVn4Gev
         Zzc4+1qrY40Oyk02S5OR5RDYNvtOQK2O29zgat67lFxZqGDXzyPhhwOviR3HSwKqXdcG
         fYzlg9Ku4BcgnsAGRlHCYyx9hUkSH0OszUds43gZMNRBwcId0ot85VVsJcVAu2TwjqUd
         xNghjqOZaWJkkbBiKaiUEh6v0RwCcuFIVz2otJFJygGVCJ6VEoGnObI4vkJwAM88dfY5
         KqQw==
X-Gm-Message-State: AOJu0YxxK9KCf3VzrVKbVPb2PpAHYH3z9z/1oGklUahl8+WAsBMZmGLj
        JP33P6Y0YltobvIRErFIzP9XaNBlfC+vXqjIMdzHTA==
X-Google-Smtp-Source: AGHT+IEs7Rerd4yq15tCHSeKB4PQDjPHN7VoyG+py4ZfRx+PDPSz4WHfc5sxH51hqS7WjnOnvLzStg==
X-Received: by 2002:a17:90a:3484:b0:27d:310a:b20e with SMTP id p4-20020a17090a348400b0027d310ab20emr12845228pjb.0.1698856909747;
        Wed, 01 Nov 2023 09:41:49 -0700 (PDT)
Received: from telecaster.hsd1.wa.comcast.net ([2601:602:a300:3bc0::7aaf])
        by smtp.gmail.com with ESMTPSA id gv5-20020a17090b11c500b0027d12b1e29dsm1064233pjb.25.2023.11.01.09.41.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Nov 2023 09:41:49 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-xfs@vger.kernel.org
Cc:     kernel-team@fb.com, "Darrick J . Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v3] xfs: fix internal error from AGFL exhaustion
Date:   Wed,  1 Nov 2023 09:41:45 -0700
Message-ID: <3533095d43eaf6231df628362664d4b1e91354e9.1698856601.git.osandov@fb.com>
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

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
Changes since v2 [1]:

- Clarified comment.
- Added Darrick and Dave's reviewed-bys.

Changes since v1 [2]:

- Updated calculation to account for internal nodes that may also need
  to be split.
- Updated comments and commit message accordingly.

1: https://lore.kernel.org/linux-xfs/68cd85697855f686529829a2825b044913148caf.1698699188.git.osandov@fb.com/T/#u
2: https://lore.kernel.org/linux-xfs/ZTrSiwF7OAq0hJHn@dread.disaster.area/T/

 fs/xfs/libxfs/xfs_alloc.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 3069194527dd..100ab5931b31 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2275,16 +2275,37 @@ xfs_alloc_min_freelist(
 
 	ASSERT(mp->m_alloc_maxlevels > 0);
 
+	/*
+	 * For a btree shorter than the maximum height, the worst case is that
+	 * every level gets split and a new level is added, then while inserting
+	 * another entry to refill the AGFL, every level under the old root gets
+	 * split again. This is:
+	 *
+	 *   (full height split reservation) + (AGFL refill split height)
+	 * = (current height + 1) + (current height - 1)
+	 * = (new height) + (new height - 2)
+	 * = 2 * new height - 2
+	 *
+	 * For a btree of maximum height, the worst case is that every level
+	 * under the root gets split, then while inserting another entry to
+	 * refill the AGFL, every level under the root gets split again. This is
+	 * also:
+	 *
+	 *   2 * (current height - 1)
+	 * = 2 * (new height - 1)
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

