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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8120C4320A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C21E660F38
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbhGZLHN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbhGZLHM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 07:07:12 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B910DC061757
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:47:41 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id q17-20020a17090a2e11b02901757deaf2c8so13921085pjd.0
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cb0C/N7rzztA8FbrAmysDpDCe8obSpkpE98jtL7+GAE=;
        b=Q5lhaK+mQOSBPPVshzcN76LGFCvAiMwxmaLhX3xZKpn1bWwLFeBtCMyT9SOci3ktcG
         G1/7NZcFlvDrRZOlx1N4x4n6Ji+I8ZqC6HbTRp9pAk1PYkop0yLK3sB+sXapW4YWaP1v
         Zb1VHPWoIniZraGdLQkB6RD+smEiEkMP54senmtHaJDd71i7I4cHMrsf8i3DRdlliDbf
         iCJwSrz9a554H3PFrXTuKT85TtcA1nsbPtT17ndvefzq6foNvdibjgWK1BCSxufeVNgK
         XH1YpF+4B15hjC/ev3wQXi428pZPi1w9tweshJ8YCD7X7fJh0LtJHG6HbS4PqtusSzPa
         QZQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cb0C/N7rzztA8FbrAmysDpDCe8obSpkpE98jtL7+GAE=;
        b=ZPDpv3duENl91t+ouDCGUiPy33hRyTFwepu5aL5aTJ4VjlgzI3yfwxIJBOZ5d5I/0U
         VEwKjzvf8TvATyawi0Uq0461ntwlrttSJCKtg/WsJI++8ONoAiuhaUoTwIyXNpcnwp45
         nXE0b3y9L4DJ4Kd7dudHmaQUAAxmy+ho6JnpqDYurM3MW6mrT5wzXzPsH5f8NxKj6D/z
         zikggVPof29daJNjxdFKX1Aq0wQnn6qH+3YsBsBm3dqnKZeDK2mcB/I0UpnYumTOUtNO
         vZIKco7/QuF0gGoze02wdyLaD/pXt3Ztd1OEEnLkGY9mHOq+TeL1xaFDuvIYQfHlJ/Ch
         BSpg==
X-Gm-Message-State: AOAM531HpVrTXi+WmzX5Rjn8NaV0791zxXEMNfFiBH1jyACNjqHNJTUS
        1TmyVQ0cIL7SIdvcP2QNzGW4+NgP8BU=
X-Google-Smtp-Source: ABdhPJwciqhFtNZUKnxwq3Op3bBF0uNmBmQIdKP2Nok6NJ9QJ4pvKEsjz3VZlxeWGfey39ww2KJeLA==
X-Received: by 2002:a63:4a43:: with SMTP id j3mr17910826pgl.302.1627300061232;
        Mon, 26 Jul 2021 04:47:41 -0700 (PDT)
Received: from localhost.localdomain ([122.179.41.55])
        by smtp.gmail.com with ESMTPSA id y10sm35936900pjy.18.2021.07.26.04.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 04:47:41 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org
Subject: [PATCH V2 04/12] xfsprogs: Use xfs_extnum_t instead of basic data types
Date:   Mon, 26 Jul 2021 17:17:16 +0530
Message-Id: <20210726114724.24956-5-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726114724.24956-1-chandanrlinux@gmail.com>
References: <20210726114724.24956-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_extnum_t is the type to use to declare variables which have values
obtained from xfs_dinode->di_[a]nextents. This commit replaces basic
types (e.g. uint32_t) with xfs_extnum_t for such variables.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 db/bmap.c               | 2 +-
 db/frag.c               | 2 +-
 libxfs/xfs_bmap.c       | 2 +-
 libxfs/xfs_inode_buf.c  | 2 +-
 libxfs/xfs_inode_fork.c | 2 +-
 repair/dinode.c         | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/db/bmap.c b/db/bmap.c
index 5f81d2b52..50f0474bc 100644
--- a/db/bmap.c
+++ b/db/bmap.c
@@ -47,7 +47,7 @@ bmap(
 	int			n;
 	int			nex;
 	xfs_fsblock_t		nextbno;
-	int			nextents;
+	xfs_extnum_t		nextents;
 	xfs_bmbt_ptr_t		*pp;
 	xfs_bmdr_block_t	*rblock;
 	typnm_t			typ;
diff --git a/db/frag.c b/db/frag.c
index 570ad3b74..90fa2131c 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -273,7 +273,7 @@ process_fork(
 	int		whichfork)
 {
 	extmap_t	*extmap;
-	int		nex;
+	xfs_extnum_t	nex;
 
 	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
 	if (!nex)
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 608ae5b83..dd60d8105 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -46,9 +46,9 @@ xfs_bmap_compute_maxlevels(
 	xfs_mount_t	*mp,		/* file system mount structure */
 	int		whichfork)	/* data or attr fork */
 {
+	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		level;		/* btree level */
 	uint		maxblocks;	/* max blocks at this level */
-	uint		maxleafents;	/* max leaf entries possible */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 056fe252b..b2e8e431a 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -339,7 +339,7 @@ xfs_dinode_verify_fork(
 	struct xfs_mount	*mp,
 	int			whichfork)
 {
-	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
 	xfs_extnum_t		max_extents;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 4cd117382..48afaaeec 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -105,7 +105,7 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
 	int			size = nex * sizeof(xfs_bmbt_rec_t);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
diff --git a/repair/dinode.c b/repair/dinode.c
index a0c5be7c3..a034b5e86 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -967,7 +967,7 @@ process_exinode(
 	xfs_bmbt_rec_t		*rp;
 	xfs_fileoff_t		first_key;
 	xfs_fileoff_t		last_key;
-	int32_t			numrecs;
+	xfs_extnum_t		numrecs;
 	int			ret;
 
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
-- 
2.30.2

