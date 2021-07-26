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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 911C6C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:45:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 739E8601FD
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbhGZLF2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbhGZLF2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 07:05:28 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCF9C061757
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:45:56 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id a20so11464385plm.0
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U1Uaxe85ctweAghCw4ywmDZvzrupPIXJFV78a1i/shg=;
        b=No6JxzHsrqrdNSCjHYTJokjXuq86cev40L6b/jJeUZhfd5cpU5GN0vj9gr4Rl+kd1V
         TQ2MmU6AIrcJ0qApfC0SMKXf+FqPdWSddp3jkdhLodj2LCad7ewVq6Sn2IeBfaqS3tIz
         LPWF1YPuJGJOTFNdY73kAM5ks+Oi8IXnFWqWHN1siZfRZmJPskUOctFw5mh/WhKE/x7N
         vuexy/2SMwWJjoDHSal5mE/KrqwOvj3zFHD5r0Y009Z3e870BeNDMSPMaawAu11UsZnz
         +hHHwt3hUOjPH13HQ9/8VwQxKsLwPceJkrNahMfynyH2IIa5olEPAPSjpxEvyBqLLopE
         8Hcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U1Uaxe85ctweAghCw4ywmDZvzrupPIXJFV78a1i/shg=;
        b=hTGke9nqi4XP1nxUa3Tax/eu4x4U0iPFgixMg5Gh7b8CH1OJrMTEF1e5b+qBOLgpV9
         fmmiQI4R/IBaHZH2+QjG5sETzws0YNEXePiN851UTaXvIm2VtG5njxbAAfRJrtu5BUmw
         EWdFX4elshhsi87yxAY7UlGv2u2pNsrbh5xuWfPNLiFGZ2C7RDiyRSWoiQ4nfPJgwOc9
         p/SzO+1kdnVVZbHMru49Lz2ZOLzn3aHjrG033myD356dZ9pbp+kTW0HjzjbTpbAoMASy
         pIF2SClGzk/OKHbA4BnlleG5q1Tvxd06gH8ASuCWqlA+Ii+i9jvN6nIYje/FIJjqBvgi
         d+4g==
X-Gm-Message-State: AOAM530mozfltWEzP1JtyxxoEUBFDHkvBLKYqDJ2oSA6mc5vE+BmAWIU
        QbK2XXeZ0WhNPqIIdRk1xMgXjFj4Akw=
X-Google-Smtp-Source: ABdhPJx6xomQ8aGSnRbEekMydTcVkGCjyf6w7aqcV9R+Qfktk1hiHH+Fhp4cjCnfB8KqkvMCd/63fw==
X-Received: by 2002:a65:4244:: with SMTP id d4mr18080480pgq.83.1627299955674;
        Mon, 26 Jul 2021 04:45:55 -0700 (PDT)
Received: from localhost.localdomain ([122.179.41.55])
        by smtp.gmail.com with ESMTPSA id k8sm50833919pgr.91.2021.07.26.04.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 04:45:55 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org
Subject: [PATCH V2 02/12] xfs: Rename MAXEXTNUM, MAXAEXTNUM to XFS_IFORK_EXTCNT_MAXS32, XFS_IFORK_EXTCNT_MAXS16
Date:   Mon, 26 Jul 2021 17:15:31 +0530
Message-Id: <20210726114541.24898-3-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726114541.24898-1-chandanrlinux@gmail.com>
References: <20210726114541.24898-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation for introducing larger extent count limits, this commit renames
existing extent count limits based on their signedness and width.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 4 ++--
 fs/xfs/libxfs/xfs_format.h     | 8 ++++----
 fs/xfs/libxfs/xfs_inode_buf.c  | 4 ++--
 fs/xfs/libxfs/xfs_inode_fork.c | 3 ++-
 fs/xfs/scrub/inode_repair.c    | 2 +-
 5 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f3c9a0ebb0a5..8f262405a5b5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -76,10 +76,10 @@ xfs_bmap_compute_maxlevels(
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
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 37cca918d2ba..920e3f9c418f 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1110,11 +1110,11 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_UUID,		"uuid" }
 
 /*
- * Max values for extlen, extnum, aextnum.
+ * Max values for extlen and disk inode's extent counters.
  */
-#define	MAXEXTLEN	((uint32_t)0x001fffff)	/* 21 bits */
-#define	MAXEXTNUM	((int32_t)0x7fffffff)	/* signed int */
-#define	MAXAEXTNUM	((int16_t)0x7fff)	/* signed short */
+#define	MAXEXTLEN		((uint32_t)0x1fffff) /* 21 bits */
+#define XFS_IFORK_EXTCNT_MAXS32 ((int32_t)0x7fffffff)  /* Signed 32-bits */
+#define XFS_IFORK_EXTCNT_MAXS16 ((int16_t)0x7fff)      /* Signed 16-bits */
 
 /*
  * Inode minimum and maximum sizes.
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 5625df1ddd95..66d13e8fa420 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -365,9 +365,9 @@ xfs_dinode_verify_fork(
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
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 801a6f7dbd0c..6f4b14d3d381 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -736,7 +736,8 @@ xfs_iext_count_may_overflow(
 	if (whichfork == XFS_COW_FORK)
 		return 0;
 
-	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
+	max_exts = (whichfork == XFS_ATTR_FORK) ?
+		XFS_IFORK_EXTCNT_MAXS16 : XFS_IFORK_EXTCNT_MAXS32;
 
 	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
 		max_exts = 10;
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index a80cd633fe59..c44f8d06939b 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1198,7 +1198,7 @@ xrep_inode_blockcounts(
 			return error;
 		if (count >= sc->mp->m_sb.sb_dblocks)
 			return -EFSCORRUPTED;
-		if (nextents >= MAXAEXTNUM)
+		if (nextents >= XFS_IFORK_EXTCNT_MAXS16)
 			return -EFSCORRUPTED;
 		ifp->if_nextents = nextents;
 	} else {
-- 
2.30.2

