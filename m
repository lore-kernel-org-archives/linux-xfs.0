Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CFF4734CF
	for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2026 10:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791368092; cv=none; b=NCAhG67shoJ1p8cVebjSCbA+heE+8ndsixot3UQwsdxvUWyHXhGPHDmc3m2J31vYwZm2fYziZ99hDzvHB9kufQ3kTGWYrJNjDz1MsPzdwQpCkDk8+HOhoLmT4QVBYC1u+r8bbCVnfMwJ9wJSvFcw2VleehhSPQ+D3HvRNYCNdrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791368092; c=relaxed/simple;
	bh=tebKim9JaLkNw548/CccRDBoYLBI51uOmrmdBu1YhPk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EifZ9mYQ5F/QAbUsM8lg1QnptA3PhYalbmU6OV5gxSf8p2p4yi03EZb867ktKcd8YUoILwq/n6VMJCRi48Uip3VfZIhQ95AvWXmmuwJkfAQ13N7bnPJL4nueTEKukJ3HRgwfCLBT+mZrN6oECuxCRkW0tWEopraWOrz01IcinoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4j089z5sFQzKnV5;
	Wed, 07 Oct 2026 12:14:31 +0200 (CEST)
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of kernel@pankajraghav.com designates 2001:67c:2050:b231:465::102 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
From: Pankaj Raghav <p.raghav@samsung.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: pankaj.raghav@linux.dev,
	John Garry <john.g.garry@oracle.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	p.raghav@samsung.com,
	gost.dev@samsung.com
Subject: [PATCH v2] xfs: don't limit software atomic writes by the group alignment
Date: Wed,  7 Oct 2026 12:14:25 +0200
Message-ID: <20261007101425.3741087-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4j089z5sFQzKnV5

xfs_calc_group_awu_max() clamps the atomic write unit maximum to the
greatest power-of-two factor of the group size when the device advertises
atomic writes, so that allocations can be made naturally aligned for
REQ_ATOMIC. But that value is the software limit: it is only used when
reflink is enabled, and out of place writes through the COW fork have no
alignment requirement.

Compute the software limit from the group size alone, and apply the
alignment constraint in xfs_get_atomic_write_max_opt() instead, which is
what reports the size that can be offloaded to the hardware.

Results on a 14TB device with 16k hardware atomic support with 16k
blocksize:

Without patches:
[nix-shell:~]# trace-cmd report
cpus=16
mount-617   [009]  1184.719159: xfs_calc_atomic_write_unit_max: dev 259:2 ag
max_write 131072 max_ioend 4096 max_gsize 2 awu_max 2

[nix-shell:~]# ./statx /media/test/hello.txt
/media/test/hello.txt:
   stx_atomic_write_unit_min:            16384
   stx_atomic_write_unit_max:            32768
   stx_atomic_write_unit_max_opt:        16384
   stx_atomic_write_segments_max:        1

With patches:
[nix-shell:~]# trace-cmd report
cpus=16
mount-598   [005]   319.692000: xfs_calc_atomic_write_unit_max: dev 259:2 ag
max_write 131072 max_ioend 4096 max_gsize 33554432 awu_max 4096

[nix-shell:~]# ./statx /media/test/hello.txt
/media/test/hello.txt:
   stx_atomic_write_unit_min:            16384
   stx_atomic_write_unit_max:            67108864
   stx_atomic_write_unit_max_opt:        16384
   stx_atomic_write_segments_max:        1

Fixes: 0c438dcc3150 ("xfs: add xfs_calc_atomic_write_unit_max()")
Assisted-by: LLM
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
Changes since v1:
- Change opt to max_opt
- Move xfs_inode_group_type helper to xfs_inode.h
- Change commit message with the latest xfsprogs

 fs/xfs/xfs_inode.h |  9 +++++++++
 fs/xfs/xfs_iops.c  | 21 ++++++++++++++++-----
 fs/xfs/xfs_mount.c | 35 ++++++++++++++++++++++++-----------
 fs/xfs/xfs_mount.h |  2 ++
 4 files changed, 51 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index ca96ba096359..64b47fa17b1a 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -353,6 +353,15 @@ static inline bool xfs_inode_has_bigrtalloc(const struct xfs_inode *ip)
 	return XFS_IS_REALTIME_INODE(ip) && ip->i_mount->m_sb.sb_rextsize > 1;
 }
 
