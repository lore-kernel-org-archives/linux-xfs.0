Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7834CC7EE39
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Mar 2023 17:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbjCCRMf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Mar 2023 12:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbjCCRMe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Mar 2023 12:12:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DDB73644F
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 09:12:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC2536187E
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 17:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489D8C433EF;
        Fri,  3 Mar 2023 17:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677863552;
        bh=/iqlqNfDHlKgNNBVDDvt2m9cH0WUpZq+DxiangXpjC8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=u2jOkym3Cl++zUS49ih1l4nXRsNEw9EnkYDhk5VnUbNhcTbHYYMoiag8Fe1sI6RPh
         Qh7xTwj3hmEvbG7Fzxy55z7l+pTgN4ma5lT6zeTB8t9rKb+LkK1KHvCQ6FGBu7i8Q3
         K3px/i8+lgA3CBJtYitINiZ81Y3vNAXn1kYMYFLOiGHftdwq7VF/7g6VIEoBmejXYt
         OOK7iyNvbfrThZzG6tfdU46nyts148tvvXORvpADU10c5oziE8ZD/izQtagEcvS48s
         m7oC8PoCPJtxHx4vFpKQyjDvqV2VMFn58RtsMmJFDGhb1nogJ5xBkEiFEWP9wqYyDh
         Qlr/t19CYTDDQ==
Subject: [PATCH 13/13] xfs: revert "load secure hash algorithm for parent
 pointers"
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Date:   Fri, 03 Mar 2023 09:12:31 -0800
Message-ID: <167786355185.1543331.4836262247618832123.stgit@magnolia>
In-Reply-To: <167786347827.1543331.2803518928321606576.stgit@magnolia>
References: <167786347827.1543331.2803518928321606576.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

We don't use this anymore, so get rid of it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Kconfig      |    1 -
 fs/xfs/xfs_linux.h  |    1 -
 fs/xfs/xfs_mount.c  |   13 -------------
 fs/xfs/xfs_mount.h  |    3 ---
 fs/xfs/xfs_sha512.h |   42 ------------------------------------------
 fs/xfs/xfs_super.c  |    3 ---
 6 files changed, 63 deletions(-)
 delete mode 100644 fs/xfs/xfs_sha512.h


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 6422daaf8914..4798a147fd9e 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -5,7 +5,6 @@ config XFS_FS
 	select EXPORTFS
 	select LIBCRC32C
 	select FS_IOMAP
-	select CRYPTO_SHA512
 	help
 	  XFS is a high performance journaling filesystem which originated
 	  on the SGI IRIX platform.  It is completely multi-threaded, can
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 3f93a742b896..c05f7e309c3e 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -62,7 +62,6 @@ typedef __u32			xfs_nlink_t;
 #include <linux/rhashtable.h>
 #include <linux/xattr.h>
 #include <linux/mnt_idmapping.h>
-#include <crypto/hash.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index a5f3dce658e9..fb87ffb48f7f 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -983,19 +983,6 @@ xfs_mountfs(
 			goto out_agresv;
 	}
 
-	if (xfs_has_parent(mp)) {
-		struct crypto_shash	*tfm;
-
-		tfm = crypto_alloc_shash("sha512", 0, 0);
-		if (IS_ERR(tfm)) {
-			error = PTR_ERR(tfm);
-			goto out_agresv;
-		}
-		xfs_info(mp, "parent pointer hash %s",
-				crypto_shash_driver_name(tfm));
-		mp->m_sha512 = tfm;
-	}
-
 	return 0;
 
  out_agresv:
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 7c8e15e84cd6..c08f55cc4f36 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -244,9 +244,6 @@ typedef struct xfs_mount {
 #endif
 	/* Hook to feed file directory updates to an active online repair. */
 	struct xfs_hooks	m_dirent_update_hooks;
-
-	/* sha512 engine, if needed */
-	struct crypto_shash	*m_sha512;
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
diff --git a/fs/xfs/xfs_sha512.h b/fs/xfs/xfs_sha512.h
deleted file mode 100644
index d9756db63aa6..000000000000
--- a/fs/xfs/xfs_sha512.h
+++ /dev/null
@@ -1,42 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Copyright (C) 2023 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <djwong@kernel.org>
- */
-#ifndef __XFS_SHA512_H__
-#define __XFS_SHA512_H__
-
-struct sha512_state {
-	union {
-		struct shash_desc desc;
-		char __desc[sizeof(struct shash_desc) + HASH_MAX_DESCSIZE];
-	};
-};
-
-#define SHA512_DESC_ON_STACK(mp, name) \
-	struct sha512_state name = { .desc.tfm = (mp)->m_sha512 }
-
-#define SHA512_DIGEST_SIZE	64
-
-static inline int sha512_init(struct sha512_state *md)
-{
-	return crypto_shash_init(&md->desc);
-}
-
-static inline int sha512_done(struct sha512_state *md, unsigned char *out)
-{
-	return crypto_shash_final(&md->desc, out);
-}
-
-static inline int sha512_process(struct sha512_state *md,
-		const unsigned char *in, unsigned long inlen)
-{
-	return crypto_shash_update(&md->desc, in, inlen);
-}
-
-static inline void sha512_erase(struct sha512_state *md)
-{
-	memset(md, 0, sizeof(*md));
-}
-
-#endif /* __XFS_SHA512_H__ */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 610d72353f39..0432a4a096e8 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -738,8 +738,6 @@ xfs_mount_free(
 {
 	kfree(mp->m_rtname);
 	kfree(mp->m_logname);
-	if (mp->m_sha512)
-		crypto_free_shash(mp->m_sha512);
 	kmem_free(mp);
 }
 
@@ -1963,7 +1961,6 @@ static int xfs_init_fs_context(
 	if (fc->sb_flags & SB_SYNCHRONOUS)
 		mp->m_features |= XFS_FEAT_WSYNC;
 
-	mp->m_sha512 = NULL;
 	fc->s_fs_info = mp;
 	fc->ops = &xfs_context_ops;
 

