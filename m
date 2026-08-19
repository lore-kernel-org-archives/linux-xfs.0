Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FDA29BDBB
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098516; cv=none; b=Cql8NrRdkT5vyMlotO7EEU78O1EysklPIB4Gs1WIkcoNzoMOdBu7gBkTQPCaLA64Ge6Jv2asyTGu/EE6hVEaDmaNw5EIW8u9hHoti+QbO6NNgVUlUrT2sU5m3NwxqwLUQanIporodWKvvdLN24aB4isJG5VpjM4759ZNsc8XIY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098516; c=relaxed/simple;
	bh=KuXBV+13f3CnXSSNaxJVABHzkUiBsvMQ1DG/YlcGB44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rd7RyxJ8yhDzosAh1PIhrqmFzEb/UL+PIrWqV5EZ5IKHJftoqTAdK1JXuOU4U6XeLLR+1Ebnfi57P8eI3Gb6Bq5/b8JDG89HHNf2A6QZE140SOsnVpmMcrT3rhnkwxPZhub/lBbXBm1MOydhC9PqxKqHr5RoDn9GYc4H33v9/1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yj2CmKg2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yj2CmKg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC501F000E9;
	Wed, 19 Aug 2026 00:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098514;
	bh=Sy8yTLmr4azeSyC4C98DlNghbjO3ZbgDhMsVXwIw2Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yj2CmKg2upywy4Ixjb0hKyQIbD/GC3gRzJbALumYyXehUy43CSvyDytnOrbZp99FE
	 0i2NnExvNWC1r2M5avaaxTRL5WRDQ9AyiU/amleBEDwdZMI0QG2pOS9cdmdoydj2Dj
	 j1wzwNW9qk8rchUQg6Zyni3FnwSRGzhXqZqDFyYh/AxVdhvVEVAeGM9Mdl90ih3lMF
	 NJVGCYWd1l2yaS7lzgR9pdLnANSvEUJ+VYFSBdk8lWIu9QOPK9wwcMVNiJWgxKrHGd
	 7R0lka3ppyfECWUkQH0N96oxCuWeRGgtLSnom0iqu91pQTQdT9so8zyEB5I1JpSJzL
	 j0BMW4vcyjFuA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 21/38] xfs: use rolling transaction in xfs_bmapi_convert_delalloc
Date: Wed, 19 Aug 2026 10:12:24 +1000
Message-ID: <20260819001442.1451892-22-dgc@kernel.org>
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

Move the transaction allocation, ILOCK acquisition and inode join
up from xfs_bmapi_convert_one_delalloc() into
xfs_bmapi_convert_delalloc(). Pass the transaction down to each
call to xfs_bmapi_convert_one_delalloc(), and use xfs_defer_finish()
after each iteration to process deferred operations and roll the
transaction while keeping the ILOCK held.

The rolling transaction keeps the ILOCK held across the entire
conversion loop, making this multi-extent conversion operation
atomic with respect to other concurrent extent operations.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7f3a3a02a035..4eaf67b51c8d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4503,8 +4503,26 @@ xfs_bmapi_convert_delalloc(
 	struct iomap		*iomap,
 	unsigned int		*seq)
 {
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
 	int			error;
 
+	/*
+	 * Allocate the transaction, take the ILOCK and join the inode to it.
+	 * Space for the extent and indirect blocks was reserved when the
+	 * delalloc extent was created so there's no need to reserve blocks.
+	 * The rolling transaction keeps the ILOCK held across the entire
+	 * conversion loop, making this multi-extent conversion operation
+	 * atomic with respect to other concurrent extent operations.
+	 */
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0,
+				XFS_TRANS_RESERVE, &tp);
+	if (error)
+		return error;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+
 	/*
 	 * Attempt to allocate whatever delalloc extent currently backs offset
 	 * and put the result into iomap.  Allocate in a loop because it may
@@ -4512,13 +4530,24 @@ xfs_bmapi_convert_delalloc(
 	 * delalloc extent if free space is sufficiently fragmented.
 	 */
 	do {
-		error = xfs_bmapi_convert_one_delalloc(NULL, ip, whichfork,
+		error = xfs_bmapi_convert_one_delalloc(tp, ip, whichfork,
 					offset, iomap, seq);
 		if (error)
-			return error;
+			goto out_trans_cancel;
+
+		error = xfs_defer_finish(&tp);
+		if (error)
+			goto out_trans_cancel;
 	} while (iomap->offset + iomap->length <= offset);
 
-	return 0;
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+
+out_trans_cancel:
+	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
 }
 
 int
-- 
2.55.0

