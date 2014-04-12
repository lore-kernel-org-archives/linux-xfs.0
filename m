Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2C9F07F4E
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 18:13:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 084ED304075
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 16:13:12 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id Kqi38L0rjur8PWS1 (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 12 Apr 2014 16:13:11 -0700 (PDT)
From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] renameat2: add system call number for i386
Date: Sat, 12 Apr 2014 19:13:04 -0400
Message-Id: <1397344384-15302-1-git-send-email-tytso@mit.edu>
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
Cc: Miklos Szeredi <mszeredi@suse.cz>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Miklos Szeredi <mszeredi@suse.cz>
---
 src/renameat2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/renameat2.c b/src/renameat2.c
index 5145959..8613aa9 100644
--- a/src/renameat2.c
+++ b/src/renameat2.c
@@ -14,6 +14,10 @@
 #define SYS_renameat2 316
 #endif
 
+#if !defined(SYS_renameat2) && defined(__i386__)
+#define SYS_renameat2 353
+#endif
+
 static int renameat2(int dfd1, const char *path1,
 		     int dfd2, const char *path2,
 		     unsigned int flags)
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
