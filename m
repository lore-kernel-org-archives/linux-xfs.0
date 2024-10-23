Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476AC1ABEA9
	for <linux-xfs@vger.kernel.org>; Wed, 23 Oct 2024 13:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729690686; cv=none; b=Nk4IjHrmn2MWbZcMnB1a9a8PkcZC3ouZK6wtLY6LOyV/8ekpAsx2rggUzBQSvBF+5AIwZj0tzYjbZ3Y6Y0yQq5XnNFtqp3FDVI15vxk9F6ZnY+GznrgOxowH6VYOop5zosghbmKPSC75+Dgxzgad2ZCPmg1UNS3adWtiN06t1xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729690686; c=relaxed/simple;
	bh=oAp74vRkIU2XQNg4+dscI4vW6LqrY2RbbFO/uJ3+gbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=esXyynXDHToGgsYtT9NEgOKAgkqLKoQx4kTfbjHXM/AuKvMIOVvbG0NXpi2JVvWiOEE+Fq1lB22x5qKXJwGW5gemy2WVWpXWugSEle5jDwFZAIuMA9RE5/TKBhru7ButOBRdDNNsVfD5RLt7i/acLW5mpLnVG+7qdH3wYeauaB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qKu4bm1K; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qKu4bm1K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mq2hJxX1HWeG3WjvESgrctXx7aBUC0OIOmwLfPHGXws=; b=qKu4bm1KaY0+3uhNslVzDZLPJb
	cdv/dIcekwfdnlW8bCjksdKSMD92RtdBXA+TDyxN8Vr9q5IrgPrno8Soc7KyMXDN/Hmf+EVZEOAe6
	JrzL8qjPjh5XXFO3HPzXckKMg/pXy+9XEWQH+zn13h9FRq0yReBQPJwBLnSFGlw7fyYpXe/4kb06z
	QbVgxdZHvnmb3tjEKXnFdrbwgpxRrFIh/+mUgmbEGZxnUwtHq2MbAaWRO1Y9a05um7tds9mpd6xPp
	T14H3e2ISNnYMIf4THWbVG9W28p9p5VtkISIwIuXW+Jn/MkWllekEf9cmOiXHnNJGQby6H4Pll7IT
	vHP0ZL+Q==;
Received: from 2a02-8389-2341-5b80-8c6c-e123-fc47-94a5.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8c6c:e123:fc47:94a5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t3bYq-0000000EZWT-0n2C;
	Wed, 23 Oct 2024 13:38:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: streamline xfs_filestream_pick_ag
Date: Wed, 23 Oct 2024 15:37:23 +0200
Message-ID: <20241023133755.524345-3-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241023133755.524345-1-hch@lst.de>
References: <20241023133755.524345-1-hch@lst.de>
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
 fs/xfs/xfs_filestream.c | 96 ++++++++++++++++++++---------------------
 1 file changed, 46 insertions(+), 50 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 88bd23ce74cd..290ba8887d29 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -67,22 +67,28 @@ xfs_filestream_pick_ag(
 	xfs_extlen_t		minfree, maxfree = 0;
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
@@ -107,7 +113,9 @@ xfs_filestream_pick_ag(
 			     !(flags & XFS_PICK_USERDATA) ||
 			     (flags & XFS_PICK_LOWSPACE))) {
 				/* Break out, retaining the reference on the AG. */
-				break;
+				if (max_pag)
+					xfs_perag_rele(max_pag);
+				goto done;
 			}
 		}
 
@@ -115,56 +123,44 @@ xfs_filestream_pick_ag(
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
-
-		/*
-		 * No unassociated AGs are available, so select the AG with the
-		 * most free space, regardless of whether it's already in use by
-		 * another filestream. It none suit, just use whatever AG we can
-		 * grab.
-		 */
-		if (!max_pag) {
-			for_each_perag_wrap(args->mp, 0, start_agno, pag) {
-				max_pag = pag;
-				break;
-			}
+	/*
+	 * We must be low on data space, so run a final lowspace optimised
+	 * selection pass if we haven't already.
+	 */
+	if (!(flags & XFS_PICK_LOWSPACE)) {
+		flags |= XFS_PICK_LOWSPACE;
+		goto restart;
+	}
 
-			/* Bail if there are no AGs at all to select from. */
-			if (!max_pag)
-				return -ENOSPC;
+	/*
+	 * No unassociated AGs are available, so select the AG with the most
+	 * free space, regardless of whether it's already in use by another
+	 * filestream. It none suit, just use whatever AG we can grab.
+	 */
+	if (!max_pag) {
+		for_each_perag_wrap(args->mp, 0, start_agno, pag) {
+			max_pag = pag;
+			break;
 		}
 
-		pag = max_pag;
-		atomic_inc(&pag->pagf_fstrms);
-	} else if (max_pag) {
-		xfs_perag_rele(max_pag);
+		/* Bail if there are no AGs at all to select from. */
+		if (!max_pag)
+			return -ENOSPC;
 	}
 
+	pag = max_pag;
+	atomic_inc(&pag->pagf_fstrms);
+done:
 	trace_xfs_filestream_pick(pag, pino);
 	args->pag = pag;
 	return 0;
-- 
2.45.2

