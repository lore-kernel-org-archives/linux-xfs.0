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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E84C433ED
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Apr 2021 07:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97F086124C
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Apr 2021 07:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbhDEHrz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Apr 2021 03:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbhDEHrz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Apr 2021 03:47:55 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D91BC061756
        for <linux-xfs@vger.kernel.org>; Mon,  5 Apr 2021 00:47:48 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id t24so1594356pjw.4
        for <linux-xfs@vger.kernel.org>; Mon, 05 Apr 2021 00:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4bN++VGD7eIbZaP+iBitXRbyql9uTp24l9JxR7yglss=;
        b=lVvxTyjN0Cn9WLxXJWs3Rd1PH1EaFSao3NImCpI39Ql0urP9/7oAKmzn49UdEVCRLf
         gJ4ozyBX5Jg1PfHNo6z9Fz73FDJTgtS6N7azgIR+lSlA7exwe9+JrY41gH+xs3jppTNv
         UtJOkmrJBURW4hYsW5HHTPwRTG7t4xuw4gbFugcPz3k5hqLDRgjDMxwc7Ep6V5zzNscp
         AnXfyDdUI54Xrh07/dnrKUzCOWLuMyQ9BYkZz3+IMIRZQQ9H8gRk80YQ6MA8PTsm3coG
         w7LsOCIkwJiXT91WTkceYLCWC87J6On+8LcFH2QXO4NaCv8pcHgcq972mldoE2F3BXiS
         EwzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4bN++VGD7eIbZaP+iBitXRbyql9uTp24l9JxR7yglss=;
        b=Y4CAAdtJrlUphUixvICOOJM9IkGeOf6jxviGxmSSFpU3lJ0KpRgvkCyYHB+sTIUaNL
         3GiTkcRp81C6qlMgz6AE2jqsVcQOX11tDWiqH+AaJ5i7LWDqrMPSV4mb9Q5n03sQoTWR
         NskMbHH9lvRdgZ8oLVxxxuKw8M+zc/Ih9hUvUdwxGIkZbiecjD9nXSJ+oVRsavxqUQIx
         dtKCVMdR5bdOjDvbcNNauGMzGoLwY/Yz6pEsPtSyckEeGVT5OJAoPzTVc+SGtfNW0+NQ
         uyf1T/0gIjYu/OZvciOXlHaTC2LtPclsHA7lhke4msnNIYgoXm0M/UiTX6WfIMe9yBeA
         takA==
X-Gm-Message-State: AOAM532ZVP7V0QswXsBuARvz4uN9yR/mw9BNbP1kTIa6btRhmYKxyZeO
        UT0LASI0O8PcZDJQYTeUil/2qKmGvXU=
X-Google-Smtp-Source: ABdhPJzPWNu/nt+KoCu/G41SOEUkJl7jR09NU4pwvh4G+84/+0Ll7IYqix7Lpk0Nx2bh8iHR0BRwBg==
X-Received: by 2002:a17:90a:c08a:: with SMTP id o10mr25470893pjs.67.1617608867641;
        Mon, 05 Apr 2021 00:47:47 -0700 (PDT)
Received: from localhost.localdomain ([122.171.183.71])
        by smtp.gmail.com with ESMTPSA id l18sm4933882pgh.70.2021.04.05.00.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 00:47:47 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org
Subject: [PATCH] xfs: scrub: Disable check for non-optimized data fork bmbt node
Date:   Mon,  5 Apr 2021 13:17:42 +0530
Message-Id: <20210405074742.22816-1-chandanrlinux@gmail.com>
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
calculation. This commit disables the check for non-optimized (in terms of
disk space usage) data fork bmbt trees since there could be filesystems
in use that already have such a layout.

Reported-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/scrub/btree.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index debf392e0515..79e0aa484b4a 100644
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
@@ -469,14 +470,17 @@ xchk_btree_check_minrecs(
 	 */
 	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
 	    level == cur->bc_nlevels - 2) {
+		struct xfs_inode 	*ip = bs->sc->ip;
 		struct xfs_btree_block	*root_block;
 		struct xfs_buf		*root_bp;
 		int			root_maxrecs;
+		int			whichfork = cur->bc_ino.whichfork;
 
 		root_block = xfs_btree_get_block(cur, root_level, &root_bp);
 		root_maxrecs = cur->bc_ops->get_dmaxrecs(cur, root_level);
 		if (be16_to_cpu(root_block->bb_numrecs) != 1 ||
-		    numrecs <= root_maxrecs)
+		    (!(whichfork == XFS_DATA_FORK && XFS_IFORK_Q(ip)) &&
+		     numrecs <= root_maxrecs))
 			xchk_btree_set_corrupt(bs->sc, cur, level);
 		return;
 	}
-- 
2.29.2

