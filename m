Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193AD27AC31
	for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 11:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787572022; cv=none; b=HgT6T0SVIsHFlaJ8iHhJdd1e4URoCWu6qUL2RguRpN0o5w9H29d0Tr7smkNzYtoQ6aGLpYX4HhcCJwakN4qG8aGC5sevUO+rwdb1fldZjFVyu7n95M5RvAjxMh1WSH1quVm/HkWCWJ8TYDSACA7XTllAzH7I+K4kmiPa3C0QQTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787572022; c=relaxed/simple;
	bh=omC1PaN+AyjRgj8T5oM4LbkFXe/dXINKoYAZYKhMWn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyFL4CKwyXGHcAoe+16ATncs83epkt4HnZ2lxVYR0HJsp3owVqz+uef0SsyvGffGQQfoLVep8ks9Nsv4NQd0xoIspXwLKmqroPVFwm1m93ZOcpTrYQ1CC+YpiUZVT4SEHfm9Up1To8plo6bk/L2te49YV2O4dJ5UQb88ONRCotE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JIZdXulY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JIZdXulY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E381F000E9;
	Mon, 24 Aug 2026 11:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787572020;
	bh=nSFK7mpw7crsDIQSQbKr/KMQK2nNGQKi7Ehdigr8Hzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JIZdXulYq5uLNZbyy5dovU3nDdpqbA+vvWUqzMKwXiv1ocbmAySABPawiHZZJET09
	 Kl7Jic0xJU1wAXpeEEzR8ElB176De1YBRTLwCFM70Uka4/LnuIhBcOli5CR2DWZunX
	 5hnUCA6yZB0ErBoLbh/Wyq21/9oCLK/o9bc5hkIDkAm6TF05sPcFi4hz0ZxXQm1SPh
	 dXORhgxRdQ2JhAleHKcwH9BgPbWU/HHs0N+kO5y7cGa9qd6JOW9tcGlFx8bgN5Wu01
	 /4mxrPGqt1fqwzdpBCbnTdWfHbG7x0YRM+0wdVsiYYs85ZkAwVYHe5Vi2H1AVk0AU4
	 5yGHxgi/9/ZGw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	aalbersh@kernel.org
Cc: bestswngs@gmail.com,
	brauner@kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	cmaiolino@redhat.com,
	dawei.feng@seu.edu.cn,
	djwong@kernel.org,
	gaoyingjie@uniontech.com,
	hch@lst.de,
	jiapenglin@tencent.com,
	roland.mainz@nrubsig.org,
	xmei5@asu.edu
Subject: [PATCH 19/21] xfs: fix off-by-one in rtrefcount btree root level validation
Date: Mon, 24 Aug 2026 12:40:17 +0200
Message-ID: <20260824104022.420566-20-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260824104022.420566-1-aalbersh@kernel.org>
References: <20260824104022.420566-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiang Mei <xmei5@asu.edu>

Source kernel commit: cc3144da377de5fb422d44a2311f978623f7c900

xfs_rtrefcountbt_compute_maxlevels() sets

mp->m_rtrefc_maxlevels = min(d_maxlevels, r_maxlevels) + 1;

where the trailing "+ 1" already accounts for the inode-root level, so the
deepest valid on-disk root level is m_rtrefc_maxlevels - 1 and a cursor must
satisfy bc_nlevels <= bc_maxlevels (= m_rtrefc_maxlevels).

The two on-disk validation paths, xfs_rtrefcountbt_verify() and
xfs_iformat_rtrefcount(), check the root level with ">" instead of ">=", so a
crafted rtreflink (metadir + realtime + reflink) image whose
/rtgroups/N.refcount inode has bb_level == m_rtrefc_maxlevels is accepted on
mount. xfs_rtrefcountbt_init_cursor() then sets bc_nlevels = bb_level + 1,
exceeding bc_maxlevels by one. Since the xfs_rtrefcountbt_cur slab object is
sized for exactly bc_maxlevels entries, the first btree op on such a cursor
indexes bc_levels[m_rtrefc_maxlevels] past the end of the object. This is
reached by the first rtrefcount cursor built after mount, via log/CoW
recovery (xfs_reflink_recover_cow() during xfs_mountfs()) or an
FS_IOC_GETFSMAP over the realtime device.

Reject a root level equal to m_rtrefc_maxlevels, matching the ">=" form
already used by the sibling data-device refcount/rmap verifiers and the
in-memory rtrmap verifier.

BUG: KASAN: slab-out-of-bounds in xfs_btree_lookup (fs/xfs/libxfs/xfs_btree.c:2101)
Write of size 2 at addr ffff888018391658 by task exploit/144
xfs_btree_lookup (fs/xfs/libxfs/xfs_btree.c:2101)
xfs_btree_query_range (fs/xfs/libxfs/xfs_btree.c:5308)
xfs_refcount_recover_cow_leftovers (fs/xfs/libxfs/xfs_refcount.c:2113)
xfs_reflink_recover_cow (fs/xfs/xfs_reflink.c:1085)
xlog_recover_finish (fs/xfs/xfs_log_recover.c:3551)
xfs_mountfs (fs/xfs/xfs_mount.c:1158)
xfs_fs_fill_super (fs/xfs/xfs_super.c:1940)
get_tree_bdev_flags (fs/super.c:1634)
vfs_get_tree (fs/super.c:1694)
path_mount (fs/namespace.c:4161)
__x64_sys_mount (fs/namespace.c:4367)
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
The buggy address belongs to the cache xfs_rtrefcountbt_cur of size 216
The buggy address is located 8 bytes to the right of
allocated 216-byte region [ffff888018391578, ffff888018391650)
Kernel panic - not syncing: Fatal exception

Fixes: 9abe03a0e4f978 ("xfs: introduce realtime refcount btree ondisk definitions")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtrefcount_btree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index 2c51b618e1ce..02230c8ef0f0 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -199,7 +199,7 @@ xfs_rtrefcountbt_verify(
 	if (fa)
 		return fa;
 	level = be16_to_cpu(block->bb_level);
-	if (level > mp->m_rtrefc_maxlevels)
+	if (level >= mp->m_rtrefc_maxlevels)
 		return __this_address;
 
 	return xfs_btree_fsblock_verify(bp, mp->m_rtrefc_mxr[level != 0]);
@@ -649,7 +649,7 @@ xfs_iformat_rtrefcount(
 	numrecs = be16_to_cpu(dfp->bb_numrecs);
 	level = be16_to_cpu(dfp->bb_level);
 
-	if (level > mp->m_rtrefc_maxlevels ||
+	if (level >= mp->m_rtrefc_maxlevels ||
 	    xfs_rtrefcount_droot_space_calc(level, numrecs) > dsize) {
 		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
-- 
2.55.0

