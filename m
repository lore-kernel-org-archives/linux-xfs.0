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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FFA7C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:47:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65E8C601FD
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbhGZLHL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbhGZLHL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 07:07:11 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37217C061757
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:47:40 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id u9-20020a17090a1f09b029017554809f35so19309156pja.5
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S3NFASGKszQVhoyC3m93WoCw4T5yG75LfYNmQlaMiJQ=;
        b=qJOIIHkdCKsXKg++/ciAZP2Un9lxIKwmz/QcHPxy0k9naydouxsGTQSyGGRfer+1lh
         N+3pVoELXOvCzjpWDKcZppIxbvvg5NALRFuh1Q4anxETkaCX5eAJbYtcNetMtvtTkNN/
         fFBoVKRs65C364Vm815l20i3JfjiRy2R3VHIOeSrVel6ZZGVyWT3oADUTi5xNFTYib+i
         /vvaSXg9VQv/u1QOt7MiNi4A1aV/F1LV1GyAGi83uxI4iaS7lGnfBNlwDe4YKPXpnEDH
         iQw9kS81sKfvFaf+3ARRGK0HLiuo3VlCbK6srYApLZUWM7EWalERc8gJ4RJw+cR06htZ
         VRlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S3NFASGKszQVhoyC3m93WoCw4T5yG75LfYNmQlaMiJQ=;
        b=oHj+g7lQSqdWgk4iPFsG4yxitwjJ4Gsr8mLZIBzOm9cHGvszFLjWwPRBt3KwL/t/eR
         N5s2udauK07E/BWlYRkTYcrGaCXQylCq0x2yTHifEd99c+NDYNTkx1749lfAnRbtotLE
         JTDDQsoGb6BxX4HBN5Fs4USu3TwVaZlUZ8SVI7fXsK847KVXytm0UW6i/DX3Qty7LyrV
         2MYc2ixlbr7ermrlEO17rDSNqFAiEp+mj4CTknzp1nF6SN0T1dh9nMsMm0aIpn/i9gr7
         D+btqfNaCMb10jerN1NGi5iiIFRwgu2AUT6yarcN7H+7Ti8ydViXOD/f4KNcle3iv471
         1pRQ==
X-Gm-Message-State: AOAM532oV53CuErpexL6mVmaivLCzqhatbFE4FoTUuUGVXlE2x2ID2m/
        O19fahFwtgABvZ5shbKvmbBoyLoNoLI=
X-Google-Smtp-Source: ABdhPJwV8XVKik3t5GKTBJNRzlKVv65mkU60VSq3VgDZ/X9+GYaQi13cXM96UQVSB2HVp90fvmrMOA==
X-Received: by 2002:a63:4c03:: with SMTP id z3mr17661792pga.130.1627300059661;
        Mon, 26 Jul 2021 04:47:39 -0700 (PDT)
Received: from localhost.localdomain ([122.179.41.55])
        by smtp.gmail.com with ESMTPSA id y10sm35936900pjy.18.2021.07.26.04.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 04:47:39 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org
