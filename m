Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 12 Oct 2008 05:30:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9CCTDAj028961
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 05:29:13 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C3C594E731D
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 05:30:47 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id NZBLB7C1zFszdphs for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 05:30:47 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m9CCUjIF030342
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 14:30:45 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m9CCUioa030340
	for xfs@oss.sgi.com; Sun, 12 Oct 2008 14:30:44 +0200
Date: Sun, 12 Oct 2008 14:30:44 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix remount rw with unrecognized options
Message-ID: <20081012123044.GA30272@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

When we skip unrecognized options in xfs_fs_remount we should just break
out of the switch and not return because otherwise we may skip clearing
the xfs-internal read-only flag.  This will only show up on some
operations like touch because most read-only checks are done by the VFS
which things this filesystem is r/w.  Eventually we should replace the
XFS read-only flag with a helper that always checks the VFS flag to make
sure they can never get out of sync.

Bug reported and fix verified by Marcel Beister on #xfs.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-10-11 00:59:04.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-10-11 00:59:35.000000000 +0200
@@ -1218,7 +1218,7 @@ xfs_fs_remount(
 	"XFS: mount option \"%s\" not supported for remount\n", p);
 			return -EINVAL;
 #else
-			return 0;
+			break;
 #endif
 		}
 	}
