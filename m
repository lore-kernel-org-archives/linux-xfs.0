Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28237155C87;
	Wed, 18 Dec 2024 19:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734551453; cv=none; b=gj4hPsRBAKnzG7c+mbShrJegwb/KgBHOJo8QTosWn5tcVw3L7i8GUF5locsfEINzGBmy123o3+vlFVRHlWt7i0qNrDBCmjFlfPR8LfUDxAwFJUmAdBpvNklTYcOE2mpEY/MYALOmyK50dzoRaFYbxo28AIIZF/SZOmCJ7iMXNP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734551453; c=relaxed/simple;
	bh=IlzwpdlsgMLG86O/R02Vm5+HFlZIAyaj54wExYRLx6A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dqsXGbcjNFhn88TNw1fX573ZvYPXm0t4f+ezeH6NnuWnOme3QecxoWpPjoETB+I8IffPu6Srwdvn6/qNx2bKTbbv2BJDGlONJC/v3n8VjPOd/sjcuHVvJXw4KxRkb/HBJ7sCEVpJV+bUDFYc8FTh1REBY7yQmjRQD5bbxOgPr5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sCGS/AzY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sCGS/AzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A21C4CECD;
	Wed, 18 Dec 2024 19:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734551452;
	bh=IlzwpdlsgMLG86O/R02Vm5+HFlZIAyaj54wExYRLx6A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sCGS/AzYV3+yTmfD8yWUYW6KVhl4EAwucTTDk537SFToZ6zUHrAIyHHcNuknDKPvo
	 WUoPT2BLcbXBU1/b7dZlW0IIskXianfNn/FSx1qdxLdH8ZUbvyDaJvQFZJSYK4Yrqz
	 GKlQxnYXsXiHz6xCcf3HqFdAxctjMwPHaE5VSgUkMjg9ToEYsQmgSKkDkIAlrUGvtw
	 x48JiQHNojET2cZIWirhuXm6D1BSc7m1sHV9jGtphj3/omW+CUoeGUYbPKJwRImv5V
	 KiBC3g065HkoH2ffFtpqYeuDwVXTgh5SnCDo0vDROpf6pkx9RIsKdEnTM0sj+PCkD1
	 vyCgA0VtN14KA==
Date: Wed, 18 Dec 2024 11:50:52 -0800
Subject: [PATCH 3/5] xfs: fix off-by-one error in fsmap's end_daddr usage
From: "Darrick J. Wong" <djwong@kernel.org>
To: stable@vger.kernel.org, djwong@kernel.org
Cc: wozizhi@huawei.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173455093546.305755.16195246941369372978.stgit@frogsfrogsfrogs>
In-Reply-To: <173455093488.305755.7686977865497104809.stgit@frogsfrogsfrogs>
References: <173455093488.305755.7686977865497104809.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

commit a440a28ddbdcb861150987b4d6e828631656b92f upstream.

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
 fs/xfs/xfs_fsmap.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index ae18ab86e608b5..8712b891defbc7 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -162,7 +162,8 @@ struct xfs_getfsmap_info {
 	xfs_daddr_t		next_daddr;	/* next daddr we expect */
 	/* daddr of low fsmap key when we're using the rtbitmap */
 	xfs_daddr_t		low_daddr;
-	xfs_daddr_t		end_daddr;	/* daddr of high fsmap key */
+	/* daddr of high fsmap key, or the last daddr on the device */
+	xfs_daddr_t		end_daddr;
 	u64			missing_owner;	/* owner of holes */
 	u32			dev;		/* device id */
 	/*
@@ -306,7 +307,7 @@ xfs_getfsmap_helper(
 	 * Note that if the btree query found a mapping, there won't be a gap.
 	 */
 	if (info->last && info->end_daddr != XFS_BUF_DADDR_NULL)
-		rec_daddr = info->end_daddr;
+		rec_daddr = info->end_daddr + 1;
 
 	/* Are we just counting mappings? */
 	if (info->head->fmh_count == 0) {
@@ -898,7 +899,10 @@ xfs_getfsmap(
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
@@ -963,9 +967,6 @@ xfs_getfsmap(
 
 	info.next_daddr = head->fmh_keys[0].fmr_physical +
 			  head->fmh_keys[0].fmr_length;
-	info.end_daddr = XFS_BUF_DADDR_NULL;
-	info.fsmap_recs = fsmap_recs;
-	info.head = head;
 
 	/* For each device we support... */
 	for (i = 0; i < XFS_GETFSMAP_DEVS; i++) {
@@ -978,17 +979,23 @@ xfs_getfsmap(
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
 

