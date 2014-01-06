Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5648F7F51
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 09:17:41 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 435B3304039
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 07:17:38 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tMMvlVV0BTyAW8Lc for
	<xfs@oss.sgi.com>; Mon, 06 Jan 2014 07:17:37 -0800 (PST)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfsprogs/io: set argmax to 1 for imap command
Date: Mon,  6 Jan 2014 10:24:26 -0500
Message-Id: <1389021866-10793-1-git-send-email-bfoster@redhat.com>
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
Cc: jeff.liu@oracle.com

The imap command supports an optional argument to specify the
number of inode records to capture per ioctl(), but argmax is
currently set to 0. This leads to an error if an argument is
provided on the command line. Set argmax to 1 to support the
optional argument.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 io/imap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io/imap.c b/io/imap.c
index 0a4f14e..4f3f883 100644
--- a/io/imap.c
+++ b/io/imap.c
@@ -67,7 +67,7 @@ imap_init(void)
 	imap_cmd.name = "imap";
 	imap_cmd.cfunc = imap_f;
 	imap_cmd.argmin = 0;
-	imap_cmd.argmax = 0;
+	imap_cmd.argmax = 1;
 	imap_cmd.args = _("[nentries]");
 	imap_cmd.flags = CMD_NOMAP_OK;
 	imap_cmd.oneline = _("inode map for filesystem of current file");
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
