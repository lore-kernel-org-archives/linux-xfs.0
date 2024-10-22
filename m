Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED12E19CC32
	for <linux-xfs@vger.kernel.org>; Tue, 22 Oct 2024 12:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729599242; cv=none; b=qlJWfrr8VLVmNpjEOGg6PpNUAXF2XVC9Xym+QjZG6ZQG6qEnUMgE7tvlsvwVVLg72HUECRNI3nqgLC979LIXT3AvsUKCkAM+DdAYLfbo1Qn30eorJYcsmVFyMtl7eBN+83zlEDxMyxK8/LpOZteblOY1zzitcggHhpbGYn4Ssss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729599242; c=relaxed/simple;
	bh=OIKdbuGzn3Ab2uPUrIMu0bpCJylBR9fSDi4NCl/R4Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tf/eIfHungw6t17PyFQi+/IDa02yNd/aas02lvzgO5DfRzge0tABsk++YJXDASqFsKCVghHV+LOx3BVzGg2S11qfnpnnt4y9BtjqbQ1aom0UvD386CLSWOQ45HNam2m0sWa9ScnfPRt74gdnhrByidRlro9Bj9IdcGK8RA2l2rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=08x/9raZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="08x/9raZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=93nhMdm69+/8DgLvtPv8a7WlhzSAkSiUCxRMJvvPUOM=; b=08x/9raZOZ+bw8o+KifXccvQYl
	LhS/1wOpR9jYi7jX+kNqBEhm5BgyXUeJctvaShd4YUYTWy/pe1tAv15IK8iiNV9cguqv61C+jZ2A2
	sphGYYVwAkZgOYw3dU1TAXEbzFJn6ukVyLsooSePJgK5q9EFRQ3r+VeFZXLxfgeP35ITWM4gvhy2w
	sI1h9RLGJ+CQztoJwVrDcSxtYnJc0/kyj1A6nrRq/b1NxchCw0QHrTAjbO1suJDKjogQn8Kkks43u
	Rp1m8ej672FhXVRDnXVpBgXJVPCEJ+AxnfGxYQkRn9uGYtu5+luPowR32QdafDjdGfPCe6x+cwKaA
	UAS2LpoQ==;
Received: from 2a02-8389-2341-5b80-1159-405c-1641-8dd9.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1159:405c:1641:8dd9] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t3Dlw-0000000Ao1Y-0vOQ;
	Tue, 22 Oct 2024 12:14:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: streamline xfs_filestream_pick_ag
Date: Tue, 22 Oct 2024 14:13:37 +0200
Message-ID: <20241022121355.261836-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241022121355.261836-1-hch@lst.de>
References: <20241022121355.261836-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Directly return the error from xfs_bmap_longest_free_extent instead
of breaking from the loop and handling it there, and use a done
label to directly jump to the exist when we found a suitable perag
structure to reduce the indentation level and pag/max_pag check
complexity in the tail of the function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_filestream.c | 95 ++++++++++++++++++++---------------------
 1 file changed, 46 insertions(+), 49 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index e3aaa055559781..f523027cc32586 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -67,22 +67,28 @@ xfs_filestream_pick_ag(
 	xfs_extlen_t		free = 0, minfree, maxfree = 0;
 	xfs_agnumber_t		agno;
 	bool			first_pass = true;
-	int			err;
 
 	/* 2% of an AG's blocks must be free for it to be chosen. */
 	minfree = mp->m_sb.sb_agblocks / 50;
 
 restart:
 	for_each_perag_wrap(mp, start_agno, agno, pag) {
+		int		err;
+
 		trace_xfs_filestream_scan(pag, pino);
+
 		*longest = 0;
 		err = xfs_bmap_longest_free_extent(pag, NULL, longest);
 		if (err) {
-			if (err != -EAGAIN)
-				break;
-			/* Couldn't lock the AGF, skip this AG. */
-			err = 0;
-			continue;
+			if (err == -EAGAIN) {
+				/* Couldn't lock the AGF, skip this AG. */
+				err = 0;
+				continue;
+			}
+			xfs_perag_rele(pag);
+			if (max_pag)
+				xfs_perag_rele(max_pag);
+			return err;
 		}
 
 		/* Keep track of the AG with the most free blocks. */
@@ -108,7 +114,9 @@ xfs_filestream_pick_ag(
 			     (flags & XFS_PICK_LOWSPACE))) {
 				/* Break out, retaining the reference on the AG. */
 				free = pag->pagf_freeblks;
-				break;
+				if (max_pag)
+					xfs_perag_rele(max_pag);
+				goto done;
 			}
 		}
 
@@ -116,53 +124,42 @@ xfs_filestream_pick_ag(
 		atomic_dec(&pag->pagf_fstrms);
 	}
 
-	if (err) {
-		xfs_perag_rele(pag);
-		if (max_pag)
-			xfs_perag_rele(max_pag);
-		return err;
+	/*
+	 * Allow a second pass to give xfs_bmap_longest_free_extent() another
+	 * attempt at locking AGFs that it might have skipped over before we
+	 * fail.
+	 */
+	if (first_pass) {
+		first_pass = false;
+		goto restart;
 	}
 
-	if (!pag) {
-		/*
-		 * Allow a second pass to give xfs_bmap_longest_free_extent()
-		 * another attempt at locking AGFs that it might have skipped
-		 * over before we fail.
-		 */
-		if (first_pass) {
-			first_pass = false;
-			goto restart;
-		}
-
-		/*
-		 * We must be low on data space, so run a final lowspace
-		 * optimised selection pass if we haven't already.
-		 */
-		if (!(flags & XFS_PICK_LOWSPACE)) {
-			flags |= XFS_PICK_LOWSPACE;
-			goto restart;
-		}
+	/*
+	 * We must be low on data space, so run a final lowspace optimised
+	 * selection pass if we haven't already.
+	 */
+	if (!(flags & XFS_PICK_LOWSPACE)) {
+		flags |= XFS_PICK_LOWSPACE;
+		goto restart;
+	}
 
-		/*
-		 * No unassociated AGs are available, so select the AG with the
-		 * most free space, regardless of whether it's already in use by
-		 * another filestream. It none suit, just use whatever AG we can
-		 * grab.
-		 */
-		if (!max_pag) {
-			for_each_perag_wrap(args->mp, 0, start_agno, args->pag)
-				break;
-			atomic_inc(&args->pag->pagf_fstrms);
-			*longest = 0;
-		} else {
-			pag = max_pag;
-			free = maxfree;
-			atomic_inc(&pag->pagf_fstrms);
-		}
-	} else if (max_pag) {
-		xfs_perag_rele(max_pag);
+	/*
+	 * No unassociated AGs are available, so select the AG with the most
+	 * free space, regardless of whether it's already in use by another
+	 * filestream. It none suit, just use whatever AG we can grab.
+	 */
+	if (!max_pag) {
+		for_each_perag_wrap(args->mp, 0, start_agno, args->pag)
+			break;
+		atomic_inc(&args->pag->pagf_fstrms);
+		*longest = 0;
+	} else {
+		pag = max_pag;
+		free = maxfree;
+		atomic_inc(&pag->pagf_fstrms);
 	}
 
+done:
 	trace_xfs_filestream_pick(pag, pino, free);
 	args->pag = pag;
 	return 0;
-- 
2.45.2

