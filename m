Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3JKsloT008673 for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 15:54:47 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 953AC2254B5
	for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 13:54:41 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id Ep9jaEewXVUrsB0P for
	<xfs@oss.sgi.com>; Sun, 19 Apr 2009 13:54:41 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 5AB1CAC358C
	for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 15:54:41 -0500 (CDT)
Message-ID: <49EB8F90.20705@sandeen.net>
Date: Sun, 19 Apr 2009 15:54:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: skip dump tests if dump utils not found
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

I was running xfstests on a NAS box which had no xfsdump,
and any tests which required xfsdump were failing in not-so-nice
ways:

> xfsdump not found
038      [failed, exit status 1] - output mismatch (see 038.out.bad)

I think using _notrun is a lot better:

038      [not run] xfsdump not found

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/common.dump b/common.dump
index 6d2f120..fcc4945 100644
--- a/common.dump
+++ b/common.dump
@@ -23,9 +23,9 @@ if [ -n "$DEBUGDUMP" ]; then
 	[ -x $here/xfsinvutil ] && echo "Using xfstests' xfsinvutil for debug"
 fi
 
-[ "$XFSDUMP_PROG" = "" ]    && _fatal "xfsdump not found"
-[ "$XFSRESTORE_PROG" = "" ] && _fatal "xfsrestore not found"
-[ "$XFSINVUTIL_PROG" = "" ] && _fatal "xfsinvutil not found"
+[ "$XFSDUMP_PROG" = "" ]    && _notrun "xfsdump not found"
+[ "$XFSRESTORE_PROG" = "" ] && _notrun "xfsrestore not found"
+[ "$XFSINVUTIL_PROG" = "" ] && _notrun "xfsinvutil not found"
 
 # status returned for not run tests
 NOTRUNSTS=2


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
