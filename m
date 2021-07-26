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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94131C432BE
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72ABE603E9
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbhGZLFa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbhGZLFa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 07:05:30 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CECDC061757
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:45:59 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id pf12-20020a17090b1d8cb0290175c085e7a5so19351183pjb.0
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=egX49VLOYW0Ka8wk9leDQQi6L1Fb5WhS4AtKGZoZ0bg=;
        b=IOE+jhbCLmqeyOiwYg07UIOXrvX+xkpf8RxMKUlfAvTwnuX+B3TPAmhAJjOi4HAvGa
         Wr03ekmVaiQYB/v5Wyagu1iKHX4D3uN5MHLlRH/2NcfJaMXsqVREZrOhGoU2M/HlTyHR
         ifg+Um6pIawEWmxvEDp2SlLLXQRlNOdde4eyDw79NrMaqdOEeP1v2sHPkz7gIqekqPXO
         5yN8IbUYt0Odojtl4kvoDLwAaJZyCCSgG0uemxkbf858usij2HJON6/XbCP3qwnfc5q+
         lx1T+Qq1wOFaF70MH2HxALi2Yr0SaQ2Y8eVd8ptiCJ/CMyyGOo5byvMJZDLeIeaM0F3Z
         otkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=egX49VLOYW0Ka8wk9leDQQi6L1Fb5WhS4AtKGZoZ0bg=;
        b=VwfTbfScYGNJEdBxLsNfZmrVLMUZgivNDz4mqvrG7SFvosY9hyh/LyItStnjSeNYhC
         4GblHjraFvMyhxW2lvWD67VeaJLgBEKqA1E6zmV8V6Hu+p9dzdFEOP84W0y0571rpzpR
         fUmnRyG5ew95vYi5b12fhLCf7RL13bXy0W0viegB5vzTaZFXjTVQTbCpZ4BGRf0fcCD2
         1sBSecv8PnsBxVSr2uICMmXnlkKnA1p2QpYM8Eulf6VuGJ0/Zv5QL1FqxaleRZ5OQ67O
         HZQpPfxFKXK9UWKVfaZkIXDRbPgk8Waj+8AAf86mk/iijROpEvd4HNXG0+D/QVzBOROc
         3Eow==
X-Gm-Message-State: AOAM5316E/IfZq7QyZarIfGeFMgWk4klPpxAurfzrSt8DuTraw3ZF0eo
        w+P5YqCHihmQr3Is/7g1aJHN3C3ul54=
X-Google-Smtp-Source: ABdhPJzt1n97hswKbwIWVEJ/VGYLv59nImFoi0wmXwzBPH3+0AOaQLewuC+AqAs16f92kBzTXV4W6w==
X-Received: by 2002:a17:90a:ea98:: with SMTP id h24mr25422740pjz.7.1627299958846;
        Mon, 26 Jul 2021 04:45:58 -0700 (PDT)
Received: from localhost.localdomain ([122.179.41.55])
        by smtp.gmail.com with ESMTPSA id k8sm50833919pgr.91.2021.07.26.04.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 04:45:58 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org
Subject: [PATCH V2 04/12] xfs: Use xfs_extnum_t instead of basic data types
Date:   Mon, 26 Jul 2021 17:15:33 +0530
Message-Id: <20210726114541.24898-5-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726114541.24898-1-chandanrlinux@gmail.com>
References: <20210726114541.24898-1-chandanrlinux@gmail.com>
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
 fs/xfs/libxfs/xfs_bmap.c       | 2 +-
 fs/xfs/libxfs/xfs_inode_buf.c  | 2 +-
 fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
 fs/xfs/scrub/inode.c           | 2 +-
 fs/xfs/scrub/inode_repair.c    | 2 +-
 fs/xfs/xfs_trace.h             | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 282aeb3c0e49..e5d243fd187d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -53,9 +53,9 @@ xfs_bmap_compute_maxlevels(
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
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 419b92dc6ac8..cba9a38f3270 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -342,7 +342,7 @@ xfs_dinode_verify_fork(
 	struct xfs_mount	*mp,
 	int			whichfork)
 {
-	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
 	xfs_extnum_t		max_extents;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index c6856ec95335..a1e40df585a3 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -107,7 +107,7 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
 	int			size = nex * sizeof(xfs_bmbt_rec_t);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index e6068590484b..246d11ca133f 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -219,7 +219,7 @@ xchk_dinode(
 	size_t			fork_recs;
 	unsigned long long	isize;
 	uint64_t		flags2;
-	uint32_t		nextents;
+	xfs_extnum_t		nextents;
 	prid_t			prid;
 	uint16_t		flags;
 	uint16_t		mode;
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index a44d7b48c374..042c7d0bc0f5 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -597,9 +597,9 @@ xrep_dinode_bad_extents_fork(
 {
 	struct xfs_bmbt_irec	new;
 	struct xfs_bmbt_rec	*dp;
+	xfs_extnum_t		nex;
 	bool			isrt;
 	int			i;
-	int			nex;
 	int			fork_size;
 
 	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index affc9b5834fb..5ed11f894f79 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2338,7 +2338,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 		__field(int, which)
 		__field(xfs_ino_t, ino)
 		__field(int, format)
-		__field(int, nex)
+		__field(xfs_extnum_t, nex)
 		__field(int, broot_size)
 		__field(int, fork_off)
 	),
-- 
2.30.2

