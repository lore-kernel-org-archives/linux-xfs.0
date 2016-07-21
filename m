Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 10A057CA0
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 07:08:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C62AF8F804B
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 05:08:43 -0700 (PDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.75]) by
	cuda.sgi.com with ESMTP id WS6nPWkWh5BFWSt8 (version=TLSv1.2
	cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2016 05:08:41 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] xfs: remove dax code from object file when disabled
Date: Thu, 21 Jul 2016 14:07:50 +0200
Message-Id: <20160721120824.2797655-1-arnd@arndb.de>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Ross Zwisler <ross.zwisler@linux.intel.com>

We check IS_DAX(inode) before calling either xfs_file_dax_read or
xfs_file_dax_write, and this will lead the call being optimized out at
compile time when CONFIG_FS_DAX is disabled.

However, the two functions are marked STATIC, so they become global
symbols when CONFIG_XFS_DEBUG is set, leaving us with two unused global
functions that call into an undefined function and a broken "allmodconfig"
build:

fs/built-in.o: In function `xfs_file_dax_read':
fs/xfs/xfs_file.c:348: undefined reference to `dax_do_io'
fs/built-in.o: In function `xfs_file_dax_write':
fs/xfs/xfs_file.c:758: undefined reference to `dax_do_io'

Marking the two functions 'static noinline' instead of 'STATIC' will let
the compiler drop the symbols when there are no callers but avoid the
implicit inlining.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 16d4d43595b4 ("xfs: split direct I/O and DAX path")
---
 fs/xfs/xfs_file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 8ffacb8bba19..ed95e5bb04e6 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -327,7 +327,7 @@ xfs_file_dio_aio_read(
 	return ret;
 }
 
-STATIC ssize_t
+static noinline ssize_t
 xfs_file_dax_read(
 	struct kiocb		*iocb,
 	struct iov_iter		*to)
@@ -706,7 +706,7 @@ out:
 	return ret;
 }
 
-STATIC ssize_t
+static noinline ssize_t
 xfs_file_dax_write(
 	struct kiocb		*iocb,
 	struct iov_iter		*from)
-- 
2.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
