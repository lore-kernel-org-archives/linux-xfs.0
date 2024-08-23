Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9734663A
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372033; cv=none; b=mFdoQCcjy4MXL1arKHrfl9h6ERjsqJ4kp9QrTkMPDnIPuBYvFmIi0A+V3BBMRacPkZ87dInjpxSWJRFZ6o8m4/Rr1VKIrS5qQJO+dUTKsZHx4aKUve9JWUNjRvUJdIM0jBhqrfzay+7EpE1eeYJXIHyz4eJUSQOgkwtKIaFhhyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372033; c=relaxed/simple;
	bh=hf7YTmm1L/5WejtdKUeJDGMKQ0Q89I0WvFov5ZHf1eY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ULqmy1MSEYdnGonags19HwDHOm1e+RXpLpRmqvz6G0cVSk7CDd9OHA0PjnpJ4C7esYm37ve7+bc6Jie/8nPzG1BukmMohZI+ZQRlBAI2VGamqhBnJX1e/Ewns97MZtzo/fbZTItD/rXgAOujPwS/USXn/9QCRiadmTjSopYF4YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TS6Db7zX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TS6Db7zX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E70BC32782;
	Fri, 23 Aug 2024 00:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372033;
	bh=hf7YTmm1L/5WejtdKUeJDGMKQ0Q89I0WvFov5ZHf1eY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TS6Db7zXPqz+nd6Y2I4CHzEhmLK1NFsJpnaC0m5f61siQ/ZK3sGhPuGHAOA0RKGP1
	 cgOGVti1zsnI4dixTZIiSxv16x0ZU53wMnXX1fsh4D5lMmVuwhLduAUoek4DMh8L2a
	 jJUC5T+l2yAcL/rUB1X94807kgX6gNj+8cW2U+kPE3PXUvrfCLSfsmARoe2Kw7BdC/
	 ouvGndukk3ds70FIW9JNukrChfcg9HhoGQ/tLGLIhsvrIYqg1+3S6/bpDUV0/kh35b
	 KgUyT8il7B8DggTjHql/9KDel2SJzK92jdwjmgbPBO9oNqD9cfPSeHNRBv7+qj/h8I
	 RoBVtnBpGXSGw==
Date: Thu, 22 Aug 2024 17:13:52 -0700
Subject: [PATCH 07/10] xfs: reduce excessive clamping of maxlen in
 xfs_rtallocate_extent_near
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437086737.59070.10832733339991521324.stgit@frogsfrogsfrogs>
In-Reply-To: <172437086590.59070.9398644715198875909.stgit@frogsfrogsfrogs>
References: <172437086590.59070.9398644715198875909.stgit@frogsfrogsfrogs>
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

The near rt allocator employs two allocation strategies -- first it
tries to allocate at exactly @start.  If that fails, it will pivot back
and forth around that starting point looking for an appropriately sized
free space.

However, I clamped maxlen ages ago to prevent the exact allocation scan
from running off the end of the rt volume.  This, I realize, was
excessive.  If the allocation request is (say) for 32 rtx but the start
position is 5 rtx from the end of the volume, we clamp maxlen to 5.  If
the exact allocation fails, we then pivot back and forth looking for 5
rtx, even though the original intent was to try to get 32 rtx.

If we then find 5 rtx when we could have gotten 32 rtx, we've not done
as well as we could have.  This may be moot if the caller immediately
comes back for more space, but it might not be.  Either way, we can do
better here.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 2fe3f6563cad3..3dafe37f01f64 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -340,23 +340,29 @@ xfs_rtallocate_extent_exact(
 	xfs_rtxlen_t		prod,	/* extent product factor */
 	xfs_rtxnum_t		*rtx)	/* out: start rtext allocated */
 {
+	struct xfs_mount	*mp = args->mp;
 	xfs_rtxnum_t		next;	/* next rtext to try (dummy) */
 	xfs_rtxlen_t		alloclen; /* candidate length */
+	xfs_rtxlen_t		scanlen; /* number of free rtx to look for */
 	int			isfree;	/* extent is free */
 	int			error;
 
 	ASSERT(minlen % prod == 0);
 	ASSERT(maxlen % prod == 0);
-	/*
-	 * Check if the range in question (for maxlen) is free.
-	 */
-	error = xfs_rtcheck_range(args, start, maxlen, 1, &next, &isfree);
+
+	/* Make sure we don't run off the end of the rt volume. */
+	scanlen = xfs_rtallocate_clamp_len(mp, start, maxlen, prod);
+	if (scanlen < minlen)
+		return -ENOSPC;
+
+	/* Check if the range in question (for scanlen) is free. */
+	error = xfs_rtcheck_range(args, start, scanlen, 1, &next, &isfree);
 	if (error)
 		return error;
 
 	if (isfree) {
-		/* start to maxlen is all free; allocate it. */
-		*len = maxlen;
+		/* start to scanlen is all free; allocate it. */
+		*len = scanlen;
 		*rtx = start;
 		return 0;
 	}
@@ -412,11 +418,6 @@ xfs_rtallocate_extent_near(
 	if (start >= mp->m_sb.sb_rextents)
 		start = mp->m_sb.sb_rextents - 1;
 
-	/* Make sure we don't run off the end of the rt volume. */
-	maxlen = xfs_rtallocate_clamp_len(mp, start, maxlen, prod);
-	if (maxlen < minlen)
-		return -ENOSPC;
-
 	/*
 	 * Try the exact allocation first.
 	 */

