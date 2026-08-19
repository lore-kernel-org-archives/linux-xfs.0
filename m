Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6AD296BAF
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098507; cv=none; b=VO7eoMU+0E2ZCm4LJZX+uM9gWvwqZsUxqcKmxU4ufZYoehQkologtcr2FhD0a7JsDxToXa18YDRx9ztHweDEktesPjSpaWR+ujJVj4skxTO4TnBYo1OwgtMfJsf0L1Tey1clggE2fvTLC3oY2mwVeEZhf2Ps2UiPZ3l0zsVd7yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098507; c=relaxed/simple;
	bh=EFaWaIi/EmfKxrkHZElt06ZZWHrAqSeN/tSWTEdUISs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwEPZ/aOiMfAdqiEyAxdgYJZHzlm03SDzE2u8MYUusUrvU9D2ornHetuynW6avqsyRXyE/aBWaKJSesRNVzpKkgb/fgx/pSerhku0xQxm7rv6XdAZQxLmohWYjNDrTbm+WWovMDUxotSa6tI0Tbbo7jpguVD6kW8No8mntNJagw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IerbBuJl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IerbBuJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8951F000E9;
	Wed, 19 Aug 2026 00:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098504;
	bh=jtvKsqhHnbUYvmXemwpaPWep3FT6qDNlzxGAXqX8T4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IerbBuJlqCkn0irJ2f6/uNQ8xxGCgVX6MbHal/iCCyo0TZ3fyfKmmzwDTn6sHVoCo
	 Tcu6MqE9ZCAK4971XJd09w73dAcX5ozL64T2KuwkbaaVQcHkJPHQJw4Z+tQZ/mRQbZ
	 /Z2L/0tepxd1nIee+EzGVIgMQv4uJ56QnzYTBVGpuW9V4FEn8dBq+MZxnm50OzE7n4
	 cgLIARvAXAohqdObPZS+AMUtuq3dEa9WBgAjrNoso5ceFQSQVe0te57x7/6b8OCbO3
	 JmazIUlFXB1XsfRQf7KHj/HaC7Ge58OglCAsns+34naVyVwd6ZeJp8ER31u/mrtPXU
	 OWPeSkHjzuvlw==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 13/38] xfs: return -EAGAIN from xfs_reflink_allocate_cow for COW hole without transaction
Date: Wed, 19 Aug 2026 10:12:16 +1000
Message-ID: <20260819001442.1451892-14-dgc@kernel.org>
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

