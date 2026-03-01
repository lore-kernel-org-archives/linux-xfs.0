Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE1D238171;
	Sun,  1 Mar 2026 01:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328203; cv=none; b=lhFIy4nrcMWXDZcQHY09+X4xclrou3GeAHXGiE12Ne5Uc1aXMhKEwyZSVpYQC7aV3PsN3zt2GFyCdhyF4SNuRh3KruXD1dRV9QzIefee6GVhaAVPaUUZIDoaEiU8lBAgZM4BmB2EvR4wZzzdmmkR4CLGpO2KRqEsFrVpeFzg3wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328203; c=relaxed/simple;
	bh=lztf7gbi9rIi7D96Gsi+OIv5d56OJVcQ8bcksuUHnEI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=svkFcg4jIuuraDpjDO4f4+S0Ye8ih65DRant8/Fwvt+yN3IkxRasNp9jyoXPfbWGFMZfqmIVvbge7ys09SiRi6xgbJ0awYQBG4KUPvr9wE28Gm+y3chzL/sCQ4goliHvlmVcnCY/Nf+Bywe9JJAQsX7l56rlW3kqFK1d9kUFM8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vwd7/8mc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vwd7/8mc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F9CC19421;
	Sun,  1 Mar 2026 01:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328203;
	bh=lztf7gbi9rIi7D96Gsi+OIv5d56OJVcQ8bcksuUHnEI=;
	h=From:To:Cc:Subject:Date:From;
	b=Vwd7/8mcuWhf51kzuv/gMzrBLwoL8fF1r0gMRqbXibxoaQQsP67fwqTmHE6i8iqGb
	 eKU3FqfApIIpuL6eN5WwfwNB1iI2aN0M+3CzNJ0aRs5DO70STyt4EcfxI7fhHDM6G/
	 OadEzrxI10Qu8qg7WDNSg6v11ldNEtvWT0p3wa4MMrQ8ODqcKgyk02ujH7Vm4Ta/VE
	 JH8jaMhaB/4O4P95xgFckDz7fwekNTRlnmW9MWZVPNxmwZIdxatGuDn9Q6r7sLUkCU
	 0xvfLJ0V/0me5B1t/kwWGIih0Whw1CWwaR60N1JsTlmoMEd0NtzH43ONz7iIDDnCwU
	 MfQ3IbFZROm6w==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	djwong@kernel.org
Cc: r772577952@gmail.com,
	Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: FAILED: Patch "xfs: only call xf{array,blob}_destroy if we have a valid pointer" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:23:21 -0500
Message-ID: <20260301012321.1680046-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 6.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From ba408d299a3bb3c5309f40c5326e4fb83ead4247 Mon Sep 17 00:00:00 2001
From: "Darrick J. Wong" <djwong@kernel.org>
Date: Fri, 23 Jan 2026 09:27:37 -0800
Subject: [PATCH] xfs: only call xf{array,blob}_destroy if we have a valid
 pointer

Only call the xfarray and xfblob destructor if we have a valid pointer,
and be sure to null out that pointer afterwards.  Note that this patch
fixes a large number of commits, most of which were merged between 6.9
and 6.10.

Cc: r772577952@gmail.com
Cc: <stable@vger.kernel.org> # v6.12
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Jiaming Zhang <r772577952@gmail.com>
---
 fs/xfs/scrub/agheader_repair.c | 8 ++++++--
 fs/xfs/scrub/attr_repair.c     | 6 ++++--
 fs/xfs/scrub/dir_repair.c      | 8 ++++++--
 fs/xfs/scrub/dirtree.c         | 8 ++++++--
 fs/xfs/scrub/nlinks.c          | 3 ++-
 5 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index d8e3c51a41b1a..15d58eedb3873 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -837,8 +837,12 @@ xrep_agi_buf_cleanup(
 {
 	struct xrep_agi	*ragi = buf;
 
-	xfarray_destroy(ragi->iunlink_prev);
-	xfarray_destroy(ragi->iunlink_next);
+	if (ragi->iunlink_prev)
+		xfarray_destroy(ragi->iunlink_prev);
+	ragi->iunlink_prev = NULL;
+	if (ragi->iunlink_next)
+		xfarray_destroy(ragi->iunlink_next);
+	ragi->iunlink_next = NULL;
 	xagino_bitmap_destroy(&ragi->iunlink_bmp);
 }
 
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index f9191eae13eea..a924b467a8447 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -1516,8 +1516,10 @@ xrep_xattr_teardown(
 		xfblob_destroy(rx->pptr_names);
 	if (rx->pptr_recs)
 		xfarray_destroy(rx->pptr_recs);
-	xfblob_destroy(rx->xattr_blobs);
-	xfarray_destroy(rx->xattr_records);
+	if (rx->xattr_blobs)
+		xfblob_destroy(rx->xattr_blobs);
+	if (rx->xattr_records)
+		xfarray_destroy(rx->xattr_records);
 	mutex_destroy(&rx->lock);
 	kfree(rx);
 }
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index dbfcef6fb7da6..f105e49f654bd 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -172,8 +172,12 @@ xrep_dir_teardown(
 	struct xrep_dir		*rd = sc->buf;
 
 	xrep_findparent_scan_teardown(&rd->pscan);
-	xfblob_destroy(rd->dir_names);
-	xfarray_destroy(rd->dir_entries);
+	if (rd->dir_names)
+		xfblob_destroy(rd->dir_names);
+	rd->dir_names = NULL;
+	if (rd->dir_entries)
+		xfarray_destroy(rd->dir_entries);
+	rd->dir_names = NULL;
 }
 
 /* Set up for a directory repair. */
diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index e484f8a0886cd..e95dc74f11456 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -81,8 +81,12 @@ xchk_dirtree_buf_cleanup(
 		kfree(path);
 	}
 
-	xfblob_destroy(dl->path_names);
-	xfarray_destroy(dl->path_steps);
+	if (dl->path_names)
+		xfblob_destroy(dl->path_names);
+	dl->path_names = NULL;
+	if (dl->path_steps)
+		xfarray_destroy(dl->path_steps);
+	dl->path_steps = NULL;
 	mutex_destroy(&dl->lock);
 }
 
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index 46488aff908cc..e80fe7395d788 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -971,7 +971,8 @@ xchk_nlinks_teardown_scan(
 
 	xfs_dir_hook_del(xnc->sc->mp, &xnc->dhook);
 
-	xfarray_destroy(xnc->nlinks);
+	if (xnc->nlinks)
+		xfarray_destroy(xnc->nlinks);
 	xnc->nlinks = NULL;
 
 	xchk_iscan_teardown(&xnc->collect_iscan);
-- 
2.51.0




