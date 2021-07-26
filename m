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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D27CFC432BE
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:47:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC00F601FD
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbhGZLHJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbhGZLHJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 07:07:09 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9300DC061757
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:47:38 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id mz5-20020a17090b3785b0290176ecf64922so3473517pjb.3
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q32+ueAsxoCUwty4kn7/uAewrzSzmE4JscZMCaCi6Bg=;
        b=ktn1MZhj5CcFosMdNZDD3BybwbMN3zekOgFMCpMYZVbwkNFTvSkPJS1TjQ3lqQIIEs
         ehOs/pxi2CIv/n4o+HE3BiJZb8MlrhdDM/wHRHFroNETQQhaGIzuV0o1mv3srtr2Chuh
         JQCbFOHx2HhXutKOiU1Dwbsc/w9l93yeIjy1k4cJhdR8JTUR07A5IUgeKIC6UU3oKdp5
         LXrEzw5FoVTIPyaJINHFBI38endPxxAGyCrMSxyusR7WUHPCAt1vBhLicDVFa6xQCegK
         DSKo7pYaVIt5UTYM1rWcyR0QqeI9wZoMAv9beMHg4oW90R2HFtUD1Y4HLlMILtogVDKD
         0DmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q32+ueAsxoCUwty4kn7/uAewrzSzmE4JscZMCaCi6Bg=;
        b=N57Jaqyx0gucpd6hRTvkh9pnbUgjKuXOVBz+xfUWsn7dczD2JXMBTGoKLp+vuDmRBs
         dcUuM0BYCw8yyckrzWKUjFx+9f9Kw0K8Efu+YpFu1EVERyd8gqYARYXIaVQ/CPlI06Ov
         ZvEqKk8lzNI+jmUYL7mspa+NyNDAxx/9+MdsG+RYJqRy4IfzZgAZHuOIIihGoMU2/cfX
         bFX0mCARxeZTx7g3i6UPiF9nj643Lw+isRFowjQspzvGOJiWnpiLnAW4I5NrPGiVnXd6
         KIzNl9tDUxYGcGWeIC8tXKBbR9gIbHQODbYKWQ8OuZ2XlO8Bl6HBMHj+n7KXm62H7Cj9
         5ujg==
X-Gm-Message-State: AOAM5313SexGHnGaqFycTLIT2PvrOXegHVSc/HJNyFrpZpiWbVt8BmiA
        w76uNvkV5ePQ0LK6s/B5GOgZpgKDR7Q=
X-Google-Smtp-Source: ABdhPJyUS+1ERbF3dO6DLxkT2Y2SQuC87KUTvS4Gv3j1+BNT3PIANX/ZKwagqzow/1ZqRk4CxT6hWg==
X-Received: by 2002:a05:6a00:d6f:b029:398:74ba:4cdc with SMTP id n47-20020a056a000d6fb029039874ba4cdcmr5321116pfv.49.1627300058008;
        Mon, 26 Jul 2021 04:47:38 -0700 (PDT)
Received: from localhost.localdomain ([122.179.41.55])
        by smtp.gmail.com with ESMTPSA id y10sm35936900pjy.18.2021.07.26.04.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 04:47:37 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org
Subject: [PATCH V2 02/12] xfsprogs: Rename MAXEXTNUM, MAXAEXTNUM to XFS_IFORK_EXTCNT_MAXS32, XFS_IFORK_EXTCNT_MAXS16
Date:   Mon, 26 Jul 2021 17:17:14 +0530
Message-Id: <20210726114724.24956-3-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726114724.24956-1-chandanrlinux@gmail.com>
References: <20210726114724.24956-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation for introducing larger extent count limits, this commit renames
existing extent count limits based on their signedness and width.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 libxfs/xfs_bmap.c       | 4 ++--
 libxfs/xfs_format.h     | 8 ++++----
 libxfs/xfs_inode_buf.c  | 4 ++--
 libxfs/xfs_inode_fork.c | 3 ++-
 repair/dinode.c         | 4 ++--
 5 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 277727a1a..7927e2712 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -69,10 +69,10 @@ xfs_bmap_compute_maxlevels(
 	 * available.
 	 */
 	if (whichfork == XFS_DATA_FORK) {
-		maxleafents = MAXEXTNUM;
+		maxleafents = XFS_IFORK_EXTCNT_MAXS32;
 		sz = xfs_bmdr_space_calc(MINDBTPTRS);
 	} else {
-		maxleafents = MAXAEXTNUM;
+		maxleafents = XFS_IFORK_EXTCNT_MAXS16;
 		sz = xfs_bmdr_space_calc(MINABTPTRS);
 	}
 	maxrootrecs = xfs_bmdr_maxrecs(sz, 0);
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 24277f45a..84b3aefe2 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1110,11 +1110,11 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_UUID,		"uuid" }
 
 /*
- * Max values for extlen, extnum, aextnum.
+ * Max values for extlen, disk inode's extent counters.
  */
-#define	MAXEXTLEN	((uint32_t)0x001fffff)	/* 21 bits */
-#define	MAXEXTNUM	((int32_t)0x7fffffff)	/* signed int */
-#define	MAXAEXTNUM	((int16_t)0x7fff)	/* signed short */
+#define	MAXEXTLEN		((uint32_t)0x1fffff) /* 21 bits */
+#define XFS_IFORK_EXTCNT_MAXS32 ((int32_t)0x7fffffff)  /* Signed 32-bits */
+#define XFS_IFORK_EXTCNT_MAXS16 ((int16_t)0x7fff)      /* Signed 16-bits */
 
 /*
  * Inode minimum and maximum sizes.
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 3d1805e4c..855cb0b85 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -362,9 +362,9 @@ xfs_dinode_verify_fork(
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		if (whichfork == XFS_ATTR_FORK) {
-			if (di_nextents > MAXAEXTNUM)
+			if (di_nextents > XFS_IFORK_EXTCNT_MAXS16)
 				return __this_address;
-		} else if (di_nextents > MAXEXTNUM) {
+		} else if (di_nextents > XFS_IFORK_EXTCNT_MAXS32) {
 			return __this_address;
 		}
 		break;
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index e3979ceef..36e8bf702 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -734,7 +734,8 @@ xfs_iext_count_may_overflow(
 	if (whichfork == XFS_COW_FORK)
 		return 0;
 
-	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
+	max_exts = (whichfork == XFS_ATTR_FORK) ?
+		XFS_IFORK_EXTCNT_MAXS16 : XFS_IFORK_EXTCNT_MAXS32;
 
 	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
 		max_exts = 10;
diff --git a/repair/dinode.c b/repair/dinode.c
index ffd409646..45c8174cf 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1831,7 +1831,7 @@ _("bad nblocks %llu for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 		}
 	}
 
-	if (nextents > MAXEXTNUM)  {
+	if (nextents > XFS_IFORK_EXTCNT_MAXS32)  {
 		do_warn(
 _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			nextents, lino);
@@ -1854,7 +1854,7 @@ _("bad nextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 		}
 	}
 
-	if (anextents > MAXAEXTNUM)  {
+	if (anextents > XFS_IFORK_EXTCNT_MAXS16)  {
 		do_warn(
 _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			anextents, lino);
-- 
2.30.2

