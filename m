Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF55025D53B
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098499; cv=none; b=JB8G/XrsE7BPwyVI7PWanHME5QXcU5jnJVdxH4XJ9JcS4tAfYFV5bHTTfDxy0Dw5wNJkWDyNYHtHHbIMv68zkjzQ+sNeqBD+DA0vKMBCNKIHln/hn+ucgPikCq32BHMREVW82OYZipuIfB6zuttsODrqr1TEWOklhEB1CgqtnMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098499; c=relaxed/simple;
	bh=M61PmXgwv1AO/O0OmZ1o6QOtnAR1bJxb/TcguA8xrzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEJOklkyBRV/1yoD420yUQKwxWD8+WnqGePhpkWMiUw1x2uvu7/rEogfGl9OPPyV2jnkJb3NF8lWEigz5K1B/VniKeC1nfpGuIfmiZlds4VQNuWyXHZpykKWxoBQ0RGpkbL1sBaWPhh2Fk4IPAgGsonMxCCkj8jTH35izwaqyBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fRAY4XfP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fRAY4XfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77141F00A3E;
	Wed, 19 Aug 2026 00:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098497;
	bh=LMB9dAmDtOtVJnaU6KFx2lnWj9NlDXfX8HnI4uNTEpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fRAY4XfP0fctTs0+WXgJEXGZSV3znEXaWztBIp10E68jgctZPuooth4kf8V1xYUHf
	 gjzCaDvYWm+AFumRBRup70QWPeT5pn/bcAXmhJv09AkRfUK6ygZPctJxjyTn9BJh3U
	 IGetRuEBs2AZbK71ZnOYnglvTriPkfvBVmtCefLdWcb/UrMAY3QItkukrZkgi/jjOU
	 cVxKA3BNt10Y8c9n+CT4tHONkPlYmFjrB6OQlA/8mxpH6rAYk2WNVSJBZWbKMPJN+K
	 MbASOghN0V35JJCC2bw5Pxi43v87eowN+i/6CuQErXu78CaqWj5jT6psSRAmE+dI/V
	 dFbenLSvBP08g==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 08/38] xfs: add async blockgc retry to xfs_trans_reserve_more_inode()
Date: Wed, 19 Aug 2026 10:12:11 +1000
Message-ID: <20260819001442.1451892-9-dgc@kernel.org>
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

xfs_trans_reserve_more_inode() can fail with ENOSPC or EDQUOT when
called from contexts that hold the ILOCK. Unlike xfs_trans_alloc_inode()
which can drop the ILOCK, run synchronous blockgc, and retry, this
function cannot use synchronous reclaim because the ILOCK is held.

Synchronous blockgc would deadlock in two ways: first, the blockgc
workers need to take the ILOCK on each inode they scan, so they
would block on the inode we hold. Second, the locked inode pins
journal space that blockgc transactions need for their own commits.

Add a retry loop that on ENOSPC kicks xfs_blockgc_start_flush() to
reclaim global speculative preallocations, and on EDQUOT/ENOSPC
from quota kicks xfs_blockgc_free_quota_nowait() to reclaim quota-
targeted preallocations. After kicking, the loop sleeps for 100ms
via io_schedule_timeout() to allow the background workers to make
progress, then retries once. io_schedule_timeout() is used because
this can be called from the IO submission path where block plugs
may be held.

Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_trans.c | 63 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 609b0fe3d4d3..8e32da47501e 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1130,8 +1130,24 @@ xfs_trans_alloc_inode(
 }
 
 /*
- * Try to reserve more blocks and file quota for a transaction.  Same
- * conditions of usage as xfs_trans_reserve_blocks.
+ * Reserve blocks and quota for an inode that is already locked and joined to
+ * the transaction. If the reservation fails due to ENOSPC or EDQUOT, kick
+ * background blockgc reclaim and retry once after a short delay.
+ *
+ * We cannot use synchronous blockgc flushing here because we hold the ILOCK.
+ * Synchronous blockgc needs to take the ILOCK on each inode it scans, so it
+ * would deadlock on the inode we hold. Furthermore, the locked inode pins
+ * journal space that blockgc transactions need for their own commits, creating
+ * a second deadlock vector. Instead, we kick the background workers and sleep
+ * briefly so that if blockgc is stuck waiting on resources we hold, we still
+ * retry and return ENOSPC rather than deadlocking.
+ *
+ * We use io_schedule_timeout() for the delay because this can be called from
+ * the IO submission path where block plugs may be held. The 100ms delay is
+ * long enough for blockgc workers to lock an inode, run a transaction to free
+ * speculative preallocations and commit it, but short enough that we don't
+ * cause excessive IO latency if blockgc cannot make progress because it is
+ * blocked on resources we hold.
  */
 int
 xfs_trans_reserve_more_inode(
@@ -1143,27 +1159,44 @@ xfs_trans_reserve_more_inode(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	unsigned int		rtx = xfs_extlen_to_rtxlen(mp, rblocks);
+	int			retry = 0;
 	int			error;
 
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 
-	error = xfs_trans_reserve_blocks(tp, dblocks, rtx);
-	if (error)
-		return error;
-
-	if (!XFS_IS_QUOTA_ON(mp) || xfs_is_quota_inode(&mp->m_sb, I_INO(ip)))
-		return 0;
-
 	if (tp->t_flags & XFS_TRANS_RESERVE)
 		force_quota = true;
 
-	error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks,
-			force_quota);
-	if (!error)
-		return 0;
+	do {
+		if (retry)
+			io_schedule_timeout(msecs_to_jiffies(100));
+
+		error = xfs_trans_reserve_blocks(tp, dblocks, rtx);
+		if (error == -ENOSPC) {
+			xfs_blockgc_start_flush(mp);
+			continue;
+		}
+		if (error)
+			return error;
+
+		if (!XFS_IS_QUOTA_ON(mp) ||
+		    xfs_is_quota_inode(&mp->m_sb, I_INO(ip)))
+			return 0;
+
+		error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks,
+				rblocks, force_quota);
+		if (!error)
+			return 0;
+
+		xfs_trans_unreserve_blocks(tp, dblocks, rtx);
+
+		if (error == -EDQUOT || error == -ENOSPC) {
+			xfs_blockgc_free_quota_nowait(ip);
+			continue;
+		}
+		return error;
+	} while (retry++ == 0);
 
-	/* Quota failed, give back the new reservation. */
-	xfs_trans_unreserve_blocks(tp, dblocks, rtx);
 	return error;
 }
 
-- 
2.55.0

