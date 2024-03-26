Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A680A12838F
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422076; cv=none; b=mSEOoiy8NEL2X/d1/3LIP7IRvM7hKqWGJkBEcyLgxp2jx3nZzr3Ft83TWCrzpd9NIFF3WELixMN3GaNIK66HpDAl8+h/wBj2DpODeSlIv8wsba/oAxyWev7rDHRzhJjYRo2Cgqc8XJJYwbjtU9ImnufgMdwV2p0955A4QWEMj1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422076; c=relaxed/simple;
	bh=n4Bo/i4otABr9uol4OMkBHfj4nI4vOn8oVRKxLG8uJg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F8wjCSAFZgzYhqZGqCI0edeLwaAlqkneDwr51Eko6fHPt20c6DaXxlXOYoKufYGZ9RYinVREFWO6jVDIApwIdrBk1p0mVNhCiVwIwS6OfEkkjfPEQUwlMZ24/5xb0j1/kHrpZL2VB05OzOpAG/J+US0ZrreYX6c2nrevvGDuiJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qh1VEb0M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qh1VEb0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F75C4166D;
	Tue, 26 Mar 2024 03:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422076;
	bh=n4Bo/i4otABr9uol4OMkBHfj4nI4vOn8oVRKxLG8uJg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qh1VEb0MGruBoxfZIm03P7tYxHhy1j7IzTMbdgWbXY4PyCVJvI3xS8z2qVFi5GWxt
	 ZT1SaWu+7YTr4F01hzitb/0Tqb4r9pdSyd8hwYauNyGT9LRAiop2VZ3eiCqxPtxSLH
	 gm0jM4ac8pxrk4jg+QDLUNWAKLWI3r4IGmmDsozR5SaBYzxUQn+U4C36JFQApJ7X4w
	 OLQ5ws1CMmeSQYZuNVJD+NnG0gfT5PYD5HgD17GE6uucyQtpLb0NhwtWCzaiKNXcY7
	 N0HzRz41BpnHrzcGGkXwwTCaee3IzMn/MllrtoFCzbRoqTR2t4qOJjzwgqljUJwHBf
	 GZbhKzSpJSxPQ==
Date: Mon, 25 Mar 2024 20:01:15 -0700
Subject: [PATCH 07/13] mkfs: convert utility to use new rt extent helpers and
 types
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142126410.2211955.12894105597682969627.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs>
References: <171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs>
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

