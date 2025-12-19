Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE10F279329
	for <linux-xfs@vger.kernel.org>; Fri, 19 Dec 2025 02:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766112051; cv=none; b=U7fSakpS5rWjvvgvTCo32K+bxqPrietPd/qQq9v/pCvikSXnFVmoDt1VRlCtNkeM+Jf8flK+/CpZmg2xCxZoxqodeO5/mIcea00/ReJ1qnOM+XK4OSFj2SRWnI+jDyA9iZfh4C4ODy/hUUqJcKrOp0oPsTqBygP598vWm4zT8H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766112051; c=relaxed/simple;
	bh=BzBwTFQnuz40F4KAjXuAr5sWDbjSwcanhL72xzfGmnI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pvwrwbdGS3GFbGs0u6lwq6Y370p2QxqhxeBduGhAGitAXNTKrYaxoa/qo7ZiLX8TAyFZLSyqgL3dtdwEe8Bz7ww9ilZx/hLZ+03C1Ho3fp8qSX28LevI4UYiO3MogFMRmhR5hIsGzAINs+WluXg3awFfhstNKU2yD0korGWwzUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V9f+P4j8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V9f+P4j8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730EDC4CEFB;
	Fri, 19 Dec 2025 02:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766112051;
	bh=BzBwTFQnuz40F4KAjXuAr5sWDbjSwcanhL72xzfGmnI=;
	h=Date:From:To:Cc:Subject:From;
	b=V9f+P4j8Yzgvffq7/nlQT+TSBUcgXliwGGlYtXFlODJq22Ps8wrbY5BiclFcjRp+F
	 DFp4e+zNBZUImrWzKgeXAMeyrFjLp8eABzLwrhCQVxFHWzwyuh1PCbEdxwrAZ3WXr+
	 UcbB7C1wUznEcG5wuy+sm7POGEpRr8UzWj/7yDIH6JDcuFaC9+2fP/YKlsO2m1omOM
	 zoKSf/WArdFef7IHH8sSIf3VyOWNihbpwBymJ9vZ7EYAXuj/S3zWtdtGofKWjwMrx5
	 8zHqXck9MEiRtwbyp9+q5ExBRtsxf9dc9oZObFLNU52wO/6S7z7QGLSzPoZHXT1Lp6
	 jZ+QHGYru3bzg==
Date: Thu, 18 Dec 2025 18:40:50 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: mark data structures corrupt on EIO and ENODATA
Message-ID: <20251219024050.GE7725@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

I learned a few things this year: first, blk_status_to_errno can return
ENODATA for critical media errors; and second, the scrub code doesn't
mark data structures as corrupt on ENODATA or EIO.

Currently, scrub failing to capture these errors isn't all that
impactful -- the checking code will exit to userspace with EIO/ENODATA,
and xfs_scrub will log a complaint and exit with nonzero status.  Most
people treat fsck tools failing as a sign that the fs is corrupt, but
online fsck should mark the metadata bad and keep moving.

Cc: <stable@vger.kernel.org> # v4.15
Fixes: 4700d22980d459 ("xfs: create helpers to record and deal with scrub problems")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/btree.c   |    2 ++
 fs/xfs/scrub/common.c  |    4 ++++
 fs/xfs/scrub/dabtree.c |    2 ++
 3 files changed, 8 insertions(+)

diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index cd6f0ff382a7c8..c440f2eb4d1a44 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -42,6 +42,8 @@ __xchk_btree_process_error(
 		break;
 	case -EFSBADCRC:
 	case -EFSCORRUPTED:
+	case -EIO:
+	case -ENODATA:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
 		*error = 0;
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 7bfa37c99480f0..5f9be4151d722e 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -103,6 +103,8 @@ __xchk_process_error(
 		break;
 	case -EFSBADCRC:
 	case -EFSCORRUPTED:
+	case -EIO:
+	case -ENODATA:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
 		*error = 0;
@@ -177,6 +179,8 @@ __xchk_fblock_process_error(
 		break;
 	case -EFSBADCRC:
 	case -EFSCORRUPTED:
+	case -EIO:
+	case -ENODATA:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
 		*error = 0;
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 056de4819f866d..a6a5d3a75d994e 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -45,6 +45,8 @@ xchk_da_process_error(
 		break;
 	case -EFSBADCRC:
 	case -EFSCORRUPTED:
+	case -EIO:
+	case -ENODATA:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 		*error = 0;
