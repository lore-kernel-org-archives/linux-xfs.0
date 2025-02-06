Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6751A9B3F
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881118; cv=none; b=meU0ha8MHk5h854chuuEAgP9wb++yhLgyGHsGGwoa9ubNEAkwKykZKrM4CYXv/jtINLy5t5SMxKe7A/UQ9dgkEe9Hp85X5LXlmlK8ZdcuugD+AZHjf5HzjyRJqNeNs3WRVmbf45288zKbPTEYDPgpbjviXaL2IY9d04cDjPkJJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881118; c=relaxed/simple;
	bh=zYmmiPT5QI6o2Mi+rYGvf2DB2RWXoDFri3rtt13psLU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jZHD4+ePICHpSt7mVWOURUDvDCO/ndt1Zq9wyMll4Tt8z43KmY+7c8ewQWc3L7rFgi6Jeuy1DMAiEgKN+HE1pUJiGy9KV6aGGXxaCAEnKqHstXhVKaFAoDieUL4hi2c3XT8oq46On+qvq8PSBTjkmV2w4C+wrqjrZx5ukbVeaOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QWvOn45B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QWvOn45B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47E3C4CEDD;
	Thu,  6 Feb 2025 22:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881118;
	bh=zYmmiPT5QI6o2Mi+rYGvf2DB2RWXoDFri3rtt13psLU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QWvOn45BdtJ993mwH+ldVflJruFCydPAAGzmgniM18hxKwmTnf0how2z2Utj+K36s
	 qBPo97oSwKBn6TcsaWegElBkO+edhOoED81HqmE74dPrtTUWlw7cGo0NVKL8pIQjjD
	 9pFjb8lsak55Q1fGQrtCqZ8nVNK8JpJoMAph0l/0HECwpD5dN/WjZYrl+fKL2Cw7ud
	 7N04akksKgQkfgDYYU52Fp5sW9e8DefwaUjy290ZcMmQddCUATxYcQuXhtNSgVgtSz
	 Wn0RncPLXv5kWV3Y2722ozl9Og+vpNKr2Gp8wNhQi1aQrhJRinXYX+3Iq816T37gWY
	 Gp/X1KC9ft0dw==
Date: Thu, 06 Feb 2025 14:31:57 -0800
Subject: [PATCH 05/17] xfs_scrub: don't report data loss in unlinked inodes
 twice
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888086136.2738568.12499263697186080933.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If parent pointers are enabled, report_ioerr_fsmap will report lost file
data and xattrs for all files, having used the parent pointer ioctls to
generate the path of the lost file.  For unlinked files, the path lookup
will fail, but we'll report the inumber of the file that lost data.

Therefore, we don't need to do a separate scan of the unlinked inodes
in report_all_media_errors after doing the fsmap scan.

Cc: <linux-xfs@vger.kernel.org> # v6.10.0
Fixes: 9b5d1349ca5fb1 ("xfs_scrub: use parent pointers to report lost file data")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase6.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index fc63f5aad0bd7b..2695e645004bf1 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -569,12 +569,12 @@ report_all_media_errors(
 	 * Scan the directory tree to get file paths if we didn't already use
 	 * directory parent pointers to report the loss.
 	 */
-	if (!can_use_pptrs(ctx)) {
-		ret = scan_fs_tree(ctx, report_dir_loss, report_dirent_loss,
-				vs);
-		if (ret)
-			return ret;
-	}
+	if (can_use_pptrs(ctx))
+		return 0;
+
+	ret = scan_fs_tree(ctx, report_dir_loss, report_dirent_loss, vs);
+	if (ret)
+		return ret;
 
 	/* Scan for unlinked files. */
 	return scrub_scan_all_inodes(ctx, report_inode_loss, 0, vs);

