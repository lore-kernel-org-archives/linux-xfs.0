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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1699C4320A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:45:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6A70601FD
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbhGZLF3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbhGZLF2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 07:05:28 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF197C061757
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:45:57 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id pf12-20020a17090b1d8cb0290175c085e7a5so19351086pjb.0
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ke1thBOtJ83M3Pzz4Z3GvQJqecw53ADoUBZbHqtzRmw=;
        b=sALBoOoH60baireqjgH49MIQqp5WYpRrAR4PO0jheJRcwXtiV9wSYThq2Obn+JbEB4
         YMWQ2uNvHWaQELuUs1E2BLV1F4THgiLi155kpsuwqkJhL3WeZME3GmonJ26gpVfxuKPU
         qh4blaDon2WYX9CnF4CD6Vk5uVxxLAmHCNdcZir+yueEH6FKV52M0IhM1cwCqKDXvSEJ
         lIewOHLar0fnAatLim3CxZi46vO5Qbhc6R4mys9/DD7rRPXQ2YJ70tb79O+vLYlEHSES
         xRl+XoNRSdh+iW79l82oQlax5TalA8fSqRtuAD0fFrh21WKkBHliP8HoFGaYAlEy2dZo
         1zsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ke1thBOtJ83M3Pzz4Z3GvQJqecw53ADoUBZbHqtzRmw=;
        b=blkOQ9AkzJK1q4+sf2A7bHXrpHQ4iuryoOA7wZhawA+WIG9BETHWUgMZuyXzcC57Oy
         5tPSr8gx4+/6OUNSnbJTeEcEZqTo2KXTl4NO6wTCKx4ZQu77XJcAawd81cpemaPRHAmJ
         Y7ZQy4hjS3oI5l+mIv/2M0w3EmvII+dkSWr9Ea2h5y46Qd1PWMGotvnrI2B2ocjFJYsF
         10NJ9iPg1Roz3PEI5Dm7sNUjYWHbVeivxQyolANeOdzp68WiEQgYuD0ITqfXRk+TtpYs
         27yu5CPuMYICBO6DfV2aQr+RACb5Z7agZtCWfvw+XqN21er8+6egmyg406UII2dGu1zb
         Sqlg==
X-Gm-Message-State: AOAM530jtVzEFFR8RioFqpi7ApAQhSHXRg8mtFOyr1Fti98o1spu1rSS
        HpEcS8E+Lz7OeeUIPKINvWBVCxzgGGs=
X-Google-Smtp-Source: ABdhPJwWNwph7+uAy1B9BjTvt7yuUjN7jkLrHrMWF4HALCHNgOxwh2WQmnfH7oRtEhH6gJGtFMLQdg==
X-Received: by 2002:a17:90a:b78d:: with SMTP id m13mr7951727pjr.178.1627299957305;
        Mon, 26 Jul 2021 04:45:57 -0700 (PDT)
Received: from localhost.localdomain ([122.179.41.55])
        by smtp.gmail.com with ESMTPSA id k8sm50833919pgr.91.2021.07.26.04.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 04:45:57 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org
Subject: [PATCH V2 03/12] xfs: Introduce xfs_iext_max() helper
Date:   Mon, 26 Jul 2021 17:15:32 +0530
Message-Id: <20210726114541.24898-4-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726114541.24898-1-chandanrlinux@gmail.com>
References: <20210726114541.24898-1-chandanrlinux@gmail.com>
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
 fs/xfs/libxfs/xfs_bmap.c       | 9 ++++-----
 fs/xfs/libxfs/xfs_inode_buf.c  | 8 +++-----
 fs/xfs/libxfs/xfs_inode_fork.c | 6 +++---
 fs/xfs/libxfs/xfs_inode_fork.h | 8 ++++++++
 fs/xfs/scrub/inode_repair.c    | 2 +-
 5 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 8f262405a5b5..282aeb3c0e49 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -75,13 +75,12 @@ xfs_bmap_compute_maxlevels(
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
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 66d13e8fa420..419b92dc6ac8 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -343,6 +343,7 @@ xfs_dinode_verify_fork(
 	int			whichfork)
 {
 	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		max_extents;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
 	case XFS_DINODE_FMT_LOCAL:
@@ -364,12 +365,9 @@ xfs_dinode_verify_fork(
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
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 6f4b14d3d381..c6856ec95335 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -729,6 +729,7 @@ xfs_iext_count_may_overflow(
 	int			whichfork,
 	int			nr_to_add)
 {
+	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	uint64_t		max_exts;
 	uint64_t		nr_exts;
@@ -736,10 +737,9 @@ xfs_iext_count_may_overflow(
 	if (whichfork == XFS_COW_FORK)
 		return 0;
 
-	max_exts = (whichfork == XFS_ATTR_FORK) ?
-		XFS_IFORK_EXTCNT_MAXS16 : XFS_IFORK_EXTCNT_MAXS32;
+	max_exts = xfs_iext_max(mp, whichfork);
 
-	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
 		max_exts = 10;
 
 	nr_exts = ifp->if_nextents + nr_to_add;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index cf82be263b48..1eda2163603e 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
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
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index c44f8d06939b..a44d7b48c374 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1198,7 +1198,7 @@ xrep_inode_blockcounts(
 			return error;
 		if (count >= sc->mp->m_sb.sb_dblocks)
 			return -EFSCORRUPTED;
-		if (nextents >= XFS_IFORK_EXTCNT_MAXS16)
+		if (nextents >= xfs_iext_max(sc->mp, XFS_ATTR_FORK))
 			return -EFSCORRUPTED;
 		ifp->if_nextents = nextents;
 	} else {
-- 
2.30.2

