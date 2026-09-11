Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91833B95E3
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 05:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789106070; cv=none; b=a11tyYz/lGuQAcZyPNB0j1DP/PCAA4e91mk0M1zWmiSGRB8DheBtyMjClDlizHkRIZgEjgHQVmkD2K/BgMi0fNUx/vSn5qFZy5dz1F8vN3ny8yu09o4gH2pvBDYslth+cZtiqQ6fIlhHt1fgZnlmHEXJ1wNy1ppTJcagdoLFq+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789106070; c=relaxed/simple;
	bh=9ovDfgliWQcIFvjUYSN7MA2AsDQCCqNq6FXinoWKSD0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rJny1nYHLun55t0g2Y5UW23AYbvObfd8d4jPnKp/Z2yOSgACCBjLKwfphXIpkfQSty6jmwEBqcdNWFv4V4a7ZMJCTP+uLTlQctovuoOaGh9eT/hem1sN3SWfAaaLfvoje3hwV/iH7bp2twDLdGN0oLNIwLnGV8ceYgUcMmP7EwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F8yOZD1M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F8yOZD1M"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 417191F000FF;
	Fri, 11 Sep 2026 05:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789106067;
	bh=NX37DpU3I/tJM4B7UmYnSjmbu/wMQvwt4z0zat1tIWE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=F8yOZD1MsmjCZL4qac11GN0kQ036t+BfsmBsHvrbKRGuILIY5Gzbllc9a1R9jUaVw
	 7MdFnRbL51V7gwZygEkwNizLN7rh23vtRJZKJ2vzAqZ7L0LCqVdxDDPzVujNvpZGY7
	 bOZ7W2dIkIB39s6DbUTm70XIodTRfSR6LgfPWE8DZ80chZUz8y47mRzEqDgQ87VdDN
	 yAulicgQEIPQOFvYh5Jimz5YQWuuebHrSuQ7/B3PnXmOGNZS3d6fbwbRYZvMBzonfz
	 DY5F9bJ68zAkuL3RMwd/3VPnZgcnSRr3hQGnXicm19a2W6aAm635Q49tQq16cFX4Ji
	 vWmO72N12Pu4A==
Date: Thu, 10 Sep 2026 22:54:26 -0700
Subject: [PATCH 4/6] xfs: fix integer overflows in xbitmap set functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <178910162105.174887.5504947439003231517.stgit@frogsfrogsfrogs>
In-Reply-To: <178910161988.174887.8958318922224347752.stgit@frogsfrogsfrogs>
References: <178910161988.174887.8958318922224347752.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM complains that the xbitmap set functions can suffer an integer
underflow or overflow and thereby return the wrong left and right
pointers.  Fix that logic bomb, even though (AFAICT) we never actually
try to set the *entire* bitmap.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/bitmap.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index c7fa908d92b25e..08f216d26ec632 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -122,8 +122,8 @@ xbitmap64_set(
 	uint64_t		start,
 	uint64_t		len)
 {
-	struct xbitmap64_node	*left;
-	struct xbitmap64_node	*right;
+	struct xbitmap64_node	*left = NULL;
+	struct xbitmap64_node	*right = NULL;
 	uint64_t		last = start + len - 1;
 	int			error;
 
@@ -131,6 +131,7 @@ xbitmap64_set(
 	left = xbitmap64_tree_iter_first(&bitmap->xb_root, start, last);
 	if (left && left->bn_start <= start && left->bn_last >= last)
 		return 0;
+	left = NULL;
 
 	/* Clear out everything in the range we want to set. */
 	error = xbitmap64_clear(bitmap, start, len);
@@ -138,11 +139,15 @@ xbitmap64_set(
 		return error;
 
 	/* Do we have a left-adjacent extent? */
-	left = xbitmap64_tree_iter_first(&bitmap->xb_root, start - 1, start - 1);
+	if (start > 0)
+		left = xbitmap64_tree_iter_first(&bitmap->xb_root, start - 1,
+				start - 1);
 	ASSERT(!left || left->bn_last + 1 == start);
 
 	/* Do we have a right-adjacent extent? */
-	right = xbitmap64_tree_iter_first(&bitmap->xb_root, last + 1, last + 1);
+	if (last < U64_MAX)
+		right = xbitmap64_tree_iter_first(&bitmap->xb_root, last + 1,
+				last + 1);
 	ASSERT(!right || right->bn_start == last + 1);
 
 	if (left && right) {
@@ -397,8 +402,8 @@ xbitmap32_set(
 	uint32_t		start,
 	uint32_t		len)
 {
-	struct xbitmap32_node	*left;
-	struct xbitmap32_node	*right;
+	struct xbitmap32_node	*left = NULL;
+	struct xbitmap32_node	*right = NULL;
 	uint32_t		last = start + len - 1;
 	int			error;
 
@@ -406,6 +411,7 @@ xbitmap32_set(
 	left = xbitmap32_tree_iter_first(&bitmap->xb_root, start, last);
 	if (left && left->bn_start <= start && left->bn_last >= last)
 		return 0;
+	left = NULL;
 
 	/* Clear out everything in the range we want to set. */
 	error = xbitmap32_clear(bitmap, start, len);
@@ -413,11 +419,15 @@ xbitmap32_set(
 		return error;
 
 	/* Do we have a left-adjacent extent? */
-	left = xbitmap32_tree_iter_first(&bitmap->xb_root, start - 1, start - 1);
+	if (start > 0)
+		left = xbitmap32_tree_iter_first(&bitmap->xb_root, start - 1,
+				start - 1);
 	ASSERT(!left || left->bn_last + 1 == start);
 
 	/* Do we have a right-adjacent extent? */
-	right = xbitmap32_tree_iter_first(&bitmap->xb_root, last + 1, last + 1);
+	if (last < U32_MAX)
+		right = xbitmap32_tree_iter_first(&bitmap->xb_root, last + 1,
+				last + 1);
 	ASSERT(!right || right->bn_start == last + 1);
 
 	if (left && right) {

