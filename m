Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746702701B6
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098502; cv=none; b=VTI+D/aG2po8k70RdtzvSzm0ISZijXp0Lk6jO7GsWyBQjyQ10DtWQlcoklU1cZLvkpW/KFO6koaPD8pjlQWRJahdt2bkwpKPmoDasq2N9yCh63VSZjNgG/Xst0iEaVObzT20FMDmJaGikwmx0pYAh15/DJdpqYqiRe9PCH1gxxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098502; c=relaxed/simple;
	bh=yEi5YozTMgdqbquQg2N+5A0CdJlYpq+kgXZZ/XWL6WA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ao8WdrLvaXo6SExDbZOjGZ9zUYft1LZd3HyJ3KQWhVr8AT1t+l92cRJcwNZtbUiLxXSZlrIakX4xZUswb+MtwIiMG1Ogw646sotF79bQ9YLM8e4rRWPdUkIhlSEJDxZI/RSGvJUpRg/EU1QG6PFGbcN3h6DLBkFPcYVVqkvuzHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ikFGvnWL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ikFGvnWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2481F00A3A;
	Wed, 19 Aug 2026 00:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098500;
	bh=U0iIFSqipJHyjPx8ln8Ik/fCgAiPfpfcGfuO2HvbPrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ikFGvnWLOnnEOBnQ/GO++m2cZOePm/XzYkH2Qyt4/Q60uOk488r8Vpd1KOe4oHShw
	 ISfa4zhs2u96f+b2gZ3b6pQf+aoqqVUIjO34LBIWdzIjCsvWvhjjgi3YPkX1co4fnC
	 FfENrw0LoKOHJXPx9GIvPXd6Afb/5oaPKGqndK9qH9hhy2tqIVDBcXIDVb7F+QYmFP
	 pMnxj0brgUC3ivNDgkgt9iBApegbv7oWAzBMOaFpR1w+gdWvpY229qhoxBYLrAvXGw
	 lWbsKTrnVFxXgOcvCXE4O0vmO77iHiC24kBjxoG0neHbcXiO3oZIBjf+PB3IAr8p4Z
	 lgG+PHfzM/gXQ==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 10/38] xfs: plumb xfs_trans through xfs_reflink_allocate_cow and fill_cow_hole
Date: Wed, 19 Aug 2026 10:12:13 +1000
Message-ID: <20260819001442.1451892-11-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819001442.1451892-1-dgc@kernel.org>
References: <20260819001442.1451892-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a struct xfs_trans pointer as the first parameter to
xfs_reflink_allocate_cow() and xfs_reflink_fill_cow_hole().
All callers currently pass NULL.

This is preparation for having the caller pre-allocate a transaction
and pass it down to avoid needing to cycle the ILOCK inside
fill_cow_hole().

The local transaction variable in fill_cow_hole() is renamed to
local_tp to avoid shadowing the new parameter.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_iomap.c   |  2 +-
 fs/xfs/xfs_reflink.c | 17 ++++++++++-------
 fs/xfs/xfs_reflink.h |  6 +++---
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index df9fc7c6a4b9..e4e64412b431 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -913,7 +913,7 @@ xfs_direct_write_cow_iomap_begin(
 		goto out_unlock;
 
 	/* may drop and re-acquire the ilock */
-	error = xfs_reflink_allocate_cow(ip, imap, &cmap, &shared,
+	error = xfs_reflink_allocate_cow(NULL, ip, imap, &cmap, &shared,
 			lockmode,
 			(flags & IOMAP_DIRECT) || IS_DAX(VFS_I(ip)));
 	if (error)
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 480136136635..1fa899048b24 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -430,6 +430,7 @@ xfs_reflink_convert_unwritten(
 
 static int
 xfs_reflink_fill_cow_hole(
+	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	struct xfs_bmbt_irec	*imap,
 	struct xfs_bmbt_irec	*cmap,
@@ -438,7 +439,7 @@ xfs_reflink_fill_cow_hole(
 	bool			convert_now)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_trans	*tp;
+	struct xfs_trans	*local_tp;
 	xfs_filblks_t		resaligned;
 	unsigned int		seq_before = READ_ONCE(ip->i_df.if_seq);
 	unsigned int		dblocks = 0, rblocks = 0;
@@ -460,7 +461,7 @@ xfs_reflink_fill_cow_hole(
 	*lockmode = 0;
 
 	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, dblocks,
-			rblocks, false, &tp);
+			rblocks, false, &local_tp);
 	if (error)
 		return error;
 
@@ -487,20 +488,21 @@ xfs_reflink_fill_cow_hole(
 		goto out_trans_cancel;
 
 	if (found) {
-		xfs_trans_cancel(tp);
+		xfs_trans_cancel(local_tp);
 		goto convert;
 	}
 
 	/* Allocate the entire reservation as unwritten blocks. */
 	nimaps = 1;
-	error = xfs_bmapi_write(tp, ip, imap->br_startoff, imap->br_blockcount,
+	error = xfs_bmapi_write(local_tp, ip, imap->br_startoff,
+			imap->br_blockcount,
 			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, 0, cmap,
 			&nimaps);
 	if (error)
 		goto out_trans_cancel;
 
 	xfs_inode_set_cowblocks_tag(ip);
-	error = xfs_trans_commit(tp);
+	error = xfs_trans_commit(local_tp);
 	if (error)
 		return error;
 
@@ -508,7 +510,7 @@ xfs_reflink_fill_cow_hole(
 	return xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now);
 
 out_trans_cancel:
-	xfs_trans_cancel(tp);
+	xfs_trans_cancel(local_tp);
 	return error;
 }
 
@@ -597,6 +599,7 @@ xfs_reflink_fill_delalloc(
 /* Allocate all CoW reservations covering a range of blocks in a file. */
 int
 xfs_reflink_allocate_cow(
+	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	struct xfs_bmbt_irec	*imap,
 	struct xfs_bmbt_irec	*cmap,
@@ -627,7 +630,7 @@ xfs_reflink_allocate_cow(
 	 * Allocate a real extent in the CoW fork.
 	 */
 	if (cmap->br_startoff > imap->br_startoff)
-		return xfs_reflink_fill_cow_hole(ip, imap, cmap, shared,
+		return xfs_reflink_fill_cow_hole(NULL, ip, imap, cmap, shared,
 				lockmode, convert_now);
 
 	/*
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 9d1ed9bb0bee..6a984363edbc 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -30,9 +30,9 @@ int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
 int xfs_bmap_trim_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,
 		bool *shared);
 
-int xfs_reflink_allocate_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,
-		struct xfs_bmbt_irec *cmap, bool *shared, uint *lockmode,
-		bool convert_now);
+int xfs_reflink_allocate_cow(struct xfs_trans *tp, struct xfs_inode *ip,
+		struct xfs_bmbt_irec *imap, struct xfs_bmbt_irec *cmap,
+		bool *shared, uint *lockmode, bool convert_now);
 extern int xfs_reflink_convert_cow(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t count);
 int xfs_reflink_convert_cow_locked(struct xfs_inode *ip,
-- 
2.55.0

