Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124522D3759
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 05:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752556631; cv=none; b=l62vlviTRZPWQTWJlGpNnkPXIV42UMj4E1C2WuSA99bvoAN2et1W80vM8BqCjwll1Ox7fN9MhPMhb4G2WREcFovOJwn93PGMPpknKPzncHyoWEQYukk0gODqJ6tEcknJrnAqX2X4H5+BdUQKSlhnV1r425aeDwQl64xYKtrwyAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752556631; c=relaxed/simple;
	bh=RakYFV8V0qt7wLFhRgGzFnLoKOeWov8dObyuXlfaW/Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i0QrFOlqNVVQjlvVxOfiXsXkL0/mfooqLs7BJLgeKOioaZviC29BPdwzM8zgGkzp64tLCWqPb5L5CKLlUB+EHNrjuiDG9qMSKj7rJbwmU6RdB0/HBlF++bfIMFjQwcTghEZJaFeHTPYbcTGa38MRNMe6Z4VYn9qltaN7YQRgdEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mmjHTpB5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mmjHTpB5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8CAC4CEE3;
	Tue, 15 Jul 2025 05:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752556629;
	bh=RakYFV8V0qt7wLFhRgGzFnLoKOeWov8dObyuXlfaW/Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mmjHTpB5SFsCHjXfgC5iFaR40TGZv+X0gOqcfqIfMRe7D/TEtlPy64TH22/gikn8o
	 /8iIAOSnLxor2wb9qs0paEb2x9vyCi71bGoJNVzHrRZZl46HGNV+svsmgPGg0wU6Hy
	 6SOlX1/Yvor3byC6tke4ggEFw6liL5a45053mRhMDCPNSj9pQ5k1I5MJUX7v/yxBwf
	 Yw1Wz1xgajjaxJX8TGlUI9v+mXeuNBAbyEdKtwbOeCKh6MO7Z3eXu6ELr+eMJnj0u+
	 r9vPnlI5YfAjxFiEHEXeGJERYwiNvuI5COc0pGQUOTKWY3oPFeH4BstpFRI5+Iuy7L
	 RSXnLk/LfNuWg==
Date: Mon, 14 Jul 2025 22:17:09 -0700
Subject: [PATCH 3/6] xfs: commit CoW-based atomic writes atomically
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, john.g.garry@oracle.com, catherine.hoang@oracle.com,
 john.g.garry@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <175255652167.1830720.8934470497908919729.stgit@frogsfrogsfrogs>
In-Reply-To: <175255652087.1830720.17606543077660806130.stgit@frogsfrogsfrogs>
References: <175255652087.1830720.17606543077660806130.stgit@frogsfrogsfrogs>
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

