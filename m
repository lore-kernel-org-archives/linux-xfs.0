Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15336157E82;
	Wed, 18 Dec 2024 19:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734551437; cv=none; b=krcFt0e++rbfgbHw7VnEX1Y+C373P++Mp/ux54aIXWRx4hnHE/JPxACXEPnPY0CE2+JckPbCcvp0/ogIZaZ925erfXZfP8O/ow0VClAiQtfQH5EKAN3VWmNOHl4XD1Lwx5CRJ/gahlTUUHiGCTS/P4RCPSj3tj4B5q9QJTWs3b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734551437; c=relaxed/simple;
	bh=V3jQLWo1JewtY4J8x3XU6YBN7FktZWLUbZ3WyT0/emI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nb2iA/2UzjBLR6kB/b6uT/logr9GPMkYyAMFzWLRdcqx8Cp2KEAwUSn9s8VYA5VEuGvUFeatkaDGp4Sqjq7IbwzpnjV8KK5DrNY4HJrrODbuYDgcw3OAr3TldrwFmTBr6lE/Bv1BnuYR98Ny2ImVjuQ818qwwYMCBqBG8O7+Da8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e7vph/rG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e7vph/rG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD3EC4CECD;
	Wed, 18 Dec 2024 19:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734551436;
	bh=V3jQLWo1JewtY4J8x3XU6YBN7FktZWLUbZ3WyT0/emI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=e7vph/rGpyHch4+OQ2xqTFf8BqxI3YdEvw8cF+XpsddunLgj7yyNOdGBx/+/jr5KP
	 VdL5m4cIcX8kidASZNwXz4wOW0yBN1oBqaUGDiL3entZ09HcSvSMm9ik921wAxmGoR
	 /acI+vZA7hqvl+NF+eQqSfa0TO3prcI7wzEy+PMOhuBTZWxVYZXXONTi7i3JKhkcqt
	 oF8kVpzt7xAC9Tuft6Vm/Xy9Rp69J3TR+BlI0QUx1Y3zRVgrZAG/974vld5Opveq3W
	 X5pYbXPFMgyt/ExhchLO6m4x4/3E5CHj61S62+ep6at5m++IXahKWqDmw+c6r04Yc1
	 rnh7igdJTT0Ug==
Date: Wed, 18 Dec 2024 11:50:36 -0800
Subject: [PATCH 2/5] xfs: fix sparse inode limits on runt AG
From: "Darrick J. Wong" <djwong@kernel.org>
To: stable@vger.kernel.org, djwong@kernel.org
Cc: dchinner@redhat.com, cem@kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173455093530.305755.17997290982247743874.stgit@frogsfrogsfrogs>
In-Reply-To: <173455093488.305755.7686977865497104809.stgit@frogsfrogsfrogs>
References: <173455093488.305755.7686977865497104809.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Dave Chinner <dchinner@redhat.com>

commit 13325333582d4820d39b9e8f63d6a54e745585d9 upstream.

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
[djwong: backport to stable because upstream maintainer ignored cc-stable]
Link: https://lore.kernel.org/linux-xfs/20241112231539.GG9438@frogsfrogsfrogs/
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ialloc.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 271855227514cb..6258527315f28b 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -855,7 +855,8 @@ xfs_ialloc_ag_alloc(
 		 * the end of the AG.
 		 */
 		args.min_agbno = args.mp->m_sb.sb_inoalignmt;
-		args.max_agbno = round_down(args.mp->m_sb.sb_agblocks,
+		args.max_agbno = round_down(xfs_ag_block_count(args.mp,
+							pag->pag_agno),
 					    args.mp->m_sb.sb_inoalignmt) -
 				 igeo->ialloc_blks;
 
@@ -2332,9 +2333,9 @@ xfs_difree(
 		return -EINVAL;
 	}
 	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
-	if (agbno >= mp->m_sb.sb_agblocks)  {
-		xfs_warn(mp, "%s: agbno >= mp->m_sb.sb_agblocks (%d >= %d).",
-			__func__, agbno, mp->m_sb.sb_agblocks);
+	if (agbno >= xfs_ag_block_count(mp, pag->pag_agno)) {
+		xfs_warn(mp, "%s: agbno >= xfs_ag_block_count (%d >= %d).",
+			__func__, agbno, xfs_ag_block_count(mp, pag->pag_agno));
 		ASSERT(0);
 		return -EINVAL;
 	}
@@ -2457,7 +2458,7 @@ xfs_imap(
 	 */
 	agino = XFS_INO_TO_AGINO(mp, ino);
 	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
-	if (agbno >= mp->m_sb.sb_agblocks ||
+	if (agbno >= xfs_ag_block_count(mp, pag->pag_agno) ||
 	    ino != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino)) {
 		error = -EINVAL;
 #ifdef DEBUG
@@ -2467,11 +2468,12 @@ xfs_imap(
 		 */
 		if (flags & XFS_IGET_UNTRUSTED)
 			return error;
-		if (agbno >= mp->m_sb.sb_agblocks) {
+		if (agbno >= xfs_ag_block_count(mp, pag->pag_agno)) {
 			xfs_alert(mp,
 		"%s: agbno (0x%llx) >= mp->m_sb.sb_agblocks (0x%lx)",
 				__func__, (unsigned long long)agbno,
-				(unsigned long)mp->m_sb.sb_agblocks);
+				(unsigned long)xfs_ag_block_count(mp,
+							pag->pag_agno));
 		}
 		if (ino != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino)) {
 			xfs_alert(mp,

