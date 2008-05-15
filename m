Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 May 2008 10:04:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4FH4VdE017149
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 10:04:33 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D9AF11866F3
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 10:05:13 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id UIVn8C8u6TQpryKT for <xfs@oss.sgi.com>; Thu, 15 May 2008 10:05:13 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m4FH56F3009109
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 19:05:06 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m4FH56US009106
	for xfs@oss.sgi.com; Thu, 15 May 2008 19:05:06 +0200
Date: Thu, 15 May 2008 19:05:05 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix reiserfs case in 032
Message-ID: <20080515170505.GA8949@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

mkfs.reiserfs refuses to create a filesystem on full devices without
partitions unless it's given -f in addition to the already required Y
input to confirm the fs creation, so give the argument to it.

While we're at it also write the full command line used to create the
filesystem into the log to ease future debugging.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests/032
===================================================================
RCS file: /cvs/xfs-cmds/xfstests/032,v
retrieving revision 1.13
diff -u -p -r1.13 032
--- xfstests/032	9 Nov 2005 02:49:08 -0000	1.13
+++ xfstests/032	15 May 2008 17:02:08 -0000
@@ -43,7 +43,7 @@ do
 	[ $fs = vfat ] && postargs=2000
 	# these folks prompt before writing
 	[ $fs = jfs ] && preop="echo Y |"
-	[ $fs = reiserfs ] && preop="echo y |"
+	[ $fs = reiserfs ] && preop="echo y |" && preargs="-f"
 	# cramfs mkfs requires a directory argument
 	[ $fs = cramfs ] && preargs=/proc/fs/xfs
 
@@ -52,7 +52,7 @@ do
 
 	# create a filesystem of this type
 	echo "=== Creating $fs filesystem..." >>$seq.full
-	echo "    ( mkfs -t $fs $SCRATCH_DEV )" >>$seq.full
+	echo "    ( $preop mkfs -t $fs $preargs $SCRATCH_DEV $postargs )" >>$seq.full
 	eval $preop mkfs -t $fs $preargs $SCRATCH_DEV $postargs >>$seq.full 2>&1
 
 	# next, ensure we don't overwrite it
