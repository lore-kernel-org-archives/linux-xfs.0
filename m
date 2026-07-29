Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4130C44BCA5
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 10:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319615; cv=none; b=rHSS6yONwJN1KIttJxGTIF+puQc5ONnWAcqHTybYtBYuvOBiyWHIUYrkBxH7C8it1EKqFK9peVI9E7ANdeWPHm/wviM6Hqo0URVvdqZrs8YuTQnS/D60bIbPQg8ZosliOV7mZkpML49T42dIeoM+OoBKkxPj7+70HaG15a2hzOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319615; c=relaxed/simple;
	bh=KuXBV+13f3CnXSSNaxJVABHzkUiBsvMQ1DG/YlcGB44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEd9351XwvvDhoZQogIsShyKOtn218Y/qWcq2Jd/f3y7bHIhS71XAAZbF7loeKUF3BGBLsh9A0K1MESgYZOSrKfqiYTBClwyeml57eCh18C3QmOO18gf6vtD1exFydGTdTk1ENJjYKH90h/iJoQx0XOSNLImIYcECGUQ3fn5UrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ePWUxZSI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ePWUxZSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280941F00A3A;
	Wed, 29 Jul 2026 10:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785319613;
	bh=Sy8yTLmr4azeSyC4C98DlNghbjO3ZbgDhMsVXwIw2Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ePWUxZSIwI7fCd5hCsbBnEjzS6VCmvJSj1x6ZC4yjBmXoIZkoh3bZBNfP/wtu2va+
	 rkNgcytD+geBkJeulG0v/tXY+SmjtijYdYHSA3peDdBDKi6fEGKrSL3tepisUoI8vi
	 U3/jqp/+8ACyT0ph0G/fqfQ8k9FXXLW9hqIOrnYow1jvkvgg6DXMXsswkp0gkretdV
	 cz9rXMnkoHtpVnnaE2jq2YqXbbo2vfy7vLiF97DbGO7dTX6zztyRQzE3FTTt8klKu5
	 XQhE42iC2mIGI+GFIv1nMz6mHSLRdAbVyEv0OYMYZP8Pcsz+XlDDw3HdsuDhIJ7htN
	 xublFL/c2zTAw==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 16/33] xfs: use rolling transaction in xfs_bmapi_convert_delalloc
Date: Wed, 29 Jul 2026 20:02:00 +1000
Message-ID: <20260729100629.1943710-17-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729100629.1943710-1-dgc@kernel.org>
References: <20260729100629.1943710-1-dgc@kernel.org>
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

