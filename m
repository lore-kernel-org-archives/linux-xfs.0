Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mALMHgfP013704 for <xfs@oss.sgi.com>; Fri, 21 Nov 2008 16:17:42 -0600
Received: from zero.voxel.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DAF0F15C1190
	for <xfs@oss.sgi.com>; Fri, 21 Nov 2008 14:17:41 -0800 (PST)
Received: from zero.voxel.net (zero.voxel.net [69.9.191.6]) by cuda.sgi.com
	with ESMTP id G73WsDPYmJmrL1sn for <xfs@oss.sgi.com>;
	Fri, 21 Nov 2008 14:17:41 -0800 (PST)
Received: from mail.magoazul.com (localhost [127.0.0.1])
	by zero.voxel.net (Postfix) with ESMTP id CBAF11BB005F
	for <xfs@oss.sgi.com>; Fri, 21 Nov 2008 17:17:10 -0500 (EST)
Message-ID: <72b2ec8a9397a88aff5abf5c8590f282.squirrel@mail.voxel.net>
In-Reply-To: <a2da1d27af9a31cc891cfeeafc27abf4.squirrel@mail.voxel.net>
References: <a2da1d27af9a31cc891cfeeafc27abf4.squirrel@mail.voxel.net>
Date: Fri, 21 Nov 2008 14:17:10 -0800 (PST)
Subject: Re: couple small xfstest patches
From: "Matthew Kent" <mkent@magoazul.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20081121141710_72777"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

------=_20081121141710_72777
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

> * add a unified diff output option, find it easier on the eyes ;)

oops :)

fixed.
-- 
Matthew Kent <mkent@magoazul.com>
http://magoazul.com
------=_20081121141710_72777
Content-Type: text/x-diff; name="xfstest-unified_diff.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="xfstest-unified_diff.patch"

--- xfs-cmds/xfstests/common.orig	2008-11-21 14:13:12.000000000 -0800
+++ xfs-cmds/xfstests/common	2008-11-21 14:15:37.000000000 -0800
@@ -107,6 +107,7 @@
     -nfs                test NFS
     -l			line mode diff (default)
     -xdiff		graphical mode diff
+    -udiff		show unified diff
     -n			show me, do not run tests
     -q			quick [deprecated]
     -T			output timestamps
@@ -157,6 +158,11 @@
 	    fi
 	    ;;
 
+	-udiff)	# show a unified diff
+	    xpand=false
+	    diff="$diff -u"
+	    ;;
+
 	-q)	# "quick", no longer used - always quick :-)
 	    xpand=false
 	    ;;
------=_20081121141710_72777
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------=_20081121141710_72777--
