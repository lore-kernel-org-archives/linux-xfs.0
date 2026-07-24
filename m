Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA953859F0;
	Fri, 24 Jul 2026 06:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784874094; cv=none; b=X20j3IdsYpL8Cux2vrXPKcseSDksqt7nqsBUfa336vjdWyqVBgURdCq4sakp5iHg5r6Bv/rimGCNSezxyYC6JEIU3l3bSQIysdApq+XXJQXMKJ5kHHIb6t6IUcEGeOA+sVw9pNDHLRP0RhfoN+80GJNnYbFudQ/Jgy+X19SRN5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784874094; c=relaxed/simple;
	bh=0N6e8IVwr/od2eNxvuiu4ET8E0BoW/s2UcIkjBwMyDE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HbqUQU7bR8EY4ixEGkC/b30MZRFkF6n/uU/yfbucsu5lc2i9vvrv88KqibAM0CHnUdUErnNggwawCkzCLpGzvac912KRjZ6iErKyWgRq2GBQpDYBB9NR1TWGmb2/B79z4YF3iuiuyyRa5AL0JL1rkt7rGgSv8VTgobLLjc7o254=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dT0t6Tiq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dT0t6Tiq"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 460D71F000E9;
	Fri, 24 Jul 2026 06:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784874092;
	bh=16MOaQIJa4Y6KcCfoNXUUp95GYEskOxM1WbBbrywGtE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=dT0t6TiqqWXlyiy3MuJeJq3/Egx89GKTF7C1CeOVHF7cI5Y46kiEo7B1lFy83K/85
	 Lqm20mhhCKlBi0zLBC15VWwFhAyFBjgep7rac3jkDFQfexXNuEDBATyu47/XVDJrjm
	 WtEBGnHQoevtjDpkelNYCVMb5kRCmJfCRGubP3UhUzHm2N632ZKiMo/8CTR0gaG/OP
	 kNqoqmCv5pyg3iQXmrldQFwkyDxyJDSnrmnEkrnWAILOOfMeFuDyFczdduwQvJAfsV
	 +N9X9ad55dU7SHIA3uX1nHEtHcEhhRyBePs00r+wh5Dkpt44oQ6xvxn4RVGDIN4eMz
	 KV6cdCjkELHJA==
Date: Thu, 23 Jul 2026 23:21:31 -0700
Subject: [PATCH 2/6] xfs: don't double-lock when deleting a self-referential
 directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178487405420.3442778.11716685055970529363.stgit@frogsfrogsfrogs>
In-Reply-To: <178487405343.3442778.10258954219942220821.stgit@frogsfrogsfrogs>
References: <178487405343.3442778.10258954219942220821.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM notices that the dirtree scrubber can detect a directory that
refers to itself.  In this case, it's not correct for the directory tree
repair code to try to iolock/ilock both sc->ip and dp, because they're
the same inode.  Fix this by detecting that corner case and handling it
appropriately.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 3f31406aef493b ("xfs: fix corruptions in the directory tree")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/dirtree_repair.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/dirtree_repair.c b/fs/xfs/scrub/dirtree_repair.c
index 1c0d7ea4a5be6a..bbf6acf6fd400c 100644
--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -349,6 +349,8 @@ xrep_dirtree_unlink_iolock(
 
 	ASSERT(sc->ilock_flags & XFS_IOLOCK_EXCL);
 
+	if (sc->ip == dp)
+		return 0;
 	if (xfs_ilock_nowait(dp, XFS_IOLOCK_EXCL))
 		return 0;
 
@@ -400,8 +402,18 @@ xrep_dirtree_unlink(
 	 * directory code can handle a reservationless update.
 	 */
 	resblks = xfs_remove_space_res(mp, step->name_len);
-	error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, sc->ip,
-			&resblks, &sc->tp, &dontcare);
+	if (sc->ip == dp) {
+again:
+		error = xfs_trans_alloc_inode(dp, &M_RES(mp)->tr_remove,
+				resblks, 0, false, &sc->tp);
+		if ((error == -ENOSPC || error == -EDQUOT) && resblks > 0) {
+			resblks = 0;
+			goto again;
+		}
+	} else {
+		error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, sc->ip,
+				&resblks, &sc->tp, &dontcare);
+	}
 	if (error)
 		goto out_iolock;
 
@@ -489,9 +501,11 @@ xrep_dirtree_unlink(
 	xchk_trans_cancel(sc);
 out_ilock:
 	xfs_iunlock(sc->ip, XFS_ILOCK_EXCL);
-	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	if (dp != sc->ip)
+		xfs_iunlock(dp, XFS_ILOCK_EXCL);
 out_iolock:
-	xfs_iunlock(dp, XFS_IOLOCK_EXCL);
+	if (dp != sc->ip)
+		xfs_iunlock(dp, XFS_IOLOCK_EXCL);
 	return error;
 }
 

