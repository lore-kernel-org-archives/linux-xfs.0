Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD62731F9BC;
	Mon, 27 Jul 2026 05:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785129843; cv=none; b=pMrIbfyJ2dMPC8//8zIKWkBC4qHNHexVqlfkxLklUHd7FPP4JQ89HgtCnOUg2+JAzB0dlBOuzHaPrX0Rm82k/igyjPQpt4ElceOfcAYog8hdzEhPRit0plHe4xhPxetc6CjH3Kx/g9e6fHVE4JswzUdTo2xiKMFFuf34mKnZ/wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785129843; c=relaxed/simple;
	bh=FQEHMAns1q8FWp7RW4qsCH6VA0NEyljWMPcVOEzxZqA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ajPF5HVu+1t4Bk/4YDcLsSSZTmA+iUaAqNQqmuj3o0JXs4ZSXxvRPPQ1PX5t1sZUNMTudW0eLHEpBTj8Hn6bq1rCn6ANljj8GDUAeTulzqboFhos6orjSVAnxfLJQEF4jPWQJg8c2TQ1BAykMQSZ8D/d1SUaMXfSzcnGA6MSPvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kO47T+nk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kO47T+nk"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 76C0A1F00A3A;
	Mon, 27 Jul 2026 05:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785129842;
	bh=5+pUdGrdxWqyVHAZueu0urX28U4TypzpZHfgHJaTc/I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=kO47T+nkWKzJFm7r/5BRy54ct31Z4u16wgJQcnsNFc1vEL7+3GPeJsLsgWEmS6RHd
	 u2C4WoD0AeG06U01MemNTuiiN7YmFv+Ksm/ms1cptjwa8IGjPhlaIiGijBxq+HPGum
	 lFm7O7S6zkpmJasSCssa0CV1Uzjg9OTznM27VPTPh0PPMuNYbWSS0amPdQM7RcxDme
	 i8eeMT8oNjNb5+qytTGshCS7VFh0+hrgcZe7uPINldbC6ucn6fgZH/Cpotnxl+truA
	 6OOa7wCNgLb7bP2jy44Da4/EBcGCAtNbTZJ4g2YZ4NjsWTilJiwoXA/z/RJWyAy78c
	 P27iYXTJXhpCg==
Date: Sun, 26 Jul 2026 22:24:02 -0700
Subject: [PATCH 5/6] xfs: nlink scrub must take IOLOCK before determining
 ILOCK state
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178512389273.1494795.6087235993994857365.stgit@frogsfrogsfrogs>
In-Reply-To: <178512389129.1494795.16117444961252720216.stgit@frogsfrogsfrogs>
References: <178512389129.1494795.16117444961252720216.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

