Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBCF37416F
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 13:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778853095; cv=none; b=YVbvV8zBGNiiv3iQVUwXMHw8evf7EiATVcYqM3qC1o97sPj8rZx+5zDLgRvo6q7XMTtoVJGNi2WJlm7H+VwZHhWHxqOZhNSCcaBaCo2kP4+GrpYXfGqSknVmDdOJ5rhJRY0/kiTxY+nqoL/ovqUrW9csmhk+9y778AHEf5UQ5c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778853095; c=relaxed/simple;
	bh=NWnO3PFOf57SENTBo+O+v8k+PViYYBgAckncRUhV6YU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tF2bptxir4rw1pAxNy44iBbwxQZJDpg2NIw3JhC3zrrP54eAdhhC3FDZDWlwX6H/jKP+jDkA9DM4kvzKj/3GQljgSgN9rXWQVdQ5ogzhGtV6py0uEsWKv6tgHINMgMgNvq8S3wwFeqEgjOP0dUPNmtikm4tWcU/8rCgLnVxII+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1kB+6qmK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1kB+6qmK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=buBs1rMLlg+hktGKk4bZq+T8k6pMJlrlBR+LTsTAsg4=; b=1kB+6qmK9NEhzmQ9b9/2rjGhX+
	7wRvkikApeoNUg0+RrjLUkY8yW5Bgrp1rSQivai9X4Ww+3m38IAfVfhuzap34CRSeaSL/+lhng7F0
	zZc4XX8xdaQZTw6swPn3l8qcxNmkKjQwlZUU9eaNMNLLlyNayGOSn7SYqmFGqKbjsBSyvMweYJu2P
	4YBBsnxYk6fQhHR29Gvbn2ce0mdL8TN4kwRhnENWO/tQ/XyMAWSgbl23CGDatDtowumHoRSiqggTw
	NXXHG0T0rpYme+g8NI0FgOi8y8xpwQllG+DdSjWp2clDtoT2M5MkpeV3LFCovUY+aI6Y+y8D44NTn
	Tqy1zYAA==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wNswr-00000008Ube-0F39;
	Fri, 15 May 2026 13:51:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 7/9] xfs: convert xchk_inode_xref_set_corrupt to xchk_ip_xref_set_corrupt
Date: Fri, 15 May 2026 15:50:28 +0200
Message-ID: <20260515135103.4042407-8-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260515135103.4042407-1-hch@lst.de>
References: <20260515135103.4042407-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

All xref corruption reports have the xfs_inode structure, so switch
the helper to work based on that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/common.c    | 6 +++---
 fs/xfs/scrub/common.h    | 4 ++--
 fs/xfs/scrub/dirtree.c   | 4 ++--
 fs/xfs/scrub/inode.c     | 6 +++---
 fs/xfs/scrub/nlinks.c    | 2 +-
 fs/xfs/scrub/rtbitmap.c  | 4 ++--
 fs/xfs/scrub/rtsummary.c | 2 +-
 7 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 5041f0c91603..f4d17239175f 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -309,12 +309,12 @@ xchk_ino_set_corrupt(
 
 /* Record a corruption while cross-referencing with an inode. */
 void
-xchk_ino_xref_set_corrupt(
+xchk_ip_xref_set_corrupt(
 	struct xfs_scrub	*sc,
-	xfs_ino_t		ino)
+	struct xfs_inode	*ip)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XCORRUPT;
-	trace_xchk_ino_error(sc, ino, __return_address);
+	trace_xchk_ino_error(sc, ip->i_ino, __return_address);
 }
 
 /* Record corruption in a block indexed by a file fork. */
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index ae998501f8aa..5f854d3c7e8e 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -41,8 +41,8 @@ void xchk_qcheck_set_corrupt(struct xfs_scrub *sc, unsigned int dqtype,
 
 void xchk_block_xref_set_corrupt(struct xfs_scrub *sc,
 		struct xfs_buf *bp);
-void xchk_ino_xref_set_corrupt(struct xfs_scrub *sc,
-		xfs_ino_t ino);
+void xchk_ip_xref_set_corrupt(struct xfs_scrub *sc,
+		struct xfs_inode *ip);
 void xchk_fblock_xref_set_corrupt(struct xfs_scrub *sc,
 		int whichfork, xfs_fileoff_t offset);
 
diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index 124b2379d5c4..51b37dfa28f0 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -954,7 +954,7 @@ xchk_dirtree(
 		 * parent pointers are corrupt; this scan cannot be completed
 		 * without full information.
 		 */
-		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ip_xref_set_corrupt(sc, sc->ip);
 		error = 0;
 		goto out_scanlock;
 	}
@@ -984,7 +984,7 @@ xchk_dirtree(
 		if (oc.bad || oc.good + oc.suspect != 1)
 			xchk_ip_set_corrupt(sc, sc->ip);
 		if (oc.suspect)
-			xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
+			xchk_ip_xref_set_corrupt(sc, sc->ip);
 	}
 
 out_scanlock:
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 948d04dcba2a..3f234e9c5afd 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -710,17 +710,17 @@ xchk_inode_xref_bmap(
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
 	if (nextents < xfs_dfork_data_extents(dip))
-		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ip_xref_set_corrupt(sc, sc->ip);
 
 	error = xchk_inode_count_blocks(sc, XFS_ATTR_FORK, &nextents, &acount);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
 	if (nextents != xfs_dfork_attr_extents(dip))
-		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ip_xref_set_corrupt(sc, sc->ip);
 
 	/* Check nblocks against the inode. */
 	if (count + acount != be64_to_cpu(dip->di_nblocks))
-		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ip_xref_set_corrupt(sc, sc->ip);
 }
 
 /* Cross-reference with the other btrees. */
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index 2a214802c77c..01ce6517a036 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -740,7 +740,7 @@ xchk_nlinks_compare_inode(
 		 * number of subdirectory entries in the directory.
 		 */
 		if (obs.children != obs.backrefs)
-			xchk_ino_xref_set_corrupt(sc, ip->i_ino);
+			xchk_ip_xref_set_corrupt(sc, ip);
 	} else {
 		/*
 		 * Non-directories and unlinked directories should not have
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 10d4c11372d9..de3f22f310f7 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -284,7 +284,7 @@ xchk_xref_is_used_rt_space(
 	if (xfs_has_zoned(sc->mp)) {
 		if (!xfs_zone_rgbno_is_valid(rtg,
 				xfs_rtb_to_rgbno(sc->mp, rtbno) + len - 1))
-			xchk_ino_xref_set_corrupt(sc, rtg_rmap(rtg)->i_ino);
+			xchk_ip_xref_set_corrupt(sc, rtg_rmap(rtg));
 		return;
 	}
 
@@ -295,5 +295,5 @@ xchk_xref_is_used_rt_space(
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
 	if (is_free)
-		xchk_ino_xref_set_corrupt(sc, rtg_bitmap(rtg)->i_ino);
+		xchk_ip_xref_set_corrupt(sc, rtg_bitmap(rtg));
 }
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 18074c1ff166..78f72a046887 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -189,7 +189,7 @@ xchk_rtsum_record_free(
 	rtlen = xfs_rtxlen_to_extlen(mp, rec->ar_extcount);
 
 	if (!xfs_verify_rtbext(mp, rtbno, rtlen)) {
-		xchk_ino_xref_set_corrupt(sc, rtg_bitmap(rtg)->i_ino);
+		xchk_ip_xref_set_corrupt(sc, rtg_bitmap(rtg));
 		return -EFSCORRUPTED;
 	}
 
-- 
2.53.0

