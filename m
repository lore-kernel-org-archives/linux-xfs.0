Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC4CBA46
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372752; cv=none; b=ukjXQ4HXPTvRrCP3s3tHxAeVUQfk5nVPrbR9QAqT9L5M42mGA+pcqY0sQ0kuHPRZumJIzfoKI+pSYYeMoUjCWq6jpYmKdDxVCCL8OcYK8vQ/51KP69c+MjbdhR21U2COC5Ep2fzxk2dL3iziwclRtD9LSiHThNaM8aWnqxPfFiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372752; c=relaxed/simple;
	bh=CUY+3KIaBmlKzZsA1R7I35JNmLTgfLY5ogGBHZFVZhc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lQaJvm9XC2sPNguIbmEprrR4GLasdp4yhctOl0qqOGTHpQUzG/BCO/sLoteQvYE5zN/CMJkq9hZH9DbxurZ7wQgxpyEjiLQAPVyKHxUc686N6gbLk4MX+rvazfY7s6TaFUWrRIqo6cv3nZq6nUQhLFXIxB7tER97jJeisogDljM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=inz66aPZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="inz66aPZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E10C32782;
	Fri, 23 Aug 2024 00:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372752;
	bh=CUY+3KIaBmlKzZsA1R7I35JNmLTgfLY5ogGBHZFVZhc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=inz66aPZD3QP/KglRvikAAhXcUxv+sMZSV6/Kt8O9/EnIIapTmwsz5ZJkqmqo+E1M
	 6Mj3aKJW+bJ1CW96moFgw010rmb4naQApIkfGhEjxmg8IyDSHLmXKMZQJ6Lb+QuA3F
	 kAMysDTWvpNBQqXo0ogbPj7dP/MxPAUY4HeooUfNh/6jSt9My0Vz0M4u/0gdvDlnis
	 vaElL22oqHRUX/6TXoo63GpGY1QYNI9pa9mGqcyfF03K2LDS8THIKqnJ5BtCty/hFl
	 HtHxFNgh/KDmo/N6NC5V7tPWKD3o4bVHl0SnkIxzNv9fwIf2RV1jcHCsNwrUX1e5OT
	 deVEwVtjI5gQA==
Date: Thu, 22 Aug 2024 17:25:51 -0700
Subject: [PATCH 18/26] xfs: support error injection when freeing rt extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437088834.60592.5110162859616544393.stgit@frogsfrogsfrogs>
In-Reply-To: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_rtbitmap.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index dfac0e89409a9..c8958d3e0abe0 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -21,6 +21,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_health.h"
 #include "xfs_sb.h"
+#include "xfs_errortag.h"
 #include "xfs_log.h"
 #include "xfs_buf_item.h"
 
@@ -1065,6 +1066,9 @@ xfs_rtfree_extent(
 	ASSERT(rbmip->i_itemp != NULL);
 	xfs_assert_ilocked(rbmip, XFS_ILOCK_EXCL);
 
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_FREE_EXTENT))
+		return -EIO;
+
 	error = xfs_rtcheck_alloc_range(&args, start, len);
 	if (error)
 		return error;

