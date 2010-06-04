Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o54HvYxb237525 for <xfs@oss.sgi.com>; Fri, 4 Jun 2010 12:57:35 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 50B2A398CD8
	for <xfs@oss.sgi.com>; Fri,  4 Jun 2010 11:00:02 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id MOeCW2VfnX1Ps14q for
	<xfs@oss.sgi.com>; Fri, 04 Jun 2010 11:00:02 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 648204817DE0
	for <xfs@oss.sgi.com>; Fri,  4 Jun 2010 13:00:02 -0500 (CDT)
Message-ID: <4C093F22.1010006@sandeen.net>
Date: Fri, 04 Jun 2010 13:00:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V3] xfstests: use stat not lstat when examining devices
References: <4C091B4E.5030503@sandeen.net> <4C0939B9.9000109@sandeen.net>
In-Reply-To: <4C0939B9.9000109@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

If you try running xfstests on lvm volumes which are symlinks,
it'll fail to run several tests because our _require_scratch 
framework ultimately uses lstat not stat, and does not think 
the lvm device (which is usually a symlink to a dm-X device) 
is a block device.  Sigh.

Just calling stat(1) with -L to follow the link should
suffice.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/common.rc b/common.rc
index 6bf1e12..db18884 100644
--- a/common.rc
+++ b/common.rc
@@ -584,7 +584,7 @@ _is_block_dev()
 	exit 1
     fi
 
-    [ -b $1 ] && src/lstat64 $1 | $AWK_PROG '/Device type:/ { print $9 }'
+    [ -b $1 ] && stat -L $1 | $AWK_PROG '/Device type:/ { print $9 }'
 }
 
 # Do a command, log it to $seq.full, optionally test return status

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
