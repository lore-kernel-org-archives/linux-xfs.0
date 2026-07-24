Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DE6377AB6;
	Fri, 24 Jul 2026 06:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784874140; cv=none; b=XPehpKmc9B+QOTQr1A7g8PliBZ6yGgDcNpDcyyv5SPS4OgdBS2DKF8UvGfQYZnXznTBKoWNgULWrMVyocaih1/9yrEA43P455PPdXSZBO+wMcxoCRy6gcT/9uuvKooFHXi+hYjRx8ynIXOzFl4Ig0I9muXFPUEPBnGuZZd00Z3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784874140; c=relaxed/simple;
	bh=OxozelXBC3LqvAZ0sS22xDjknhnFWJcsFT3doqUaKjI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XoFPyZuosliJpPiL+xuZLQa6YoNYhoYqMC+q2Es21ogcpYRdy83WjUuwM8aM+LGOR88RN88QhH+s46gcBNzb4Zysw6Y/qCan3NZAhOCTfOg8jlXkoWpN1LaKCqa54dqzQOebF+tk9nKC+Bvp5yZxGv0NonS7/72b/XQ0Zeytu5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BSfuGqZC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BSfuGqZC"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0CB631F000E9;
	Fri, 24 Jul 2026 06:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784874139;
	bh=Yfo+eCjeCul4cSHTP6sz9TrlM8cSbV+tm9cm3xS5bZg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=BSfuGqZCtkcsxUoW5wWJnZPqaoB/08wvm53G8cJwxrpWP8uVwxvOoo6B2K0GlXTja
	 6p1d01268crPVmNtktEw41SBSvbSGYV9DMyKUyk37OvJljk2ZrTijyyxc+w5FFZgST
	 FpGvBGfCVBIixLvPee7rvbZZTJQlJYSwqjXwev0pdzKGdBr+vx8Cdf5i4Sm73/gvkd
	 uUuvcz/91x5kJG4Md/f8nkOxpdcK4zUWX8qZxxu1lQZwqIr9Hp3uLo624kYiFzqI6H
	 PiIejWO5C2a0hvws6lXl6ysM8MXdQnz9kScViPuee2KCXNgsZsG9ZypsZzFRDowEJl
	 +Jo/hBX2s+DEQ==
Date: Thu, 23 Jul 2026 23:22:18 -0700
Subject: [PATCH 5/6] xfs: nlink scrub must take IOLOCK before determining
 ILOCK state
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178487405483.3442778.17939171750881157462.stgit@frogsfrogsfrogs>
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

In xchk_nlinks_ilock_dir, take the IOLOCK before accessing internal
inode state to figure out if we need to take ILOCK shared or exclusive.
That way we can't race with directory updates.  LOLLM pointed out that
the code was initially correct w.r.t. the IOLOCK, but then I broke it.

Cc: <stable@vger.kernel.org> # v6.18
Fixes: f477af0cfa0487 ("xfs: fix locking in xchk_nlinks_collect_dir")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/nlinks.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index 355ab6de23eaba..bcedb8c3e4e608 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -382,6 +382,12 @@ xchk_nlinks_ilock_dir(
 {
 	uint			lock_mode = XFS_ILOCK_SHARED;
 
+	/*
+	 * Take the IOLOCK so that other threads cannot start a directory
+	 * update while we're scanning.
+	 */
+	xfs_ilock(ip, XFS_IOLOCK_SHARED);
+
 	/*
 	 * We're going to scan the directory entries, so we must be ready to
 	 * pull the data fork mappings into memory if they aren't already.
@@ -397,13 +403,8 @@ xchk_nlinks_ilock_dir(
 	    xfs_need_iread_extents(&ip->i_af))
 		lock_mode = XFS_ILOCK_EXCL;
 
-	/*
-	 * Take the IOLOCK so that other threads cannot start a directory
-	 * update while we're scanning.
-	 */
-	lock_mode |= XFS_IOLOCK_SHARED;
 	xfs_ilock(ip, lock_mode);
-	return lock_mode;
+	return lock_mode | XFS_IOLOCK_SHARED;
 }
 
 /* Walk a directory to bump the observed link counts of the children. */

