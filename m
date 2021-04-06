Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2632C433B4
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 06:55:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3ACB6117A
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 06:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhDFGzk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Apr 2021 02:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbhDFGzj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Apr 2021 02:55:39 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735B8C06174A
        for <linux-xfs@vger.kernel.org>; Mon,  5 Apr 2021 23:55:32 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id cl21-20020a17090af695b02900c61ac0f0e9so807645pjb.1
        for <linux-xfs@vger.kernel.org>; Mon, 05 Apr 2021 23:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FfCUHHdLJlOvl/1pCnu+UJQ8uM5B1Lc9jUVu/JUqtLU=;
        b=gv4wW6IQdhdVWVnq10GzAYmsWVKuFkDfp4wMlgc9tAxsBALzi9fWUV1xP0oGkTwX4g
         5Y4rbW59qL2jxn/eHzzdZLvGK/GD0VFyTgivtDo+3vP8TcQz9d2M1ig7siVGnzmo16YR
         GiFcMBPnx7F4Eqk3C8lglAq6th0/DeyZHz4rJPGmaEMzKEUtqfExpsY+QxLnCa3o2xFR
         9RAF57Frf7oP5wkftG1yCt6cHuYKfGOOpi7HFOcuDms2y54/SzoOFGLFGhVOgJuqe5Qj
         /a2uDZTVl+z+Bu9cNSFxL++9EFPWXbL7cDE0+nL2bBVORNRSYC79hEK9oLoID4sMi6dd
         FKPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FfCUHHdLJlOvl/1pCnu+UJQ8uM5B1Lc9jUVu/JUqtLU=;
        b=eJNdmG0KEmZ4euHZFy1k98BmgZNaqhP8BQ664cln7TAsEI0lLjhZHj8oPaUXO76ygp
         Jmx4qnRmNVfZq58DmmmTTS6m4JuRdvZSFSMBctnvBwNFzJOBtJfazgzHljMX5FhmA9Va
         uGBeK10QaAevJC1Ot5qq5mvnSf3tnXBMSFIMEHp4bYzeYDK1XxDxIbpLEWAJNTZNc/14
         auFlLUa+GLqQI0oUYXkgMyWZhdM2lne4aNX5MsLCRucTKHunvrT8RKfsU3J9Hb0qDecJ
         zYiTqgUdPSzSe5oMeZ+5q8CJyVqwGeQ+FyTRAZ4smySMPLQEueNRwhXt2sVHY5MhZMmQ
         5CyQ==
X-Gm-Message-State: AOAM531QjYP/ZnGRmq2L5f6fGnWoLb/QrpoKhGYPGWjNhfnr3TE6WS8G
        CdGtFgmPuDvWWUWxmp0ooEP0Ge89o5w=
X-Google-Smtp-Source: ABdhPJyizSrG0O2i1JJ0206m8dhxeb7pf5Cz5qTIsYPycXUKPrJLuMdPbu58qfPdK6+54SvY9qNf3Q==
X-Received: by 2002:a17:90a:af87:: with SMTP id w7mr2903025pjq.187.1617692131754;
        Mon, 05 Apr 2021 23:55:31 -0700 (PDT)
Received: from localhost.localdomain ([122.179.71.212])
        by smtp.gmail.com with ESMTPSA id n73sm18363443pfd.196.2021.04.05.23.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 23:55:31 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org
Subject: [PATCH V2] xfs: scrub: Disable check for unoptimized data fork bmbt node
Date:   Tue,  6 Apr 2021 12:25:19 +0530
Message-Id: <20210406065519.696-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xchk_btree_check_minrecs() checks if the contents of the immediate child of a
bmbt root block can fit within the root block. This check could fail on inodes
with an attr fork since xfs_bmap_add_attrfork_btree() used to demote the
current root node of the data fork as the child of a newly allocated root node
if it found that the size of "struct xfs_btree_block" along with the space
required for records exceeded that of space available in the data fork.

xfs_bmap_add_attrfork_btree() should have used "struct xfs_bmdr_block" instead
of "struct xfs_btree_block" for the above mentioned space requirement
calculation. This commit disables the check for unoptimized (in terms of
disk space usage) data fork bmbt trees since there could be filesystems
in use that already have such a layout.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
Changelog:
 V1 -> V2:
   1. Apply "minimum records check" restriction only to BMBT btrees.
   
 fs/xfs/scrub/btree.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index debf392e0515..a94bd8122c60 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -9,6 +9,7 @@
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -442,6 +443,30 @@ xchk_btree_check_owner(
 	return xchk_btree_check_block_owner(bs, level, XFS_BUF_ADDR(bp));
 }
 
+/* Decide if we want to check minrecs of a btree block in the inode root. */
+static inline bool
+xchk_btree_check_iroot_minrecs(
+	struct xchk_btree	*bs)
+{
+	/*
+	 * xfs_bmap_add_attrfork_btree had an implementation bug wherein it
+	 * would miscalculate the space required for the data fork bmbt root
+	 * when adding an attr fork, and promote the iroot contents to an
+	 * external block unnecessarily.  This went unnoticed for many years
+	 * until scrub found filesystems in this state.  Inode rooted btrees are
+	 * not supposed to have immediate child blocks that are small enough
+	 * that the contents could fit in the inode root, but we can't fail
+	 * existing filesystems, so instead we disable the check for data fork
+	 * bmap btrees when there's an attr fork.
+	 */
+	if (bs->cur->bc_btnum == XFS_BTNUM_BMAP &&
+	    bs->cur->bc_ino.whichfork == XFS_DATA_FORK &&
+	    XFS_IFORK_Q(bs->sc->ip))
+		return false;
+
+	return true;
+}
+
 /*
  * Check that this btree block has at least minrecs records or is one of the
  * special blocks that don't require that.
@@ -475,8 +500,9 @@ xchk_btree_check_minrecs(
 
 		root_block = xfs_btree_get_block(cur, root_level, &root_bp);
 		root_maxrecs = cur->bc_ops->get_dmaxrecs(cur, root_level);
-		if (be16_to_cpu(root_block->bb_numrecs) != 1 ||
-		    numrecs <= root_maxrecs)
+		if (xchk_btree_check_iroot_minrecs(bs) &&
+		    (be16_to_cpu(root_block->bb_numrecs) != 1 ||
+		     numrecs <= root_maxrecs))
 			xchk_btree_set_corrupt(bs->sc, cur, level);
 		return;
 	}
-- 
2.29.2

