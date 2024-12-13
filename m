Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04CF629
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052011; cv=none; b=N3zgJKsH1rJX7sMTn6PJ411R/l5h1gxoHkbqc50b2ebPCgJFqnZ6lvyiiCQWPm7Cqo5nCxz6Afm9e3RMJp6gjDXz4V1KD182eNGa/EhRgijyV0H81SN8dVVRwCCNkwPQFKUuY0BlsdKx2KXaqYexeusvB2U8eiZ08WtJkiseheQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052011; c=relaxed/simple;
	bh=WUM6qnQ6Ne2z0qNRG752efCJR0fVEV9gVW9BMzP9bAY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GLtLHWYTH5cwDnYWWKC93FfsgFzYiW44sS6q3fro2Hw8kB/Zwd5nOn9ICL3BXSz/Fn3dK5ptk0O521rM6W4zWF1pzY4xKWPGH8Yp4X1T22LOAFEUV22SrvYCVFjYWbw3I4Y94amnSgoxOXX98IMB+g3/1xsv8VbPz/HUZN2HjCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o5LrSnIf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o5LrSnIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98C2C4CED3;
	Fri, 13 Dec 2024 01:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052010;
	bh=WUM6qnQ6Ne2z0qNRG752efCJR0fVEV9gVW9BMzP9bAY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=o5LrSnIfDm7JOXadnoILNba+qzxYEcMvExZICOHbiJDcrt9Memdrnz74Q2s1jPbJl
	 xQaHgePP5LP/LhjVjDyXZGi9n0xfcpDCsDfrbqqqG7TV1v+WelNKgTPQ0A6uL8zaIj
	 rDHtW6FlZCvEEiLb4r3NgY5JYANyUdA9p7Pqf8w5PIHW7W2rbQG0ai1m2qG+dmRrOz
	 z38g0AqenubtqVHZg9x5LOicYbAo8hG3alsHDbV41L+/69R6nhUItzO2ZtItNDxRVe
	 bMx/lZusUuwJzZDL/X0vxEcc0Vkn/A8+jn3XkzQ44Z8mHNYb/oHiQFwJ2XtozvS2DJ
	 KbwnkvwOan9Jw==
Date: Thu, 12 Dec 2024 17:06:50 -0800
Subject: [PATCH 24/37] xfs: scan rt rmap when we're doing an intense rmap
 check of bmbt mappings
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405123727.1181370.595086889127827740.stgit@frogsfrogsfrogs>
In-Reply-To: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Teach the bmbt scrubber how to perform a comprehensive check that the
rmapbt does not contain /any/ mappings that are not described by bmbt
records when it's dealing with a realtime file.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c |   48 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 42 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index b7f9f3b3d81a3a..f6077b0cba8a14 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -21,6 +21,8 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_rtgroup.h"
 #include "xfs_health.h"
+#include "xfs_rtalloc.h"
+#include "xfs_rtrmap_btree.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
@@ -641,8 +643,7 @@ xchk_bmap_check_rmap(
 			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 					check_rec.rm_offset);
 		if (irec.br_startblock !=
-		    xfs_agbno_to_fsb(to_perag(cur->bc_group),
-				check_rec.rm_startblock))
+		    xfs_gbno_to_fsb(cur->bc_group, check_rec.rm_startblock))
 			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 					check_rec.rm_offset);
 		if (irec.br_blockcount > check_rec.rm_blockcount)
@@ -696,6 +697,30 @@ xchk_bmap_check_ag_rmaps(
 	return error;
 }
 
+/* Make sure each rt rmap has a corresponding bmbt entry. */
+STATIC int
+xchk_bmap_check_rt_rmaps(
+	struct xfs_scrub		*sc,
+	struct xfs_rtgroup		*rtg)
+{
+	struct xchk_bmap_check_rmap_info sbcri;
+	struct xfs_btree_cur		*cur;
+	int				error;
+
+	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
+	cur = xfs_rtrmapbt_init_cursor(sc->tp, rtg);
+
+	sbcri.sc = sc;
+	sbcri.whichfork = XFS_DATA_FORK;
+	error = xfs_rmap_query_all(cur, xchk_bmap_check_rmap, &sbcri);
+	if (error == -ECANCELED)
+		error = 0;
+
+	xfs_btree_del_cursor(cur, error);
+	xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
+	return error;
+}
+
 /*
  * Decide if we want to scan the reverse mappings to determine if the attr
  * fork /really/ has zero space mappings.
@@ -750,10 +775,6 @@ xchk_bmap_check_empty_datafork(
 {
 	struct xfs_ifork	*ifp = &ip->i_df;
 
-	/* Don't support realtime rmap checks yet. */
-	if (XFS_IS_REALTIME_INODE(ip))
-		return false;
-
 	/*
 	 * If the dinode repair found a bad data fork, it will reset the fork
 	 * to extents format with zero records and wait for the this scrubber
@@ -804,6 +825,21 @@ xchk_bmap_check_rmaps(
 	struct xfs_perag	*pag = NULL;
 	int			error;
 
+	if (xfs_ifork_is_realtime(sc->ip, whichfork)) {
+		struct xfs_rtgroup	*rtg = NULL;
+
+		while ((rtg = xfs_rtgroup_next(sc->mp, rtg))) {
+			error = xchk_bmap_check_rt_rmaps(sc, rtg);
+			if (error ||
+			    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)) {
+				xfs_rtgroup_rele(rtg);
+				return error;
+			}
+		}
+
+		return 0;
+	}
+
 	while ((pag = xfs_perag_next(sc->mp, pag))) {
 		error = xchk_bmap_check_ag_rmaps(sc, whichfork, pag);
 		if (error ||

