Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C5222083
	for <linux-xfs@vger.kernel.org>; Sun, 12 Jul 2026 00:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783816022; cv=none; b=qgQKZjjIrkOycXwawraplcLHVsj9rykw8sQDN1tgDsyaxcyOS5reRSInD8mHONoTD3tiQBamQi/i+u6Xgfb+C1/XWPxS5Rs0rb1QfNu/WkP544hgiQ6b/FE2LaQdnqeF9IcA4N9qkvFZ/4ehvl4IRk846rTYhFKB6+n6Kg0H/m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783816022; c=relaxed/simple;
	bh=pFOImWJaWC+O/qgUUJVGr9/2spNYBZqmxDb0l1I0Nhk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bU1j20om/vzdx/U+7/jV0Ob0kdNGQmu06/cSkTgDIox4k67YKHAmBNtk+M79sKKx9yn8S92301OHA2q331EX9ec7KRUl5Kjbqh2nQjLEv63r36VjljGWUDj/nzoRrNNDuqoEJO4YwaRWu+hYVkLvEmCcbEGuaqxwj/LE/pen9iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=KQAmpYR5; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="KQAmpYR5"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-848595b338cso2276508b3a.0
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jul 2026 17:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1783816020; x=1784420820; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=p/2hYk18e/fNYE7v3xFrEU1ws4tuPf19DZFB+i1uOzc=;
        b=KQAmpYR5eLMIbKzcksDX19cda7hg92VVPeujL3xP7WTsEZVIFLRO+3P4LZRDiM6DYe
         dWugjvhXJGE9X3tGCyCcAY4tlKBRqSAQtabmZqWfxm8oJIdVGj4YEWnanwOOfQ5puYdr
         6tdXhPqQlln9yAlCwlZddFzlypXFvyT47e1KVIeLgxFNgV3US9JkY0uVfebdkjkiHR4J
         CR5BbKO9yTlM5+fbseV+znNAoJe/fO3Bks7Mp/wyyKpXjMPI6Tm/CUu/wCWlOl+pbaL+
         ESiD0Dv7tlQddvGP2o3ZGMTeFMFarzxQF+F2feY5EryZ/06/J3cRR1/K3xfWhNhcWfb4
         SK/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783816020; x=1784420820;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p/2hYk18e/fNYE7v3xFrEU1ws4tuPf19DZFB+i1uOzc=;
        b=bD724NpGJuR14ckdyOG1LQtawDNqbfo4tD/HJdt7wk21yNJAdBpTkced3U2Tc13lVD
         eC+s1GlQYeZc7Nou3+ufXPDT9jEA4vCFvY0KFnhp9I1R0IB9v3g+1ylN87c7Vth9udah
         SnYqIcu0yYZufruhj3tW51QErQKb5VJ2NG7f2+KWJlM6tZVVcnG/qkb/9OuqCxcBrq0X
         cKNSTvbSRwSUBn/Ie7r5oMu9SJp37iYjRIH4gMAP4A+uwJPoYXnr6km7AJZczRRpn8s4
         l/EXDsrrQSo5GZfg80T7+9ETAsAM9QKWMaVfJYYBDk1HXFmCcWqH5lriOawR4R7WfE9U
         h/MQ==
X-Forwarded-Encrypted: i=1; AHgh+RpX0155Cq593dcWEPITILWwMVNreNZ4bh8Wv7bf+69BMwKdjgl1ajkYm2KVjPgaCUGM4lQK5Re7ECg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjOVAY9AVEQ6DZmKV11Apqe0CpLtpG5iAT8lO5LLvTx5hco7NA
	aHU+FEvTc8oenoGNhGif8L3jm4451Ou8xs3CszGNumHw6wnxOCTAQ9+N+ql5DUlfvQ==
X-Gm-Gg: AfdE7ck1SWbsc3sxf7ELPkmDCQKM6nipWhO0idC7CI+o6TucySRTXh9gJOMSxYX4PrG
	K+ttGh1n4z8jGcdx1jFFy0haeWJLMDpuXDYLNKPGiRJ4GDxDK+4gegs1GdQQqaIhIasGU6Lh7jf
	2JNSKjfBhLBKbl+kKr3aQ11sd3GRA8SfTRhFEMFq2rvdPOVfv4rdiPj/7s9CTL+2Ubn03+z/cxy
	HNUViRIv6teQTq9kcuEB0N4kV68S8XCDwEDAL1XiZc2YyYYC4VzzBksX1YnEe/4RvahOzv6tZn1
	unvZvQOYj6I0yr4s11gYWdjLLiMT51aZTaMiktBZZ3ddtlNW4SdITxLBwm6aoMJ61cGvpEblsKl
	2tWI1XG0UhONQYbdsgMEohqWdY9XE5qUbXe9mTxZiN0lLS7C0U0I4v6fouKMe5om95xbZ5aXN
X-Received: by 2002:a05:6a00:c84:b0:847:7ece:3426 with SMTP id d2e1a72fcca58-8488979782emr3902127b3a.58.1783816019835;
        Sat, 11 Jul 2026 17:26:59 -0700 (PDT)
Received: from p1.. ([2607:fb90:ec97:866f:3e08:175:39c0:3297])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6d4d000sm12105025b3a.34.2026.07.11.17.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 17:26:57 -0700 (PDT)
From: Xiang Mei <xmei5@asu.edu>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bestswngs@gmail.com,
	Xiang Mei <xmei5@asu.edu>
Subject: [PATCH] xfs: fix off-by-one in rtrefcount btree root level validation
Date: Sat, 11 Jul 2026 17:26:44 -0700
Message-ID: <20260712002644.2519804-1-xmei5@asu.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

Fixes: 9abe03a0e4f9 ("xfs: introduce realtime refcount btree ondisk definitions")
Fixes: f0415af60f48 ("xfs: wire up a new metafile type for the realtime refcount")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
---
 fs/xfs/libxfs/xfs_rtrefcount_btree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index f27b80a199ba..22acc1411aac 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -201,7 +201,7 @@ xfs_rtrefcountbt_verify(
 	if (fa)
 		return fa;
 	level = be16_to_cpu(block->bb_level);
-	if (level > mp->m_rtrefc_maxlevels)
+	if (level >= mp->m_rtrefc_maxlevels)
 		return __this_address;
 
 	return xfs_btree_fsblock_verify(bp, mp->m_rtrefc_mxr[level != 0]);
@@ -651,7 +651,7 @@ xfs_iformat_rtrefcount(
 	numrecs = be16_to_cpu(dfp->bb_numrecs);
 	level = be16_to_cpu(dfp->bb_level);
 
-	if (level > mp->m_rtrefc_maxlevels ||
+	if (level >= mp->m_rtrefc_maxlevels ||
 	    xfs_rtrefcount_droot_space_calc(level, numrecs) > dsize) {
 		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
-- 
2.43.0

