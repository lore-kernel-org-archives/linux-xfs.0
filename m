Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3JLp6ht011215 for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 16:51:06 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A268D14328DC
	for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 14:53:33 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id Av3g2YRFPT14FpHQ for
	<xfs@oss.sgi.com>; Sun, 19 Apr 2009 14:53:33 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id F20EAAC358C
	for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 16:50:59 -0500 (CDT)
Message-ID: <49EB9CC3.1000305@sandeen.net>
Date: Sun, 19 Apr 2009 16:50:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: skip fsr tests if xfs_fsr utils not found
References: <49EB8F90.20705@sandeen.net>
In-Reply-To: <49EB8F90.20705@sandeen.net>
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

Similar to the xfsdump-related patch; gracefully fail
if no xfs_fsr is found.

I'll probably send another for the acl & attr userspace,
it's actually not always installed on minimal boxes.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/042 b/042
index 7c2bcac..6628040 100755
--- a/042
+++ b/042
@@ -37,6 +37,8 @@ _supported_os IRIX Linux
 
 _require_scratch
 
+[ "$XFS_FSR_PROG" = "" ] && _notrun "xfs_fsr not found"
+
 _cull_files()
 {
     perl -e "\$manifest=\"$tmp.manifest\";" -e '
diff --git a/111 b/111
index 060c0bc..3ce4ee1 100755
--- a/111
+++ b/111
@@ -27,6 +27,8 @@ _supported_fs xfs
 _supported_os Linux
 _require_scratch
 
+[ "$XFS_FSR_PROG" = "" ] && _notrun "xfs_fsr not found"
+
 # real QA test starts here
 umount $SCRATCH_DEV 2>/dev/null
 MKFS_OPTIONS="-bsize=4096"


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
