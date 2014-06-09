Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 50F2A7F66
	for <xfs@oss.sgi.com>; Mon,  9 Jun 2014 16:31:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3D1678F806F
	for <xfs@oss.sgi.com>; Mon,  9 Jun 2014 14:31:00 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id gVP7wGHvmIIbx9DQ for <xfs@oss.sgi.com>;
	Mon, 09 Jun 2014 14:30:59 -0700 (PDT)
Message-ID: <53962792.6040000@sandeen.net>
Date: Mon, 09 Jun 2014 16:30:58 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfs: fix crc field handling in xfs_sb_to/from_disk
References: <5390F89C.2050305@redhat.com>
In-Reply-To: <5390F89C.2050305@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

I discovered this in userspace, but the same change applies
to the kernel.

If we xfs_mdrestore an image from a non-crc filesystem, lo
and behold the restored image has gained a CRC:

# db/xfs_metadump.sh -o /dev/sdc1 - | xfs_mdrestore - test.img
# xfs_db -c "sb 0" -c "p crc" /dev/sdc1
crc = 0 (correct)
# xfs_db -c "sb 0" -c "p crc" test.img
crc = 0xb6f8d6a0 (correct)

This is because xfs_sb_from_disk doesn't fill in sb_crc,
but xfs_sb_to_disk(XFS_SB_ALL_BITS) does write the in-memory
CRC to disk - so we get uninitialized memory on disk.

Fix this by always initializing sb_crc to 0 when we read
the superblock, and masking out the CRC bit from ALL_BITS
when we write it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
index 8baf61a..d2ccb2e 100644
--- a/fs/xfs/xfs_sb.c
+++ b/fs/xfs/xfs_sb.c
@@ -450,6 +450,8 @@ xfs_sb_from_disk(
 	to->sb_features_incompat = be32_to_cpu(from->sb_features_incompat);
 	to->sb_features_log_incompat =
 				be32_to_cpu(from->sb_features_log_incompat);
+	/* crc is only used on disk, not in memory; just init to 0 here. */
+	to->sb_crc = 0;
 	to->sb_pad = 0;
 	to->sb_pquotino = be64_to_cpu(from->sb_pquotino);
 	to->sb_lsn = be64_to_cpu(from->sb_lsn);
@@ -527,6 +529,9 @@ xfs_sb_to_disk(
 	if (!fields)
 		return;
 
+	/* We should never write the crc here, it's updated in the IO path */
+	fields &= ~XFS_SB_CRC;
+
 	xfs_sb_quota_to_disk(to, from, &fields);
 	while (fields) {
 		f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
