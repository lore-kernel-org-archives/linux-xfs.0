Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D1ED77F5A
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 10:24:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AEDDC8F8035
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 08:24:41 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 640jnRzCQf565FZc for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 08:24:39 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 7EFCD65B63AA
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 10:24:39 -0500 (CDT)
Message-ID: <542C1CB8.103@sandeen.net>
Date: Wed, 01 Oct 2014 10:24:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/2] xfs: fix crc field handling in xfs_sb_to/from_disk
References: <542C1B36.5080804@redhat.com>
In-Reply-To: <542C1B36.5080804@redhat.com>
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
To: xfs-oss <xfs@oss.sgi.com>

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

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 8426e5e..5f902fa 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -445,6 +445,8 @@ __xfs_sb_from_disk(
 	to->sb_features_incompat = be32_to_cpu(from->sb_features_incompat);
 	to->sb_features_log_incompat =
 				be32_to_cpu(from->sb_features_log_incompat);
+	/* crc is only used on disk, not in memory; just init to 0 here. */
+	to->sb_crc = 0;
 	to->sb_pad = 0;
 	to->sb_pquotino = be64_to_cpu(from->sb_pquotino);
 	to->sb_lsn = be64_to_cpu(from->sb_lsn);
@@ -550,6 +552,9 @@ xfs_sb_to_disk(
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
