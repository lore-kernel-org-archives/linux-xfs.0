Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5DBCB7FDA
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 05:15:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EE937AC00B
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 03:15:15 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 4ZDMLpxxzBzyiUHK (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 03 Jul 2015 03:15:14 -0700 (PDT)
Received: from [88.128.80.19] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZAy02-0003kO-11
	for xfs@oss.sgi.com; Fri, 03 Jul 2015 10:15:14 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/13] xfsprogs: include libxfs.h in libxfs_priv.h
Date: Fri,  3 Jul 2015 12:12:18 +0200
Message-Id: <1435918341-10128-11-git-send-email-hch@lst.de>
In-Reply-To: <1435918341-10128-1-git-send-email-hch@lst.de>
References: <1435918341-10128-1-git-send-email-hch@lst.de>
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

libxfs_priv.h duplicates large parts of libxfs.h.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/libxfs.h     |  4 ----
 libxfs/libxfs_priv.h | 37 +------------------------------------
 2 files changed, 1 insertion(+), 40 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index 1fb2d6d..62553f0 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -163,12 +163,8 @@ extern int	libxfs_bmap_finish(xfs_trans_t **, xfs_bmap_free_t *, int *);
 extern void 	libxfs_fs_repair_cmn_err(int, struct xfs_mount *, char *, ...);
 extern void	libxfs_fs_cmn_err(int, struct xfs_mount *, char *, ...);
 
-/* XXX: this is messy and needs fixing */
-#ifndef __LIBXFS_INTERNAL_XFS_H__
 extern void cmn_err(int, char *, ...);
 enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
-#endif
-
 
 extern int		libxfs_nproc(void);
 extern unsigned long	libxfs_physmem(void);	/* in kilobytes */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 7a29fd7..aaa24df 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -57,39 +57,7 @@
 	__xfs_dir2_data_freescan((ip)->i_mount->m_dir_geo, \
 				 (ip)->d_ops, hdr, loghead)
 
-#include "libxfs_api_defs.h"
-#include "platform_defs.h"
-
-#include "list.h"
-#include "hlist.h"
-#include "cache.h"
-#include "bitops.h"
-#include "kmem.h"
-#include "radix-tree.h"
-#include "atomic.h"
-
-#include "xfs_types.h"
-#include "xfs_arch.h"
-
-#include "xfs_fs.h"
-
-/* CRC stuff, buffer API dependent on it */
-extern uint32_t crc32_le(uint32_t crc, unsigned char const *p, size_t len);
-extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
-
-#define crc32(c,p,l)	crc32_le((c),(unsigned char const *)(p),(l))
-#define crc32c(c,p,l)	crc32c_le((c),(unsigned char const *)(p),(l))
-
-#include "xfs_cksum.h"
-
-/*
- * This mirrors the kernel include for xfs_buf.h - it's implicitly included in
- * every files via a similar include in the kernel xfs_linux.h.
- */
-#include "libxfs_io.h"
-
-/* for all the support code that uses progname in error messages */
-extern char    *progname;
+#include "libxfs.h"
 
 #undef ASSERT
 #define ASSERT(ex) assert(ex)
@@ -115,9 +83,6 @@ extern char    *progname;
 #define XFS_IGET_CREATE			0x1
 #define XFS_IGET_UNTRUSTED		0x2
 
-extern void cmn_err(int, char *, ...);
-enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
-
 #define xfs_notice(mp,fmt,args...)		cmn_err(CE_NOTE,fmt, ## args)
 #define xfs_warn(mp,fmt,args...)		cmn_err(CE_WARN,fmt, ## args)
 #define xfs_hex_dump(d,n)		((void) 0)
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
