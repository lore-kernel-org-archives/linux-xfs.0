Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 May 2008 12:07:14 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4PJ7B9j022310
	for <xfs@oss.sgi.com>; Sun, 25 May 2008 12:07:11 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F040BD9342
	for <xfs@oss.sgi.com>; Sun, 25 May 2008 12:08:02 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id pvXBFlcZp1AX4VHf for <xfs@oss.sgi.com>; Sun, 25 May 2008 12:08:02 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m4PJ7sF3014133
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 25 May 2008 21:07:54 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m4PJ7sWr014131
	for xfs@oss.sgi.com; Sun, 25 May 2008 21:07:54 +0200
Date: Sun, 25 May 2008 21:07:54 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/4] fix biosize option
Message-ID: <20080525190754.GD13372@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

iosizelog shouldn't be the same as iosize but the logarithm of it.  Then
again the current biosize option doesn't make much sense to me as it
doesn't set the preferred I/O size as mentioned in the comment next to
it but rather the allocation size and thus is identical to the allocsize
option (except for the missing logarithm).  It's also not documented in
Documentation/filesystems/xfs.txt or the mount manpage.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-05-25 20:59:04.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-05-25 20:59:38.000000000 +0200
@@ -252,7 +252,7 @@ xfs_parseargs(
 				return EINVAL;
 			}
 			iosize = simple_strtoul(value, &eov, 10);
-			iosizelog = (uint8_t) iosize;
+			iosizelog = ffs(iosize) - 1;
 		} else if (!strcmp(this_char, MNTOPT_ALLOCSIZE)) {
 			if (!value || !*value) {
 				cmn_err(CE_WARN,
