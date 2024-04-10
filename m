Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA72387
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710145; cv=none; b=DBAXSq5xQXLaYvjAZcOKuqdRTJKgOnMk8PCaBqMB5rEIFFf8osWqDNujwVNFwtSDPkAgFg+HmiGJ9lwQTdyqZ+cG7kVzyM0vF52GqrV9oaawT6YNe+HhBv3uVSwGiefQbwx37H4Axc7J7dBjDl1CU3c4i2lRaOgRjayCT9TpFvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710145; c=relaxed/simple;
	bh=sigUxlnLRZoWH130xrizHBILFy++An7UJGlA3H6ESHA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rB9fNFisOjxdiXJZe3rBEX5jYHTUFvPWM5xgt6oPrCmluiHKHPYtaxRlzmBr4TcJPmOcdRLgcEAZN5p04ltTzlhZKQKh5zzXJnIfLklpRC8PXNjPyuMucB7x/xW6EoZPdxHrBvWgquTPKhsrNbMAv8APBAukpIsbvsf1qJ/JhJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PlzBL32h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PlzBL32h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA47C433F1;
	Wed, 10 Apr 2024 00:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710145;
	bh=sigUxlnLRZoWH130xrizHBILFy++An7UJGlA3H6ESHA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PlzBL32ho6YMJrHfJIlAmQn1SZMkZ+UgzLSQxI6V//rH3xehNf9GC1BOURTm0kvJr
	 06xaKb3BN7O/xx5jr7ZeiG2nSumNq/omRuHvwlOc7mllZO2sCNBVsDsBM3k7LSqE2A
	 //qXooIabOSEjy0m49sDv01k1Jm0r14DAYUK35AHsK91xEoU+QQqo+YpUf59/25RXF
	 i5dB+HDI4cL0LTxxcxX51FYhiwQDKJmf1lwKTyXmGemzr8stsW6e8gtWJ3LqcAFwq8
	 huB/O7cON9evTsLfV8nmN9uchzK9LdtJnsJlsn+SdvkrrpegwSiV/x6AtsNvfcXCdB
	 SdOuFOD6we53Q==
Date: Tue, 09 Apr 2024 17:49:04 -0700
Subject: [PATCH 6/7] xfs: don't pick up IOLOCK during rmapbt repair scan
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270968005.3631167.11200418428870190784.stgit@frogsfrogsfrogs>
In-Reply-To: <171270967888.3631167.1528096915093261854.stgit@frogsfrogsfrogs>
References: <171270967888.3631167.1528096915093261854.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we've fixed the directory operations to hold the ILOCK until
they're finished with rmapbt updates for directory shape changes, we no
longer need to take this lock when scanning directories for rmapbt
records.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/rmap_repair.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)


diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index e8e07b683eab6..25acd69614c2c 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -578,23 +578,9 @@ xrep_rmap_scan_inode(
 	struct xrep_rmap	*rr,
 	struct xfs_inode	*ip)
 {
-	unsigned int		lock_mode = 0;
+	unsigned int		lock_mode = xrep_rmap_scan_ilock(ip);
 	int			error;
 
-	/*
-	 * Directory updates (create/link/unlink/rename) drop the directory's
-	 * ILOCK before finishing any rmapbt updates associated with directory
-	 * shape changes.  For this scan to coordinate correctly with the live
-	 * update hook, we must take the only lock (i_rwsem) that is held all
-	 * the way to dir op completion.  This will get fixed by the parent
-	 * pointer patchset.
-	 */
-	if (S_ISDIR(VFS_I(ip)->i_mode)) {
-		lock_mode = XFS_IOLOCK_SHARED;
-		xfs_ilock(ip, lock_mode);
-	}
-	lock_mode |= xrep_rmap_scan_ilock(ip);
-
 	/* Check the data fork. */
 	error = xrep_rmap_scan_ifork(rr, ip, XFS_DATA_FORK);
 	if (error)

