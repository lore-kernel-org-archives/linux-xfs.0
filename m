Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD56944E
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299496; cv=none; b=FrXP4WBD3xeA595A3lctiknbd+SL6is1b7sORiKx4dgCeokhkb1n2DCugFRJDLKAIZIM5EYFn4r4Ng6XIvOGEM0+JOvY2Ua/cTsYLxhjTHHb7NFz3dFVzj5sCEXBsoW15RbNzCQ5amDgZJsx8uBn8ha7FkjyRW0QGqb3WUCdFhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299496; c=relaxed/simple;
	bh=espKtufMo0z0S2t1AfNfRPOtbbkrB7Zxyiy2hbnq3nk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BRrfB07ahFxiaembT+4ual+MEx7b45fiGAQDDWxfqtpatZ4N5UZ8j3msSBeC3Wmi5MGqYfflDINFpwIw9aFZfS6op4PVgHWDAK0k9py4AioITy7Fw/FWd3KAR+VFPQHyHOzd87M91FOIKZObNeDLBEhMW8LiYDa3oxbLMqZ6WCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b85ZYdV5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b85ZYdV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443FDC32786;
	Tue, 30 Jul 2024 00:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299496;
	bh=espKtufMo0z0S2t1AfNfRPOtbbkrB7Zxyiy2hbnq3nk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b85ZYdV5jnxQQ/ZzhGIC2Gcu95nO1xRoQZz9WXZULFYzANwmp/BQuXFKsHy/i+vXF
	 cd5HctEeQef64JBuKXZ9ionDY9qg7JH1wXgpxdvFhSwAszCMjhHA+oiRmR/v5W3l6R
	 eY+37k7dda6ZwyCAHhlW7bjrGxOlXn6qOkPSd5MddkPPb0QdXYUGUN5NRyG17GAsBv
	 J8QMArqixP2aLQqw20q7BXPoUzVPNZDegtkefUHFzad4beazd7Ra9ZSc2KQqcbtFEL
	 7lL6i3Q3UtxHTPFeAKpS6M3T65BHgdtIjoIJdvMtToyIIoumfLLMzX0iRprjMFuSLJ
	 MZWc0mGoEFEqw==
Date: Mon, 29 Jul 2024 17:31:35 -0700
Subject: [PATCH 030/115] xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Catherine Hoang <catherine.hoang@oracle.com>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <172229842866.1338752.502015054000485511.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: 7560c937b4b5a3c671053be86ff00156a6fdd399

Renames that generate parent pointer updates can join up to 5
inodes locked in sorted order.  So we need to increase the
number of defer ops inodes and relock them in the same way.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
[djwong: have one sorting function]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_priv.h |    2 ++
 libxfs/xfs_defer.c   |    6 +++++-
 libxfs/xfs_defer.h   |    8 +++++++-
 3 files changed, 14 insertions(+), 2 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 9ddba767b..aa0a3adb4 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -440,6 +440,8 @@ xfs_buf_readahead(
 })
 #define xfs_lock_two_inodes(ip0,mode0,ip1,mode1)	((void) 0)
 #define xfs_assert_ilocked(ip, flags)			((void) 0)
+#define xfs_lock_inodes(i_tab, nr, mode)		((void) 0)
+#define xfs_sort_inodes(i_tab, nr)			((void) 0)
 
 /* space allocation */
 #define XFS_EXTENT_BUSY_DISCARDED	0x01	/* undergoing a discard op. */
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 3a91bb3a5..7cf392e2f 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -1086,7 +1086,11 @@ xfs_defer_ops_continue(
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
 	/* Lock the captured resources to the new transaction. */
-	if (dfc->dfc_held.dr_inos == 2)
+	if (dfc->dfc_held.dr_inos > 2) {
+		xfs_sort_inodes(dfc->dfc_held.dr_ip, dfc->dfc_held.dr_inos);
+		xfs_lock_inodes(dfc->dfc_held.dr_ip, dfc->dfc_held.dr_inos,
+				XFS_ILOCK_EXCL);
+	} else if (dfc->dfc_held.dr_inos == 2)
 		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
 				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
 	else if (dfc->dfc_held.dr_inos == 1)
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 81cca60d7..8b338031e 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -77,7 +77,13 @@ extern const struct xfs_defer_op_type xfs_exchmaps_defer_type;
 /*
  * Deferred operation item relogging limits.
  */
-#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
+
+/*
+ * Rename w/ parent pointers can require up to 5 inodes with deferred ops to
+ * be joined to the transaction: src_dp, target_dp, src_ip, target_ip, and wip.
+ * These inodes are locked in sorted order by their inode numbers
+ */
+#define XFS_DEFER_OPS_NR_INODES	5
 #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
 
 /* Resources that must be held across a transaction roll. */

