Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC273BB690;
	Thu,  8 Oct 2026 05:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791439064; cv=none; b=GSut6+sn4w4Z8WApIz07hWRzoQ77OageQabxGigldCB2vau4fshcsHQS3fWeptoULRo4+s9yEMaqHKBi+1mdtuvFpfIgcShn54F5O+bsRqpNPSnsSFoxp0EL75z2g9CHOtsB/pDG7yj/Dex10wJ6kNM2MhxsPHS7QqEB1PLlmB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791439064; c=relaxed/simple;
	bh=1WrkDvHkQ+iqzY3/YgYiqqS7lXGyfRr4QCsyCbfn7V0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o4StUX2D1AbgYNt5jPNUFhbW8GAB3eVODBNA3k9rB0VmozncMapKK3n3aMXdwnw2SHtzW9LY79HRg1CbgNJ8YEBwu1JsagCtvbrqm01ku+rZzxZPjETZwVyN2R0mNIZgO4zcxjpD00ipOYpbVvmwNuoBRIENPF16ENMjHDbgw/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ACl7+5DU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ACl7+5DU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B07971F000FF;
	Thu,  8 Oct 2026 05:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791439062;
	bh=nuoxyx+nn95GUsiChWTU+6F+Xv4qrTBN0qc8KYU3cUo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=ACl7+5DULxCtpS/b9hmcuLzlPuzj2eFi9R4exobzcwUAd4P+AyEtmE9AHHnKh8yBC
	 32oN7ozzZFnssWx8zHPVKCaBbUhIok1Q6EwWV9SB9Z2QOdwk7dwfmcGBU4sffIwCJF
	 Ce7KywRGTDPFypIt7BsQQIYnMn33WK5c7FTVHYKngsPDlRniKPX9hYF0z0iWATFj3Y
	 nrKdNYyff7iJnZ8N+85gY1DDCcxMVMbzE58xS134P28puzund30GJotXMBGd87U3vl
	 UTsOwhP96q7f5RAx3DQOPmnEpOFTk5FTeaGDlabRTbE06sp9iHf/J1CqRZB10FNY5w
	 XY4JPkmI00axg==
Date: Wed, 07 Oct 2026 22:57:42 -0700
Subject: [PATCH 11/12] xfs: clarify various parts of the bitmap API
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179141521494.2728617.17754060229795248066.stgit@frogsfrogsfrogs>
In-Reply-To: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
References: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
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

