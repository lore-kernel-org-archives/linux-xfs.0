Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5569C54905
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713225543; cv=none; b=CBuzY1zfkfzH+P2g9iDQLCO+dTJRBZWTs20FPyOJlMbJUruu9EaiZV1qh1DS5U5Q1+gLTUAuliLKATQ3/IdZsLDIsiMOIfpZrJmndkhmR9fRc5md2r6511IvWVcKtEOteB52G9rLI9o+c2S+BDUHpF5Se05pXHYiySEmslKDdU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713225543; c=relaxed/simple;
	bh=8qgS8zSfYnOtok0d3oedPPCoHi0ZjBC5pA+pvCEHvRg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QgrrSdG3kawtOCKdXv3UNReijoPUoHaPt1+0Tvac9NgN9FAgPdTB8TBYQFecm2BC8POjTC2EP9XtxQR0/A8fTuZIjPWbK1exYibOpsC/+CamlyJ8dYBn/thCZM8pqOxd8rvOTWSzdZve85rSmWBmobIjselWAxhc/gItnlx/16M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vL7gNPrb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vL7gNPrb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC1FC113CC;
	Mon, 15 Apr 2024 23:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713225542;
	bh=8qgS8zSfYnOtok0d3oedPPCoHi0ZjBC5pA+pvCEHvRg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vL7gNPrbaIrvuggnzuU5xvbWD3GnHreK48ENNmm3oXCVSEqV6mbMC1jGeVtqoCYc2
	 RDYjC2B5qBfJAw2F5Oin/eRfCjIU0W832J4D0Qed1adjKLBs7FZHyar12h4fLBU/T1
	 6wZnk/YbxSq3SpCBElA+P0AGuMZaeloAz/zA/ZIY5Eie+RzN+B3S00YTJRSFJQGcp8
	 BZ2oPOC7lLj5cLnMQwID2r9ewDIyITmVOFUveVWG5wwuT7FKxHQBUmfobUJSe6wUet
	 owdyzKLZxv92gf4gIt2lFy0sATd1U+AEpo34Z4z2OGo4zYqpOPHn2BWfYOVfDKUrum
	 RjKLbzgeTwRBQ==
Date: Mon, 15 Apr 2024 16:59:02 -0700
Subject: [PATCH 6/7] xfs: don't pick up IOLOCK during rmapbt repair scan
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, allison.henderson@oracle.com,
 catherine.hoang@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <171322386613.92087.11496615490291969574.stgit@frogsfrogsfrogs>
In-Reply-To: <171322386495.92087.3714112630678704273.stgit@frogsfrogsfrogs>
References: <171322386495.92087.3714112630678704273.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/rmap_repair.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)


diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index e8e07b683eab..25acd69614c2 100644
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

