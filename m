Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48098 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727595AbeJELAN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Oct 2018 07:00:13 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 06/15] xfsprogs: minor endian annotation fixes
Date: Thu,  4 Oct 2018 23:03:07 -0500
Message-Id: <1538712196-13625-7-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

No actual bugs, just quiet the sparse checker.

Fixes sparse warnings about this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 copy/xfs_copy.c     | 2 +-
 db/crc.c            | 4 ++--
 db/write.c          | 4 ++--
 logprint/log_misc.c | 5 +++--
 repair/rmap.c       | 3 ++-
 5 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index a7b4656..1d04780 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -507,7 +507,7 @@ sb_update_uuid(
 	 */
 	if (xfs_sb_version_hascrc(sb) && !xfs_sb_version_hasmetauuid(sb) &&
 	    !uuid_equal(&tcarg->uuid, &sb->sb_uuid)) {
-		__be32 feat;
+		__u32 feat;
 
 		feat = be32_to_cpu(ag_hdr->xfs_sb->sb_features_incompat);
 		feat |= XFS_SB_FEAT_INCOMPAT_META_UUID;
diff --git a/db/crc.c b/db/crc.c
index b6775bc..c4136a4 100644
--- a/db/crc.c
+++ b/db/crc.c
@@ -144,8 +144,8 @@ crc_f(
 		bit_length *= fcount(sfl->fld, iocur_top->data, parentoffset);
 		crc = getbitval(iocur_top->data, sfl->offset, bit_length,
 				BVUNSIGNED);
-		/* Off by one.. */
-		crc = cpu_to_be32(crc + 1);
+		/* Off by one, ignore endianness - we're just corrupting it. */
+		crc++;
 		setbitval(iocur_top->data, sfl->offset, bit_length, &crc);
 
 		/* Temporarily remove write verifier to write a bad CRC */
diff --git a/db/write.c b/db/write.c
index a48576b..e25d6ea 100644
--- a/db/write.c
+++ b/db/write.c
@@ -525,7 +525,7 @@ convert_arg(
 	char		*endp;
 	char		*rbuf;
 	char		*ostr;
-	__u64		*value;
+	__be64		*value;
 	__u64		val = 0;
 
 	if (bit_length <= 64)
@@ -535,7 +535,7 @@ convert_arg(
 
 	buf = xrealloc(buf, alloc_size);
 	memset(buf, 0, alloc_size);
-	value = (__u64 *)buf;
+	value = (__be64 *)buf;
 	rbuf = buf;
 
 	if (*arg == '\"') {
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 640c00e..c5dba30 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -467,6 +467,7 @@ xlog_print_dir2_sf(
 	xfs_dir2_sf_hdr_t *sfp,
 	int		size)
 {
+	__be64		pino;	/* parent inode nr */
 	xfs_ino_t	ino;
 	int		count;
 	int		i;
@@ -481,8 +482,8 @@ xlog_print_dir2_sf(
 
 	printf(_("SHORTFORM DIRECTORY size %d count %d\n"),
 	       size, sfp->count);
-	memmove(&ino, &(sfp->parent), sizeof(ino));
-	printf(_(".. ino 0x%llx\n"), (unsigned long long) be64_to_cpu(ino));
+	memmove(&pino, &(sfp->parent), sizeof(pino));
+	printf(_(".. ino 0x%llx\n"), (unsigned long long) be64_to_cpu(pino));
 
 	count = sfp->count;
 	sfep = xfs_dir2_sf_firstentry(sfp);
diff --git a/repair/rmap.c b/repair/rmap.c
index 6de4a10..ebb5a3a 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -482,7 +482,8 @@ rmap_store_ag_btree_rec(
 	 */
 	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
 	b = agfl_bno + ag_rmaps[agno].ar_flcount;
-	while (*b != NULLAGBLOCK && b - agfl_bno < libxfs_agfl_size(mp)) {
+	while (*b != cpu_to_be32(NULLAGBLOCK) &&
+	       b - agfl_bno < libxfs_agfl_size(mp)) {
 		error = rmap_add_ag_rec(mp, agno, be32_to_cpu(*b), 1,
 				XFS_RMAP_OWN_AG);
 		if (error)
-- 
1.8.3.1
