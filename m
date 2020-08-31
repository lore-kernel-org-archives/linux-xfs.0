Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B305C433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 13:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2256E20866
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 13:01:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rEqbaxRg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgHaNBc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 09:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbgHaNBY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 09:01:24 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC05AC061575
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 06:01:17 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id q1so2918219pjd.1
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 06:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+fqQuZPZvWzU17uVJ7KeQpx8eOWgNmQVrkl230VuaCk=;
        b=rEqbaxRgtokz12Xc5sZNYPJlCIq0mgiLO78sPhJdYy3uXNv5EXR/9tSo55yYPB8e8Y
         gKEGzmDs+VmZSiGMj10sDfYEd3Wm5qEU+vzG4WroukCic4alHEryxzU6WOcP1kqCbIWi
         Mgbf/vW4q2vZqbUIWr11N1K6Hku25x3+J2lekRwvGU0oGkdCEFhJLPbApXkhfMYgbcPn
         C/QU8Itthl4CUSmuuYvRs6i376lQNDbMfYpp6mZOH7V/9CYl3nXqstmECgcRIJ2HbtwB
         UrJs7O2rDUMA+RjMQcUohqhNT4iIJphfOvVKFASgl+7igAbBH4BbU2HNdDDW4YDhJVA6
         gY/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+fqQuZPZvWzU17uVJ7KeQpx8eOWgNmQVrkl230VuaCk=;
        b=PMb7DiqTCEuUD2uxoxEq2feS/4ai3UKeDKPcGcf+MzN7/opD/VBvvZRSD7vBdl8vPH
         aZca0pR38vMmcvcPR9hVEI24p9lvwnZWKDpnKMWMVxOlOjjIDcBMM/dM5fGRvHrqy80H
         n9GnXXFEZi/BP67ACeFc8EETGcXDM+vGDwszNMFJJmH1qiXdilt34gbUP51O/zey3owj
         IdtzcqDnkVOTT8UGuOC5uhSVuESzKZdeynsV9JeRUwgBAjn2l3ssdpwmKgv3mHfBDrNl
         RIPZMHOTAgS6xv4bDhxDCnJqGyxPHwO0TdUXVoiCvT4CiIjKMzcys5fOUviujiUtyHXM
         YCQA==
X-Gm-Message-State: AOAM5302o3hhyxyHZasMUwnUbfsIV7IYP9UkhV2BOqh8Vf1MZdSSwWjq
        UWvz2LYaTqQ9YBBJ3nfwdJtbsHlB8I8=
X-Google-Smtp-Source: ABdhPJxN1eHbVjyqT77cl5U4OrHfKe+pLVCxm+8JcvuSkdrQNH4KkuFRR4QbB2D7TGQt7WUqLSrAbA==
X-Received: by 2002:a17:902:bc87:: with SMTP id bb7mr985495plb.146.1598878876295;
        Mon, 31 Aug 2020 06:01:16 -0700 (PDT)
Received: from localhost.localdomain ([122.167.36.194])
        by smtp.gmail.com with ESMTPSA id o2sm7643220pjh.4.2020.08.31.06.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 06:01:15 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, david@fromorbit.com,
        darrick.wong@oracle.com, bfoster@redhat.com
Subject: [PATCH 1/4] xfsprogs: Introduce xfs_iext_max() helper
Date:   Mon, 31 Aug 2020 18:30:59 +0530
Message-Id: <20200831130102.507-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200831130102.507-1-chandanrlinux@gmail.com>
References: <20200831130102.507-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_iext_max() returns the maximum number of extents possible for either
data fork or attribute fork. This helper will be extended further in a
future commit when maximum extent counts associated with data/attribute
forks are increased.

