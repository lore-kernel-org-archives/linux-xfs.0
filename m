Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A09CFC636D3
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Feb 2023 17:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbjBHRws (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Feb 2023 12:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbjBHRwr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Feb 2023 12:52:47 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026E445F6F
        for <linux-xfs@vger.kernel.org>; Wed,  8 Feb 2023 09:52:47 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id pj3so19160405pjb.1
        for <linux-xfs@vger.kernel.org>; Wed, 08 Feb 2023 09:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WyQfx+wsgdhns+st33QwWoatL2y0i9H7oBpPoGKnb1A=;
        b=QuYcKXkIJDumD/EjF3W3fojCCr/mQCARKAONmpweDdchapAvJMGUIgAZio49i/Res/
         3DfemCDYrGajqjgULiPzMU1dXdY1aShmsQiIb2Qj5l6BvH14GShwMU1QRF32hBQQOsO5
         t5MWclRefX8V8zpMv8PSq83i2t+HdWJw9QY+iG9IjH2a+8htDmsUbj/Bs8i3LinqQEng
         D5eXade2WjBXiU7sO6cASUefXbvXBUH5GirV5HJL5Rpq64X9UkBBqmGepFNVlohDQVC1
         +3BbhZRpMywDnv+JonNGu9j8g64tNlRUKSqdnDzKgg5kMFUSTIF/C8QT95TlxRS2VSCH
         52rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WyQfx+wsgdhns+st33QwWoatL2y0i9H7oBpPoGKnb1A=;
        b=vHCd5tbzIqRe3tcPTVZmGFZ/4IskZTVSWANkp/A///EMqF4Y7L7WICxCE7kOXh9E+T
         WyUJ22srGTPcJfY0o+NrbQyS2wukNRxlknBtcgB/kivDfTpl4bZdx2oyejmQPrHeXmil
         wh28ua1YdvCIva6+Q1Fw6vKcvVs/QwG04JX1s56/buRHNrXOzlJfvHjawH75liLzFSBU
         CO2HJmLZpUfGuJAR7HMbaJCu6uhMKBpZIu1xTsanGHTsk9EzzzMQ/VczBf7t4PsMcO3R
         Tzu19BdkbbuG9Gk5Aq43RNzpfFKmWcB5FRGABq1WecCaQXkC3DkvSTK74EaRL7DTYRoV
         hZFA==
X-Gm-Message-State: AO0yUKWLO+B/HJhJ9dhs2mqe1UkFCO3zen2t5cc4aj3capF2ZBRwCbr7
        NJi87XWHSJAxbHdKazwnewBoFGazfHk1lA==
X-Google-Smtp-Source: AK7set8wJDuJOJ2tsguhybthPdTf3V93JcXJ/IxjLIAQBF6OWDGtRlEfWisyF1mt+5c5v2eGWWfHCA==
X-Received: by 2002:a17:902:d50b:b0:196:7906:b4e with SMTP id b11-20020a170902d50b00b0019679060b4emr10408268plg.19.1675878766193;
        Wed, 08 Feb 2023 09:52:46 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:726:5e6d:fcde:4245])
        by smtp.gmail.com with ESMTPSA id y17-20020a170902d65100b00198e397994bsm10911452plh.136.2023.02.08.09.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 09:52:45 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com,
        Dave Chinner <dchinner@redhat.com>,
        kernel test robot <oliver.sang@intel.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 06/10] xfs: avoid unnecessary runtime sibling pointer endian conversions
Date:   Wed,  8 Feb 2023 09:52:24 -0800
Message-Id: <20230208175228.2226263-7-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
In-Reply-To: <20230208175228.2226263-1-leah.rumancik@gmail.com>
References: <20230208175228.2226263-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 5672225e8f2a872a22b0cecedba7a6644af1fb84 ]

Commit dc04db2aa7c9 has caused a small aim7 regression, showing a
small increase in CPU usage in __xfs_btree_check_sblock() as a
result of the extra checking.

This is likely due to the endian conversion of the sibling poitners
being unconditional instead of relying on the compiler to endian
convert the NULL pointer at compile time and avoiding the runtime
conversion for this common case.

Rework the checks so that endian conversion of the sibling pointers
is only done if they are not null as the original code did.

.... and these need to be "inline" because the compiler completely
fails to inline them automatically like it should be doing.

$ size fs/xfs/libxfs/xfs_btree.o*
   text	   data	    bss	    dec	    hex	filename
  51874	    240	      0	  52114	   cb92 fs/xfs/libxfs/xfs_btree.o.orig
  51562	    240	      0	  51802	   ca5a fs/xfs/libxfs/xfs_btree.o.inline

Just when you think the tools have advanced sufficiently we don't
have to care about stuff like this anymore, along comes a reminder
that *our tools still suck*.

