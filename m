Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Jul 2007 19:06:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6N26Xbm004274
	for <xfs@oss.sgi.com>; Sun, 22 Jul 2007 19:06:35 -0700
Date: Mon, 23 Jul 2007 12:06:30 +1000
From: David Chinner <dgc@sgi.com>
Subject: Review: increase default filestreams timeout
Message-ID: <20070723020630.GU12413810@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

The default is too low resulting in far too frequent workqueue
flushing and it's unlikely that it will work properly with buffered
I/O on such a low timeout. i.e. test 172 expects the timeout of 50
(default) expects buffered I/O to fail to lay the streams out
without interleaving.

Set the default timeout to 30s instead of 500ms.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/linux-2.6/xfs_globals.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_globals.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_globals.c	2007-07-09 16:06:23.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_globals.c	2007-07-17 09:06:46.595999067 +1000
@@ -49,7 +49,7 @@ xfs_param_t xfs_params = {
 	.inherit_nosym	= {	0,		0,		1	},
 	.rotorstep	= {	1,		1,		255	},
 	.inherit_nodfrg	= {	0,		1,		1	},
-	.fstrm_timer	= {	1,		50,		3600*100},
+	.fstrm_timer	= {	1,		30*100,		3600*100},
 };
 
 /*
