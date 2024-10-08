Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB8C1DF75E
	for <linux-xfs@vger.kernel.org>; Tue,  8 Oct 2024 13:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393161; cv=none; b=oBxPp3A03B+vi3JkKd++f7luXeOtBxGWg/4tJ7MZg/qkXAeacYEi9AueOCtRRJcnr+CXwSoxAkEZNbOFbpZ2JHH0THpYBiTdGQhHmZRn8THLaUTobo4Kbz01tSA8Bj14Ac/GXEGW+KzUpo3yN2/yzkZmT7qwnQU7eNB2EHGq4/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393161; c=relaxed/simple;
	bh=zUrU1JyCea6ygXP4VC+tYB3c5Rzt9MflJ3e6TtUabbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PD/7aXchQdHIWbmPuUULSlpnGSpRI7CZraYKMUekNwMe2yfZxjzYCzunX1KmZCk7kTozLyT7AqsUiAh/QxPx9k/7/dy+r1sMT8v3ODZJeiLbhRmAMypzyymhnFuA41WolX7v3KZwt2CimRLrmCZja+5nR0FDH9PCrirCAP2/KUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ACqurShW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ACqurShW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728393158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M5Ki+NyakFVa6ZIR9/LFOx6scqjhoVnUvla7uOC/r/Q=;
	b=ACqurShWysWxYP3iEfmm6vwEDKd7JsY0RFk6bMBtN9FqPMgq6yfh2To1rCSWOjoF0fMkO/
	0LdmQoG8ZdKiq/S/KQSF/1ew2yMC1z6T50O4z3Y5VaPRCCvaLnF7NlLsx1j8VgezfL6m4U
	yjLtLJGTZKegvqSLnVpSVzb3dvO0f+0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-333-jk27p8LBMUKicU04lB0vuQ-1; Tue,
 08 Oct 2024 09:12:37 -0400
X-MC-Unique: jk27p8LBMUKicU04lB0vuQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 344EC195421D;
	Tue,  8 Oct 2024 13:12:36 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.32.133])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 66EDE19560AA;
	Tue,  8 Oct 2024 13:12:35 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	sandeen@sandeen.net
Subject: [RFC 4/4] xfs: support dynamic AG size growing on single AG filesystems
Date: Tue,  8 Oct 2024 09:13:48 -0400
Message-ID: <20241008131348.81013-5-bfoster@redhat.com>
In-Reply-To: <20241008131348.81013-1-bfoster@redhat.com>
References: <20241008131348.81013-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

This is a prototype for AG size growing of single AG filesystems.
The intent is to experiment with a potential solution to the
recurring problem where cloud-oriented filesystem images are
initially formatted to very small sizes and then copied/deployed and
grown to excessively high AG counts. This ultimately leads to
performance and scalability problems and can only currently be
resolved through a reformat and data migration.

Since the use case for a cloud image filesystem is known at creation
time, nothing prevents mkfs from starting with a geometry that is
more suitable to the post-deployment size. For example, the image
creator could use a larger file size if sparse files are handled
efficiently, or mkfs could in theory support creating a single AG
filesystem where the AG size is larger than the current fs size.
While mkfs doesn't currently support this, it is trivially enabled
and growfs already works as expected.

These options require enough familiarity with filesystem specific
geometry that image creators might not take these steps. Therefore,
the purpose of this prototype is to propose a growfs scheme that
would cooperate with a special mkfs time option that is specifically
designed for the cloud image use case. For example, consider a mkfs
command like 'mkfs.xfs --image <file>' where mkfs knows to create a
single AG filesystem with a larger than default log under the
implication that the image file is to be grown as part of a
deployment process.

The purpose of formatting with a single AG is that the AG size can
increase with no impact on existing data and functionality up until
a second AG is created. Therefore, kernel growfs of a single AG
filesystem can optionally decide to increase the AG size before
physically growing the fs. If the AG size is grown, the first AG is
extended just the same as a final runt AG is on a multi-ag
filesystem.

As an example, consider a 512MB filesystem image formatted and then
grown to 20GB. The standard mkfs and growfs sequence produces a
filesystem with over 150 AGs. A dynamic growfs can increase the AG
size to 5GB and produce a 4xAG filesystem more typical of how a 20GB
filesystem is formatted from the start.

This patch implements a simple AG size grow mechanism and sample
heuristic for resizing small, single AG filesystems. The heuristic
defines a minimum AG size of 4GB and otherwise targets a standard
4xAG geometry. This means that a small filesystem grown to anything
less than ~16GB will see an enforced 4GB AG size at the cost of
reduced redundancy (i.e. AG count). On the other hand, as the target
grow size increases beyond 16GB, the AG size is increased to
maintain a 4xAG geometry up until the maximum AG size is reached.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_fsops.c | 89 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 86 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 3b95a368584e..9cd70989fa1c 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -107,6 +107,64 @@ xfs_growfs_calc_agcount(
 	return nb_div;
 }
 
