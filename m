Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Jun 2007 21:28:13 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5D4S7Wt003056
	for <xfs@oss.sgi.com>; Tue, 12 Jun 2007 21:28:09 -0700
Date: Wed, 13 Jun 2007 14:27:58 +1000
From: David Chinner <dgc@sgi.com>
Subject: [PATCH] Export radix_tree_preload()
Message-ID: <20070613042758.GJ86004887@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lkml <linux-kernel@vger.kernel.org>
Cc: xfs-oss <xfs@oss.sgi.com>


Upcoming XFS functionality [1] uses radix trees and uses the preload
functions. XFS can be built as a module and hence we need 
radix_tree_preload() exported. radix_tree_preload_end() is a
static inline, so it doesn't need exporting.

[1] http://marc.info/?l=linux-xfs&m=118170839531601&w=2

Signed-Off-By: Dave Chinner <dgc@sgi.com>

---
 lib/radix-tree.c |    1 +
 1 file changed, 1 insertion(+)

Index: 2.6.x-xfs-new/lib/radix-tree.c
===================================================================
--- 2.6.x-xfs-new.orig/lib/radix-tree.c	2007-03-29 19:00:53.802804161 +1000
+++ 2.6.x-xfs-new/lib/radix-tree.c	2007-03-29 19:07:10.297495640 +1000
@@ -151,6 +151,7 @@ int radix_tree_preload(gfp_t gfp_mask)
 out:
 	return ret;
 }
+EXPORT_SYMBOL(radix_tree_preload);
 
 static inline void tag_set(struct radix_tree_node *node, unsigned int tag,
 		int offset)
