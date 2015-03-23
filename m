Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4D4AC7F4E
	for <xfs@oss.sgi.com>; Mon, 23 Mar 2015 15:20:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D5D42AC009
	for <xfs@oss.sgi.com>; Mon, 23 Mar 2015 13:20:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id zOQRGy1cBL867Pmy for <xfs@oss.sgi.com>;
	Mon, 23 Mar 2015 13:19:45 -0700 (PDT)
Message-ID: <55107560.90907@sandeen.net>
Date: Mon, 23 Mar 2015 15:19:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 13/13 V2] xfs_repair: validate & fix inode CRCs
References: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
	<1426624395-8258-14-git-send-email-sandeen@redhat.com>
In-Reply-To: <1426624395-8258-14-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

xfs_repair doesn't ever check an inode's CRC, so it never repairs
them.  If the root inode or realtime inodes have bad crcs, the
fs won't even mount and can't be fixed (without using xfs_db).

It's fairly straightforward to just test the inode CRC before
we do any other checking or modification of the inode, and
just mark it dirty if it's wrong and needs to be re-written.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---

V2: fix whitespace, urgh!

diff --git a/repair/dinode.c b/repair/dinode.c
index 5d9094b..035212c 100644
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
+				XFS_DINODE_CRC_OFF)) {
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


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
