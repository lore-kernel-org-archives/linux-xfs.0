Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C68B1AA1F5
	for <linux-xfs@vger.kernel.org>; Fri,  8 Nov 2024 17:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731087548; cv=none; b=ZunfR+5gJmtYsTt0xmpabUiDZxoh+hDJSCmNavBs5VmG+r5Inet8z/9VB2roXW6sI4K3zfaYFASJt+k76Sz6nnmmspZNye09B/boPw2Vkd+kBWEjwK91YCTIRsBKxr0BOrHtdJJsAe0roFIXFs2cDaiuieGRYxTy+NrsnM1/o1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731087548; c=relaxed/simple;
	bh=+pkYNl3ZV/R4lVTLl6fN4+/58bl6wtzodUoxWOLPqXk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cIg8TPCZSS7D9XuckZysu5ZZ9dw6Xqu2TUAMe01XdKkoBiC0G8YQPCAloP9oX37xoaIy4UWrGMssjvbwy1FQh7wZJSL9vlo6kFSDTPH2XC62N5kg8Yp45bDepwez9B2aqdkyRuGe1xI7SATI3fDr8fM+g3qoGtRVc5KB0BEaxCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Aq+JJf0Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Aq+JJf0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA041C4CECD;
	Fri,  8 Nov 2024 17:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731087547;
	bh=+pkYNl3ZV/R4lVTLl6fN4+/58bl6wtzodUoxWOLPqXk=;
	h=Date:From:To:Cc:Subject:From;
	b=Aq+JJf0QS89lPLCAB1jl1FE1sBlJ3nkhwhwa9omdU3fKH6q2iQWIp9RQkUhhOTwZw
	 mTo+rBxFR2eBpB9/LzGBUhUKkkx2Yr837YgX3V/KIgpkiniUY9eJCanlDMDtg4axkg
	 KP81q6GUIWcovlcgW/gBPF2I26wFc7EYcrC17MxWGSrQWe1WVLKcZPNCY0g/fb6v+D
	 jhlnJno+OKoAa38LefWA6d25xiCfdSpma+5/9jU1VkHYo8K6OY67Lwr/dkp33fNVm5
	 sjm60+r6y8jJ9KBAtAUMdwqoF4Uulz+jUMpUn49lLnWK8EmtQJbNUh9FRTXhQFKuA+
	 ktaJ9qwTGwM4A==
Date: Fri, 8 Nov 2024 09:39:07 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zizhi Wo <wozizhi@huawei.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>
Subject: [PATCH] xfs: fix off-by-one error in fsmap's end_daddr usage
Message-ID: <20241108173907.GB168069@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

In commit ca6448aed4f10a, we created an "end_daddr" variable to fix
fsmap reporting when the end of the range requested falls in the middle
of an unknown (aka free on the rmapbt) region.  Unfortunately, I didn't
notice that the the code sets end_daddr to the last sector of the device
but then uses that quantity to compute the length of the synthesized
mapping.

Zizhi Wo later observed that when end_daddr isn't set, we still don't
report the last fsblock on a device because in that case (aka when
info->last is true), the info->high mapping that we pass to
xfs_getfsmap_group_helper has a startblock that points to the last
fsblock.  This is also wrong because the code uses startblock to
compute the length of the synthesized mapping.

Fix the second problem by setting end_daddr unconditionally, and fix the
first problem by setting start_daddr to one past the end of the range to
query.

Cc: <stable@vger.kernel.org> # v6.11
Fixes: ca6448aed4f10a ("xfs: Fix missing interval for missing_owner in xfs fsmap")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reported-by: Zizhi Wo <wozizhi@huawei.com>
---
 fs/xfs/xfs_fsmap.c |   35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index f6d20da34aba1d..0202b705dd5eb2 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -165,7 +165,8 @@ struct xfs_getfsmap_info {
 	xfs_daddr_t		next_daddr;	/* next daddr we expect */
 	/* daddr of low fsmap key when we're using the rtbitmap */
 	xfs_daddr_t		low_daddr;
-	xfs_daddr_t		end_daddr;	/* daddr of high fsmap key */
+	/* daddr of high fsmap key, or the last daddr on the device */
+	xfs_daddr_t		end_daddr;
 	u64			missing_owner;	/* owner of holes */
 	u32			dev;		/* device id */
 	/*
@@ -388,8 +389,8 @@ xfs_getfsmap_group_helper(
 	 * we calculated from userspace's high key to synthesize the record.
 	 * Note that if the btree query found a mapping, there won't be a gap.
 	 */
-	if (info->last && info->end_daddr != XFS_BUF_DADDR_NULL)
-		frec->start_daddr = info->end_daddr;
+	if (info->last)
+		frec->start_daddr = info->end_daddr + 1;
 	else
 		frec->start_daddr = xfs_gbno_to_daddr(xg, startblock);
 
@@ -737,8 +738,8 @@ xfs_getfsmap_rtdev_rtbitmap_helper(
 	 * we calculated from userspace's high key to synthesize the record.
 	 * Note that if the btree query found a mapping, there won't be a gap.
 	 */
-	if (info->last && info->end_daddr != XFS_BUF_DADDR_NULL) {
-		frec.start_daddr = info->end_daddr;
+	if (info->last) {
+		frec.start_daddr = info->end_daddr + 1;
 	} else {
 		frec.start_daddr = xfs_rtb_to_daddr(mp, start_rtb);
 	}
@@ -1108,7 +1109,10 @@ xfs_getfsmap(
 	struct xfs_trans		*tp = NULL;
 	struct xfs_fsmap		dkeys[2];	/* per-dev keys */
 	struct xfs_getfsmap_dev		handlers[XFS_GETFSMAP_DEVS];
-	struct xfs_getfsmap_info	info = { NULL };
+	struct xfs_getfsmap_info	info = {
+		.fsmap_recs		= fsmap_recs,
+		.head			= head,
+	};
 	bool				use_rmap;
 	int				i;
 	int				error = 0;
@@ -1176,9 +1180,6 @@ xfs_getfsmap(
 
 	info.next_daddr = head->fmh_keys[0].fmr_physical +
 			  head->fmh_keys[0].fmr_length;
-	info.end_daddr = XFS_BUF_DADDR_NULL;
-	info.fsmap_recs = fsmap_recs;
-	info.head = head;
 
 	/* For each device we support... */
 	for (i = 0; i < XFS_GETFSMAP_DEVS; i++) {
@@ -1191,17 +1192,23 @@ xfs_getfsmap(
 			break;
 
 		/*
-		 * If this device number matches the high key, we have
-		 * to pass the high key to the handler to limit the
-		 * query results.  If the device number exceeds the
-		 * low key, zero out the low key so that we get
-		 * everything from the beginning.
+		 * If this device number matches the high key, we have to pass
+		 * the high key to the handler to limit the query results, and
+		 * set the end_daddr so that we can synthesize records at the
+		 * end of the query range or device.
 		 */
 		if (handlers[i].dev == head->fmh_keys[1].fmr_device) {
 			dkeys[1] = head->fmh_keys[1];
 			info.end_daddr = min(handlers[i].nr_sectors - 1,
 					     dkeys[1].fmr_physical);
+		} else {
+			info.end_daddr = handlers[i].nr_sectors - 1;
 		}
+
+		/*
+		 * If the device number exceeds the low key, zero out the low
+		 * key so that we get everything from the beginning.
+		 */
 		if (handlers[i].dev > head->fmh_keys[0].fmr_device)
 			memset(&dkeys[0], 0, sizeof(struct xfs_fsmap));
 
