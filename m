Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:45965 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752123AbdITUw4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2017 16:52:56 -0400
Received: by mail-pg0-f44.google.com with SMTP id 188so2344651pgb.2
        for <linux-xfs@vger.kernel.org>; Wed, 20 Sep 2017 13:52:56 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v3 15/31] xfs: Define usercopy region in xfs_inode slab cache
Date: Wed, 20 Sep 2017 13:45:21 -0700
Message-Id: <1505940337-79069-16-git-send-email-keescook@chromium.org>
In-Reply-To: <1505940337-79069-1-git-send-email-keescook@chromium.org>
References: <1505940337-79069-1-git-send-email-keescook@chromium.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, David Windsor <dave@nullcore.net>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com

From: David Windsor <dave@nullcore.net>

The XFS inline inode data, stored in struct xfs_inode_t field
i_df.if_u2.if_inline_data and therefore contained in the xfs_inode slab
cache, needs to be copied to/from userspace.

cache object allocation:
    fs/xfs/xfs_icache.c:
        xfs_inode_alloc(...):
            ...
            ip = kmem_zone_alloc(xfs_inode_zone, KM_SLEEP);

    fs/xfs/libxfs/xfs_inode_fork.c:
        xfs_init_local_fork(...):
            ...
            if (mem_size <= sizeof(ifp->if_u2.if_inline_data))
                    ifp->if_u1.if_data = ifp->if_u2.if_inline_data;
            ...

    fs/xfs/xfs_symlink.c:
        xfs_symlink(...):
            ...
            xfs_init_local_fork(ip, XFS_DATA_FORK, target_path, pathlen);

example usage trace:
    readlink_copy+0x43/0x70
    vfs_readlink+0x62/0x110
    SyS_readlinkat+0x100/0x130

    fs/xfs/xfs_iops.c:
        (via inode->i_op->get_link)
        xfs_vn_get_link_inline(...):
            ...
            return XFS_I(inode)->i_df.if_u1.if_data;

    fs/namei.c:
        readlink_copy(..., link):
            ...
            copy_to_user(..., link, len);

        generic_readlink(dentry, ...):
            struct inode *inode = d_inode(dentry);
            const char *link = inode->i_link;
            ...
            if (!link) {
                    link = inode->i_op->get_link(dentry, inode, &done);
            ...
            readlink_copy(..., link);

In support of usercopy hardening, this patch defines a region in the
xfs_inode slab cache in which userspace copy operations are allowed.

This region is known as the slab cache's usercopy region. Slab caches can
now check that each copy operation involving cache-managed memory falls
entirely within the slab's usercopy region.

This patch is modified from Brad Spengler/PaX Team's PAX_USERCOPY
whitelisting code in the last public patch of grsecurity/PaX based on my
understanding of the code. Changes or omissions from the original code are
mine and don't reflect the original grsecurity/PaX code.

Signed-off-by: David Windsor <dave@nullcore.net>
[kees: adjust commit log, provide usage trace]
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/kmem.h      | 10 ++++++++++
 fs/xfs/xfs_super.c |  7 +++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 4d85992d75b2..08358f38dee6 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -110,6 +110,16 @@ kmem_zone_init_flags(int size, char *zone_name, unsigned long flags,
 	return kmem_cache_create(zone_name, size, 0, flags, construct);
 }
 
+static inline kmem_zone_t *
+kmem_zone_init_flags_usercopy(int size, char *zone_name, unsigned long flags,
+				size_t useroffset, size_t usersize,
+				void (*construct)(void *))
+{
+	return kmem_cache_create_usercopy(zone_name, size, 0, flags,
+				useroffset, usersize, construct);
+}
+
+
 static inline void
 kmem_zone_free(kmem_zone_t *zone, void *ptr)
 {
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index c996f4ae4a5f..1b4b67194538 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1846,9 +1846,12 @@ xfs_init_zones(void)
 		goto out_destroy_efd_zone;
 
 	xfs_inode_zone =
-		kmem_zone_init_flags(sizeof(xfs_inode_t), "xfs_inode",
+		kmem_zone_init_flags_usercopy(sizeof(xfs_inode_t), "xfs_inode",
 			KM_ZONE_HWALIGN | KM_ZONE_RECLAIM | KM_ZONE_SPREAD |
-			KM_ZONE_ACCOUNT, xfs_fs_inode_init_once);
+				KM_ZONE_ACCOUNT,
+			offsetof(xfs_inode_t, i_df.if_u2.if_inline_data),
+			sizeof_field(xfs_inode_t, i_df.if_u2.if_inline_data),
+			xfs_fs_inode_init_once);
 	if (!xfs_inode_zone)
 		goto out_destroy_efi_zone;
 
-- 
2.7.4

