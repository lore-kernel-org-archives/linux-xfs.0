Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9199CA6F
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098512; cv=none; b=X4qHgc/bEp9ba2TcgF7T+Z7m7cdXlLlyLRjaaeAfXXGDoP9GF+BAxgp4Zye7P/zzvKX5R7v1eHeI8/2s+uxM1NifNegtyQVVIGiEsO6U8h1emaxTJTe5bJiAA8tYAuIGiVMeIGw5lGOBVf4tLwvpnaUvN9Z5uRmYep7dWFOOo/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098512; c=relaxed/simple;
	bh=EckGMuGKy3ptX5lRWv3twh0jyOWSQbVxQm2P8ZrOn98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zg5D1aPyPa/OhhRbxIdL6sDgt6HeSUgxRvTgaJqsWvJjf1he4RGfJZMI2dy8LBZetn89gge6xXuBlsr7BMyMXIHJ6M3nEn07/cIVkNXipiqsAOb+m00nFGvWL30YEEao5e6pLmmDwxb+fC+zLeBAlkgtpKMVm4HHiMJXGZDhOEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VznNQe+0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VznNQe+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F321F00A3A;
	Wed, 19 Aug 2026 00:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098510;
	bh=TTSk1x1mh8U815nAQE126iV6qk7NzQf32ciPbILxKyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VznNQe+0LTLedZBRrqNxVtGJVlQ27F4f4frhqBU4fwl8T8pOpiGd1ApAw18bE5U/p
	 VXTn0aunpy4fYz2wbMG6Ll7I+G/JUksIJpcVx2/w/BCd+77e2gTczOgkA5eCFYeMoV
	 orv0MicnqV/G6usjnO9O7A9Mu5Ue0hkKE73JpO0AOMNiwrop/4rWPzCuOaO6yzFvhi
	 lxGE8lps6oDnXXTFng0oLyKlnpVHP8LaUS5sCvwRN1y9R5RIBSDLRYltIU8UiFaORW
	 epAyMoJQDjAzgD2woe8t+pgOeGQC/aRzNuuA7/ywQhBlO+e4reg2Bg5vnwOBdha/+L
	 6xlg99v3MIC9A==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 18/38] xfs: return -EAGAIN from xfs_reflink_allocate_cow for all allocation cases
Date: Wed, 19 Aug 2026 10:12:21 +1000
Message-ID: <20260819001442.1451892-19-dgc@kernel.org>
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

Consolidate the -EAGAIN transaction check for both COW hole and
delalloc allocation paths. Both cases require a transaction to
proceed, so lift the *tpp == NULL check above both branches and
return -EAGAIN from a single point.

This activates the retry loop for the delalloc case, which was
previously handled by cycling the ILOCK internally in
xfs_reflink_fill_delalloc().

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_reflink.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 3e8eb16ce076..cc3c1caee2d8 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -616,23 +616,20 @@ xfs_reflink_allocate_cow(
 				convert_now);
 
 	/*
-	 * CoW fork does not have an extent and data extent is shared.
-	 * Allocate a real extent in the CoW fork. If the caller has not
-	 * provided a transaction for the allocation, return -EAGAIN to
-	 * tell the caller to allocate a transaction and retry.
+	 * Allocation is now required, so we need a transaction context from
+	 * the caller if it hasn't already supplied one.
 	 */
-	if (cmap->br_startoff > imap->br_startoff) {
-		if (!*tpp)
-			return -EAGAIN;
+	if (!*tpp)
+		return -EAGAIN;
+
+	if (cmap->br_startoff > imap->br_startoff)
 		return xfs_reflink_fill_cow_hole(tpp, ip, imap, cmap, shared,
 				convert_now);
-	}
 
 	/*
 	 * CoW fork has a delalloc reservation. Replace it with a real extent.
 	 * There may or may not be a data fork mapping.
 	 */
-	ASSERT(!*tpp);
 	if (isnullstartblock(cmap->br_startblock) ||
 	    cmap->br_startblock == DELAYSTARTBLOCK)
 		return xfs_reflink_fill_delalloc(tpp, ip, imap, cmap, shared,
-- 
2.55.0

