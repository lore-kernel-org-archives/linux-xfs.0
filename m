Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7627449BD7A;
	Mon, 12 Oct 2026 15:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791818609; cv=none; b=Rwxj9tsR9bC2urKjhlA3K+enNUoynvvjeCJplNhEUKdxBMSyvHBdGo7CsrL4gr5Bcxqhy5mhozrvqSS1BUpL48pAIuhdYcdBOT97sVmyYzETVE0drDcb+vUbjrDn+d9+Dp2XpGag4M2xiXDCtE9fgjHKqEVmOiU24HdOMO/KEP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791818609; c=relaxed/simple;
	bh=9vmMB8KEpx6BufuLEZkNGJk4oJngwAOPd21ZQcZVXkk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JqTkiRaw5DF/zUBuOxab6KqAvDts2kYOF70bQitcmSx7ZRiHo7/j++AOnPzX87TdbJJlbn7OsJw0yBkELOc7EXegIbUaeqNCWtiQ2+UoMuvPmoVB+7qO75WdCArJHrbjWv3Ot/LIA6YArMBWl+tJXJPJugQph86zg17TAcNm+Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AippUYM9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AippUYM9"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 421D81F0089B;
	Mon, 12 Oct 2026 15:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791818608;
	bh=0UGB9/AOAb7cl1N4cYudfaAB8LU9tpPhuQC6M1QqfKg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=AippUYM9/VTKRAqouzbXw6ppjhvQfwuxc2R2+/L2a4m3cgNrAxKwEEHO1w8mOTnjh
	 pKVYsF/AWFdkKzIHgy/3tyGz6lJqdNnbWhh8uT8E6Mf3KKhSBRQhkDH0dzf39hxrkw
	 IAgfVI6Px+ZPJNV/fS2bZIn6rnlXT2fxUPpiOCED5jkU5qQ5vdRWBvn9Bj1MCatY+D
	 MmExaWCKPMMVyI4rP0kVYEJIfn4YitfnQ4dgr5GC+ffpE23YDF/88bMF0YCZX6++sL
	 uwoKz2bMsFjiLbl9YqnTIR92CfWWxXOsVH8DtWI5JIX2Fzi4azEE8W/3DrA8beobZ1
	 anwfCaiVBrSSg==
Date: Mon, 12 Oct 2026 08:23:27 -0700
Subject: [PATCH 12/13] xfs: clarify various parts of the bitmap API
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179181839506.1417179.7620993844006216106.stgit@frogsfrogsfrogs>
In-Reply-To: <179181839163.1417179.9019753534701755931.stgit@frogsfrogsfrogs>
References: <179181839163.1417179.9019753534701755931.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM pointed out some underspecified parts of the xbitmap{32,64} API.
Specifically, the behavior of set/clear/test functions when the length
parameter is zero is not well defined, nor is what happens when someone
tries to disunion a bitmap with itself.  None of these situations are
expected, but we'll define zero-length set and clear to be nops, and the
rest to be checked by assertions.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: 6ece924b952262 ("xfs: create separate structures and code for u32 bitmaps")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/bitmap.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)


diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index 08f216d26ec632..1da99e179baa42 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -77,6 +77,9 @@ xbitmap64_clear(
 	struct xbitmap64_node	*new_bn;
 	uint64_t		last = start + len - 1;
 
+	if (!len)
+		return 0;
+
 	while ((bn = xbitmap64_tree_iter_first(&bitmap->xb_root, start, last))) {
 		if (bn->bn_start < start && bn->bn_last > last) {
 			uint64_t	old_last = bn->bn_last;
@@ -127,6 +130,9 @@ xbitmap64_set(
 	uint64_t		last = start + len - 1;
 	int			error;
 
+	if (!len)
+		return 0;
+
 	/* Is this whole range already set? */
 	left = xbitmap64_tree_iter_first(&bitmap->xb_root, start, last);
 	if (left && left->bn_start <= start && left->bn_last >= last)
@@ -223,6 +229,8 @@ xbitmap64_disunion(
 	struct xbitmap64_node	*bn;
 	int			error;
 
+	ASSERT(bitmap != sub);
+
 	if (xbitmap64_empty(bitmap) || xbitmap64_empty(sub))
 		return 0;
 
@@ -287,6 +295,8 @@ xbitmap64_test(
 	struct xbitmap64_node	*bn;
 	uint64_t		last = start + *len - 1;
 
+	ASSERT(*len > 0);
+
 	bn = xbitmap64_tree_iter_first(&bitmap->xb_root, start, last);
 	if (!bn)
 		return false;
@@ -357,6 +367,9 @@ xbitmap32_clear(
 	struct xbitmap32_node	*new_bn;
 	uint32_t		last = start + len - 1;
 
+	if (!len)
+		return 0;
+
 	while ((bn = xbitmap32_tree_iter_first(&bitmap->xb_root, start, last))) {
 		if (bn->bn_start < start && bn->bn_last > last) {
 			uint32_t	old_last = bn->bn_last;
@@ -407,6 +420,9 @@ xbitmap32_set(
 	uint32_t		last = start + len - 1;
 	int			error;
 
+	if (!len)
+		return 0;
+
 	/* Is this whole range already set? */
 	left = xbitmap32_tree_iter_first(&bitmap->xb_root, start, last);
 	if (left && left->bn_start <= start && left->bn_last >= last)
@@ -503,6 +519,8 @@ xbitmap32_disunion(
 	struct xbitmap32_node	*bn;
 	int			error;
 
+	ASSERT(bitmap != sub);
+
 	if (xbitmap32_empty(bitmap) || xbitmap32_empty(sub))
 		return 0;
 
@@ -567,6 +585,8 @@ xbitmap32_test(
 	struct xbitmap32_node	*bn;
 	uint32_t		last = start + *len - 1;
 
+	ASSERT(*len > 0);
+
 	bn = xbitmap32_tree_iter_first(&bitmap->xb_root, start, last);
 	if (!bn)
 		return false;

