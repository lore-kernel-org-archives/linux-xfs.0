Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1CD1EF091;
	Sun,  1 Mar 2026 01:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328161; cv=none; b=UShHJJd28ZgbMINnEX582/WQ5aA3IMdhjtWj8hQ1sVeRGfZ1p/8HHQcy3/eWE3gLdAW5MbRQxuf6nuOW8/9faZabFnnKLitXxwxXLbCOZLhl6bU/9DP5sl9/X0pJO3pPuVegfpgXkbKy/8OJDmYTVFhVaU6bxh5Z7uREqZhftvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328161; c=relaxed/simple;
	bh=hZ1ZE3nxKnw4QpPrjuUiZXODr1RhfChLJEDdnU3x4o0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Vb/fQajYFNDVok6oV6mAFoRKsHHu/MZIONXY8+JDBPonp1TWMiPGC6PAjfefParGo8tTdggUwR9p8KjYyv67an8FO+kSwJE9e3VsDWqurAETr8PSFpGEreAmaaA/BU+wfy1bud7nKDJVuMwgj0Rt7On7FcokcdiasCNxBhAQ8vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WWnK6PDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WWnK6PDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54AFC19421;
	Sun,  1 Mar 2026 01:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328161;
	bh=hZ1ZE3nxKnw4QpPrjuUiZXODr1RhfChLJEDdnU3x4o0=;
	h=From:To:Cc:Subject:Date:From;
	b=WWnK6PDhdxdtr3cBHH+V6mhKBdg4cQqlbJR7a/+Qsfasgoln8TAUZPzRGiHZCpUnh
	 whX9opxeSH07TfbjnNqlIWmAwgbHHYYzCR7z5uGFojiFndEDCOAbnLxtyuF4nNxtV7
	 s88ir2NQHAgkJrQofQYMD4rPLBp7pK+HB7GqIhcbrqhomPWRDKzZFHd/5QGUcIiCEL
	 2Qiwg5Q/veJeek+DHqmbCwbN17n+Wu628ZnoZUmEwbzYaPL4WgZjeYR7pd0PRmWRaO
	 vMldRZVDj7Q/JbpAWPqaQAtayBeOtFK4u+ibtaoVAAUpv3RuLT9UDwiVpjgffeA3Hz
	 wJgcUNpI0J23g==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: FAILED: Patch "xfs: mark data structures corrupt on EIO and ENODATA" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:22:39 -0500
Message-ID: <20260301012239.1679102-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 6.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From f39854a3fb2f06dc69b81ada002b641ba5b4696b Mon Sep 17 00:00:00 2001
From: "Darrick J. Wong" <djwong@kernel.org>
Date: Thu, 18 Dec 2025 18:40:50 -0800
Subject: [PATCH] xfs: mark data structures corrupt on EIO and ENODATA

I learned a few things this year: first, blk_status_to_errno can return
ENODATA for critical media errors; and second, the scrub code doesn't
mark data structures as corrupt on ENODATA or EIO.

Currently, scrub failing to capture these errors isn't all that
impactful -- the checking code will exit to userspace with EIO/ENODATA,
and xfs_scrub will log a complaint and exit with nonzero status.  Most
people treat fsck tools failing as a sign that the fs is corrupt, but
online fsck should mark the metadata bad and keep moving.

Cc: stable@vger.kernel.org # v4.15
Fixes: 4700d22980d459 ("xfs: create helpers to record and deal with scrub problems")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 fs/xfs/scrub/btree.c   | 2 ++
 fs/xfs/scrub/common.c  | 4 ++++
 fs/xfs/scrub/dabtree.c | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 8ba004979862f..40f36db9f07d5 100644
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
index 38d0b7d5c894b..affed35a8c96f 100644
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
index dd14f355358ca..5858d4d5e279b 100644
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
-- 
2.51.0




