Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Sep 2007 19:40:59 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8H2epv0026307
	for <xfs@oss.sgi.com>; Sun, 16 Sep 2007 19:40:54 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l8GC4YA5031717
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 16 Sep 2007 14:04:34 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l8GC4XOj031713
	for xfs@oss.sgi.com; Sun, 16 Sep 2007 14:04:33 +0200
Date: Sun, 16 Sep 2007 14:04:33 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix valid but harmless sparse warning in xfs_log_recovery.c
Message-ID: <20070916120433.GA31602@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

The new xlog_recover_do_reg_buffer checks call be16_to_cpu on di_gen
which is a 32bit value so sparse rightly complains.  Fortunately the
warning is harmless because we don't care for the value, but only
whether it's non-NULL.  Due to that fact we can simply kill the endian
swaps on this and the previous di_mode check entirely.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2007-09-16 12:57:25.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2007-09-16 12:57:38.000000000 +0200
@@ -1920,9 +1920,9 @@ xlog_recover_do_reg_buffer(
 				stale_buf = 1;
 				break;
 			}
-			if (be16_to_cpu(dip->di_core.di_mode))
+			if (dip->di_core.di_mode)
 				mode_count++;
-			if (be16_to_cpu(dip->di_core.di_gen))
+			if (dip->di_core.di_gen)
 				gen_count++;
 		}
 
