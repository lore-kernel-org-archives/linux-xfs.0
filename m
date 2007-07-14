Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 14 Jul 2007 09:07:40 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6EG7abm016473
	for <xfs@oss.sgi.com>; Sat, 14 Jul 2007 09:07:38 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l6EG7bNO008517
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 14 Jul 2007 18:07:38 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l6EG64E5008423
	for xfs@oss.sgi.com; Sat, 14 Jul 2007 18:06:04 +0200
Date: Sat, 14 Jul 2007 18:06:04 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix sparse warning in kmem_shake_allow
Message-ID: <20070714160604.GB7768@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

We can't returned a masked result of a __bitwise type.  Compare it to
0 first to keep the behaviour without the warning.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/kmem.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/kmem.h	2007-07-14 16:00:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/kmem.h	2007-07-14 16:00:38.000000000 +0200
@@ -103,7 +103,7 @@ extern void *kmem_zone_zalloc(kmem_zone_
 static inline int
 kmem_shake_allow(gfp_t gfp_mask)
 {
-	return (gfp_mask & __GFP_WAIT);
+	return (gfp_mask & __GFP_WAIT) != 0;
 }
 
 #endif /* __XFS_SUPPORT_KMEM_H__ */