Fixes: dc04db2aa7c9 ("xfs: detect self referencing btree sibling pointers")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/libxfs/xfs_btree.c | 47 +++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 5bec048343b0..b4b5bf4bfed7 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -51,16 +51,31 @@ xfs_btree_magic(
 	return magic;
 }
 
-static xfs_failaddr_t
+/*
+ * These sibling pointer checks are optimised for null sibling pointers. This
+ * happens a lot, and we don't need to byte swap at runtime if the sibling
+ * pointer is NULL.
+ *
+ * These are explicitly marked at inline because the cost of calling them as
+ * functions instead of inlining them is about 36 bytes extra code per call site
+ * on x86-64. Yes, gcc-11 fails to inline them, and explicit inlining of these
+ * two sibling check functions reduces the compiled code size by over 300
+ * bytes.
+ */
+static inline xfs_failaddr_t
 xfs_btree_check_lblock_siblings(
 	struct xfs_mount	*mp,
 	struct xfs_btree_cur	*cur,
 	int			level,
 	xfs_fsblock_t		fsb,
-	xfs_fsblock_t		sibling)
+	__be64			dsibling)
 {
-	if (sibling == NULLFSBLOCK)
+	xfs_fsblock_t		sibling;
+
+	if (dsibling == cpu_to_be64(NULLFSBLOCK))
 		return NULL;
+
+	sibling = be64_to_cpu(dsibling);
 	if (sibling == fsb)
 		return __this_address;
 	if (level >= 0) {
@@ -74,17 +89,21 @@ xfs_btree_check_lblock_siblings(
 	return NULL;
 }
 
-static xfs_failaddr_t
+static inline xfs_failaddr_t
 xfs_btree_check_sblock_siblings(
 	struct xfs_mount	*mp,
 	struct xfs_btree_cur	*cur,
 	int			level,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		agbno,
-	xfs_agblock_t		sibling)
+	__be32			dsibling)
 {
-	if (sibling == NULLAGBLOCK)
+	xfs_agblock_t		sibling;
+
+	if (dsibling == cpu_to_be32(NULLAGBLOCK))
 		return NULL;
+
+	sibling = be32_to_cpu(dsibling);
 	if (sibling == agbno)
 		return __this_address;
 	if (level >= 0) {
@@ -136,10 +155,10 @@ __xfs_btree_check_lblock(
 		fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
 
 	fa = xfs_btree_check_lblock_siblings(mp, cur, level, fsb,
-			be64_to_cpu(block->bb_u.l.bb_leftsib));
+			block->bb_u.l.bb_leftsib);
 	if (!fa)
 		fa = xfs_btree_check_lblock_siblings(mp, cur, level, fsb,
-				be64_to_cpu(block->bb_u.l.bb_rightsib));
+				block->bb_u.l.bb_rightsib);
 	return fa;
 }
 
@@ -204,10 +223,10 @@ __xfs_btree_check_sblock(
 	}
 
 	fa = xfs_btree_check_sblock_siblings(mp, cur, level, agno, agbno,
-			be32_to_cpu(block->bb_u.s.bb_leftsib));
+			block->bb_u.s.bb_leftsib);
 	if (!fa)
 		fa = xfs_btree_check_sblock_siblings(mp, cur, level, agno,
-				 agbno, be32_to_cpu(block->bb_u.s.bb_rightsib));
+				 agbno, block->bb_u.s.bb_rightsib);
 	return fa;
 }
 
@@ -4517,10 +4536,10 @@ xfs_btree_lblock_verify(
 	/* sibling pointer verification */
 	fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
 	fa = xfs_btree_check_lblock_siblings(mp, NULL, -1, fsb,
-			be64_to_cpu(block->bb_u.l.bb_leftsib));
+			block->bb_u.l.bb_leftsib);
 	if (!fa)
 		fa = xfs_btree_check_lblock_siblings(mp, NULL, -1, fsb,
-				be64_to_cpu(block->bb_u.l.bb_rightsib));
+				block->bb_u.l.bb_rightsib);
 	return fa;
 }
 
@@ -4574,10 +4593,10 @@ xfs_btree_sblock_verify(
 	agno = xfs_daddr_to_agno(mp, xfs_buf_daddr(bp));
 	agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
 	fa = xfs_btree_check_sblock_siblings(mp, NULL, -1, agno, agbno,
-			be32_to_cpu(block->bb_u.s.bb_leftsib));
+			block->bb_u.s.bb_leftsib);
 	if (!fa)
 		fa = xfs_btree_check_sblock_siblings(mp, NULL, -1, agno, agbno,
-				be32_to_cpu(block->bb_u.s.bb_rightsib));
+				block->bb_u.s.bb_rightsib);
 	return fa;
 }
 
-- 
2.39.1.519.gcb327c4b5f-goog

