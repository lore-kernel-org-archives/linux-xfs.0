Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3164F1D0DDE;
	Mon, 18 Nov 2024 23:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731971087; cv=none; b=VWMQeZSpoj7ZEbm5Hie5mZJsX+ybwUEoq8T24JTWkdVkbMKMIE83B3vCsA02JmHDQRSU+CmqyEvYwWjBVVslXPFs1B1qQVBbEp7KCFL97NjGJtFewVHfYUQlF4/91qDb3L3qyI50IWM+WG4OOw1pLI6RC/wYujAScdJ60Wr93x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731971087; c=relaxed/simple;
	bh=jmJ4H6fsAxmvUhHg1MxFBsdBZX3AUZ6jOHO+8MLFBT0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EXuRb2+N1MhxqddRdU64IWIDQUbfV5ug29bOQmAA/lvLBZkilrvTsOqBF4noch9iOWV+Xckn3yQ2n7RAsUvuW516WXDQZ/c8K7lwgbF7QaA/egmrPu296j/0z8qntah74THZSrEtJXGxkY+lOWEGBKBA/KzrTChyGaDoWMXu7qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ofi2ccV0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ofi2ccV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE72C4CECC;
	Mon, 18 Nov 2024 23:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731971087;
	bh=jmJ4H6fsAxmvUhHg1MxFBsdBZX3AUZ6jOHO+8MLFBT0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ofi2ccV0N2DNh6FYsiAcx/pB38aEW+WhTDDHP3QsUNQ14RAV/KaaPVeXw/z7Ly0Wf
	 xQmLy2OuX0LrkuAjyDyqvRjxzRx3gSKrfpQ6nRxwteGoLgvUvoPzLS5LJ6Q7KPJq/a
	 xn3F9sITBCOIa+PjwOfn2P5+xdRYzPRkHhu8WsRbceLtiXWPV1Ad9PrGMOiC6kemGG
	 wPLSQy1Eyy3A1SczwiEzZjCi0nRZkslg2ZNGzY2G7z0zxZr/vitQLr8bf58Ef1AlCc
	 HqNPMB5MF/CG45R8mEOk84ptJTPH1tEhQaDoX3uQAaJrYOjTFz9NeeTrSrdxr2jLcz
	 B080Mas4Bl3jw==
Date: Mon, 18 Nov 2024 15:04:46 -0800
Subject: [PATCH 01/10] xfs: fix off-by-one error in fsmap's end_daddr usage
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, wozizhi@huawei.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <173197084431.911325.16302324218533112215.stgit@frogsfrogsfrogs>
In-Reply-To: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
References: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_fsmap.c |   38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 82f2e0dd224997..3290dd8524a69a 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -163,7 +163,8 @@ struct xfs_getfsmap_info {
 	xfs_daddr_t		next_daddr;	/* next daddr we expect */
 	/* daddr of low fsmap key when we're using the rtbitmap */
 	xfs_daddr_t		low_daddr;
-	xfs_daddr_t		end_daddr;	/* daddr of high fsmap key */
+	/* daddr of high fsmap key, or the last daddr on the device */
+	xfs_daddr_t		end_daddr;
 	u64			missing_owner;	/* owner of holes */
 	u32			dev;		/* device id */
 	/*
@@ -387,8 +388,8 @@ xfs_getfsmap_group_helper(
 	 * we calculated from userspace's high key to synthesize the record.
 	 * Note that if the btree query found a mapping, there won't be a gap.
 	 */
-	if (info->last && info->end_daddr != XFS_BUF_DADDR_NULL)
-		frec->start_daddr = info->end_daddr;
+	if (info->last)
+		frec->start_daddr = info->end_daddr + 1;
 	else
 		frec->start_daddr = xfs_gbno_to_daddr(xg, startblock);
 
@@ -736,11 +737,10 @@ xfs_getfsmap_rtdev_rtbitmap_helper(
 	 * we calculated from userspace's high key to synthesize the record.
 	 * Note that if the btree query found a mapping, there won't be a gap.
 	 */
-	if (info->last && info->end_daddr != XFS_BUF_DADDR_NULL) {
-		frec.start_daddr = info->end_daddr;
-	} else {
+	if (info->last)
+		frec.start_daddr = info->end_daddr + 1;
+	else
 		frec.start_daddr = xfs_rtb_to_daddr(mp, start_rtb);
-	}
 
 	frec.len_daddr = XFS_FSB_TO_BB(mp, rtbcount);
 	return xfs_getfsmap_helper(tp, info, &frec);
@@ -933,7 +933,10 @@ xfs_getfsmap(
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
@@ -998,9 +1001,6 @@ xfs_getfsmap(
 
 	info.next_daddr = head->fmh_keys[0].fmr_physical +
 			  head->fmh_keys[0].fmr_length;
-	info.end_daddr = XFS_BUF_DADDR_NULL;
-	info.fsmap_recs = fsmap_recs;
-	info.head = head;
 
 	/* For each device we support... */
 	for (i = 0; i < XFS_GETFSMAP_DEVS; i++) {
@@ -1013,17 +1013,23 @@ xfs_getfsmap(
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
 

