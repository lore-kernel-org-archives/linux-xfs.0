Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585D05228
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608923; cv=none; b=l8jp1JbY/rbgQzymdbDnnCRGB8UUXwGWzoVLJnVtIpiQ5P8+5oWedz/j/acAIgxkWYhxALppO2C73D9WcRXJCaX2Hp41qQVlnUSoCTt/7jcqGj44z0xxmTkeDpZjEcsvpQKrmXCxcyWhtuTiHGRwPQOQQnwnjirMxwltCJwLImw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608923; c=relaxed/simple;
	bh=ZfgBfRs+2MUjqWeFLFVixFmr3wSrUp+TM98DEakC4do=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gv3udVNgjK3Sb+5H07cWjybazDB8K1pHiIDXIWpy10JLzyplhrp2ob/15UAJknkdveeE6cPLXYp8yvUP/xt22Fc8I5N4MgavrPPOzggvvr+SG9RnRkfb0wPXMMeSsQQ8+hY2M1ruiOJRFuNfz92WtW8ebC6zi1o+DNnPYqGJIvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lC7xGw0P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lC7xGw0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CBBC4CEC5;
	Fri, 11 Oct 2024 01:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608923;
	bh=ZfgBfRs+2MUjqWeFLFVixFmr3wSrUp+TM98DEakC4do=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lC7xGw0P8+spV6OB+ktBjy/iGWdRlwh4CC+c9HioNNZyBxtPz1K6kiVQNG6VMOlrW
	 MgSHRFlDh97Ekpx6L2zDmrftPemU62m1IKcxmLLQQCj18IO0l9w6y6yZe3aKyuIK6Z
	 gweAyEehW2ntv77A21er2E8ytdYacRMqeUi8O+yqyPle56h6wwLFPcI9/batjpjmaj
	 ldTW00KiBTjbbd40mC4/lJ4ZzQ+TtpdmOlzrQ3jso2rMW8PJdK7h1PfUEM4x4F1oYT
	 k8bCf+28qTEpViMldQC00FBgbbT4v1k9cQxyRNqAXLbZfZh05Rh6mYhaZ8G2y+YYAZ
	 ShJc/IeDwmo7A==
Date: Thu, 10 Oct 2024 18:08:42 -0700
Subject: [PATCH 27/36] xfs: create helpers to deal with rounding xfs_fileoff_t
 to rtx boundaries
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644707.4178701.6278873000359043020.stgit@frogsfrogsfrogs>
In-Reply-To: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
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

We're about to segment xfs_rtblock_t addresses, so we must create
type-specific helpers to do rt extent rounding of file block offsets
because the rtb helpers soon will not do the right thing there.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.h |   17 +++++++++++++----
 fs/xfs/xfs_bmap_util.c       |    6 +++---
 2 files changed, 16 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 7be76490a31879..dc2b8beadfc331 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -135,13 +135,22 @@ xfs_rtb_roundup_rtx(
 	return roundup_64(rtbno, mp->m_sb.sb_rextsize);
 }
 
-/* Round this rtblock down to the nearest rt extent size. */
+/* Round this file block offset up to the nearest rt extent size. */
 static inline xfs_rtblock_t
-xfs_rtb_rounddown_rtx(
+xfs_fileoff_roundup_rtx(
 	struct xfs_mount	*mp,
-	xfs_rtblock_t		rtbno)
+	xfs_fileoff_t		off)
 {
-	return rounddown_64(rtbno, mp->m_sb.sb_rextsize);
+	return roundup_64(off, mp->m_sb.sb_rextsize);
+}
+
+/* Round this file block offset down to the nearest rt extent size. */
+static inline xfs_rtblock_t
+xfs_fileoff_rounddown_rtx(
+	struct xfs_mount	*mp,
+	xfs_fileoff_t		off)
+{
+	return rounddown_64(off, mp->m_sb.sb_rextsize);
 }
 
 /* Convert an rt extent number to a file block offset in the rt bitmap file. */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index aa745cc5922246..dff27c69fccb6f 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -537,7 +537,7 @@ xfs_can_free_eofblocks(
 	 */
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
 	if (xfs_inode_has_bigrtalloc(ip))
-		end_fsb = xfs_rtb_roundup_rtx(mp, end_fsb);
+		end_fsb = xfs_fileoff_roundup_rtx(mp, end_fsb);
 	last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
 	if (last_fsb <= end_fsb)
 		return false;
@@ -859,8 +859,8 @@ xfs_free_file_space(
 
 	/* We can only free complete realtime extents. */
 	if (xfs_inode_has_bigrtalloc(ip)) {
-		startoffset_fsb = xfs_rtb_roundup_rtx(mp, startoffset_fsb);
-		endoffset_fsb = xfs_rtb_rounddown_rtx(mp, endoffset_fsb);
+		startoffset_fsb = xfs_fileoff_roundup_rtx(mp, startoffset_fsb);
+		endoffset_fsb = xfs_fileoff_rounddown_rtx(mp, endoffset_fsb);
 	}
 
 	/*

