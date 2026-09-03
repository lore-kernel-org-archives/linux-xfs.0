Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC2E311597;
	Thu,  3 Sep 2026 05:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788414698; cv=none; b=c16gtq5dk2JXz3ePBW5TJV1rh1Ib8vdCdSxnkHFtXvCo85o9JC1h41lS/aG4FAxIbXELE3toHbdfk5Rwv303Qg4tQWudxkIccf+UASfk0ksGkyJzgxmcNpCLRSGF00DleSFMA3jSS53bu6xMJMb1GrEXINoSu3mBIhba/dkwBdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788414698; c=relaxed/simple;
	bh=IazXLahLAg9gRmw0EuQ9gHSAUoq4R1ti2p4DYE4fgJc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WgepZRE1+JkUBYXkz5Se+5f9lcFIhligwShE/7HqvDd5WzS6yHxTSH0/axi+cQcD/BNGRaCJ7dhV7/xw8episa43JRc882BmCXtkTaNIIZxlu7p8qCkn4JB9A+ZTjTgF2sCla2hi4tHq6Rm2A0oI5QTE62YWeb8zxrs5HsiZoEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZrxuUe//; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZrxuUe//"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1E1821F000E9;
	Thu,  3 Sep 2026 05:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788414697;
	bh=nZZOvBZp5fl8ZBIRPFIh3H/kDFfkKAA84AGiQrqXZtw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=ZrxuUe///0hMy+UWDZx4x6+1Ur12w+2FCunEG2NJq7xRqJ6+7GVEc1UeUB/l6MMbE
	 BlFQXRDmw5NzuHcecnO+Mh7WSJeJq+F46w2PcaLZVC10GZnRWe3Q3GMHfELE8C3muq
	 jwssS+sFYNIgg6S6IyfEHdcA7Vu7bhX6QV7Cojz+mD6hGI6nFckdcI8+kc6wVHqZzd
	 pBdtZrJlw5s/fh9AMp8Sr1kDZPA1TCb+njRAUtiRNnP38BIVXXeDiatFOxSIx3ALKH
	 7UFeWK5TYsfRP3pm5whF/Ku7oBr+qQOxvemj0pBoQDZDmWvLP4OLbx3hgAbqwPTZrn
	 Vh/RK6YgKBDhQ==
Date: Wed, 02 Sep 2026 22:51:36 -0700
Subject: [PATCH 3/6] xfs: strengthen the "is cow staging" helpers in scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178840969892.484660.6073163246909319479.stgit@frogsfrogsfrogs>
In-Reply-To: <178840969793.484660.11718284266382755759.stgit@frogsfrogsfrogs>
References: <178840969793.484660.11718284266382755759.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM pointed out a bug in both of the refcount scrub predicates that
determine if a range of blocks is marked as CoW staging in the btree.
While it compares blockcount < len, this isn't enough to determine that
the CoW staging record is at least as large as the range passed into the
helper.  Fix both of them.

Cc: <stable@vger.kernel.org> # v4.16
Fixes: f6d5fc21fdc713 ("xfs: cross-reference refcount btree during scrub")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/refcount.c   |    6 +++++-
 fs/xfs/scrub/rtrefcount.c |    6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index f2addaf13c58e4..f8c51d8fbb3da5 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -581,8 +581,12 @@ xchk_xref_is_cow_staging(
 	if (rc.rc_domain != XFS_REFC_DOMAIN_COW)
 		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
 
+	/* Can't start after bno */
+	if (rc.rc_startblock > agbno)
+		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
+
 	/* Must be at least as long as what was passed in */
-	if (rc.rc_blockcount < len)
+	if (rc.rc_startblock + rc.rc_blockcount < agbno + len)
 		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
 }
 
diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
index a024d50cf9d20f..652d6b78b7a05b 100644
--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -609,8 +609,12 @@ xchk_xref_is_rt_cow_staging(
 	if (rc.rc_domain != XFS_REFC_DOMAIN_COW)
 		xchk_btree_xref_set_corrupt(sc, sc->sr.refc_cur, 0);
 
+	/* Can't start after bno */
+	if (rc.rc_startblock > bno)
+		xchk_btree_xref_set_corrupt(sc, sc->sr.refc_cur, 0);
+
 	/* Must be at least as long as what was passed in */
-	if (rc.rc_blockcount < len)
+	if (rc.rc_startblock + rc.rc_blockcount < bno + len)
 		xchk_btree_xref_set_corrupt(sc, sc->sr.refc_cur, 0);
 }
 

