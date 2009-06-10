Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5AHpptc104200 for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 12:51:51 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A5A01A9EAB1
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 10:52:11 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id CeFYOXHUo0fOdEcb for
	<xfs@oss.sgi.com>; Wed, 10 Jun 2009 10:52:11 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 28E96A9BE26
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 12:52:10 -0500 (CDT)
Message-ID: <4A2FF2CB.1060805@sandeen.net>
Date: Wed, 10 Jun 2009 12:52:11 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests:  Skip dump _cleanup if filesystem is not xfs
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

Skip dump _cleanup if filesystem is not xfs

Many/most dump tests include common.dump before checking
supported fs, and this means that even if the dump tests
are skipped, the sleep & filesystem check in _cleanup
gets run, which makes it take rather a long time to
skip these tests for non-xfs filesystems.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/common.dump b/common.dump
index 94de07f..d5aadfc 100644
--- a/common.dump
+++ b/common.dump
@@ -233,6 +233,12 @@ _wipe_fs()
 #
 _cleanup()
 {
+    # Some tests include this before checking _supported_fs xfs
+    # and the sleeps & checks get annoying
+    if [ "$FSTYP" != "xfs" ]; then
+       return
+    fi
+
     cd $here
     rm -f $tmp.*
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