+/*
+ * Return the type of the group that data for a given inode is allocated from.
+ */
+static inline enum xfs_group_type
+xfs_inode_group_type(const struct xfs_inode *ip)
+{
+	return XFS_IS_REALTIME_INODE(ip) ? XG_TYPE_RTG : XG_TYPE_AG;
+}
+
 /*
  * Return the buftarg used for data allocations on a given inode.
  */
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index f67a541ef35a..6b28b9c7de84 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -642,19 +642,20 @@ xfs_get_atomic_write_max(
 	 * then advertise a maximum size of whatever we can complete through
 	 * that means.  Hardware support is reported via max_opt, not here.
 	 */
-	if (XFS_IS_REALTIME_INODE(ip))
-		return XFS_FSB_TO_B(mp, mp->m_groups[XG_TYPE_RTG].awu_max);
-	return XFS_FSB_TO_B(mp, mp->m_groups[XG_TYPE_AG].awu_max);
+	return XFS_FSB_TO_B(mp, mp->m_groups[xfs_inode_group_type(ip)].awu_max);
 }
 
 unsigned int
 xfs_get_atomic_write_max_opt(
 	struct xfs_inode	*ip)
 {
+	struct xfs_mount	*mp = ip->i_mount;
 	unsigned int		awu_max = xfs_get_atomic_write_max(ip);
+	xfs_extlen_t		align_max_fsb;
+	unsigned int		max_opt;
 
 	/* if the max is 1x block, then just keep behaviour that opt is 0 */
-	if (awu_max <= ip->i_mount->m_sb.sb_blocksize)
+	if (awu_max <= mp->m_sb.sb_blocksize)
 		return 0;
 
 	/*
@@ -663,7 +664,17 @@ xfs_get_atomic_write_max_opt(
 	 * less than our out of place write limit, but we don't want to exceed
 	 * the awu_max.
 	 */
-	return min(awu_max, xfs_inode_buftarg(ip)->bt_awu_max);
+	max_opt = min(awu_max, xfs_inode_buftarg(ip)->bt_awu_max);
+
+	/*
+	 * REQ_ATOMIC writes also have to be naturally aligned on disk, so we
+	 * cannot promise more than the largest extent that the allocator is
+	 * able to align within a group.
+	 */
+	align_max_fsb = xfs_calc_group_awu_align_max(mp,
+						xfs_inode_group_type(ip));
+
+	return min_t(xfs_fsize_t, max_opt, XFS_FSB_TO_B(mp, align_max_fsb));
 }
 
 static void
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index be90c7b03994..b7110b3d023b 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -674,15 +674,13 @@ static inline xfs_extlen_t xfs_calc_atomic_write_max(struct xfs_mount *mp)
 }
 
 /*
- * If the underlying device advertises atomic write support, limit the size of
- * atomic writes to the greatest power-of-two factor of the group size so
- * that every atomic write unit aligns with the start of every group.  This is
- * required so that the allocations for an atomic write will always be
- * aligned compatibly with the alignment requirements of the storage.
+ * The largest out of place write is the number of blocks that user files can
+ * allocate from any group.
  *
- * If the device doesn't advertise atomic writes, then there are no alignment
- * restrictions and the largest out-of-place write we can do ourselves is the
- * number of blocks that user files can allocate from any group.
+ * This is a software limit, so it deliberately does not take the alignment
+ * requirements of the storage into account. An atomic write that cannot be
+ * handed to the device as a single naturally aligned REQ_ATOMIC bio is
+ * completed through the COW fork instead, which has no such requirement.
  */
 static xfs_extlen_t
 xfs_calc_group_awu_max(
@@ -690,15 +688,30 @@ xfs_calc_group_awu_max(
 	enum xfs_group_type	type)
 {
 	struct xfs_groups	*g = &mp->m_groups[type];
-	struct xfs_buftarg	*btp = xfs_group_type_buftarg(mp, type);
 
 	if (g->blocks == 0)
 		return 0;
-	if (btp && btp->bt_awu_min > 0)
-		return max_pow_of_two_factor(g->blocks);
 	return rounddown_pow_of_two(g->blocks);
 }
 
+/*
+ * Compute the largest atomic write unit for which the allocator can guarantee
+ * naturally aligned extents in this group type.
+ *
+ * Hardware atomic writes have to be naturally aligned on disk.
+ */
+xfs_extlen_t
+xfs_calc_group_awu_align_max(
+	struct xfs_mount	*mp,
+	enum xfs_group_type	type)
+{
+	struct xfs_groups	*g = &mp->m_groups[type];
+
+	if (g->blocks == 0)
+		return 0;
+	return max_pow_of_two_factor(g->blocks);
+}
+
 /* Compute the maximum atomic write unit size for each section. */
 static inline void
 xfs_calc_atomic_write_unit_max(
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 894ff2f4ecbd..cbcfb89c67a4 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -820,6 +820,8 @@ static inline void xfs_mod_sb_delalloc(struct xfs_mount *mp, int64_t delta)
 
 int xfs_set_max_atomic_write_opt(struct xfs_mount *mp,
 		unsigned long long new_max_bytes);
+xfs_extlen_t xfs_calc_group_awu_align_max(struct xfs_mount *mp,
+		enum xfs_group_type type);
 
 static inline struct xfs_buftarg *
 xfs_group_type_buftarg(

base-commit: d10270a8e5fde59eb68921fddfe40c6c2a31a954
-- 
2.51.2

