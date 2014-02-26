Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 76A1F7F3F
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 10:22:52 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4D3E8304043
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 08:22:48 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id d9gbkNs8QrACm1C4 for <xfs@oss.sgi.com>;
	Wed, 26 Feb 2014 08:22:46 -0800 (PST)
Message-ID: <530E14D4.9050601@sandeen.net>
Date: Wed, 26 Feb 2014 10:22:44 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfs_copy: band-aids for CRC filesystems
References: <530D4B68.9090905@redhat.com>
In-Reply-To: <530D4B68.9090905@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>

xfs_copy needs a fair bit of work for CRCs because it rewrites
UUIDs by default, but this change will get it working properly
with the "-d" (duplicate) option which keeps the same UUID.

Accept the the CRC magic valid, change the ASSERT() to an error
message and exit more gracefully, and don't
even get started if we don't have the '-d' option.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 9986fbf..f443568 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -684,6 +684,16 @@ main(int argc, char **argv)
 	sb = &mbuf.m_sb;
 	libxfs_sb_from_disk(sb, XFS_BUF_TO_SBP(sbp));
 
+	/*
+	 * For now, V5 superblock filesystems are not supported without -d;
+	 * we do not have the infrastructure yet to fix CRCs when a new UUID
+	 * is generated.
+	 */
+	if (xfs_sb_version_hascrc(sb) && !duplicate) {
+		do_log(_("%s: Cannot yet copy V5 fs without '-d'\n"), progname);
+		exit(1);
+	}
+
 	mp = libxfs_mount(&mbuf, sb, xargs.ddev, xargs.logdev, xargs.rtdev, 0);
 	if (mp == NULL) {
 		do_log(_("%s: %s filesystem failed to initialize\n"
@@ -957,7 +967,13 @@ main(int argc, char **argv)
 				 ((char *)btree_buf.data +
 				  pos - btree_buf.position);
 
-			ASSERT(be32_to_cpu(block->bb_magic) == XFS_ABTB_MAGIC);
+			if (be32_to_cpu(block->bb_magic) !=
+			    (xfs_sb_version_hascrc(&mp->m_sb) ?
+			     XFS_ABTB_CRC_MAGIC : XFS_ABTB_MAGIC)) {
+				do_log(_("Bad btree magic 0x%x\n"),
+				        be32_to_cpu(block->bb_magic));
+				exit(1);
+			}
 
 			if (be16_to_cpu(block->bb_level) == 0)
 				break;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
