Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 684137F54
	for <xfs@oss.sgi.com>; Fri, 29 May 2015 14:17:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 37F08304059
	for <xfs@oss.sgi.com>; Fri, 29 May 2015 12:17:50 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id g6KPBDmiW3I11kI8 for <xfs@oss.sgi.com>;
	Fri, 29 May 2015 12:17:48 -0700 (PDT)
Message-ID: <5568BB5C.4080400@sandeen.net>
Date: Fri, 29 May 2015 14:17:48 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 4/4] xfsprogs: zero out clean log in xfs_metadump
References: <5568B7CE.9030709@redhat.com>
In-Reply-To: <5568B7CE.9030709@redhat.com>
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

When doing an xfs_metadump, if the log is clean, zero it out
for 2 reasons:

 * It'll make the image more compressible
 * It'll eliminate an un-obfuscated metadata source

If the log isn't clean, and the user expected obfuscation, warn
that metadata in the log will not be obfuscated.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/db/metadump.c b/db/metadump.c
index bea4e00..eb5e9da 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -17,6 +17,7 @@
  */
 
 #include <libxfs.h>
+#include <libxlog.h>
 #include "bmap.h"
 #include "command.h"
 #include "metadump.h"
@@ -2169,6 +2170,8 @@ copy_sb_inodes(void)
 static int
 copy_log(void)
 {
+	int dirty;
+
 	if (show_progress)
 		print_progress("Copying log");
 
@@ -2180,6 +2183,31 @@ copy_log(void)
 		print_warning("cannot read log");
 		return !stop_on_read_error;
 	}
+
+	dirty = xlog_is_dirty(mp, &x, 0);
+
+	switch (dirty) {
+	case 0:
+		/* clear out a clean log */
+		if (show_progress)
+			print_progress("Zeroing clean log");
+		memset(iocur_top->data, 0,
+			mp->m_sb.sb_logblocks * mp->m_sb.sb_blocksize);
+		break;
+	case 1:
+		/* keep the dirty log */
+		if (obfuscate)
+			print_warning(
+_("Filesystem log is dirty; image will contain unobfuscated metadata in log."));
+		break;
+	case -1:
+		/* log detection error */
+		if (obfuscate)
+			print_warning(
+_("Could not discern log; image will contain unobfuscated metadata in log."));
+		break;
+	}
+
 	return !write_buf(iocur_top);
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
