Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 173F27F91
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2015 03:40:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E98B28F8073
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2015 01:40:46 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id as1ZHxb7AFsWRsjY (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Jun 2015 01:40:44 -0700 (PDT)
Date: Wed, 10 Jun 2015 01:40:43 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfsprogs for-next build error on Debian Wheezy / amd64
Message-ID: <20150610084043.GA31392@infradead.org>
References: <20150610070604.GA9855@infradead.org>
	<20150610081914.GV9143@dastard>
	<20150610082415.GA23860@infradead.org>
	<20150610083441.GW9143@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150610083441.GW9143@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Here is the fix.  Since that commit the build accidentally relied on the
installed platform_defs.h:

---
>From e406bcdcdad80ca491d5b854cde5ad893bef6f8c Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Wed, 10 Jun 2015 10:34:45 +0200
Subject: xfsprogs: fix platform_defs.h include path
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since 2fe8a2 ("libxfs: restructure to match kernel layout") platform_defs.h
the xfs subdirectory under include/ only contains selected headers instead
of being a directory symlink.

Because of this the build does not properly pick up platform_defs.h, which
isn't symlinked into include/xfs.  Builds only work if a recent enough
platform_defs.h is available under /usr/include/xfs.

Fix this by including platform_defs.h without the xfs/ prefix.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/libxfs.h        | 2 +-
 include/xfs.h           | 2 +-
 libxfs/Makefile         | 2 +-
 libxfs/crc32.c          | 3 +--
 libxfs/gen_crc32table.c | 6 +++---
 libxfs/libxfs_priv.h    | 2 +-
 libxfs/radix-tree.c     | 2 +-
 7 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index e12cd5a..ee537f3 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -20,7 +20,7 @@
 #define __LIBXFS_H__
 
 #include <xfs/libxfs_api_defs.h>
-#include <xfs/platform_defs.h>
+#include <platform_defs.h>
 
 #include <xfs/list.h>
 #include <xfs/hlist.h>
diff --git a/include/xfs.h b/include/xfs.h
index e32c4a8..3f17b8f 100644
--- a/include/xfs.h
+++ b/include/xfs.h
@@ -33,7 +33,7 @@
 #ifndef __XFS_H__
 #define __XFS_H__
 
-#include <xfs/platform_defs.h>
+#include <platform_defs.h>
 #include <xfs/xfs_types.h>
 #include <xfs/xfs_fs.h>
 
diff --git a/libxfs/Makefile b/libxfs/Makefile
index a3c9ab5..b1fc86d 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -102,7 +102,7 @@ DEBUG = -DNDEBUG
 
 LDIRT = gen_crc32table crc32table.h crc32selftest
 
-default: xfs crc32selftest ltdepend $(LTLIBRARY)
+default: xfs ltdepend $(LTLIBRARY)
 
 crc32table.h: gen_crc32table.c
 	@echo "    [CC]     gen_crc32table"
diff --git a/libxfs/crc32.c b/libxfs/crc32.c
index 0a8d309..006faf2 100644
--- a/libxfs/crc32.c
+++ b/libxfs/crc32.c
@@ -33,8 +33,7 @@
  * match the hardware acceleration available on Intel CPUs.
  */
 
-//#include <libxfs.h>
-#include <xfs/platform_defs.h>
+#include <platform_defs.h>
 #include <xfs/swab.h>
 #include <xfs/xfs_arch.h>
 #include "crc32defs.h"
diff --git a/libxfs/gen_crc32table.c b/libxfs/gen_crc32table.c
index 574a2d1..57109ed 100644
--- a/libxfs/gen_crc32table.c
+++ b/libxfs/gen_crc32table.c
@@ -114,7 +114,7 @@ int main(int argc, char** argv)
 
 	if (CRC_LE_BITS > 1) {
 		crc32init_le();
-		printf("static u32 crc32table_le[%d][%d] = {",
+		printf("static uint32_t crc32table_le[%d][%d] = {",
 		       LE_TABLE_ROWS, LE_TABLE_SIZE);
 		output_table(crc32table_le, LE_TABLE_ROWS,
 			     LE_TABLE_SIZE, "tole");
@@ -124,7 +124,7 @@ int main(int argc, char** argv)
 #if 0	/* not used by xfsprogs */
 	if (CRC_BE_BITS > 1) {
 		crc32init_be();
-		printf("static u32 crc32table_be[%d][%d] = {",
+		printf("static uint32_t crc32table_be[%d][%d] = {",
 		       BE_TABLE_ROWS, BE_TABLE_SIZE);
 		output_table(crc32table_be, LE_TABLE_ROWS,
 			     BE_TABLE_SIZE, "tobe");
@@ -133,7 +133,7 @@ int main(int argc, char** argv)
 #endif
 	if (CRC_LE_BITS > 1) {
 		crc32cinit_le();
-		printf("static u32 crc32ctable_le[%d][%d] = {",
+		printf("static uint32_t crc32ctable_le[%d][%d] = {",
 		       LE_TABLE_ROWS, LE_TABLE_SIZE);
 		output_table(crc32ctable_le, LE_TABLE_ROWS,
 			     LE_TABLE_SIZE, "tole");
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 72fc4b3..494daf4 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -58,7 +58,7 @@
 				 (ip)->d_ops, hdr, loghead)
 
 #include "libxfs_api_defs.h"
-#include <xfs/platform_defs.h>
+#include <platform_defs.h>
 
 #include <xfs/list.h>
 #include <xfs/hlist.h>
diff --git a/libxfs/radix-tree.c b/libxfs/radix-tree.c
index c4b6971..de21527 100644
--- a/libxfs/radix-tree.c
+++ b/libxfs/radix-tree.c
@@ -18,7 +18,7 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <xfs/platform_defs.h>
+#include <platform_defs.h>
 #include "radix-tree.h"
 
 #ifndef ARRAY_SIZE
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
