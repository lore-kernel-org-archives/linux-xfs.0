Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C62E2837B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995241; cv=none; b=ZxBMTphyCoT/+wMN76aEQ+IuBvmi0a4aadU7VvFrGgVO5CerO9pFrsioJTtgcdF3WP9qXIS8OOF2ubLRuk/5QqoZ9eNYhmPJQDKF5wz+nYTJc6HBsIH//JZTTpdaeuVdmbeJuQhPVSaO3qeqeKsOt3qMXhb3dpnPmgAjP/WpUe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995241; c=relaxed/simple;
	bh=zGRCtcQCM5dlQdrk01yBhVtilUTnGumzI/f8YFuFJlI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QZYRA9e6MyTLG37h2VuYgIXJn6up8Fx49dEJqmKYFeGWjUYMqX+sAMQBNKdVKEA0B33kJ3mn8ii1rZfK/0aSdywInBDoXFmrUmxWeImhPyQWxDypT4N66Je7oN8meDJBzaa3iaQgQd0S8ACJz6Rub5cQi0pORjmzqB8l09bPXn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kNkh0ONC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kNkh0ONC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864ACC4CED3;
	Mon, 23 Dec 2024 23:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995240;
	bh=zGRCtcQCM5dlQdrk01yBhVtilUTnGumzI/f8YFuFJlI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kNkh0ONCm+LDos4IOLTmnaSX603okK3jXNVy1qp0ZybBfZ0OeO87u/WuMo2QYaW++
	 nK2TNzkYT9yn6l5kYzSkXcAGhznbnC9dQ3fgIujbj+/Gp0P4qbtwJFfrONjEdfguQa
	 gB16GVA80/NyITIjyyi9svrS8K6ZwE4fEPzVtq3+z9KrliB0hfKzrwDnkl7n8mj5nx
	 iPY58QNqCcQALHFJBnE9cVUz0D9nGM/UGRehyGwvTJwZUG1fNN6nt5K7UZYeFrEKC2
	 wsDurER3OpIE6n6pgeolGstoxyU0SWYDfB1nBvxmBnQcyBClbjSswMCqx5395PcAyf
	 iyKTjmu6SBuUQ==
Date: Mon, 23 Dec 2024 15:07:20 -0800
Subject: [PATCH 04/43] xfs: realtime refcount btree transaction reservations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420007.2381378.17804974842845753772.stgit@frogsfrogsfrogs>
In-Reply-To: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
References: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make sure that there's enough log reservation to handle mapping
and unmapping realtime extents.  We have to reserve enough space
to handle a split in the rtrefcountbt to add the record and a second
split in the regular refcountbt to record the rtrefcountbt split.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_trans_resv.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index f3392eb2d7f41f..13d00c7166e178 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -92,6 +92,14 @@ xfs_refcountbt_block_count(
 	return num_ops * (2 * mp->m_refc_maxlevels - 1);
 }
 
+static unsigned int
+xfs_rtrefcountbt_block_count(
+	struct xfs_mount	*mp,
+	unsigned int		num_ops)
+{
+	return num_ops * (2 * mp->m_rtrefc_maxlevels - 1);
+}
+
 /*
  * Logging inodes is really tricksy. They are logged in memory format,
  * which means that what we write into the log doesn't directly translate into
@@ -259,10 +267,13 @@ xfs_rtalloc_block_count(
  * Compute the log reservation required to handle the refcount update
  * transaction.  Refcount updates are always done via deferred log items.
  *
- * This is calculated as:
+ * This is calculated as the max of:
  * Data device refcount updates (t1):
  *    the agfs of the ags containing the blocks: nr_ops * sector size
  *    the refcount btrees: nr_ops * 1 trees * (2 * max depth - 1) * block size
+ * Realtime refcount updates (t2);
+ *    the rt refcount inode
+ *    the rtrefcount btrees: nr_ops * 1 trees * (2 * max depth - 1) * block size
  */
 static unsigned int
 xfs_calc_refcountbt_reservation(
@@ -270,12 +281,20 @@ xfs_calc_refcountbt_reservation(
 	unsigned int		nr_ops)
 {
 	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
+	unsigned int		t1, t2 = 0;
 
 	if (!xfs_has_reflink(mp))
 		return 0;
 
-	return xfs_calc_buf_res(nr_ops, mp->m_sb.sb_sectsize) +
-	       xfs_calc_buf_res(xfs_refcountbt_block_count(mp, nr_ops), blksz);
+	t1 = xfs_calc_buf_res(nr_ops, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_refcountbt_block_count(mp, nr_ops), blksz);
+
+	if (xfs_has_realtime(mp))
+		t2 = xfs_calc_inode_res(mp, 1) +
+		     xfs_calc_buf_res(xfs_rtrefcountbt_block_count(mp, nr_ops),
+				     blksz);
+
+	return max(t1, t2);
 }
 
 /*

