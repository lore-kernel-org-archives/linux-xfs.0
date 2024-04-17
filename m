Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC044C3D0
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388812; cv=none; b=HYZPN6yv3H1aDIj8z3zJughxOnWh4YTk6h5YQIAdDsIeCnQykaYy3X0a/JiU7+QvbXc5Pd9tbwdD3Ej5oPDu0NaiBIVDpnlOBcmTzkY1hStTBDvkXQZpIQWAV88LWsvCPMfQSp1vokmpctevzCpUNahnp+u6t7mzvGexU6dDuUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388812; c=relaxed/simple;
	bh=b4DMDJvy+ZUeREEX9GJHsFs5qY9HdpYWxp/49QLad6I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HA8vCa3begd5yT1kTP/X0p3ic5Nxsr8/Lo9NRRwB395ZQ7pgMP+F4mfHKY8oUrqLGHNSpi7/2C2prMTwsSWDrO8BHwJivdL+DOAOYRVuCX0c9eE/2poDOupkgtm9WeVAxJgKPgk4351AnkCmrBjWpd2Gue82lbnrhVSQHkepaQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sBIa0VEW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sBIa0VEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD401C072AA;
	Wed, 17 Apr 2024 21:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713388812;
	bh=b4DMDJvy+ZUeREEX9GJHsFs5qY9HdpYWxp/49QLad6I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sBIa0VEWZvl+HLib/qLtNWGdTcvsNE8Vp5F0aTbUV8+o+vWMrL5GZRF5z9fwUENQL
	 xeRqEf+rcGkPM7zOWPw/nUEWtI1qSI02CpYdzLA3T1PMTaI8fEOvxFQU5rU/BgenJC
	 MORYTgZxmaDcrV11cWhNrr54Lli2wkxw9AVVkrRVT/3FGSKRJ9pEp2g31UKvtZP0d/
	 y8rvLE+EaDoVwAyIHQLDIM8fHlX71lqCGgieQkcNTb/FiTz8QIlFfn+K5LGTOLQUqw
	 LWtDPSnZE08K7q+yPxIwQD7xrY0mAXiPbLFXPuaBTpluQZt/ziCCTYVJMrfWHe4YzC
	 dHqgaFUUZ/F/Q==
Date: Wed, 17 Apr 2024 14:20:12 -0700
Subject: [PATCH 05/11] mkfs: convert utility to use new rt extent helpers and
 types
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338841812.1853034.16625017453432671552.stgit@frogsfrogsfrogs>
In-Reply-To: <171338841726.1853034.8225385129852277375.stgit@frogsfrogsfrogs>
References: <171338841726.1853034.8225385129852277375.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Convert the repair program to use the new realtime extent types and
helper functions instead of open-coding them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 mkfs/proto.c |   41 ++++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index e9c633ed3..f8e00c4b5 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -20,6 +20,7 @@ static int newfile(xfs_trans_t *tp, xfs_inode_t *ip, int symlink, int logit,
 			char *buf, int len);
 static char *newregfile(char **pp, int *len);
 static void rtinit(xfs_mount_t *mp);
+static void rtfreesp_init(struct xfs_mount *mp);
 static long filesize(int fd);
 static int slashes_are_spaces;
 
@@ -652,7 +653,6 @@ rtinit(
 	xfs_mount_t	*mp)
 {
 	xfs_fileoff_t	bno;
-	xfs_fileoff_t	ebno;
 	xfs_bmbt_irec_t	*ep;
 	int		error;
 	int		i;
@@ -770,19 +770,34 @@ rtinit(
 		fail(_("Block allocation of the realtime summary inode failed"),
 				error);
 
-	/*
-	 * Free the whole area using transactions.
-	 * Do one transaction per bitmap block.
-	 */
-	for (bno = 0; bno < mp->m_sb.sb_rextents; bno = ebno) {
-		i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
+	rtfreesp_init(mp);
+}
+
+/*
+ * Free the whole realtime area using transactions.
+ * Do one transaction per bitmap block.
+ */
+static void
+rtfreesp_init(
+	struct xfs_mount	*mp)
+{
+	struct xfs_trans	*tp;
+	xfs_rtxnum_t		rtx;
+	xfs_rtxnum_t		ertx;
+	int			error;
+
+	for (rtx = 0; rtx < mp->m_sb.sb_rextents; rtx = ertx) {
+		error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
 				0, 0, 0, &tp);
-		if (i)
-			res_failed(i);
-		libxfs_trans_ijoin(tp, rbmip, 0);
-		ebno = XFS_RTMIN(mp->m_sb.sb_rextents,
-			bno + NBBY * mp->m_sb.sb_blocksize);
-		error = -libxfs_rtfree_extent(tp, bno, (xfs_extlen_t)(ebno-bno));
+		if (error)
+			res_failed(error);
+
+		libxfs_trans_ijoin(tp, mp->m_rbmip, 0);
+		ertx = XFS_RTMIN(mp->m_sb.sb_rextents,
+			rtx + NBBY * mp->m_sb.sb_blocksize);
+
+		error = -libxfs_rtfree_extent(tp, rtx,
+				(xfs_rtxlen_t)(ertx - rtx));
 		if (error) {
 			fail(_("Error initializing the realtime space"),
 				error);

