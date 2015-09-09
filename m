Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B58047F37
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 14:34:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A246B304062
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 12:34:17 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id GIFDXEI7CsdefXI5 for <xfs@oss.sgi.com>;
	Wed, 09 Sep 2015 12:34:16 -0700 (PDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 09/13] xfs_repair: better checking of v5 attributes
Date: Wed,  9 Sep 2015 14:34:07 -0500
Message-Id: <1441827251-13128-10-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1441827251-13128-1-git-send-email-sandeen@sandeen.net>
References: <1441827251-13128-1-git-send-email-sandeen@sandeen.net>
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

The commit:

0519f66 xfs_repair: better checking of v5 metadata fields

added new corruption checks to dir2.c but missed the similar
code in attr_repair.c; add that here.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 repair/attr_repair.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 2aafdf6..c8ba484 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -201,6 +201,15 @@ traverse_int_dablock(xfs_mount_t	*mp,
 			goto error_out;
 		}
 
+		/* corrupt node; rebuild the dir. */
+		if (bp->b_error == -EFSBADCRC || bp->b_error == -EFSCORRUPTED) {
+			libxfs_putbuf(bp);
+			do_warn(
+_("corrupt tree block %u for directory inode %" PRIu64 "\n"),
+				bno, da_cursor->ino);
+			goto error_out;
+		}
+
 		if (nodehdr.count > geo->node_ents)  {
 			do_warn(_("bad record count in inode %" PRIu64 ", "
 				  "count = %d, max = %d\n"),
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
