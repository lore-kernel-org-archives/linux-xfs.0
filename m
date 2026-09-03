Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51853495518
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 11:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435733; cv=none; b=TnIdaDZYWeyAZUxmSf8YHNzv5wf28I/VddRN+SVVgpx0dpuPRDfG1SavjkxarCxbMNEQoQwAWsPe2I3cll7NtzFOgbGq+1N3HK0p8BuZ2XwPOqZUxF9KpgpIQ90zKmdHTIpqhpDf7NX7odteF59+2sgmt5NIclxRdiURWYiB6mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435733; c=relaxed/simple;
	bh=omC1PaN+AyjRgj8T5oM4LbkFXe/dXINKoYAZYKhMWn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMHucEuebytBMfcL0Gc0L4Z+NoUr8THYFOwJlSGIGS3Z2xxzg5MuEGKpfnQmjZlfkh45aBo5iRIMA4EiA/UMExwf+3Z7F/LDW5saFY1RGI48BY1pOqgy4aR7ny6q+mCDChqRpslVKeizgWdnkzze6/Vfwo1heiS82aWqZDBt0MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i2xuvv6N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i2xuvv6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFB21F00A3A;
	Thu,  3 Sep 2026 11:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788435718;
	bh=nSFK7mpw7crsDIQSQbKr/KMQK2nNGQKi7Ehdigr8Hzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i2xuvv6NDhkF9Hui5An3xoFlgCMkHudYahFQU2SsDnQd3nbmEARHpJjIJuJxcJTt1
	 vGYLMSQlMt0XseGcvNE6pP73056iE9uYsDoQk+yGPOOZfIJhO5n7PmQ6y/XQNJ+IEC
	 SE+BPDyUw2TeCadhEX/ebkqriCcPnDw0tRfa7wueW8EPOaKhDi6KR90jcM/Kp4hjZ9
	 AmZEuxaiIpcHcZto80tGjOaEbZ1OoWAjcSiuTq/H+5sQLjQj5Zab1JBtTrpUs+2sbr
	 6FOy1tYJ54lwGCyODpxetwbkQJHZwJDLqasoIpNjbAaJ/3EqbX90JKAqHsJ00h17lH
	 lGjL8PL3oN9+w==
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
Subject: [PATCH v2 21/23] xfs: fix off-by-one in rtrefcount btree root level validation
Date: Thu,  3 Sep 2026 13:40:03 +0200
Message-ID: <20260903114022.570210-22-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903114022.570210-1-aalbersh@kernel.org>
References: <20260903114022.570210-1-aalbersh@kernel.org>
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