Subject: [PATCH V2 03/12] xfsprogs: Introduce xfs_iext_max() helper
Date:   Mon, 26 Jul 2021 17:17:15 +0530
Message-Id: <20210726114724.24956-4-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726114724.24956-1-chandanrlinux@gmail.com>
References: <20210726114724.24956-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_iext_max() returns the maximum number of extents possible for one of
data, cow or attribute fork. This helper will be extended further in a
future commit when maximum extent counts associated with data/attribute
forks are increased.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 libxfs/xfs_bmap.c       | 9 ++++-----
 libxfs/xfs_inode_buf.c  | 8 +++-----
 libxfs/xfs_inode_fork.c | 6 +++---
 libxfs/xfs_inode_fork.h | 8 ++++++++
 repair/dinode.c         | 7 ++++---
 5 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 7927e2712..608ae5b83 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -68,13 +68,12 @@ xfs_bmap_compute_maxlevels(
 	 * ATTR2 we have to assume the worst case scenario of a minimum size
 	 * available.
 	 */
-	if (whichfork == XFS_DATA_FORK) {
-		maxleafents = XFS_IFORK_EXTCNT_MAXS32;
+	maxleafents = xfs_iext_max(mp, whichfork);
+	if (whichfork == XFS_DATA_FORK)
 		sz = xfs_bmdr_space_calc(MINDBTPTRS);
-	} else {
-		maxleafents = XFS_IFORK_EXTCNT_MAXS16;
+	else
 		sz = xfs_bmdr_space_calc(MINABTPTRS);
-	}
+
 	maxrootrecs = xfs_bmdr_maxrecs(sz, 0);
 	minleafrecs = mp->m_bmap_dmnr[0];
 	minnoderecs = mp->m_bmap_dmnr[1];
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 855cb0b85..056fe252b 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -340,6 +340,7 @@ xfs_dinode_verify_fork(
 	int			whichfork)
 {
 	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		max_extents;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
 	case XFS_DINODE_FMT_LOCAL:
@@ -361,12 +362,9 @@ xfs_dinode_verify_fork(
 			return __this_address;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		if (whichfork == XFS_ATTR_FORK) {
-			if (di_nextents > XFS_IFORK_EXTCNT_MAXS16)
-				return __this_address;
-		} else if (di_nextents > XFS_IFORK_EXTCNT_MAXS32) {
+		max_extents = xfs_iext_max(mp, whichfork);
+		if (di_nextents > max_extents)
 			return __this_address;
-		}
 		break;
 	default:
 		return __this_address;
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 36e8bf702..4cd117382 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -727,6 +727,7 @@ xfs_iext_count_may_overflow(
 	int			whichfork,
 	int			nr_to_add)
 {
+	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	uint64_t		max_exts;
 	uint64_t		nr_exts;
@@ -734,10 +735,9 @@ xfs_iext_count_may_overflow(
 	if (whichfork == XFS_COW_FORK)
 		return 0;
 
-	max_exts = (whichfork == XFS_ATTR_FORK) ?
-		XFS_IFORK_EXTCNT_MAXS16 : XFS_IFORK_EXTCNT_MAXS32;
+	max_exts = xfs_iext_max(mp, whichfork);
 
-	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
 		max_exts = 10;
 
 	nr_exts = ifp->if_nextents + nr_to_add;
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index cf82be263..1eda21636 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -133,6 +133,14 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
 	return ifp->if_format;
 }
 
+static inline xfs_extnum_t xfs_iext_max(struct xfs_mount *mp, int whichfork)
+{
+	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
+		return XFS_IFORK_EXTCNT_MAXS32;
+	else
+		return XFS_IFORK_EXTCNT_MAXS16;
+}
+
 struct xfs_ifork *xfs_ifork_alloc(enum xfs_dinode_fmt format,
 				xfs_extnum_t nextents);
 struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
diff --git a/repair/dinode.c b/repair/dinode.c
index 45c8174cf..a0c5be7c3 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1808,6 +1808,7 @@ _("bad attr fork offset %d in inode %" PRIu64 ", max=%zu\n"),
  */
 static int
 process_inode_blocks_and_extents(
+	struct xfs_mount *mp,
 	xfs_dinode_t	*dino,
 	xfs_rfsblock_t	nblocks,
 	uint64_t	nextents,
@@ -1831,7 +1832,7 @@ _("bad nblocks %llu for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 		}
 	}
 
-	if (nextents > XFS_IFORK_EXTCNT_MAXS32)  {
+	if (nextents > xfs_iext_max(mp, XFS_DATA_FORK)) {
 		do_warn(
 _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			nextents, lino);
@@ -1854,7 +1855,7 @@ _("bad nextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 		}
 	}
 
-	if (anextents > XFS_IFORK_EXTCNT_MAXS16)  {
+	if (anextents > xfs_iext_max(mp, XFS_ATTR_FORK))  {
 		do_warn(
 _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			anextents, lino);
@@ -2961,7 +2962,7 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 	/*
 	 * correct space counters if required
 	 */
-	if (process_inode_blocks_and_extents(dino, totblocks + atotblocks,
+	if (process_inode_blocks_and_extents(mp, dino, totblocks + atotblocks,
 			nextents, anextents, lino, dirty) != 0)
 		goto clear_bad_out;
 
-- 
2.30.2

