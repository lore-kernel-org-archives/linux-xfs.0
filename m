Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338F414A616
	for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2024 05:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723440244; cv=none; b=NHhmDFdT9/J66XG4UrYOQHgzXzHnOZInPoIgAOkSOugmeF8VdK3XP4Mwa2bqiJOz4IFHsV3SQxfK5BFOB6ypkLp+i0dFPCHlO34CJNyMoZ4Ruc0We29UJxPaVWkC1E8bx52ZAtjXG8+cQaUxSfuAR3PHc0DaCPfooX68P/cTJkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723440244; c=relaxed/simple;
	bh=+Dp4rBDB8QO1YFmlPCsQDUaFwJU+JmYrBfgwG2Ip2Gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5SkJ/oDBc1i7l7uvN1ghYA6PsHdXZp9TMnSAiz1d8qpZ9o8BjRU/PpytrWYWgZYdJyD2mBVt+Wib3rntPLcm1yyQ5xE+kqzPPvq2LztjxTHdXU68L0BXqoBlX01kNjGUUUABww0IDajipqJYIjW2tWMqfVS26gDLFQNAHlPzis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TMEZD1i4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TMEZD1i4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=lRnXl04+DmVNGX8msI2lmDpVzDH9f7neGlfMR17aoQE=; b=TMEZD1i4TCWqDoBT43+Npn9m9c
	tYwDYkkE1V4Mr4mD2Lp1MfB5v6gm4aq9rjdyQbgZiYhJstK6jQs6KGGI8Ze1WyxFWD8Y63a6NRxpr
	EnP/0sxnTHrBvNoc7fTPYV6L99ejci7hXqXjRVq7OUBHystdRfsygy9NcQQ/tfRXLxlcVb5Mgjd9i
	6BDq+YTxlzSPLbdBoP1ba6e17eKEFYHFaiuGV1NFYPz6Vr19eNy41hkl6ROANvna3W/XIC1wm6Shj
	6U892/Lb9ZMMp7+fKBHaY+dLm9x44E8kaJjLDlBsE0VPPuyknvsJNew8gtSr9vWvGRBJinxm6iLnA
	WJbOXZrQ==;
Received: from 2a02-8389-2341-5b80-ee60-2eea-6f8f-8d7f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:ee60:2eea:6f8f:8d7f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdNXG-0000000Gv5N-0722;
	Mon, 12 Aug 2024 05:24:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: fix handling of RCU freed inodes from other AGs in xfs_icwalk_ag
Date: Mon, 12 Aug 2024 07:23:00 +0200
Message-ID: <20240812052352.3786445-2-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240812052352.3786445-1-hch@lst.de>
References: <20240812052352.3786445-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When xfs_icwalk_ag skips an inode because it was RCU freed from another
AG, the slot for the inode in the batch array needs to be zeroed.  We
also really shouldn't try to grab the inode in that case (or at very
least undo the grab), so move the call to xfs_icwalk_ag after this sanity
check.

Fixes: 1a3e8f3da09c ("xfs: convert inode cache lookups to use RCU locking")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index ae3c049fd3a216..3ee92d3d1770db 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1701,9 +1701,6 @@ xfs_icwalk_ag(
 		for (i = 0; i < nr_found; i++) {
 			struct xfs_inode *ip = batch[i];
 
-			if (done || !xfs_icwalk_igrab(goal, ip, icw))
-				batch[i] = NULL;
-
 			/*
 			 * Update the index for the next lookup. Catch
 			 * overflows into the next AG range which can occur if
@@ -1716,8 +1713,14 @@ xfs_icwalk_ag(
 			 * us to see this inode, so another lookup from the
 			 * same index will not find it again.
 			 */
-			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno)
+			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno) {
+				batch[i] = NULL;
 				continue;
+			}
+
+			if (done || !xfs_icwalk_igrab(goal, ip, icw))
+				batch[i] = NULL;
+
 			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
 			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
 				done = true;
-- 
2.43.0

