Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o19Kg0Vh249343 for <xfs@oss.sgi.com>; Tue, 9 Feb 2010 14:42:00 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1E1861391828
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2010 12:43:12 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id YcUfyIAEwBRwMyVD for
	<xfs@oss.sgi.com>; Tue, 09 Feb 2010 12:43:12 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id B3C31127664A
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2010 14:43:11 -0600 (CST)
Message-ID: <4B71C8DF.1090909@sandeen.net>
Date: Tue, 09 Feb 2010 14:43:11 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: make 204 generic
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

204 can be generic.

Also remove a stray _scratch_mkfs that snuck into
_scratch_mkfs_sized :/

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/204 b/204
index 1ac9ebf..14ebcdc 100755
--- a/204
+++ b/204
@@ -35,12 +35,13 @@ status=1	# failure is the default!
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os Linux
 
 _require_scratch
 
-_scratch_mkfs_xfs -d size=104m >/dev/null
+SIZE=104*1024*1024
+_scratch_mkfs_sized $SIZE  &> /dev/null
 _scratch_mount
 
 for i in `seq 1 22500`; do
diff --git a/common.rc b/common.rc
index 0a02a2b..c76bcde 100644
--- a/common.rc
+++ b/common.rc
@@ -325,7 +325,6 @@ _scratch_mkfs_sized()
 	_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_sized"
 	;;
     esac
-    _scratch_mkfs
 }
 
 # Emulate an N-data-disk stripe w/ various stripe units

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
