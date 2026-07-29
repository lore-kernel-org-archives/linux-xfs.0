Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7634644BCA8
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 10:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319611; cv=none; b=k/KiyHmZOuR4CK9p4PX2LcCmCCMYzOB3LUvi9O0bi5EEwWa6GtTnpioJfmt8JH+4tUrW6EM3cpU+Ny6aezc03aILXW6eJL5rz8GoU0P6SAM8noybVRx+uc56m4Y7rhc0h/S5lvsI+V3gKpHw/bNc4SKpy6/z72e1qb9ydKHZAG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319611; c=relaxed/simple;
	bh=EckGMuGKy3ptX5lRWv3twh0jyOWSQbVxQm2P8ZrOn98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dsz/XSDBSp3tM/5idnHUiAV0dFN94VaaTb8wDl9VAW1Hr/k3U4IzsR6iTGURbeqPmk6ZlTMYrf4yjLVvCJwhf3CjMYuPaJyOwjfV2Nmuj0qp2y5xHR26v6zIC+GbGI4lnz5t/XQF/OPyDEjj7+HgxyPNIrPwVvL2qLXjZNzjqfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dkOasYkn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dkOasYkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE2D1F000E9;
	Wed, 29 Jul 2026 10:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785319610;
	bh=TTSk1x1mh8U815nAQE126iV6qk7NzQf32ciPbILxKyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dkOasYkn5dCnqtojp8D6d8VF8rWR+wYpehy2UfbUjrji5IN4oGdj9A8qCNpmdJYze
	 9qPRKogaNXqXPvMHkWyHC5IOEKVh4OVMZZbyoZZMsnntERsPjESLOS6CuYUb9BKnxo
	 mGmQ99cw5Y/F71rXSkRq/07aNZY6gBpOI5J+IRcI0GGqwDBzRcYnS2487lXmJ5SZQy
	 6fIQSEVIvL3o5ZubNVUhOefds47IaA2znyAkTrWjjfNmXbZ7Rc0EbXI5CmNlIeUdPv
	 s3MC69tK9I90qsHIU9IzVv1cfLBH5snssCLFJN1sv3O5ylgUMMfiwrQ819UwfmzMtR
	 7HzqaoX7ZFOeQ==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 13/33] xfs: return -EAGAIN from xfs_reflink_allocate_cow for all allocation cases
Date: Wed, 29 Jul 2026 20:01:57 +1000
Message-ID: <20260729100629.1943710-14-dgc@kernel.org>
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

