Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Jun 2007 12:47:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5IJkvds002574
	for <xfs@oss.sgi.com>; Mon, 18 Jun 2007 12:47:10 -0700
Date: Mon, 18 Jun 2007 11:55:12 +1000
From: David Chinner <dgc@sgi.com>
Subject: [PATCH 3 of 3] Multi-File Data Streams V3 - export radix tree function
Message-ID: <20070618015512.GY86004887@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

XFS can be built as a module, so the filestreams code needs
this function exported.

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
