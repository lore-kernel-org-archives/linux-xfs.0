Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742AC7EF
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rK/zKg7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC44AC433C7;
	Mon,  1 Jan 2024 00:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067675;
	bh=wOGZQHw6EYixleSNRr5RkDzDUVzZH0xbbacM+BbyTjo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rK/zKg7U3r7hhW7Y1NiXh5b+EgUQwg/kEHDyCbkWFm8vUvj1xWZr2BPwUaPqb4eIn
	 kToy6g1S+e/GISbnxvdDcuqaWAtbTDMn6+BJd8C2TkuSaPeg7jAaIIKub/77l0mPq+
	 XpZFt1jSFntAeWFL1gD/VXsTnyS4Bw48Ec/qvfpwzcr9p6VUzVeZOCWaU5IrQ6f++S
	 58kR7daBJ5Uzp+axnOd/q0uCX/ti1uLtpFX1BmfoYtjrJSKwpTCTfUYTeE0N5OkVou
	 ef2P6E5SY5HEVM4q74yapPqG4iCZtEmVJ9lNc5Zx5b6ZUV6f+SOq7mG6luY1tQLoDI
	 32CwcxNjIK5Rw==
Date: Sun, 31 Dec 2023 16:07:54 +9900
Subject: [PATCH 2/3] xfs: support error injection when freeing rt extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405014488.1815106.11785228210366790252.stgit@frogsfrogsfrogs>
In-Reply-To: <170405014459.1815106.2840285507026368491.stgit@frogsfrogsfrogs>
References: <170405014459.1815106.2840285507026368491.stgit@frogsfrogsfrogs>
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

A handful of fstests expect to be able to test what happens when extent
free intents fail to actually free the extent.  Now that we're
supporting EFIs for realtime extents, add to xfs_rtfree_extent the same
injection point that exists in the regular extent freeing code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rtbitmap.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 7d29a72be6b..a42e54b28b9 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -16,6 +16,7 @@
 #include "xfs_trans.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_health.h"
+#include "xfs_errortag.h"
 
 /*
  * Realtime allocator bitmap functions shared with userspace.
@@ -1036,6 +1037,9 @@ xfs_rtfree_extent(
 	ASSERT(mp->m_rbmip->i_itemp != NULL);
 	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
 
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_FREE_EXTENT))
+		return -EIO;
+
 	error = xfs_rtcheck_alloc_range(&args, start, len);
 	if (error)
 		return error;

