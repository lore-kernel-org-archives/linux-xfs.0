Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:39840 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933388AbeFUMfc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Jun 2018 08:35:32 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EB1274059FEC
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 12:35:31 +0000 (UTC)
Received: from odin.usersys.redhat.com (unknown [10.40.205.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E3B116877
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 12:35:31 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] Fix coverity scan reports
Date: Thu, 21 Jun 2018 14:35:25 +0200
Message-Id: <20180621123525.5365-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Initialize a few variables before pass them by reference in other
functions.

This quiets the following Coverity reports:

CID 100898
CID 1437081
CID 1437129
CID 1437191
CID 1437201
CID 1437212
CID 1437341

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

There is another coverity issue (CID 1437358), which actually looks more
important, which really looks to pass an uninitialized value to
xfs_getfsmap_rtdev_rtbitmap_helper(), where such looks to expect the variable to
be already initialized. I'm familiar with RT code, so looking into it yet, but
I think this one deservers a separated patch if that can really trigger a bug.

 fs/xfs/libxfs/xfs_alloc.c | 14 +++++++-------
 fs/xfs/scrub/agheader.c   |  4 ++--
 fs/xfs/scrub/alloc.c      |  2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index eef466260d43..ffdd50f5af32 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -421,8 +421,8 @@ xfs_alloc_fixup_trees(
 {
 	int		error;		/* error code */
 	int		i;		/* operation results */
-	xfs_agblock_t	nfbno1;		/* first new free startblock */
-	xfs_agblock_t	nfbno2;		/* second new free startblock */
+	xfs_agblock_t	nfbno1=0;	/* first new free startblock */
+	xfs_agblock_t	nfbno2=0;	/* second new free startblock */
 	xfs_extlen_t	nflen1=0;	/* first new free length */
 	xfs_extlen_t	nflen2=0;	/* second new free length */
 	struct xfs_mount *mp;
@@ -783,8 +783,8 @@ xfs_alloc_ag_vextent_exact(
 	xfs_btree_cur_t	*bno_cur;/* by block-number btree cursor */
 	xfs_btree_cur_t	*cnt_cur;/* by count btree cursor */
 	int		error;
-	xfs_agblock_t	fbno;	/* start block of found extent */
-	xfs_extlen_t	flen;	/* length of found extent */
+	xfs_agblock_t	fbno=0;	/* start block of found extent */
+	xfs_extlen_t	flen=0;	/* length of found extent */
 	xfs_agblock_t	tbno;	/* start block of busy extent */
 	xfs_extlen_t	tlen;	/* length of busy extent */
 	xfs_agblock_t	tend;	/* end block of busy extent */
@@ -1597,7 +1597,7 @@ xfs_alloc_ag_vextent_small(
 	int		error;
 	xfs_agblock_t	fbno;
 	xfs_extlen_t	flen;
-	int		i;
+	int		i = 0;
 
 	if ((error = xfs_btree_decrement(ccur, 0, &i)))
 		goto error0;
@@ -1704,8 +1704,8 @@ xfs_free_ag_extent(
 	xfs_btree_cur_t	*bno_cur;	/* cursor for by-block btree */
 	xfs_btree_cur_t	*cnt_cur;	/* cursor for by-size btree */
 	int		error;		/* error return value */
-	xfs_agblock_t	gtbno;		/* start of right neighbor block */
-	xfs_extlen_t	gtlen;		/* length of right neighbor block */
+	xfs_agblock_t	gtbno=0;	/* start of right neighbor block */
+	xfs_extlen_t	gtlen=0;	/* length of right neighbor block */
 	int		haveleft;	/* have a left neighbor block */
 	int		haveright;	/* have a right neighbor block */
 	int		i;		/* temp, result code */
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 9bb0745f1ad2..78a7381d6ca0 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -388,8 +388,8 @@ xfs_scrub_agf_xref_cntbt(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_agf			*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
-	xfs_agblock_t			agbno;
-	xfs_extlen_t			blocks;
+	xfs_agblock_t			agbno = 0;
+	xfs_extlen_t			blocks = 0;
 	int				have;
 	int				error;
 
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 50e4f7fa06f0..c82347da400f 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -47,7 +47,7 @@ xfs_scrub_allocbt_xref_other(
 	xfs_extlen_t			len)
 {
 	struct xfs_btree_cur		**pcur;
-	xfs_agblock_t			fbno;
+	xfs_agblock_t			fbno = 0;
 	xfs_extlen_t			flen;
 	int				has_otherrec;
 	int				error;
-- 
2.14.3

