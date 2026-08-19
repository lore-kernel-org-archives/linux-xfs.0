Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70DC21CC5A
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098493; cv=none; b=cXzAcHpfuclVTWUYfwhRX+HfnEWBKseFV+uvGn/Q37hdYpBMZG6M4EILJOCFebhExkCSfMZMpzPd75ENmZqTBXJlShUJ8Z0yhqLDj0U7RoTLAA9Peo9dZAkvHBNy7v/lZ+rJxI4WplePMxatzvxvY8yRDmvU1gfNbHK56abrTLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098493; c=relaxed/simple;
	bh=97/mB345JxbltLCTbV3sve8dbju6gXWf5/10HL7K2NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LVxYkO/6RCwlUKueFa9P69CAoI64e4ITVdkpaRUC2whrNymrPyqw0x/mdvBtwnYMHwBts0QoHmi/BWxbiGTNlfLPLtotzwrkFp+z6bX+0+8D8nQ/U9bxmrzAQoFYjmjTWFPcWGkeLEbclD/XtWxeufYtt5ixUXy7/a1Kl6qsoPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X6ok54Pm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X6ok54Pm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410961F00A3A;
	Wed, 19 Aug 2026 00:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098490;
	bh=DMUZ/Jwyv+4KydAJ8CVD3jk4eB4ww4l5Ug8EGB3Q0yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X6ok54PmyNNByPno4drgzG64eaMZLVnqJE3lKtBAf4k7DsTi3HvlFseN19aFhljRk
	 3T+H+1ID3fQdiLrOuEsLHbxbvZCuAL/0o1b8dsz+CtzDFkIVvJjHgRzZciWHdKcpMA
	 lILz0lr2sOzFDWHP+CovDGZXvJjls8iRRi0Fwmgts2hjYKdJ1fRhW6EEEJRLkhl3c3
	 tR1oibBFZfD9DI4RkFDV/yBXaPXObfunbwXkpOeZ+X0XI9jm41BLUucWhQrS7RopIS
	 +SOo2zHnhf/iT36vLQQDkoY1da2GRFCKD3ytI4mKoRj6dJJaZVwViIHvDE7JHP9+4+
	 YXT5jpc3POH7w==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 02/38] xfs: fix dirty transaction cancellation in xfs_attr_set
Date: Wed, 19 Aug 2026 10:12:05 +1000
Message-ID: <20260819001442.1451892-3-dgc@kernel.org>
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

xfs_attr_set() calls xfs_iext_count_extend() before xfs_attr_lookup().
If xfs_iext_count_extend() upgrades the inode to NREXT64 format it
will dirty the transaction. If the subsequent xfs_attr_lookup() finds
a result that is incompatible with the requested operation (e.g.
EEXIST for CREATE, ENOATTR for REMOVE/REPLACE), the function returns
the error and the caller cancels the transaction. Cancelling a dirty
transaction triggers a filesystem shutdown.

Fix this by moving the xfs_attr_lookup() call before
xfs_iext_count_extend() and validating the lookup result against the
requested operation before dirtying the transaction. The code is
restructured to separate validation from execution: first filter out
the error cases that should cancel cleanly, then extend the extent
count, then dispatch to the appropriate modification function based
on the operation type.

Fixes: 4f86bb4b66c9 ("xfs: Conditionally upgrade existing inodes to use large extent counters")
Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 70 ++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b3f7b2c34ad7..bf0e867628e7 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1136,7 +1136,7 @@ xfs_attr_set(
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans_res	tres;
-	int			error, local;
+	int			error, lookup_result, local;
 	int			rmt_blks = 0;
 	unsigned int		total = 0;
 
@@ -1185,48 +1185,48 @@ xfs_attr_set(
 	if (error)
 		return error;
 
-	if (op != XFS_ATTRUPDATE_REMOVE || xfs_inode_hasattr(dp)) {
-		error = xfs_iext_count_extend(args->trans, dp, XFS_ATTR_FORK,
-				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
-		if (error)
-			goto out_trans_cancel;
-	}
-
-	error = xfs_attr_lookup(args);
-	switch (error) {
-	case -EEXIST:
-		if (op == XFS_ATTRUPDATE_REMOVE) {
-			/* if no value, we are performing a remove operation */
-			error = xfs_attr_removename(args);
-			if (error)
-				goto out_trans_cancel;
-			break;
-		}
-
-		/* Pure create fails if the attr already exists */
+	/*
+	 * Look up the attr before extending the extent count so that we
+	 * don't dirty the transaction if the op is going to fail with an
+	 * error. Cancelling a dirty transaction would shutdown the fs.
+	 */
+	lookup_result = xfs_attr_lookup(args);
+	if (lookup_result == -EEXIST) {
 		if (op == XFS_ATTRUPDATE_CREATE)
 			goto out_trans_cancel;
-
-		error = xfs_attr_replacename(args, rmt_blks);
-		if (error)
-			goto out_trans_cancel;
-		break;
-	case -ENOATTR:
-		/* Can't remove what isn't there. */
-		if (op == XFS_ATTRUPDATE_REMOVE)
+	} else if (lookup_result == -ENOATTR) {
+		if (op == XFS_ATTRUPDATE_REMOVE ||
+		    op == XFS_ATTRUPDATE_REPLACE)
 			goto out_trans_cancel;
+	} else {
+		error = lookup_result;
+		goto out_trans_cancel;
+	}
 
-		/* Pure replace fails if no existing attr to replace. */
-		if (op == XFS_ATTRUPDATE_REPLACE)
-			goto out_trans_cancel;
+	error = xfs_iext_count_extend(args->trans, dp, XFS_ATTR_FORK,
+			XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
+	if (error)
+		goto out_trans_cancel;
 
+	switch (op) {
+	case XFS_ATTRUPDATE_REMOVE:
+		error = xfs_attr_removename(args);
+		break;
+	case XFS_ATTRUPDATE_CREATE:
 		error = xfs_attr_setname(args, rmt_blks);
-		if (error)
-			goto out_trans_cancel;
 		break;
-	default:
-		goto out_trans_cancel;
+	case XFS_ATTRUPDATE_UPSERT:
+		if (lookup_result == -ENOATTR) {
+			error = xfs_attr_setname(args, rmt_blks);
+			break;
+		}
+		fallthrough;
+	case XFS_ATTRUPDATE_REPLACE:
+		error = xfs_attr_replacename(args, rmt_blks);
+		break;
 	}
+	if (error)
+		goto out_trans_cancel;
 
 	/*
 	 * If this is a synchronous mount, make sure that the
-- 
2.55.0

