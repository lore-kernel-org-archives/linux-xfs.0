Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5150486420
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871365; cv=none; b=DcNeBb7QHdbcSPZsEwsU5jJ8X7YaY3HbEv3Y6NknC99b/x8/0XjTmsFpV3RrCTq2pwB5FCD4P/t7zk80whnRsOPGOsnUPuKqsJ7QstXsnJILZrTUoxpdlIXpnx4Yp7EXAz7IhwVvwiIq5/gzo5RbgVETvtAXxSe7C06qVB5OBdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871365; c=relaxed/simple;
	bh=TBZGf0W4FbB7KaX7/a7ynAD5ppAVHTdi099lUdivU5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T+x6SmMBPYAVjd8R+AnCfV2cB5VzvesRM+mGcvz35tWXZF3Ito03BoW3/DZ2ULlZcfFKlVMwqMQXkLyDJcd7y84h26DaTt0co0wp19Nr30UXs9WAQ1N7TnPQNtfJeOmjM8DtTePOJ5MRqIwqxwDGvBrCAorjJiv4/eMhe1Y8UK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CeI4IrAk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CeI4IrAk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8ED1F000FF;
	Tue, 13 Oct 2026 06:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871363;
	bh=wtF5N8fh8dT+xuH3t+JYnLa6ILpR68r+TM4cQXpgNhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CeI4IrAkGbjVSslkewIEiJ1ByS2mrpvA2YvErY38WOj9+e2CyQAhONUSKTXFc4PdW
	 r+QKX9ChXb4agfa9dHav5zIgLI1QiNTaAtPW5JsB2Amo8HSgIGlDiBL3ufLL88TkIl
	 0x8xoQJdiBOF2al4ub92G4oVkBGz3tcHUx2zPRVg8ZMRFDftU7uEf+U85QbyVgbnqr
	 FE5N8Q6tr5YL1Db6t5W2hd1M92z2X7UrCQ3Qgm2V72T5BwQpO6MbFribMbPMv9Kbih
	 b1Pbovjk3c6Gs+56GICKahf3wmH2yHIsOsBx2qdIC6et62iJpWVS4Ga4+b149NCYPy
	 30mLsmf0BJG9g==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 28/48] xfs: validate mapping exchange intents during recovery
Date: Tue, 13 Oct 2026 17:01:18 +1100
Message-ID: <20261013060204.3138690-29-dgc@kernel.org>
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

A mapping exchange intent is a single fixed size region describing an exchange
between two files, but its contents were only checked during intent replay,
after the item had been decoded and queued.

Validate the region length as it is decoded, and validate the exchange
parameters in ->validate_item(). xfs_xmi_validate() now takes the format
structure so it can run against the decoded region. The commit handler and
intent replay can then trust the item, so the redundant checks are removed from
them.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_exchmaps_item.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_exchmaps_item.c b/fs/xfs/xfs_exchmaps_item.c
index 23381cb264c4..6ee55a22eb90 100644
--- a/fs/xfs/xfs_exchmaps_item.c
+++ b/fs/xfs/xfs_exchmaps_item.c
@@ -324,14 +324,12 @@ xfs_exchmaps_abort_intent(
 static inline bool
 xfs_xmi_validate(
 	struct xfs_mount		*mp,
-	struct xfs_xmi_log_item		*xmi_lip)
+	struct xfs_xmi_log_format	*xlf)
 {
-	struct xfs_xmi_log_format	*xlf = &xmi_lip->xmi_format;
-
 	if (!xfs_has_exchange_range(mp))
 		return false;
 
-	if (xmi_lip->xmi_format.__pad != 0)
+	if (xlf->__pad != 0)
 		return false;
 
 	if (xlf->xmi_flags & ~XFS_EXCHMAPS_LOGGED_FLAGS)
@@ -447,13 +445,7 @@ xfs_exchmaps_recover_work(
 	struct xfs_inode		*ip1, *ip2;
 	int				error = 0;
 
-	if (!xfs_xmi_validate(mp, xmi_lip)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				&xmi_lip->xmi_format,
-				sizeof(xmi_lip->xmi_format));
-		return -EFSCORRUPTED;
-	}
-
+	/* The xmi was validated when it was recovered. */
 	xmi = xfs_xmi_item_recover_intent(mp, dfp, &xmi_lip->xmi_format, &req,
 			&ip1, &ip2);
 	if (IS_ERR(xmi))
-- 
2.55.0

