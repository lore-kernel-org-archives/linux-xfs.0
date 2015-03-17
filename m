Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C52E27F60
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 15:33:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5F8E0AC003
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 13:33:21 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id zCa1oplpDa9nnIBQ for <xfs@oss.sgi.com>;
	Tue, 17 Mar 2015 13:33:20 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 13/13] xfs_repair: validate & fix inode CRCs
Date: Tue, 17 Mar 2015 15:33:15 -0500
Message-Id: <1426624395-8258-14-git-send-email-sandeen@redhat.com>
In-Reply-To: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
References: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
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

xfs_repair doesn't ever check an inode's CRC, so it never repairs
them.  If the root inode or realtime inodes have bad crcs, the
fs won't even mount and can't be fixed (without using xfs_db).

It's fairly straightforward to just test the inode CRC before
we do any other checking or modification of the inode, and
just mark it dirty if it's wrong and needs to be re-written.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 repair/dinode.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index 5d9094b..05db838 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2291,6 +2291,30 @@ process_dinode_int(xfs_mount_t *mp,
 	 */
 	ASSERT(uncertain == 0 || verify_mode != 0);
 
+	/*
+	 * This is the only valid point to check the CRC; after this we may have
+	 * made changes which invalidate it, and the CRC is only updated again
+	 * when it gets written out.
+	 *
+	 * Of course if we make any modifications after this, the inode gets
+	 * rewritten, and the CRC is updated automagically.
+	 */
+	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	    !xfs_verify_cksum((char *)dino, mp->m_sb.sb_inodesize,
+                		XFS_DINODE_CRC_OFF)) {
+		retval = 1;
+		if (!uncertain)
+			do_warn(_("bad CRC for inode %" PRIu64 "%c"),
+				lino, verify_mode ? '\n' : ',');
+		if (!verify_mode) {
+			if (!no_modify) {
+				do_warn(_(" will rewrite\n"));
+				*dirty = 1;
+			} else
+				do_warn(_(" would rewrite\n"));
+		}
+	}
+
 	if (be16_to_cpu(dino->di_magic) != XFS_DINODE_MAGIC)  {
 		retval = 1;
 		if (!uncertain)
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
