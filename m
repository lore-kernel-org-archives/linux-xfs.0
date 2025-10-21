Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FFF34D900;
	Tue, 21 Oct 2025 18:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761071444; cv=none; b=jXT3YhycSlyM1+gBXsnHvOjBVJqWaIIEzoMM8D/VwXbRaUxjE9oLecFYJ5DLtFIxn83cKjj4874V7r5N7kpLmWDc1G3dstfWUTflRuR2o3oo4qtqoERWcN60abJ2P4Y+vvNM1q/qqpR9z0fAwa8YIGpInXg9BFZAPq9fu/AefgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761071444; c=relaxed/simple;
	bh=/EIcNMBhb5dJk+caRPr1kpY9q7Ww1OV4NkrNd81Kf5U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tAFU1O+lPklKPVauUVwEweaAVi6njA7CU6EkvmuO5kY119ZdTyiEts4gmBHiSy0fQsVIaQBxF5aB69R1Qks8rYKDUoWBR73snx9K4NB7pZdKMC9BKB0MbPnkBJpC7SD35i+znzbLHSua80tGW2C9lVoKWlYjzmajiW1INjHhOBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iXRspHdo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iXRspHdo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6348C4CEF1;
	Tue, 21 Oct 2025 18:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761071443;
	bh=/EIcNMBhb5dJk+caRPr1kpY9q7Ww1OV4NkrNd81Kf5U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iXRspHdoEfsjtU5chFhAwW5hmlJwcD/46s4vXRRbsWy4Z1RdUtoQ/WdAtaKuHYXo+
	 qWdfgylHknmA3hVgpb2TOpwqD5rkAwNOau7ODoghoKFOSfJc8Pd+C/aufgpNeISTpk
	 JCQkzunmNcBt+TGzKo3rqvPStzMBoWeuVw0dBucUyAx1TV+E+rL+9ijkxCbjNj11IE
	 yiTBrwNrNHkOXGdTBlR7uDNqi/3BI3yYYiJwL7pHvFSzTw6ijY1ug97HKMZdwBuOFK
	 HL8iTT+/2q9BDEUeNvXkf4IZ8z2y/iI2Mqr8vXQ5h92oCmAFlXJsS16kWz+Otps6oZ
	 5/0z2/50k7HUQ==
Date: Tue, 21 Oct 2025 11:30:43 -0700
Subject: [PATCH 4/4] xfs: fix locking in xchk_nlinks_collect_dir
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <176107134066.4152072.17161623808506836702.stgit@frogsfrogsfrogs>
In-Reply-To: <176107133959.4152072.11526530466991879614.stgit@frogsfrogsfrogs>
References: <176107133959.4152072.11526530466991879614.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

On a filesystem with parent pointers, xchk_nlinks_collect_dir walks both
the directory entries (data fork) and the parent pointers (attr fork) to
determine the correct link count.  Unfortunately I forgot to update the
lock mode logic to handle the case of a directory whose attr fork is in
btree format and has not yet been loaded *and* whose data fork doesn't
need loading.

This leads to a bunch of assertions from xfs/286 in xfs_iread_extents
because we only took ILOCK_SHARED, not ILOCK_EXCL.  You'd need the rare
happenstance of a directory with a large number of non-pptr extended
attributes set and enough memory pressure to cause the directory to be
evicted and partially reloaded from disk.

I /think/ this only started in 6.18-rc1 because I've started seeing OOM
errors with the maple tree slab using 70% of memory, and this didn't
happen in 6.17.  Yay dynamic systems!

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 77ede5f44b0d86 ("xfs: walk directory parent pointers to determine backref count")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/nlinks.c |   34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index 26721fab5cab42..091c79e432e592 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -376,6 +376,36 @@ xchk_nlinks_collect_pptr(
 	return error;
 }
 
+static uint
+xchk_nlinks_ilock_dir(
+	struct xfs_inode	*ip)
+{
+	uint			lock_mode = XFS_ILOCK_SHARED;
+
+	/*
+	 * We're going to scan the directory entries, so we must be ready to
+	 * pull the data fork mappings into memory if they aren't already.
+	 */
+	if (xfs_need_iread_extents(&ip->i_df))
+		lock_mode = XFS_ILOCK_EXCL;
+
+	/*
+	 * We're going to scan the parent pointers, so we must be ready to
+	 * pull the attr fork mappings into memory if they aren't already.
+	 */
+	if (xfs_has_parent(ip->i_mount) && xfs_inode_has_attr_fork(ip) &&
+	    xfs_need_iread_extents(&ip->i_af))
+		lock_mode = XFS_ILOCK_EXCL;
+
+	/*
+	 * Take the IOLOCK so that other threads cannot start a directory
+	 * update while we're scanning.
+	 */
+	lock_mode |= XFS_IOLOCK_SHARED;
+	xfs_ilock(ip, lock_mode);
+	return lock_mode;
+}
+
 /* Walk a directory to bump the observed link counts of the children. */
 STATIC int
 xchk_nlinks_collect_dir(
@@ -394,8 +424,7 @@ xchk_nlinks_collect_dir(
 		return 0;
 
 	/* Prevent anyone from changing this directory while we walk it. */
-	xfs_ilock(dp, XFS_IOLOCK_SHARED);
-	lock_mode = xfs_ilock_data_map_shared(dp);
+	lock_mode = xchk_nlinks_ilock_dir(dp);
 
 	/*
 	 * The dotdot entry of an unlinked directory still points to the last
@@ -452,7 +481,6 @@ xchk_nlinks_collect_dir(
 	xchk_iscan_abort(&xnc->collect_iscan);
 out_unlock:
 	xfs_iunlock(dp, lock_mode);
-	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
 	return error;
 }
 

