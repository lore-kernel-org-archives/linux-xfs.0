Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B98BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hAVKQM3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845BEC433C8;
	Sun, 31 Dec 2023 20:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055475;
	bh=jNLlfOpoanAifR7Tx7Ij0pSgP+JrfqhCgU1sepRjQQw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hAVKQM3OFLDB3TJjCYvSXc1jlQ/agH5BePwDCAEsqnXxaNCSCiECxDbwG0f4OTViH
	 PE0QS1b3Zla54Jr+s2j1qfTnFTgM1K5kLt2QuC4jwizmEmqj2MLFAJgXT3agl+VHZ0
	 TaPj+r0zQV1HAh+Kn7OP71qzvAmCFl2HLCojpnItL0LaEyjN+AjRzgc7ZBAI/hELOD
	 OKmFtzrlNB55Oc6CRAb/IdqoNg7kquseBd5u5nj+/8QhjGiVoHrHTnSCa4UvL2jQmk
	 kPZ49cQJXW5sa631vJPJPtw9ZQeHWmvnYtIp7VSToc5+klkkm2+ydr3I/naGIE4MPD
	 Ml9plfRH9XN/A==
Date: Sun, 31 Dec 2023 12:44:35 -0800
Subject: [PATCH 6/7] xfs: don't pick up IOLOCK during rmapbt repair scan
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404840001.1756291.15935614636959963300.stgit@frogsfrogsfrogs>
In-Reply-To: <170404839888.1756291.10910474860265774109.stgit@frogsfrogsfrogs>
References: <170404839888.1756291.10910474860265774109.stgit@frogsfrogsfrogs>
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
index 9ece83704518d..c6bb90fa43cca 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -584,23 +584,9 @@ xrep_rmap_scan_inode(
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

