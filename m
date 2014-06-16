Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 95C847F47
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2014 18:14:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2CBB0AC005
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2014 16:14:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id NOt8qCcyw6Eb8u8n for <xfs@oss.sgi.com>;
	Mon, 16 Jun 2014 16:14:24 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/2] libxfs: fix crc field handling in xfs_sb_to/from_disk
Date: Mon, 16 Jun 2014 18:14:21 -0500
Message-Id: <1402960461-27881-3-git-send-email-sandeen@redhat.com>
In-Reply-To: <1402960461-27881-1-git-send-email-sandeen@redhat.com>
References: <1402960461-27881-1-git-send-email-sandeen@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

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

This same fix has already been sent for kernelspace.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/xfs_sb.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 7ee4612..ea89367 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -408,6 +408,8 @@ xfs_sb_from_disk(
 	to->sb_features_incompat = be32_to_cpu(from->sb_features_incompat);
 	to->sb_features_log_incompat =
 				be32_to_cpu(from->sb_features_log_incompat);
+	/* crc is only used on disk, not in memory; just init to 0 here. */
+	to->sb_crc = 0;
 	to->sb_pad = 0;
 	to->sb_pquotino = be64_to_cpu(from->sb_pquotino);
 	to->sb_lsn = be64_to_cpu(from->sb_lsn);
@@ -485,6 +487,9 @@ xfs_sb_to_disk(
 	if (!fields)
 		return;
 
+	/* We should never write the crc here, it's updated in the IO path */
+	fields &= ~XFS_SB_CRC;
+
 	xfs_sb_quota_to_disk(to, from, &fields);
 	while (fields) {
 		f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
