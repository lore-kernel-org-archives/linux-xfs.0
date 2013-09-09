Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C33C37F5F
	for <linux-xfs@oss.sgi.com>; Mon,  9 Sep 2013 15:33:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 52F00AC007
	for <linux-xfs@oss.sgi.com>; Mon,  9 Sep 2013 13:33:33 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id YodQfvDOMZkmR2JS for <linux-xfs@oss.sgi.com>;
	Mon, 09 Sep 2013 13:33:31 -0700 (PDT)
Message-ID: <522E3099.1040503@sandeen.net>
Date: Mon, 09 Sep 2013 15:33:29 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfs: be more forgiving of a v4 secondary sb w/ junk in
	v5 fields
References: <520D1BA3.1050500@redhat.com> <20130815210018.GR6023@dastard>
	<520D44E7.1000905@sandeen.net> <520D592D.4040600@redhat.com>
In-Reply-To: <520D592D.4040600@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

Today, if xfs_sb_read_verify encounters a v4 superblock
with junk past v4 fields which includes data in sb_crc,
it will be treated as a failing checksum and a significant
corruption.

There are known prior bugs which leave junk at the end
of the V4 superblock; we don't need to actually fail the
verification in this case if other checks pan out ok.

So if this is a secondary superblock, and the primary
superblock doesn't indicate that this is a V5 filesystem,
don't treat this as an actual checksum failure.

We should probably check the garbage condition as
we do in xfs_repair, and possibly warn about it
or self-heal, but that's a different scope of work.

Stable folks: This can go back to v3.10, which is what
introduced the sb CRC checking that is tripped up by old,
stale, incorrect V4 superblocks w/ unzeroed bits.

Cc: stable@vger.kernel.org
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Comment changes: More!  (No code changes)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 2b0ba35..b2deab1 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -749,6 +749,11 @@ xfs_sb_verify(
  * single bit error could clear the feature bit and unused parts of the
  * superblock are supposed to be zero. Hence a non-null crc field indicates that
  * we've potentially lost a feature bit and we should check it anyway.
+ *
+ * However, past bugs (i.e. in growfs) left non-zeroed regions beyond the
+ * last field in V4 secondary superblocks.  So for secondary superblocks,
+ * we are more forgiving, and ignore CRC failures if the primary doesn't
+ * indicate that the fs version is V5.
  */
 static void
 xfs_sb_read_verify(
@@ -769,8 +774,12 @@ xfs_sb_read_verify(
 
 		if (!xfs_verify_cksum(bp->b_addr, be16_to_cpu(dsb->sb_sectsize),
 				      offsetof(struct xfs_sb, sb_crc))) {
-			error = EFSCORRUPTED;
-			goto out_error;
+			/* Only fail bad secondaries on a known V5 filesystem */
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
