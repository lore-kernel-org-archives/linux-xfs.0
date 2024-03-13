Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2D1AD21
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294690; cv=none; b=YbrVKWGdlwOolskiRjkceH8H07RhVe3Rfh9Xo8slWB/cv3eHiRiv7Stqptu7mhTXpmbS3y7+R0AKayRvQMYJBuEN28rZOfBVuqPqTVLp0A4ksEPvcmsikJOBee+7rzcZtiwdcUYoW6pPTFWC6W7mqhLxle9emc2+ZLgK2gqhibM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294690; c=relaxed/simple;
	bh=zhhAPteenGRoLRXWB1gGf40NEDM4lyiefAkTBQ7b1sU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dEWZw/vEh+m0RNHNGFw8RMqTjkJsYaPRsXAR8XqryWEAgmHK3dg39JmBGweRk4wtw1c2m7c7Ao5AOnmyBrQBcepCd9Pqw+NlrctGAz0dcbs9+MZPv3BE5RY3egDCwicGDNMFHJoRSL+scwC+Y8xNnyG89JGNISa0QUxtoys1vgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zd9nBPwu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zd9nBPwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94622C433C7;
	Wed, 13 Mar 2024 01:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294689;
	bh=zhhAPteenGRoLRXWB1gGf40NEDM4lyiefAkTBQ7b1sU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Zd9nBPwukvcLQNXTqfk3Un+TjbB5gRuGvrDjUidcUb01HQJvtzpvXkxFMU7xjm7VM
	 hUdAJM19GikR9tFsXcUwpa8leZxTMrPsUED7fWjP9sDlMdPajfx8igez3tI1Fa5/gm
	 6Ud9q/AmtDVb0K/7eA+aMyrGeNiV0T3bAa2K1ILY2gSn1JJBfOFjyiFrY8dPN5QJVt
	 q8ycGaDZ6QX6CTMnwvZJ2b9kLHCs+GiCxHg5/tD2kA4JAmMIyp9ctmFHDcTeLGFDhL
	 XGgJKa/W+QMjEkj3rYhU9y2/2GqQgLd+M14Ze8bAKbnK3PnUT6l8gxStApDlemo9sN
	 YmsWmCdARDuyg==
Date: Tue, 12 Mar 2024 18:51:29 -0700
Subject: [PATCH 07/13] mkfs: convert utility to use new rt extent helpers and
 types
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171029430657.2061422.9474513570507861316.stgit@frogsfrogsfrogs>
In-Reply-To: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
References: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
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
---
 mkfs/proto.c |   41 ++++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index e9c633ed3671..f8e00c4b56f0 100644
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

