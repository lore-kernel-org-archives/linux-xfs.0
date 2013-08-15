Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6AF0F7F51
	for <linux-xfs@oss.sgi.com>; Thu, 15 Aug 2013 17:41:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0635FAC003
	for <linux-xfs@oss.sgi.com>; Thu, 15 Aug 2013 15:41:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HsmKi1mWC7IQi8If for
	<linux-xfs@oss.sgi.com>; Thu, 15 Aug 2013 15:41:52 -0700 (PDT)
Message-ID: <520D592D.4040600@redhat.com>
Date: Thu, 15 Aug 2013 17:41:49 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH, RFC] xfs: be more forgiving of a v4 secondary sb w/ junk
	in v5 fields
References: <520D1BA3.1050500@redhat.com> <20130815210018.GR6023@dastard>
	<520D44E7.1000905@sandeen.net>
In-Reply-To: <520D44E7.1000905@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

Today, if xfs_sb_read_verify encounters a v4 superblock
with junk past v4 fields which includes data in sb_crc,
it will be treated as a failing checksum and significant
corruption.

There are known prior bugs which leave junk at the end
of the superblock; we don't need to actually fail the
verification in this case if other checks pan out ok.

So if this is a secondary superblock, and the primary
superblock is not V5, don't treat this as a serious
checksum failure.

We should probably check the garbage condition as
we do in xfs_repair, and possibly warn about it
or self-heal, but that's a different scope of work.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 2b0ba35..5ce25ae 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -769,8 +769,12 @@ xfs_sb_read_verify(
 
 		if (!xfs_verify_cksum(bp->b_addr, be16_to_cpu(dsb->sb_sectsize),
 				      offsetof(struct xfs_sb, sb_crc))) {
-			error = EFSCORRUPTED;
-			goto out_error;
+			/* Only fail here for a real V5 filesystem */
+			if (bp->b_bn != XFS_SB_DADDR &&
+			    xfs_sb_version_hascrc(&mp->m_sb)) {
+				error = EFSCORRUPTED;
+				goto out_error;
+			}
 		}
 	}
 	error = xfs_sb_verify(bp, true);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
