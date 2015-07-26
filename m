Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B297229E06
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 07:21:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 382ECAC004
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 05:21:11 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id BAhabwPOngXZIS83 (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 Jul 2015 05:21:06 -0700 (PDT)
From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/6] xfsprogs: pull in libgen.h to get prototype for basename()
Date: Sun, 26 Jul 2015 08:20:51 -0400
Message-Id: <1437913255-7524-3-git-send-email-tytso@mit.edu>
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

The function prototype for basename() is in <libgen.h>, per Posix.
Without the the function prototype, the build will throw errors due to
the missing prototype.

On glibc, using libgen.h will force the use of Poxis's basename(),
instead of glibc's basename() with GNU extensions.  However, xfsprogs
doesn't depend on any of the GNU extensions, so this is fine.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 include/platform_defs.h.in | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index 3e059af..bfab7cc 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -35,6 +35,7 @@
 #include <sys/types.h>
 #include <limits.h>
 #include <stdbool.h>
+#include <libgen.h>
 
 #undef HAVE___U32
 #ifdef HAVE___U32
-- 
2.3.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
