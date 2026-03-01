Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6301E0B86;
	Sun,  1 Mar 2026 01:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328834; cv=none; b=L1+2GlWGH5djVOOf+qI6IlDoISBK0Ggb3lpMs/WwrfQfwZm2H8vxZ3jgYxQs7PGLWqya2u2tGnhMy1jdJdXadOvrWCWn9mVZsHvbkXtK88f/ThPDy+7xkERRBbqExaHyFP71y4N4AD6IdMb5D+4Esu5yT5kwl/pZeEVNEZun400=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328834; c=relaxed/simple;
	bh=d6h7B37TyLSlc0xF2POy+QzXfB5ZoddwmViLl5/odXY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kkXI+dL/4Prn8aPFrLzdhJPlvBEHgA3OVLxavFsfEPFzyfLc90U1RdkZFTvd19bIWoGuhT7jbQkih+T5J7OAbig8MJjQ4szsl1KgUbA+PvCqPW6BpfbvY3Ln/cPXYMhWqXz9/dZcjBWs6UbWduAh0iyyfSL9TByPziBD6I0yXxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i4/4Vw/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i4/4Vw/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BACC19421;
	Sun,  1 Mar 2026 01:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328834;
	bh=d6h7B37TyLSlc0xF2POy+QzXfB5ZoddwmViLl5/odXY=;
	h=From:To:Cc:Subject:Date:From;
	b=i4/4Vw/ObLFs99uUbpjoqc23fVAq3jG4ke2K+aAwNjBLEKZg2HWG0vtwubZsoFyQ8
	 RmxCcHpl1kDYpY/EiYh4V7hC6TFwZKdRaZlF1xCXf4SRFqXZsPu+irvKojEqCruMQk
	 yh32+F3cnb1Sf9Onsydx4G7xq33YQfMJxczIYbudRw4t9nrR6ed2cLkC+5wuEl2iGn
	 fObTzRFpJgvyFLF+FOY+cU6kHOSMK5YQWsrzbmgwEG9ZUiId26+qzKZPgAQphP1QaO
	 VHlPI0wF/B8guph2xHCDQgehQCWwQUATgYDH6GSUsCPTj5kvKzxIeCcHFVw9mSW/3i
	 kePx9/zN97JMw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: FAILED: Patch "xfs: mark data structures corrupt on EIO and ENODATA" failed to apply to 6.6-stable tree
Date: Sat, 28 Feb 2026 20:33:52 -0500
Message-ID: <20260301013352.1693181-1-sashal@kernel.org>
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

The patch below does not apply to the 6.6-stable tree.
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




