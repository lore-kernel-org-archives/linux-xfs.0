Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79D14457B3
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 10:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319605; cv=none; b=uHSUWiU0N9PtoblHSvDYpvnP8ixLfMr0AB8BDclrOxadfSDPgo2e0Hrk3SoProD83ziGV+Gu7AW1/11N1/h4z+Fgz9GULPqJmVGPmf87u+ruFm3Pj7YDK0eofoda6eU64HauQGiJ+CnvrICmp7EyIF+YWQnNKH8yRp3OE8I78tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319605; c=relaxed/simple;
	bh=EFaWaIi/EmfKxrkHZElt06ZZWHrAqSeN/tSWTEdUISs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ce71S/7XWdJxtZoOpJ+48z5Fn+Yb7W3yQwOGjhYUFj7AUxARF3+q57FWsUSqYPcbb57/rv4X+VoAZpCjv6xn+lXw9y+3cJGg18K9Tr2jnCaCfAyRDM2Q7RsppbOnn6z7Vy4aUE20ACXfvDGatf0/5XxsLqyl5662BlWrbu2x+lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YyaUj69J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YyaUj69J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFD21F00A3A;
	Wed, 29 Jul 2026 10:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785319604;
	bh=jtvKsqhHnbUYvmXemwpaPWep3FT6qDNlzxGAXqX8T4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YyaUj69J1cEaxK6P8DdxT2HOzurnYO9hMSU+pceHQSRyZcp/iQ8vvuIIPjr7gqkHE
	 n6IW6aQnJDtJk24GNyzsizV0JZrU+559AWndPW6HsIe/0d5T0DmnlMxlzk+ZMvDdlD
	 dWnLhjfq5v7yp/hGlwnPQuFAny2xm7T8Z7x69r8lqOy/r/uJYJFPFMa0oYgCVhreBr
	 rant75106eIuyoh4mW6cZ0KdkzTzt81s0d11+2VjH6sJaX68fNYpHdB/8cj311vFqe
	 GVU4Hb5IHpQMEtoKwFRMfpwrpbEDNKtqKIrrmFlBIOt23CrctCHs7GMC9JHJI7NDn4
	 RQASB+/BBHTUw==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 08/33] xfs: return -EAGAIN from xfs_reflink_allocate_cow for COW hole without transaction
Date: Wed, 29 Jul 2026 20:01:52 +1000
Message-ID: <20260729100629.1943710-9-dgc@kernel.org>
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

When xfs_reflink_allocate_cow() encounters a COW fork hole that needs
a real extent allocated and no transaction has been provided, return
-EAGAIN to tell the caller to allocate a transaction and retry.

When a transaction is provided, pass it through to
xfs_reflink_fill_cow_hole() which will use it directly for the COW
extent allocation without needing to cycle the ILOCK.

This activates the retry loop added in the previous patch: on the
first call (tp == NULL), allocate_cow returns -EAGAIN, the caller
drops the ILOCK, allocates a transaction, and retries. On the
second call (tp != NULL), the transaction is passed down to
fill_cow_hole() and the COW allocation completes atomically
under the ILOCK without cycling it.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_reflink.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 1ad0569ecdd1..56ad76b0f6b9 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -643,16 +643,22 @@ xfs_reflink_allocate_cow(
 
 	/*
 	 * CoW fork does not have an extent and data extent is shared.
-	 * Allocate a real extent in the CoW fork.
+	 * Allocate a real extent in the CoW fork. If the caller has not
+	 * provided a transaction for the allocation, return -EAGAIN to
+	 * tell the caller to allocate a transaction and retry.
 	 */
-	if (cmap->br_startoff > imap->br_startoff)
-		return xfs_reflink_fill_cow_hole(NULL, ip, imap, cmap, shared,
+	if (cmap->br_startoff > imap->br_startoff) {
+		if (!tp)
+			return -EAGAIN;
+		return xfs_reflink_fill_cow_hole(tp, ip, imap, cmap, shared,
 				lockmode, convert_now);
+	}
 
 	/*
 	 * CoW fork has a delalloc reservation. Replace it with a real extent.
 	 * There may or may not be a data fork mapping.
 	 */
+	ASSERT(!tp);
 	if (isnullstartblock(cmap->br_startblock) ||
 	    cmap->br_startblock == DELAYSTARTBLOCK)
 		return xfs_reflink_fill_delalloc(ip, imap, cmap, shared,
-- 
2.55.0

