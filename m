Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A85667F3F
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 14:58:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 871BC8F8050
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 12:58:10 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id CmeSPhmnx51DqSvt for <xfs@oss.sgi.com>;
	Wed, 04 Mar 2015 12:58:08 -0800 (PST)
Message-ID: <54F771DE.40107@sandeen.net>
Date: Wed, 04 Mar 2015 14:58:06 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/4] xfs_repair: validate & fix inode CRCs
References: <54F77199.8030708@redhat.com>
In-Reply-To: <54F77199.8030708@redhat.com>
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

xfs_repair doesn't ever check an inode's CRC, so it never repairs
them.  If the root inode or realtime inodes have bad crcs, the
fs won't even mount and can't be fixed (without using xfs_db).

It's fairly straightforward to just test the inode CRC before
we do any other checking or modification of the inode, once we
get past the "verify only" phase of process_dinode_int();
just mark it dirty if it's wrong and needs to be re-written.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Resend of patch from a while ago, but with CRC verification
now earlier in the function, prior to any changes are made.

diff --git a/repair/dinode.c b/repair/dinode.c
index 5d9094b..384e2dd 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2291,6 +2291,27 @@ process_dinode_int(xfs_mount_t *mp,
 	 */
 	ASSERT(uncertain == 0 || verify_mode != 0);
 
+	/*
+	 * We'd really like to know if the CRC is bad before we
+	 * go fixing anything; that way we have some hint about
+	 * bit-rot vs bugs.  Also, any changes will invalidate the
+	 * existing CRC, so this is the only valid point to test it.
+	 *
+	 * Of course if we make any modifications after this, the
+	 * inode gets rewritten, and CRC is updated automagically.
+	 */
+	if (!verify_mode && xfs_sb_version_hascrc(&mp->m_sb)) {
+		if(!xfs_verify_cksum((char *)dino, mp->m_sb.sb_inodesize,
+                		XFS_DINODE_CRC_OFF)) {
+			do_warn(_("bad CRC for inode %" PRIu64), lino);
+			if (!no_modify) {
+				do_warn(_(", will rewrite\n"));
+				*dirty = 1;
+			} else
+				do_warn(_(", would rewrite\n"));
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
