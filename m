Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 12 Oct 2008 05:30:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9CCU394029070
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 05:30:03 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C70304E7321
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 05:31:37 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id B8FYSdvGb7ilH0Ci for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 05:31:37 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m9CCVaIF030408
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 14:31:36 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m9CCVag5030406
	for xfs@oss.sgi.com; Sun, 12 Oct 2008 14:31:36 +0200
Date: Sun, 12 Oct 2008 14:31:36 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] update xfsqa 189 to check for writeable fs after remount rw
Message-ID: <20081012123136.GB30272@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-cmds/xfstests/189
===================================================================
--- xfs-cmds.orig/xfstests/189	2008-08-15 06:11:24.000000000 -1000
+++ xfs-cmds/xfstests/189	2008-10-12 02:24:25.000000000 -1000
@@ -90,6 +90,34 @@
 }
 
 #
+# make sure we really can write to a filesystem after remount,rw
+#
+_test_remount_write()
+{
+	echo
+	echo "try touching file after remount ro -> rw with options"
+	echo
+	_scratch_mount
+	[ $? -eq 0 ] || echo "mount (1) failed unexpectedly"
+
+	touch $SCRATCH_MNT/foobar
+	[ $? -eq 0 ] || echo "touch (1) failed unexpectedly"
+
+	umount $SCRATCH_MNT
+
+	_scratch_mount -o ro
+	[ $? -eq 0 ] || echo "mount (2) failed unexpectedly"
+
+	_mount -o remount,rw,filestreams $SCRATCH_MNT
+	[ $? -eq 0 ] || echo "remount failed unexpectedly"
+
+	touch $SCRATCH_MNT/foobar
+	[ $? -eq 0 ] || echo "touch (2) failed unexpectedly"
+
+	umount $SCRATCH_MNT
+}
+
+#
 # barrier is the only option we can change besides ro<->rw which is partially
 # handled by the VFS and tested elsewhere.  Make sure mount accepts going
 # from barrier (which also is the default) to nobarrier and back.
@@ -166,6 +194,7 @@
 
 _add_scratch_fstab
 _test_remount_rw
+_test_remount_write
 
 echo
 echo "add noikeep to fstab for scratch"
