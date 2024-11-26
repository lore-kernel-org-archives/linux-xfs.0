Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0F9DF49;
	Tue, 26 Nov 2024 01:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584299; cv=none; b=oswIHX2RtAqqaKatWtjvvejlpwgZ++DpHn0QEJ6plqHydBvFxQFKu/h4e4qlrJHahs6/vo8CI7tjzwtOwAYSO99vNSzjCyUCCaCVYjKTg9sk9d5ysZloF4rheX5ww0IqTsR57wJ1I3pt/kw6bEjWsuY2sHPU/God9ylAMNqV/IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584299; c=relaxed/simple;
	bh=Pizfx7xfbsJPj1lI6/tM0ZwA3V6zijokxNO54cioPLk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=im59YrGGCkPMKBx9netjDT2cGoouq0DYzek2dyQ35O0HasrB/7cBDUnIwyNqcuyr7I1LkiNj145t80kwgfKbL+y0BwmSIM18eB1UybYbcb0XISKErmeMxwypKAOVnd/ytCZEGsPw0DxkjIUqFrtwlo2EKjrgY2UAfhQiqMNCrrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TRgBWxVY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TRgBWxVY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB2CC4CECE;
	Tue, 26 Nov 2024 01:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584299;
	bh=Pizfx7xfbsJPj1lI6/tM0ZwA3V6zijokxNO54cioPLk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TRgBWxVYrJoBXgRfFz1OrG2HgnBuX/NJcHaBV3Saombqjq/J0o0MsfDHyhrw8uQCf
	 7FdxCQWpB8Tzd9S2Uur80Mk8UPqiZySNdXhC8AYXoZGJpGN5YyCj+i/yQPWQwFdXby
	 mO4f/b8qtPU5MTYG0No6EZ/yyJj2fNaeHKS7WaGdy+GaJyJWYIEncWMiWH8qLp7iKA
	 nRsutgDfyFQblgBSSHESQxDSRhQMz7PlY7xOt8wRCcZia5f25SRRhUidnfjikEixav
	 9T/H1uEv9eZHSXFwZp/laDFs6vXC0wYbQZZ3vL/WrKjZ5uCk0bb286iwK7jTKeQFRj
	 NhX4QHQnLVZYg==
Date: Mon, 25 Nov 2024 17:24:58 -0800
Subject: [PATCH 01/21] xfs: fix off-by-one error in fsmap's end_daddr usage
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: stable@vger.kernel.org, wozizhi@huawei.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <173258397820.4032920.11184703272397099638.stgit@frogsfrogsfrogs>
In-Reply-To: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
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
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
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
 

