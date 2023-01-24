Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1A36C25B4E
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 19:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbjAXTao (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Jan 2023 14:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234228AbjAXTak (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jan 2023 14:30:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940974ED2E;
        Tue, 24 Jan 2023 11:30:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D573B816B3;
        Tue, 24 Jan 2023 19:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF72C4339E;
        Tue, 24 Jan 2023 19:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674588636;
        bh=5Id/6GwyRzJyDNnF9NPtwFxMtQLo/dWq0B8EUtSBvlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQoRCGuZT1N1d1fzlet9LS8GB2TCHTEOvSrcGiubd243jqpXMQW5CtC3Dja2W9cBj
         91gepbKSr6cYm9EIdmn+hoyU49hNcRgyumNXVq/MpanjjnMz+fRboohGbWu61yNp5+
         g0lMM7M2Sw12tcENSTz0lcOaONtANcfmHiTZD2hjxSPWqYjbg9bXuorJHJAAZtcJm8
         QEeIE3BWZwWUSpZz7V0uce/mnelakMARV0plE83eeqjzeukyd327IRYqJjjLwjtj5e
         7JjCjL8ybHzlMmX3Ga9rE9Zj7K85ZwyS41HPb5qloH2zPNjb1LBOMzRVw9ExTvaPWx
         iLG0oVZxEOoeQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     tytso@mit.edu, adilger.kernel@dilger.ca, djwong@kernel.org,
        david@fromorbit.com, trondmy@hammerspace.com, neilb@suse.de,
        viro@zeniv.linux.org.uk, zohar@linux.ibm.com, xiubli@redhat.com,
        chuck.lever@oracle.com, lczerner@redhat.com, jack@suse.cz,
        bfields@fieldses.org, brauner@kernel.org, fweimer@redhat.com
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: [PATCH v8 RESEND 3/8] vfs: plumb i_version handling into struct kstat
Date:   Tue, 24 Jan 2023 14:30:20 -0500
Message-Id: <20230124193025.185781-4-jlayton@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230124193025.185781-1-jlayton@kernel.org>
References: <20230124193025.185781-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The NFS server has a lot of special handling for different types of
change attribute access, depending on the underlying filesystem. In
most cases, it's doing a getattr anyway and then fetching that value
after the fact.

Rather that do that, add a new STATX_CHANGE_COOKIE flag that is a
kernel-only symbol (for now). If requested and getattr can implement it,
it can fill out this field. For IS_I_VERSION inodes, add a generic
implementation in vfs_getattr_nosec. Take care to mask
STATX_CHANGE_COOKIE off in requests from userland and in the result
mask.

Since not all filesystems can give the same guarantees of monotonicity,
claim a STATX_ATTR_CHANGE_MONOTONIC flag that filesystems can set to
indicate that they offer an i_version value that can never go backward.

Eventually if we decide to make the i_version available to userland, we
can just designate a field for it in struct statx, and move the
STATX_CHANGE_COOKIE definition to the uapi header.

Reviewed-by: NeilBrown <neilb@suse.de>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/stat.c            | 17 +++++++++++++++--
 include/linux/stat.h |  9 +++++++++
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index d6cc74ca8486..f43afe0081fe 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -18,6 +18,7 @@
 #include <linux/syscalls.h>
 #include <linux/pagemap.h>
 #include <linux/compat.h>
+#include <linux/iversion.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -122,6 +123,11 @@ int vfs_getattr_nosec(const struct path *path, struct kstat *stat,
 	stat->attributes_mask |= (STATX_ATTR_AUTOMOUNT |
 				  STATX_ATTR_DAX);
 
+	if ((request_mask & STATX_CHANGE_COOKIE) && IS_I_VERSION(inode)) {
+		stat->result_mask |= STATX_CHANGE_COOKIE;
+		stat->change_cookie = inode_query_iversion(inode);
+	}
+
 	mnt_userns = mnt_user_ns(path->mnt);
 	if (inode->i_op->getattr)
 		return inode->i_op->getattr(mnt_userns, path, stat,
@@ -602,9 +608,11 @@ cp_statx(const struct kstat *stat, struct statx __user *buffer)
 
 	memset(&tmp, 0, sizeof(tmp));
 
-	tmp.stx_mask = stat->result_mask;
+	/* STATX_CHANGE_COOKIE is kernel-only for now */
+	tmp.stx_mask = stat->result_mask & ~STATX_CHANGE_COOKIE;
 	tmp.stx_blksize = stat->blksize;
-	tmp.stx_attributes = stat->attributes;
+	/* STATX_ATTR_CHANGE_MONOTONIC is kernel-only for now */
+	tmp.stx_attributes = stat->attributes & ~STATX_ATTR_CHANGE_MONOTONIC;
 	tmp.stx_nlink = stat->nlink;
 	tmp.stx_uid = from_kuid_munged(current_user_ns(), stat->uid);
 	tmp.stx_gid = from_kgid_munged(current_user_ns(), stat->gid);
@@ -643,6 +651,11 @@ int do_statx(int dfd, struct filename *filename, unsigned int flags,
 	if ((flags & AT_STATX_SYNC_TYPE) == AT_STATX_SYNC_TYPE)
 		return -EINVAL;
 
+	/* STATX_CHANGE_COOKIE is kernel-only for now. Ignore requests
+	 * from userland.
+	 */
+	mask &= ~STATX_CHANGE_COOKIE;
+
 	error = vfs_statx(dfd, filename, flags, &stat, mask);
 	if (error)
 		return error;
diff --git a/include/linux/stat.h b/include/linux/stat.h
index ff277ced50e9..52150570d37a 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -52,6 +52,15 @@ struct kstat {
 	u64		mnt_id;
 	u32		dio_mem_align;
 	u32		dio_offset_align;
+	u64		change_cookie;
 };
 
+/* These definitions are internal to the kernel for now. Mainly used by nfsd. */
+
+/* mask values */
+#define STATX_CHANGE_COOKIE		0x40000000U	/* Want/got stx_change_attr */
+
+/* file attribute values */
+#define STATX_ATTR_CHANGE_MONOTONIC	0x8000000000000000ULL /* version monotonically increases */
+
 #endif
-- 
2.39.1

