Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EC5306776
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 20:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783022578; cv=none; b=pgXTS8OO1Gu1IiqUZv159SseX9q0rjqgYOae298JOt5Dx5zECIYBQzcLBt/+OwXNL3+UztCxk9U211O+nggmRoWBP6FrlQC9NLSr1vIK2lMZ+M9r1qG2hW7LYvL/xHq0HfqgcExMyot7NKJUAOzQ9BgLqAh5coNKxOU75EsrLoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783022578; c=relaxed/simple;
	bh=IonqYYWcgI+uArM+jo4u44kApiiOR6EqGz+3pC52Odc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z2GSwmkzvlV5Hq6LzndLwHvfWSfreE07z46xVO8AY+pd1FTL82fsbsndeHUIkkuT3+y8xxDaWQmgXvyFx2f/CNAwWcMEgQPU92DwQKjP3ukdhirGAd9scaLW1PW1b9hbd++EWN8v40s1eF1AnUliYyPSYVZxxMlcdrVt60FFEdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UizSknwf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UizSknwf"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 219A01F000E9;
	Thu,  2 Jul 2026 20:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783022577;
	bh=wqpNmxlXrodtg8ya7HT/VOIkXIQQbI1xe/DrQ65xMGw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=UizSknwfUKBvJchuMMBjbL5i17Uyiw1Q5NcV06CjGpbZ7nr9gdobwznFAorUJIvyu
	 HYz4gYFAaFpo3abMlv+lh16Ekvm2hpHAspUwY9cM0lwyyAl/U2FzhnrBiaLOo1WPlO
	 Xnu3wBK9g4/oC0q9UQIoqFOYf0TDBwI0o6LxT0iAZe8pNF0lIXf77iCT21w08HJTwA
	 hfEdfEfdS5GejppnwxOEycMMCx9kpx0WIiThwn26iebCL9Is0kYY5PA+BqczzUjo2x
	 QUG04f7Gu3yWCmEY+q+/4luO+cirxCyo9n6IF0H93ylFPRiqa/lWjFi2D6ushqyjJp
	 zIbJBlvWqiYMQ==
Date: Thu, 02 Jul 2026 13:02:56 -0700
Subject: [PATCH 10/18] xfs: cleanup xfs_imap
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <178302226490.845537.7989897247135586504.stgit@frogsfrogsfrogs>
In-Reply-To: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
References: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 41397e7ca8a06507ae6f52f68cd27b0812e9a561

Reshuffle the code a bit so that the imap_lookup and filling out of the
xfs_imap structure aren't duplicated.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_ialloc.c |   62 +++++++++++++++++++++++----------------------------
 1 file changed, 28 insertions(+), 34 deletions(-)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 64f0376a10508f..8c42c045924db8 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2506,43 +2506,37 @@ xfs_imap(
 	 * inodes in stale state on disk. Hence we have to do a btree lookup
 	 * in all cases where an untrusted inode number is passed.
 	 */
-	if (flags & XFS_IGET_UNTRUSTED) {
-		error = xfs_imap_lookup(pag, tp, agino, agbno,
-					&chunk_agbno, &offset_agbno, flags);
-		if (error)
-			return error;
-		goto out_map;
-	}
+	if (!(flags & XFS_IGET_UNTRUSTED)) {
+		/*
+		 * If the inode cluster size is the same or smaller than the
+		 * blocksize, get to the buffer by simple arithmetics.
+		 */
+		if (M_IGEO(mp)->blocks_per_cluster == 1) {
+			cluster_agbno = agbno;
+			offset = XFS_INO_TO_OFFSET(mp, ino);
+			ASSERT(offset < mp->m_sb.sb_inopblock);
+			goto out;
+		}
 
-	/*
-	 * If the inode cluster size is the same as the blocksize or
-	 * smaller we get to the buffer by simple arithmetics.
-	 */
-	if (M_IGEO(mp)->blocks_per_cluster == 1) {
-		offset = XFS_INO_TO_OFFSET(mp, ino);
-		ASSERT(offset < mp->m_sb.sb_inopblock);
+		/*
+		 * If the inode chunks are aligned, use simple maths to find the
+		 * location.
+		 */
+		if (M_IGEO(mp)->inoalign_mask) {
+			offset_agbno = agbno & M_IGEO(mp)->inoalign_mask;
+			chunk_agbno = agbno - offset_agbno;
+			goto out_map;
+		}
 
-		imap->im_blkno = xfs_agbno_to_daddr(pag, agbno);
-		imap->im_len = XFS_FSB_TO_BB(mp, 1);
-		imap->im_boffset = (unsigned short)(offset <<
-							mp->m_sb.sb_inodelog);
-		return 0;
+		/*
+		 * Otherwise we have to do a btree lookup to find the location.
+		 */
 	}
 
-	/*
-	 * If the inode chunks are aligned then use simple maths to
-	 * find the location. Otherwise we have to do a btree
-	 * lookup to find the location.
-	 */
-	if (M_IGEO(mp)->inoalign_mask) {
-		offset_agbno = agbno & M_IGEO(mp)->inoalign_mask;
-		chunk_agbno = agbno - offset_agbno;
-	} else {
-		error = xfs_imap_lookup(pag, tp, agino, agbno,
-					&chunk_agbno, &offset_agbno, flags);
-		if (error)
-			return error;
-	}
+	error = xfs_imap_lookup(pag, tp, agino, agbno, &chunk_agbno,
+			&offset_agbno, flags);
+	if (error)
+		return error;
 
 out_map:
 	ASSERT(agbno >= chunk_agbno);
@@ -2551,7 +2545,7 @@ xfs_imap(
 		 M_IGEO(mp)->blocks_per_cluster);
 	offset = ((agbno - cluster_agbno) * mp->m_sb.sb_inopblock) +
 		XFS_INO_TO_OFFSET(mp, ino);
-
+out:
 	imap->im_blkno = xfs_agbno_to_daddr(pag, cluster_agbno);
 	imap->im_len = XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster);
 	imap->im_boffset = (unsigned short)(offset << mp->m_sb.sb_inodelog);

