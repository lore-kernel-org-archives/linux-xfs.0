Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F061B95B
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 18:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751393170; cv=none; b=uUZejKCRT9vzdOgfF6EVFFoyjbIgmNxKw+cE0NEO0Q/uSAa/3BKyP6Gt2O/kbcd2CSDI10oHDP0JmDDdYECh7LTmu4r+4WARCED2/p8BB/LfrxNRdzFi9Gb9VMkGQjktbHrN1yq2elE/aET376zpbHuzcOhYwFAlpg2bvNFSR20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751393170; c=relaxed/simple;
	bh=RakYFV8V0qt7wLFhRgGzFnLoKOeWov8dObyuXlfaW/Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UmqY8Rgt2YROUslN9no4oJ50XgTRLILhY4EhNGM5YIW6pUwMDD3qI1CdeDBhRGBhyaC2NWSHz3DJ+abFOMxyj3MIM0DT1IEKOQvhr9YEaFEoIBPeOlI7xs7bC4Su13WprCsfFOLsKgjh+kimoi4wKwLftVz/pmJdj8jaxI7NmhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JfkQYMsu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JfkQYMsu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39880C4CEEB;
	Tue,  1 Jul 2025 18:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751393170;
	bh=RakYFV8V0qt7wLFhRgGzFnLoKOeWov8dObyuXlfaW/Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JfkQYMsu1I0BXo/6ekJ48u4RyIoDyB3SlD9JntNz+gDFUDxRMGwh0wG5tlGwAj0KK
	 rwhqyWvCETvHJzCqx/ItNM+ZwECP70UT+OT9YB2wN1J6UbCZIYnHMrjNIfq4O5dbnM
	 OG/V/GBbr0H8ci7so2qG8jAzKAASUlC4hkqQWG3ZB6xK1FkWFT1KsuEVyedJw3SUxY
	 bNx+cikolynbM/ubjKbR62k/WlNj5CDvEL7WpAM+sBgkxzOgyPx+aZM/t2+abGUbZ4
	 bUc1bjfUF2Naiqg8G7uvv7tfWVylTCzjzhHr0v8zYqkT6+cOTJKrvv2s2PtmPmIgoV
	 86QytqxXFhewA==
Date: Tue, 01 Jul 2025 11:06:09 -0700
Subject: [PATCH 3/6] xfs: commit CoW-based atomic writes atomically
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, john.g.garry@oracle.com, catherine.hoang@oracle.com,
 john.g.garry@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <175139303549.915889.11392310575906404058.stgit@frogsfrogsfrogs>
In-Reply-To: <175139303469.915889.13789913656019867003.stgit@frogsfrogsfrogs>
References: <175139303469.915889.13789913656019867003.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: John Garry <john.g.garry@oracle.com>

Source kernel commit: b1e09178b73adf10dc87fba9aee7787a7ad26874

When completing a CoW-based write, each extent range mapping update is
covered by a separate transaction.

For a CoW-based atomic write, all mappings must be changed at once, so
change to use a single transaction.

Note that there is a limit on the amount of log intent items which can be
fit into a single transaction, but this is being ignored for now since
the count of items for a typical atomic write would be much less than is
typically supported. A typical atomic write would be expected to be 64KB
or less, which means only 16 possible extents unmaps, which is quite
small.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: add tr_atomic_ioend]
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 libxfs/xfs_trans_resv.h |    1 +
 libxfs/xfs_log_rlimit.c |    4 ++++
 libxfs/xfs_trans_resv.c |   15 +++++++++++++++
 3 files changed, 20 insertions(+)


diff --git a/libxfs/xfs_trans_resv.h b/libxfs/xfs_trans_resv.h
index d9d0032cbbc5d4..670045d417a65f 100644
--- a/libxfs/xfs_trans_resv.h
+++ b/libxfs/xfs_trans_resv.h
@@ -48,6 +48,7 @@ struct xfs_trans_resv {
 	struct xfs_trans_res	tr_qm_dqalloc;	/* allocate quota on disk */
 	struct xfs_trans_res	tr_sb;		/* modify superblock */
 	struct xfs_trans_res	tr_fsyncts;	/* update timestamps on fsync */
+	struct xfs_trans_res	tr_atomic_ioend; /* untorn write completion */
 };
 
 /* shorthand way of accessing reservation structure */
diff --git a/libxfs/xfs_log_rlimit.c b/libxfs/xfs_log_rlimit.c
index 246d5f486d024a..2b9047f5ffb58b 100644
--- a/libxfs/xfs_log_rlimit.c
+++ b/libxfs/xfs_log_rlimit.c
@@ -91,6 +91,7 @@ xfs_log_calc_trans_resv_for_minlogblocks(
 	 */
 	if (xfs_want_minlogsize_fixes(&mp->m_sb)) {
 		xfs_trans_resv_calc(mp, resv);
+		resv->tr_atomic_ioend = M_RES(mp)->tr_atomic_ioend;
 		return;
 	}
 
@@ -107,6 +108,9 @@ xfs_log_calc_trans_resv_for_minlogblocks(
 
 	xfs_trans_resv_calc(mp, resv);
 
+	/* Copy the dynamic transaction reservation types from the running fs */
+	resv->tr_atomic_ioend = M_RES(mp)->tr_atomic_ioend;
+
 	if (xfs_has_reflink(mp)) {
 		/*
 		 * In the early days of reflink, typical log operation counts
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 0a843deb50a118..cf735f946c8ac7 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -1281,6 +1281,15 @@ xfs_calc_namespace_reservations(
 	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 }
 
+STATIC void
+xfs_calc_default_atomic_ioend_reservation(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	/* Pick a default that will scale reasonably for the log size. */
+	resp->tr_atomic_ioend = resp->tr_itruncate;
+}
+
 void
 xfs_trans_resv_calc(
 	struct xfs_mount	*mp,
@@ -1375,4 +1384,10 @@ xfs_trans_resv_calc(
 	resp->tr_itruncate.tr_logcount += logcount_adj;
 	resp->tr_write.tr_logcount += logcount_adj;
 	resp->tr_qm_dqalloc.tr_logcount += logcount_adj;
+
+	/*
+	 * Now that we've finished computing the static reservations, we can
+	 * compute the dynamic reservation for atomic writes.
+	 */
+	xfs_calc_default_atomic_ioend_reservation(mp, resp);
 }

