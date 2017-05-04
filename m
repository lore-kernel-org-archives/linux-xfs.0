Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34708 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753594AbdEDN0d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 May 2017 09:26:33 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 8/8] xfs: use the common helper uuid_is_null()
Date: Thu,  4 May 2017 16:26:23 +0300
Message-Id: <1493904383-2187-9-git-send-email-amir73il@gmail.com>
In-Reply-To: <1493904383-2187-1-git-send-email-amir73il@gmail.com>
References: <1493904383-2187-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, Theodore Tso <tytso@mit.edu>, Richard Weinberger <richard@nod.at>, Mark Fasheh <mfasheh@versity.com>, Dan Williams <dan.j.williams@intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Use the common helper uuid_is_null() and remove the xfs specific
helper uuid_is_nil().

The common helper does not check for the NULL pointer value as
xfs helper did, but xfs code never calls the helper with a pointer
that can be NULL.

Conform comments and warning strings to use the term 'null uuid'
instead of 'nil uuid', because this is the terminology used by
lib/uuid.c and its users. It is also the terminology used in
userspace by libuuid and xfsprogs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/uuid.c            | 14 --------------
 fs/xfs/uuid.h            |  1 -
 fs/xfs/xfs_log_recover.c |  6 +++---
 fs/xfs/xfs_mount.c       |  8 ++++----
 4 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/uuid.c b/fs/xfs/uuid.c
index d41fa68..a516805 100644
--- a/fs/xfs/uuid.c
+++ b/fs/xfs/uuid.c
@@ -31,17 +31,3 @@ xfs_uuid_getnodeuniq(uuid_t *uuid, int fsid[2])
 		  be16_to_cpu(uuid->time_mid);
 	fsid[1] = be32_to_cpu(uuid->time_low);
 }
-
-int
-uuid_is_nil(uuid_t *uuid)
-{
-	int	i;
-	char	*cp = (char *)uuid;
-
-	if (uuid == NULL)
-		return 0;
-	/* implied check of version number here... */
-	for (i = 0; i < sizeof *uuid; i++)
-		if (*cp++) return 0;	/* not nil */
-	return 1;	/* is nil */
-}
diff --git a/fs/xfs/uuid.h b/fs/xfs/uuid.h
index 4911905..12f15d1 100644
--- a/fs/xfs/uuid.h
+++ b/fs/xfs/uuid.h
@@ -20,7 +20,6 @@
 
 #include <linux/uuid.h>
 
-extern int uuid_is_nil(uuid_t *uuid);
 extern void xfs_uuid_getnodeuniq(uuid_t *uuid, int fsid[2]);
 
 #endif	/* __XFS_SUPPORT_UUID_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 4a98762..004d0a9 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -352,13 +352,13 @@ xlog_header_check_mount(
 {
 	ASSERT(head->h_magicno == cpu_to_be32(XLOG_HEADER_MAGIC_NUM));
 
-	if (uuid_is_nil(&head->h_fs_uuid)) {
+	if (uuid_is_null(&head->h_fs_uuid)) {
 		/*
 		 * IRIX doesn't write the h_fs_uuid or h_fmt fields. If
-		 * h_fs_uuid is nil, we assume this log was last mounted
+		 * h_fs_uuid is null, we assume this log was last mounted
 		 * by IRIX and continue.
 		 */
-		xfs_warn(mp, "nil uuid in log - IRIX style log");
+		xfs_warn(mp, "null uuid in log - IRIX style log");
 	} else if (unlikely(!uuid_equal(&mp->m_sb.sb_uuid, &head->h_fs_uuid))) {
 		xfs_warn(mp, "log has mismatched uuid - can't recover");
 		xlog_header_check_dump(mp, head);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index f4fdce7..9096948 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -80,14 +80,14 @@ xfs_uuid_mount(
 	if (mp->m_flags & XFS_MOUNT_NOUUID)
 		return 0;
 
-	if (uuid_is_nil(uuid)) {
-		xfs_warn(mp, "Filesystem has nil UUID - can't mount");
+	if (uuid_is_null(uuid)) {
+		xfs_warn(mp, "Filesystem has null UUID - can't mount");
 		return -EINVAL;
 	}
 
 	mutex_lock(&xfs_uuid_table_mutex);
 	for (i = 0, hole = -1; i < xfs_uuid_table_size; i++) {
-		if (uuid_is_nil(&xfs_uuid_table[i])) {
+		if (uuid_is_null(&xfs_uuid_table[i])) {
 			hole = i;
 			continue;
 		}
@@ -124,7 +124,7 @@ xfs_uuid_unmount(
 
 	mutex_lock(&xfs_uuid_table_mutex);
 	for (i = 0; i < xfs_uuid_table_size; i++) {
-		if (uuid_is_nil(&xfs_uuid_table[i]))
+		if (uuid_is_null(&xfs_uuid_table[i]))
 			continue;
 		if (!uuid_equal(uuid, &xfs_uuid_table[i]))
 			continue;
-- 
2.7.4

