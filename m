Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D808BC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjBPUvr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjBPUvp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:51:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43DB4BEA8
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:51:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60438B82958
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22478C433D2;
        Thu, 16 Feb 2023 20:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580702;
        bh=NmdTBs5yThDdU56H4M0ZQXhwNN9h6w6Lt03FP2T4/5k=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=i2EHVDhj7QGbaJ5kj805wjyqY4eg2m2Ur/R3ID/R0OVoSIeQVSeld8LVP6Vc0h1ft
         Izh8fVVbAVwsGGoh3iadkqNc/Gd6UqwnWpaGHT3HSdQ8W8IEOrkf1Gukst7lUWRUSw
         TwLYkppqJL41g1HSXhUlFf86GIMQ4Cc8e1C0vdfTEjxTjsST0fgSmxg/OWO5LhplJK
         M6YoEGGzh5Mw1UM2wCI7RqkdaB60h7nLolzxI26BEs8ZhjNOifWNe43hRo6qh0CM2Z
         +C029CCRubFpO8dn6RA0TZ76PozjnooDjCwliDgxb2VvTYARHhQ9UC37ZyQUIS4O4M
         48WSWnroQdvNA==
Date:   Thu, 16 Feb 2023 12:51:41 -0800
Subject: [PATCH 1/5] xfs: load secure hash algorithm for parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657875880.3475422.10684205315154918672.stgit@magnolia>
In-Reply-To: <167657875861.3475422.10929602650869169128.stgit@magnolia>
References: <167657875861.3475422.10929602650869169128.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

We're about to start replacing the diroffset field of parent pointers
with a collision-resistant hash of the directory entry name.  Start by
attaching the sha512 crypto implementation if parent pointers are
attached.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Kconfig     |    1 +
 fs/xfs/xfs_linux.h |    1 +
 fs/xfs/xfs_mount.c |   13 +++++++++++++
 fs/xfs/xfs_mount.h |    3 +++
 fs/xfs/xfs_super.c |    3 +++
 5 files changed, 21 insertions(+)


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 4798a147fd9e..6422daaf8914 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -5,6 +5,7 @@ config XFS_FS
 	select EXPORTFS
 	select LIBCRC32C
 	select FS_IOMAP
+	select CRYPTO_SHA512
 	help
 	  XFS is a high performance journaling filesystem which originated
 	  on the SGI IRIX platform.  It is completely multi-threaded, can
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index c05f7e309c3e..3f93a742b896 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -62,6 +62,7 @@ typedef __u32			xfs_nlink_t;
 #include <linux/rhashtable.h>
 #include <linux/xattr.h>
 #include <linux/mnt_idmapping.h>
+#include <crypto/hash.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index fb87ffb48f7f..a5f3dce658e9 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -983,6 +983,19 @@ xfs_mountfs(
 			goto out_agresv;
 	}
 
+	if (xfs_has_parent(mp)) {
+		struct crypto_shash	*tfm;
+
+		tfm = crypto_alloc_shash("sha512", 0, 0);
+		if (IS_ERR(tfm)) {
+			error = PTR_ERR(tfm);
+			goto out_agresv;
+		}
+		xfs_info(mp, "parent pointer hash %s",
+				crypto_shash_driver_name(tfm));
+		mp->m_sha512 = tfm;
+	}
+
 	return 0;
 
  out_agresv:
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index c08f55cc4f36..7c8e15e84cd6 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -244,6 +244,9 @@ typedef struct xfs_mount {
 #endif
 	/* Hook to feed file directory updates to an active online repair. */
 	struct xfs_hooks	m_dirent_update_hooks;
+
+	/* sha512 engine, if needed */
+	struct crypto_shash	*m_sha512;
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0432a4a096e8..610d72353f39 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -738,6 +738,8 @@ xfs_mount_free(
 {
 	kfree(mp->m_rtname);
 	kfree(mp->m_logname);
+	if (mp->m_sha512)
+		crypto_free_shash(mp->m_sha512);
 	kmem_free(mp);
 }
 
@@ -1961,6 +1963,7 @@ static int xfs_init_fs_context(
 	if (fc->sb_flags & SB_SYNCHRONOUS)
 		mp->m_features |= XFS_FEAT_WSYNC;
 
+	mp->m_sha512 = NULL;
 	fc->s_fs_info = mp;
 	fc->ops = &xfs_context_ops;
 