+/*
+ * Calculate post-grow AG size. AG size remains unchanged for everything other
+ * than agcount=1 filesystems with no format time alignment constraints.
+ *
+ * Otherwise, agcount=1 implies an "image mode" filesystem is being deployed and
+ * grown. To help prevent tiny AG size filesystems from being grown to excessive
+ * AG counts, we have the ability to extend the AG size before growing the
+ * physical size of the fs. The objective is to set a reasonable enough size to
+ * end up with multiple AGs for metadata redundancy.
+ */
+#define XFS_AGSIZE_THRESHOLD	(4ULL << 30)	/* 4GB */
+static xfs_agblock_t
+xfs_growfs_calc_agblocks(
+	struct xfs_mount	*mp,
+	xfs_rfsblock_t		nblocks)
+{
+	xfs_agblock_t		nagblocks = XFS_B_TO_FSB(mp, XFS_AGSIZE_THRESHOLD);
+
+	if (mp->m_sb.sb_agcount > 1 || mp->m_sb.sb_unit ||
+	    mp->m_sb.sb_agblocks >= nagblocks)
+		return mp->m_sb.sb_agblocks;
+
+	/*
+	 * This is a sample image mode growfs heuristic that reuses the 4GB
+	 * threshold from mkfs concurrency logic as a minimum AG size. AG size
+	 * is set to the maximum of 4GB or 25% of the target grow size. IOW,
+	 * filesystems remain single AG until grown to at least 4GB plus the
+	 * minimum number of blocks required to create a runt second AG. The AG
+	 * size is grown larger for grows beyond the 16GB (4 x 4GB AGs) total
+	 * size threshold to target typical 4xAG mkfs time geometry.
+	 *
+	 * The end result is that grows from tiny to very large end up with a
+	 * more typical geometry. Smaller grows may not, but the 4GB minimum AG
+	 * size prevents the situation of growing MB sized AGs to pathological
+	 * AG counts.
+	 *
+	 * XXX: We need to decide how to handle filesystems that remain single
+	 * AG after grow. It should be rare enough to grow a filesystem to a
+	 * sub-4GB size that we may not have to be too paranoid about it, but a
+	 * warning or kernel message is probably warranted at minimum.
+	 */
+	if (nblocks < (nagblocks + XFS_MIN_AG_BLOCKS)) {
+		/* grow too small, remain single AG */
+		nagblocks = nblocks;
+	} else {
+		/*
+		 * Enough space for at least a runt second AG. Use the larger of
+		 * 25% of the new target size and the threshold size.
+		 */
+		do_div(nblocks, 4);
+		nagblocks = max_t(xfs_rfsblock_t, nagblocks, nblocks);
+	}
+
+	/* clamp to current ag size and max allowed */
+	nagblocks = min_t(xfs_rfsblock_t, nagblocks, XFS_B_TO_FSB(mp, XFS_MAX_AG_BYTES));
+	return max_t(xfs_rfsblock_t, nagblocks, mp->m_sb.sb_agblocks);
+}
+
 /*
  * growfs operations
  */
@@ -117,7 +175,7 @@ xfs_growfs_data_private(
 {
 	struct xfs_buf		*bp;
 	int			error;
-	xfs_agblock_t		nagblocks;
+	xfs_agblock_t		oagblocks, nagblocks;
 	xfs_agnumber_t		nagcount;
 	xfs_agnumber_t		nagimax = 0;
 	xfs_rfsblock_t		nb;
@@ -142,7 +200,9 @@ xfs_growfs_data_private(
 		xfs_buf_relse(bp);
 	}
 
-	nagblocks = mp->m_sb.sb_agblocks;
+	oagcount = mp->m_sb.sb_agcount;
+	oagblocks = mp->m_sb.sb_agblocks;
+	nagblocks = xfs_growfs_calc_agblocks(mp, nb);
 
 	nagcount = xfs_growfs_calc_agcount(mp, nagblocks, &nb);
 	delta = nb - mp->m_sb.sb_dblocks;
@@ -158,7 +218,30 @@ xfs_growfs_data_private(
 	if (delta == 0)
 		return 0;
 
-	oagcount = mp->m_sb.sb_agcount;
+	/*
+	 * Grow agblocks in a separate transaction to ensure that the
+	 * subsequent grow transaction sees the updated superblock. We only
+	 * grow agblocks for single AG filesystems where an outsized AG size is
+	 * harmless, so this doesn't necessarily need to be atomic with the
+	 * broader growfs operation.
+	 *
+	 * Nonetheless, this is included here mainly for prototyping
+	 * convenience. We might want to consider splitting this off into a
+	 * separate FSGROWFSAG operation, but that's open for discussion.
+	 * Single AG fs' may also be exclusive enough to handle here as such.
+	 */
+	if (nagblocks > oagblocks) {
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
+				XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE,
+				&tp);
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGBLOCKS, nagblocks - oagblocks);
+		xfs_trans_set_sync(tp);
+		error = xfs_trans_commit(tp);
+		if (error)
+			return error;
+		oagblocks = nagblocks;
+	}
+
 	/* allocate the new per-ag structures */
 	if (nagcount > oagcount) {
 		error = xfs_initialize_perag(mp, nagcount, nb, &nagimax);
-- 
2.46.2

