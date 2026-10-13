Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2916F4766AB
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871389; cv=none; b=dJas4sF5CuMQv0o5j3qL0xDdocbgt1OzbrBMlu+4aGm6lkcVaxLp/3oTLTMlkNJBga4j30ZDLMoT76400lfRYgV1GeALYCZIlr3CfOW0CNmMhF/00ukshQnp/V91IyxpBEp4443v+rVEtFOvQECa91b73o6Wjoci87YEaYHsuH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871389; c=relaxed/simple;
	bh=51Kt4qFWgO+KssLcNU2ro8mok9NlICO9TqrY0qUWTZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S9ivODJF8ILh5FwiVqPzwasscbUcRgMES0hLkQ913OA+KjKAzi3c/bjkynppIt/Pu5RsWg2aD+i85wnAJLGBBevHxp6crAT7wjGWJh8jiVqQogeatZBjvzOLnnaFfdqEPwwd/j3i8dl5WweWeA6x6cjJjtIJC84YfeU4NkyPnBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HpQ6laqO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HpQ6laqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077101F000FF;
	Tue, 13 Oct 2026 06:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871387;
	bh=PHj8zYGK5skEm2JrZrYNRe222Fxd2IqLEbT6Tw0mNOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HpQ6laqOSto3jZIm0W2nRsXLdmyoqpLwO7IXiYTO4JkVgI8oQE9ja0UptPKC31DW5
	 I9RxBV0uvonIkJoYhN7q/PCV2sJAVuuP/8unCWnT4P5IzZFne01vQLmnUQJw4X3K+P
	 nYwQ6F2Q8oJ9AWVKzUm9JNXrzCS0mAU+Q1hWf/a+dowjxbynDcg1GH+bqq7v7s73pF
	 r6hoH5q2XJ1fF9CndD+ayA1pRAK7LNxcFhDOI0YwRcnvkSwCwmmPcTJ0jgEKNMGyOj
	 FJDEBfbUuT7xbf4DTbMqXcKKGPsJA58HlJfq0d4EfHbz/sFRaGkZTyaoZUEtRDIIWa
	 M+QP7V87TtcGA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 47/48] xfs: fail recovery on a buffer type mismatch
Date: Tue, 13 Oct 2026 17:01:37 +1100
Message-ID: <20261013060204.3138690-48-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013060204.3138690-1-dgc@kernel.org>
References: <20261013060204.3138690-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When recovering a buffer, xlog_recover_validate_buf_type() checks that the
buffer type recorded in the log item agrees with the magic number of the
buffer being replayed into. A mismatch left bp->b_ops unset and was only
reported with a warning and an ASSERT. On a production kernel recovery then
queued the buffer with no verifier attached, so xfs_buf_verify_write() warned
about the missing operations but still wrote the mismatched recovery data to
disk.

Return an error from xlog_recover_validate_buf_type() on a type mismatch
instead of asserting. The replay path propagates the error so recovery fails
rather than writing out an unverifiable buffer. The skip path, where the
buffer on disk is newer than the log item being recovered, ignores the result:
later changes to that buffer are still to be replayed and may change its type,
so a mismatch against the current log item is expected there and must not warn.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_buf_item_recover.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index a3acefcea13a..27cab5afc8ba 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -212,7 +212,7 @@ xlog_recover_buf_commit_pass1(
  *	the first 32 bits of the buffer (most blocks),
  *	inside a struct xfs_da_blkinfo at the start of the buffer.
  */
-static void
+static int
 xlog_recover_validate_buf_type(
 	struct xfs_mount		*mp,
 	struct xfs_buf			*bp,
@@ -234,7 +234,7 @@ xlog_recover_validate_buf_type(
 	 * just avoid the verification stage for non-crc filesystems
 	 */
 	if (!xfs_has_crc(mp))
-		return;
+		return 0;
 
 	magic32 = be32_to_cpu(*(__be32 *)bp->b_addr);
 	magic16 = be16_to_cpu(*(__be16*)bp->b_addr);
@@ -424,14 +424,22 @@ xlog_recover_validate_buf_type(
 	/*
 	 * Nothing else to do in the case of a NULL current LSN as this means
 	 * the buffer is more recent than the change in the log and will be
-	 * skipped.
+	 * skipped. The buffer contents are newer than this format, so later
+	 * changes to this buffer still to be replayed may change its type. A
+	 * mismatch against this format is therefore expected and not a corruption.
 	 */
 	if (current_lsn == NULLCOMMITLSN)
-		return;
+		return 0;
 
+	/*
+	 * The buffer type does not match the magic number in the buffer we are
+	 * about to replay into. The write verifier keyed off the type would
+	 * reject it, so fail recovery rather than submit a buffer that cannot be
+	 * verified.
+	 */
 	if (warnmsg) {
 		xfs_warn(mp, warnmsg);
-		ASSERT(0);
+		return -EFSCORRUPTED;
 	}
 
 	/*
@@ -452,6 +460,8 @@ xlog_recover_validate_buf_type(
 		bip = bp->b_log_item;
 		bip->bli_item.li_lsn = current_lsn;
 	}
+
+	return 0;
 }
 
 /*
@@ -523,8 +533,7 @@ xlog_recover_do_reg_buffer(
 		bit += nbits;
 	}
 
-	xlog_recover_validate_buf_type(mp, bp, buf_f, current_lsn);
-	return 0;
+	return xlog_recover_validate_buf_type(mp, bp, buf_f, current_lsn);
 }
 
 /*
-- 
2.55.0

