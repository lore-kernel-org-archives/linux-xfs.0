Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44202 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726653AbfEIRD7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 May 2019 13:03:59 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4B14A30018F9
        for <linux-xfs@vger.kernel.org>; Thu,  9 May 2019 16:58:40 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 085E310018FB
        for <linux-xfs@vger.kernel.org>; Thu,  9 May 2019 16:58:39 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/6] xfs: refactor small allocation helper to skip cntbt attempt
Date: Thu,  9 May 2019 12:58:34 -0400
Message-Id: <20190509165839.44329-2-bfoster@redhat.com>
In-Reply-To: <20190509165839.44329-1-bfoster@redhat.com>
References: <20190509165839.44329-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The small allocation helper is implemented in a way that is fairly
tightly integrated to the existing allocation algorithms. It expects
a cntbt cursor beyond the end of the tree, attempts to locate the
last record in the tree and only attempts an AGFL allocation if the
cntbt is empty.

The upcoming generic algorithm doesn't rely on the cntbt processing
of this function. It will only call this function when the cntbt
doesn't have a big enough extent or is empty and thus AGFL
allocation is the only remaining option. Tweak
xfs_alloc_ag_vextent_small() to handle a NULL cntbt cursor and skip
the cntbt logic. This facilitates use by the existing allocation
code and new code that only requires an AGFL allocation attempt.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 52 +++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index a9ff3cf82cce..55eda416e18b 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1589,33 +1589,36 @@ xfs_alloc_ag_vextent_size(
  */
 STATIC int			/* error */
 xfs_alloc_ag_vextent_small(
-	xfs_alloc_arg_t	*args,	/* allocation argument structure */
-	xfs_btree_cur_t	*ccur,	/* by-size cursor */
-	xfs_agblock_t	*fbnop,	/* result block number */
-	xfs_extlen_t	*flenp,	/* result length */
-	int		*stat)	/* status: 0-freelist, 1-normal/none */
+	struct xfs_alloc_arg	*args,	/* allocation argument structure */
+	struct xfs_btree_cur	*ccur,	/* optional by-size cursor */
+	xfs_agblock_t		*fbnop,	/* result block number */
+	xfs_extlen_t		*flenp,	/* result length */
+	int			*stat)	/* status: 0-freelist, 1-normal/none */
 {
-	int		error;
-	xfs_agblock_t	fbno;
-	xfs_extlen_t	flen;
-	int		i;
+	int			error = 0;
+	xfs_agblock_t		fbno;
+	xfs_extlen_t		flen;
+	int			i = 0;
 
-	if ((error = xfs_btree_decrement(ccur, 0, &i)))
+	/*
+	 * If a cntbt cursor is provided, try to allocate the largest record in
+	 * the tree. Try the AGFL if the cntbt is empty, otherwise fail the
+	 * allocation. Make sure to respect minleft even when pulling from the
+	 * freelist.
+	 */
+	if (ccur)
+		error = xfs_btree_decrement(ccur, 0, &i);
+	if (error)
 		goto error0;
 	if (i) {
-		if ((error = xfs_alloc_get_rec(ccur, &fbno, &flen, &i)))
+		error = xfs_alloc_get_rec(ccur, &fbno, &flen, &i);
+		if (error)
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
-	}
-	/*
-	 * Nothing in the btree, try the freelist.  Make sure
-	 * to respect minleft even when pulling from the
-	 * freelist.
-	 */
-	else if (args->minlen == 1 && args->alignment == 1 &&
-		 args->resv != XFS_AG_RESV_AGFL &&
-		 (be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_flcount)
-		  > args->minleft)) {
+	} else if (args->minlen == 1 && args->alignment == 1 &&
+		   args->resv != XFS_AG_RESV_AGFL &&
+		   (be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_flcount) >
+		    args->minleft)) {
 		error = xfs_alloc_get_freelist(args->tp, args->agbp, &fbno, 0);
 		if (error)
 			goto error0;
@@ -1661,14 +1664,11 @@ xfs_alloc_ag_vextent_small(
 		 */
 		else
 			flen = 0;
-	}
-	/*
-	 * Can't allocate from the freelist for some reason.
-	 */
-	else {
+	} else {
 		fbno = NULLAGBLOCK;
 		flen = 0;
 	}
+
 	/*
 	 * Can't do the allocation, give up.
 	 */
-- 
2.17.2