No functional changes have been made.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 libxfs/xfs_bmap.c       |  9 ++++-----
 libxfs/xfs_inode_buf.c  |  9 ++++-----
 libxfs/xfs_inode_fork.h | 10 ++++++++++
 repair/dinode.c         | 23 ++++++++++++++---------
 4 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 11f3f5f9..dae4d339 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -67,13 +67,12 @@ xfs_bmap_compute_maxlevels(
 	 * for both ATTR1 and ATTR2 we have to assume the worst case scenario
 	 * of a minimum size available.
 	 */
-	if (whichfork == XFS_DATA_FORK) {
-		maxleafents = MAXEXTNUM;
+	maxleafents = xfs_iext_max(&mp->m_sb, whichfork);
+	if (whichfork == XFS_DATA_FORK)
 		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
-	} else {
-		maxleafents = MAXAEXTNUM;
+	else
 		sz = XFS_BMDR_SPACE_CALC(MINABTPTRS);
-	}
+
 	maxrootrecs = xfs_bmdr_maxrecs(sz, 0);
 	minleafrecs = mp->m_bmap_dmnr[0];
 	minnoderecs = mp->m_bmap_dmnr[1];
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index b65cd0b1..ae71a19e 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -363,6 +363,8 @@ xfs_dinode_verify_fork(
 	int			whichfork)
 {
 	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		max_extents;
+
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
 	case XFS_DINODE_FMT_LOCAL:
@@ -384,12 +386,9 @@ xfs_dinode_verify_fork(
 			return __this_address;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		if (whichfork == XFS_ATTR_FORK) {
-			if (di_nextents > MAXAEXTNUM)
-				return __this_address;
-		} else if (di_nextents > MAXEXTNUM) {
+		max_extents = xfs_iext_max(&mp->m_sb, whichfork);
+		if (di_nextents > max_extents)
 			return __this_address;
-		}
 		break;
 	default:
 		return __this_address;
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 668ee942..e318dfdd 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -86,6 +86,16 @@ struct xfs_ifork {
 	(XFS_IFORK_FORMAT((ip), (w)) == XFS_DINODE_FMT_EXTENTS || \
 	 XFS_IFORK_FORMAT((ip), (w)) == XFS_DINODE_FMT_BTREE)
 
+static inline xfs_extnum_t xfs_iext_max(struct xfs_sb *sbp, int whichfork)
+{
+	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
+
+	if (whichfork == XFS_DATA_FORK)
+		return MAXEXTNUM;
+	else
+		return MAXAEXTNUM;
+}
+
 struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
 
 int		xfs_iformat_fork(struct xfs_inode *, struct xfs_dinode *);
diff --git a/repair/dinode.c b/repair/dinode.c
index 526ecde3..de9a3286 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1727,13 +1727,16 @@ _("bad attr fork offset %d in inode %" PRIu64 ", max=%zu\n"),
  */
 static int
 process_inode_blocks_and_extents(
-	xfs_dinode_t	*dino,
-	xfs_rfsblock_t	nblocks,
-	uint64_t	nextents,
-	uint64_t	anextents,
-	xfs_ino_t	lino,
-	int		*dirty)
+	struct xfs_mount	*mp,
+	xfs_dinode_t		*dino,
+	xfs_rfsblock_t		nblocks,
+	uint64_t		nextents,
+	uint64_t		anextents,
+	xfs_ino_t		lino,
+	int			*dirty)
 {
+	xfs_extnum_t		max_extents;
+
 	if (nblocks != be64_to_cpu(dino->di_nblocks))  {
 		if (!no_modify)  {
 			do_warn(
@@ -1750,7 +1753,8 @@ _("bad nblocks %llu for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 		}
 	}
 
-	if (nextents > MAXEXTNUM)  {
+	max_extents = xfs_iext_max(&mp->m_sb, XFS_DATA_FORK);
+	if (nextents > max_extents)  {
 		do_warn(
 _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			nextents, lino);
@@ -1773,7 +1777,8 @@ _("bad nextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 		}
 	}
 
-	if (anextents > MAXAEXTNUM)  {
+	max_extents = xfs_iext_max(&mp->m_sb, XFS_ATTR_FORK);
+	if (anextents > max_extents)  {
 		do_warn(
 _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			anextents, lino);
@@ -2712,7 +2717,7 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 	/*
 	 * correct space counters if required
 	 */
-	if (process_inode_blocks_and_extents(dino, totblocks + atotblocks,
+	if (process_inode_blocks_and_extents(mp, dino, totblocks + atotblocks,
 			nextents, anextents, lino, dirty) != 0)
 		goto clear_bad_out;
 
-- 
2.28.0

