Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE567322C88;
	Wed,  9 Sep 2026 06:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788933970; cv=none; b=Ay/GcEd+3J4RLKo78M+CfRaTcPZe+sLqme3Wbi8rGV69itZzcM5ERuXAi/PyW+MCn9sY+zs907eMXKW/8hLn1/126Ansh4Hgq0Mz/CqGPxJzPS6lQW+M5myY+hxLU5/HsNmGGZkiPNiG8efkYM5YyzvUFm1JFgSMuPV+XgXM3b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788933970; c=relaxed/simple;
	bh=aL8rpkoEU9fOUiyqKYzqoHGlaRSiFoW2zdGgPdLQCpA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OpfhpWo/crQ+oQhUcx9qhjF4vbbaR9k1cUR83lXllRmb9IIiP5Dj+oWPR4MmNW5YeWBjUT4RCejrhCgHyIukvlWcumBQvu7u9ev7Nh5rzSokbgZHR0YcJOnx0VsAzwGGiMbg2wHfjxIHSLHIhxpkbngkKiOfeweYxCjn6ngKpd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EYq4lNys; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EYq4lNys"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C6EA41F00A3A;
	Wed,  9 Sep 2026 06:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788933968;
	bh=w8Ac5wV+HERXZzBn8+QrFf0k0XNqyegEFbjjUICntXo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=EYq4lNyslaTHDN7mrG77hACRwq0swBvsjMJ6zcc40r2Qyius5LCD2wFIJzdW6Svx6
	 b6xpybLV5dujC6eA7YQEOW94nWeez9Pskpv3BwG2WV506zcn8klHwZ/8rk+7X9FQea
	 V0l41fIZlzdYXJQQYtlUROCekfP7ALc4shtCKDd2XeWfQjrNgG95gedcy8WqFOFIot
	 6CmL9aaDDb+sLTekP+GSqGtfzCxvUriScktNY/aLtjNfE7sAK81Kysnwi0UP5nP8Lf
	 iAto+oz6eMabbCHyINvCsy4U2xdNeRQ0M8tmVhJkSJlI9Ki2OMo5viZEjoftqru8o4
	 dn4d5FfJD38UQ==
Date: Tue, 08 Sep 2026 23:06:08 -0700
Subject: [PATCH 7/7] xfs: advance the findparent inode scan cursor while
 holding ILOCK
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178892936771.4057962.16778990010632981835.stgit@frogsfrogsfrogs>
In-Reply-To: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs>
References: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM pointed out a race condition in xrep_findparent_scan -- the
directory live update hook holds the directory ILOCK when it calls the
xchk_iscan_want_live_update predicate to figure out if it needs to
remember the live update, but xrep_findparent_scan drops the directory
ILOCK before advancing the cursor.  Therefore, it's possible for a live
update to check the scan cursor after the scan drops the ILOCK but
before the scan updates its cursor.  If this happens, we'll fail to
record the live update.  Fix this by moving the cursor update logic
inside xrep_findparent_walk_directory.

Note that for non-directories it's ok to advance the cursor without
holding any ILOCK because the findparent scan only cares about directory
parents, not the children.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: a07b45576264e7 ("xfs: scan the filesystem to repair a directory dotdot entry")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/findparent.c |   54 ++++++++++++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/scrub/findparent.c b/fs/xfs/scrub/findparent.c
index 04b6b96b0a30ed..eab3ac2704befe 100644
--- a/fs/xfs/scrub/findparent.c
+++ b/fs/xfs/scrub/findparent.c
@@ -139,32 +139,52 @@ xrep_findparent_dirent(
 	return 0;
 }
 
-/*
- * If this is a directory, walk the dirents looking for any that point to the
- * scrub target inode.
- */
-STATIC int
-xrep_findparent_walk_directory(
-	struct xrep_findparent_info	*fpi)
+static inline bool
+xrep_findparent_want_scan_file(
+	const struct xrep_findparent_info	*fpi)
 {
-	struct xfs_scrub		*sc = fpi->sc;
-	struct xfs_inode		*dp = fpi->dp;
-	unsigned int			lock_mode;
-	int				error = 0;
+	const struct xfs_scrub			*sc = fpi->sc;
+	const struct xfs_inode			*dp = fpi->dp;
+
+	/* Only directories can be parents */
+	if (!S_ISDIR(VFS_IC(dp)->i_mode))
+		return false;
 
 	/*
 	 * The inode being scanned cannot be its own parent, nor can any
 	 * temporary directory we created to stage this repair.
 	 */
 	if (dp == sc->ip || dp == sc->tempip)
-		return 0;
+		return false;
 
 	/*
 	 * Similarly, temporary files created to stage a repair cannot be the
 	 * parent of this inode.
 	 */
 	if (xrep_is_tempfile(dp))
+		return false;
+
+	return true;
+}
+
+/*
+ * If this is a directory, walk the dirents looking for any that point to the
+ * scrub target inode.
+ */
+STATIC int
+xrep_findparent_walk_file(
+	struct xrep_findparent_info	*fpi)
+{
+	struct xfs_scrub		*sc = fpi->sc;
+	struct xfs_inode		*dp = fpi->dp;
+	unsigned int			lock_mode;
+	int				error = 0;
+
+	if (!xrep_findparent_want_scan_file(fpi)) {
+		if (fpi->parent_scan)
+			xchk_iscan_mark_visited(&fpi->parent_scan->iscan, dp);
 		return 0;
+	}
 
 	/*
 	 * Scan the directory to see if there it contains an entry pointing to
@@ -201,6 +221,8 @@ xrep_findparent_walk_directory(
 		goto out_unlock;
 
 out_unlock:
+	if (fpi->parent_scan)
+		xchk_iscan_mark_visited(&fpi->parent_scan->iscan, dp);
 	xfs_iunlock(dp, lock_mode);
 	return error;
 }
@@ -308,11 +330,7 @@ xrep_findparent_scan(
 	ASSERT(S_ISDIR(VFS_IC(sc->ip)->i_mode));
 
 	while ((ret = xchk_iscan_iter(&pscan->iscan, &fpi.dp)) == 1) {
-		if (S_ISDIR(VFS_I(fpi.dp)->i_mode))
-			ret = xrep_findparent_walk_directory(&fpi);
-		else
-			ret = 0;
-		xchk_iscan_mark_visited(&pscan->iscan, fpi.dp);
+		ret = xrep_findparent_walk_file(&fpi);
 		xchk_irele(sc, fpi.dp);
 		if (ret)
 			break;
@@ -401,7 +419,7 @@ xrep_findparent_confirm(
 		goto out_rele;
 	}
 
-	error = xrep_findparent_walk_directory(&fpi);
+	error = xrep_findparent_walk_file(&fpi);
 	if (error)
 		goto out_rele;
 

