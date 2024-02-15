Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C5212BEA6
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998970; cv=none; b=pQkFGPsYvIU8Y0skA8GNjIPfW1Ui+tjzrRjdLk5JhYITp4I03DttG2+AM40iTCcVJatEMBzYM6IHax0BYj2ecnB1bdTY/y2vS+cdIFZe9wUX9il9+iD3WGcESfFcUJfWFxfSMpykOsKpI7eJkUcgsSx6a110Pm+cmL2gP5bj0iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998970; c=relaxed/simple;
	bh=1hTYCq5GEeH5KRsbMo42uXCqFVK31IkpM4gyQ4lh55k=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5oGlygVnVFSa/NhoqYSATVzX6/VePJeQuKHX++jupDmcC+oIItMCYWEfg4hwuaLJhOo/tBWX8ONraIRUfD7OW+FXC/mv+0XUOdKgESeFR6CRoFmJacV4jIrREs9dMJUd2NFhPycDDRrKCD3nXF0rrZVh4X2PmqXHU+R1eKia04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i7lNRx2H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i7lNRx2H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B7DC433C7
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998969;
	bh=1hTYCq5GEeH5KRsbMo42uXCqFVK31IkpM4gyQ4lh55k=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=i7lNRx2HJrHTizwwAUbvly4YXLaqvnIl25ZHI+AUy8g4318cAYILhIUMp++cC3twX
	 Mho2zrx38CGc2muZsMZqSVclt1WQWjnxyU4mPRDIixJmIg3mkNKONARQOdnJ9mDbY1
	 OXl3zXA55VUkOCuYd+sr2MHOgDu3R2NmlySiynAPjGcL5I1+bezeTQhVqTDMwDbpAa
	 Lstst7HjHmxmC0oVs4xtF64equ0Q96cHOKB6u7qZ54gl+XLWcOURxZeErkh3An/x0a
	 a4yonH8WlH2SX8odlscRVkCZ5Cw8N5yiYVH/stL9savLEihjwDeR0wQy6AUBJHL6UQ
	 h3Nv8/uwShLew==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 14/35] xfs: convert do_div calls to xfs_rtb_to_rtx helper calls
Date: Thu, 15 Feb 2024 13:08:26 +0100
Message-ID: <20240215120907.1542854-15-cem@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215120907.1542854-1-cem@kernel.org>
References: <20240215120907.1542854-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: 055641248f649b52620a5fe8774bea253690e057

Convert these calls to use the helpers, and clean up all these places
where the same variable can have different units depending on where it
is in the function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_bmap.c     |  8 ++------
 libxfs/xfs_rtbitmap.h | 14 ++++++++++++++
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 6d7fa88f9..8fde0dc25 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4820,12 +4820,8 @@ xfs_bmap_del_extent_delay(
 	ASSERT(got->br_startoff <= del->br_startoff);
 	ASSERT(got_endoff >= del_endoff);
 
-	if (isrt) {
-		uint64_t	rtexts = del->br_blockcount;
-
-		do_div(rtexts, mp->m_sb.sb_rextsize);
-		xfs_mod_frextents(mp, rtexts);
-	}
+	if (isrt)
+		xfs_mod_frextents(mp, xfs_rtb_to_rtx(mp, del->br_blockcount));
 
 	/*
 	 * Update the inode delalloc counter now and wait to update the
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 9df583083..ff901bf3d 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -70,6 +70,20 @@ xfs_rtb_to_rtxrem(
 	return div_u64_rem(rtbno, mp->m_sb.sb_rextsize, off);
 }
 
+/*
+ * Convert an rt block number into an rt extent number, rounding up to the next
+ * rt extent if the rt block is not aligned to an rt extent boundary.
+ */
+static inline xfs_rtxnum_t
+xfs_rtb_to_rtxup(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	if (do_div(rtbno, mp->m_sb.sb_rextsize))
+		rtbno++;
+	return rtbno;
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
-- 
2.43.0

