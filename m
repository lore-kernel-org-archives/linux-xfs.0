Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BE77429E09
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 07:21:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 533DDAC007
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 05:21:11 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id 5XmOHKgOZdJ5qwVG (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 Jul 2015 05:21:07 -0700 (PDT)
From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 6/6] xfsprogs: add missing include of <stat.h>
Date: Sun, 26 Jul 2015 08:20:55 -0400
Message-Id: <1437913255-7524-7-git-send-email-tytso@mit.edu>
In-Reply-To: <1437913255-7524-1-git-send-email-tytso@mit.edu>
References: <1437913255-7524-1-git-send-email-tytso@mit.edu>
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
Cc: Theodore Ts'o <tytso@mit.edu>, fstests@vger.kernel.org

In libdisk/evms.c, fields from struct stat are used without including
<stat.h>.  Apparently stat.h is included indirectly in glibc's header
files; not so in Android's bionic libc.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 libdisk/evms.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libdisk/evms.c b/libdisk/evms.c
index 4c22ee1..7d41af6 100644
--- a/libdisk/evms.c
+++ b/libdisk/evms.c
@@ -22,6 +22,7 @@
 #include <fcntl.h>
 #include <sys/ioctl.h>
 #include <sys/sysmacros.h>
+#include <sys/stat.h>
 #include <disk/volume.h>
 #include "evms.h"
 
-- 
2.3.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
