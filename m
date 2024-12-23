Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE7C13FEE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991798; cv=none; b=JjrJUh8mKN2XptY4WIU4zvVcCGBfjk4rQL4tY1ZRUsKJ+iVy26DYRH5kQ4igVps//5eec+VAiI3cAM4sGfxLEVvBXV4hjTdZpuKd4BS6jSNxYauPM/Fs48+l7MV437E8L09/rPmrKdxmEgQGnpk/XS8BGS8Xom8jAYLSVaXF8oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991798; c=relaxed/simple;
	bh=4dhF693u/tgF86WwcbR0qZVAiz+/5Qaz/z5dykKsFN4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=emu6XoPWULlplESpZN6b3TzquE7HhvG6XyTVRTcw2n3cmhij5OSY4uYuT6XTFO/w5+LzdpE4qZv4VjOmLOKiMlXn8dkdQf6Ij0yTE9fI2nzRm/o9YNaYj+DMNd+J3v+by0S+3s7lv27wrzVJcy6NNwGAFidRI5Y+j79zfLUX7fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KVNM4ubh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KVNM4ubh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9A7C4CED3;
	Mon, 23 Dec 2024 22:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991797;
	bh=4dhF693u/tgF86WwcbR0qZVAiz+/5Qaz/z5dykKsFN4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KVNM4ubhHapAwyx7KyZ2H6PHJhAdu1ZWj/4kAj6HDi+zITI1sx4pLd/JZz8culrpA
	 AMYF/9+o8i2Y7zGhPk2r8ZTxxPeF1hoVP33lwmOq4caKU1osJFfPvxgVBKbolSDzxJ
	 zRhTs+bXJTVLqZfK+7+wtH1HuAZwg7BtGdgLucjOPSoyUgwB8CaLBsk12If0XLHh/C
	 N2OiHPNdiLAKHEj83EKTQEAjmBsne8ShJdXqfjXzvcaQeuXoGUc4473k+7FzJTy9kI
	 H1EEJnBHlRGYTudoerhVFnZO2+QO2Ey8q3U4pAfzLSStSTGopDLXHw/oOE69bBn8wT
	 MyIKmox9c2LBg==
Date: Mon, 23 Dec 2024 14:09:57 -0800
Subject: [PATCH 45/52] xfs: fix sparse inode limits on runt AG
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: dchinner@redhat.com, cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498943180.2295836.9055709735400896963.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 13325333582d4820d39b9e8f63d6a54e745585d9

The runt AG at the end of a filesystem is almost always smaller than
the mp->m_sb.sb_agblocks. Unfortunately, when setting the max_agbno
limit for the inode chunk allocation, we do not take this into
account. This means we can allocate a sparse inode chunk that
overlaps beyond the end of an AG. When we go to allocate an inode
from that sparse chunk, the irec fails validation because the
agbno of the start of the irec is beyond valid limits for the runt
AG.

Prevent this from happening by taking into account the size of the
runt AG when allocating inode chunks. Also convert the various
checks for valid inode chunk agbnos to use xfs_ag_block_count()
so that they will also catch such issues in the future.

Fixes: 56d1115c9bc7 ("xfs: allocate sparse inode chunks on full chunk allocation failure")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_ialloc.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 2575447f92dfbb..63ce76755eb77f 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -848,7 +848,8 @@ xfs_ialloc_ag_alloc(
 		 * the end of the AG.
 		 */
 		args.min_agbno = args.mp->m_sb.sb_inoalignmt;
-		args.max_agbno = round_down(args.mp->m_sb.sb_agblocks,
+		args.max_agbno = round_down(xfs_ag_block_count(args.mp,
+							pag_agno(pag)),
 					    args.mp->m_sb.sb_inoalignmt) -
 				 igeo->ialloc_blks;
 
@@ -2344,9 +2345,9 @@ xfs_difree(
 		return -EINVAL;
 	}
 	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
-	if (agbno >= mp->m_sb.sb_agblocks)  {
-		xfs_warn(mp, "%s: agbno >= mp->m_sb.sb_agblocks (%d >= %d).",
-			__func__, agbno, mp->m_sb.sb_agblocks);
+	if (agbno >= xfs_ag_block_count(mp, pag_agno(pag))) {
+		xfs_warn(mp, "%s: agbno >= xfs_ag_block_count (%d >= %d).",
+			__func__, agbno, xfs_ag_block_count(mp, pag_agno(pag)));
 		ASSERT(0);
 		return -EINVAL;
 	}
@@ -2469,7 +2470,7 @@ xfs_imap(
 	 */
 	agino = XFS_INO_TO_AGINO(mp, ino);
 	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
-	if (agbno >= mp->m_sb.sb_agblocks ||
+	if (agbno >= xfs_ag_block_count(mp, pag_agno(pag)) ||
 	    ino != xfs_agino_to_ino(pag, agino)) {
 		error = -EINVAL;
 #ifdef DEBUG
@@ -2479,11 +2480,12 @@ xfs_imap(
 		 */
 		if (flags & XFS_IGET_UNTRUSTED)
 			return error;
-		if (agbno >= mp->m_sb.sb_agblocks) {
+		if (agbno >= xfs_ag_block_count(mp, pag_agno(pag))) {
 			xfs_alert(mp,
 		"%s: agbno (0x%llx) >= mp->m_sb.sb_agblocks (0x%lx)",
 				__func__, (unsigned long long)agbno,
-				(unsigned long)mp->m_sb.sb_agblocks);
+				(unsigned long)xfs_ag_block_count(mp,
+							pag_agno(pag)));
 		}
 		if (ino != xfs_agino_to_ino(pag, agino)) {
 			xfs_alert(mp,

