Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2B02745C
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529786; cv=none; b=WKYO2e7My20NPY48o+xjsavFHmFXZD43x0GwoZCf2kIgyWWJb8pOu2xP1efBn3kPgfjYUPHe5waQYCZOOMx7rh1YwhoocnwhO8PJ6aR4/oZSwgGx53Q1JbpqOcKzt436K8ZrGA0pjO1hfYFC19UPii50MQObGIrd6M1X3G1MVWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529786; c=relaxed/simple;
	bh=yNntrkGzd2FVzZka43HuPwMRZ10Yj1SDAE/rfp5DCAE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K5ISOA0M3HMNHbqdjzKthxbpaULxkOnQYMydFS89WaUEMSp5zt+ShjtTZL2AlaMfoOqesYfnJzUzysZ13wvnr3K/HTK6tC3VlhHqKLv78vafkF/35OLikxWIszGFHslYjadjNeRj/g/hC61mx3J+fhhOnmmNyiBalqugvIlI+WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TxJHVz70; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TxJHVz70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56117C4CED1;
	Sat,  7 Dec 2024 00:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529786;
	bh=yNntrkGzd2FVzZka43HuPwMRZ10Yj1SDAE/rfp5DCAE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TxJHVz70+S9ebtXQKupmF+fiz+WbwoDrcemTed0yCYmzXGVkA4b+dXOBaRyHyFSDJ
	 0JBQpDOIttF/NzVS+X79YIxLV7N+2/zQ+g3PFuGBkL5nyF5nzn0KuJ94VMaxKffmXi
	 43IH+99maZshXF0OHYzwSjzbypuk3Re5fwdIBNAbeudLlBpvIS9wnRyFPjtXJ+Tmz8
	 y3ZYagL0isAKW1V3vMxCW4+Adved5NMnVUZ33zGUWlwYrJ1QObB5O0ZYiaZb1Eb/9m
	 tOD4IK01ypBLvldFfI3LbvG45pqENaHuFpTAA5A/L6FSjjzd8uKnK/SO2JC/eZ3EUt
	 hp9kYzmNOdzCg==
Date: Fri, 06 Dec 2024 16:03:05 -0800
Subject: [PATCH 45/46] xfs: fix sparse inode limits on runt AG
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: dchinner@redhat.com, cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750683.124560.3908345369482388836.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
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

