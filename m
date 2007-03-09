Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 Mar 2007 23:54:12 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l297s66p005196
	for <xfs@oss.sgi.com>; Thu, 8 Mar 2007 23:54:08 -0800
Date: Fri, 9 Mar 2007 07:34:10 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] New xfs_repair handling for inode nlink counts
Message-ID: <20070309073410.GA8798@infradead.org>
References: <200703090619.RAA15327@larry.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703090619.RAA15327@larry.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@melbourne.sgi.com>
Cc: xfs@oss.sgi.com, xfs-dev@sgi.com


+#ifdef TRACK_MEMORY
+
+#undef calloc
+#undef malloc
+#undef memalign
+#undef realloc
+#undef free


	Can you put all thise into a memory_tracking.h file that
	gets include with:

	#ifdef TRACK_MEMORY
	#include "track_memory.h"
	#endif

	Instead of polluting the implementation file?

+	/* add pointer to hash list, very basic simple hash function */
+	i = (((size_t)p) >> 8) & 0xff;

+	i = (((size_t)ptr) >> 8) & 0xff;

	Note that there is not guarantee that size_t and pointers have the
	same lenght, and there are system where it's not (win64?), better
	cast things use uintptr_t here.

--- xfsprogs.orig/repair/globals.h
+++ xfsprogs/repair/globals.h
@@ -16,6 +16,16 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#ifdef TRACK_MEMORY
+
+#define calloc(n,s)	track_calloc(__FILE__, __LINE__, (n), (s))
+#define malloc(s)	track_malloc(__FILE__, __LINE__, (s))
+#define memalign(b,s)	track_memalign(__FILE__, __LINE__, (b), (s))
+#define realloc(p,s)	track_realloc(__FILE__, __LINE__, (p), (s))
+#define free(p)		track_free(__FILE__, __LINE__, (p))
+
+#endif
+
 #ifndef _XFS_REPAIR_GLOBAL_H
 #define _XFS_REPAIR_GLOBAL_H

	The memory tracking should probably come after the inclusion
	guards.
