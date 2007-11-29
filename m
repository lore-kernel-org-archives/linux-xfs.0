Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 28 Nov 2007 20:03:40 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAT43WpX003195
	for <xfs@oss.sgi.com>; Wed, 28 Nov 2007 20:03:34 -0800
Received: from Liberator.local (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id C8EF41800449D
	for <xfs@oss.sgi.com>; Wed, 28 Nov 2007 22:03:39 -0600 (CST)
Message-ID: <474E3A1C.4050302@sandeen.net>
Date: Wed, 28 Nov 2007 22:03:40 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] make xfs_info work on mountpoints with spaces
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

I don't know why one would make mountpoints with spaces, but
apparently people do:

[Bug 402621] New: xfs_info doesn't handle mountpoint with spaces
https://bugzilla.redhat.com/show_bug.cgi?id=402621

I'm no bash expert but I think this solves it:

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

---

--- xfs-cmds.orig/xfsprogs/growfs/xfs_info.sh	2007-11-28 09:14:02.000000000 -0600
+++ xfs-cmds/xfsprogs/growfs/xfs_info.sh	2007-11-28 09:21:49.000000000 -0600
@@ -16,10 +16,10 @@
 		;;
 	esac
 done
-set -- extra $@
+set -- extra "$@"
 shift $OPTIND
 case $# in
-	1)	xfs_growfs -p xfs_info -n $OPTS $1
+	1)	xfs_growfs -p xfs_info -n $OPTS "$1"
 		status=$?
 		;;
 	*)	echo $USAGE 1>&2
