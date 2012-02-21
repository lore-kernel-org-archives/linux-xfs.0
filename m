Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1LGwveH198222 for <xfs@oss.sgi.com>; Tue, 21 Feb 2012 10:58:57 -0600
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150]) by
	cuda.sgi.com with ESMTP id NenRovq0msVZfQqn (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 Feb 2012 08:58:56 -0800 (PST)
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Tue, 21 Feb 2012 09:58:56 -0700
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 42B12C90054
	for <xfs@oss.sgi.com>; Tue, 21 Feb 2012 11:58:54 -0500 (EST)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q1LGwqKF159536 for <xfs@oss.sgi.com>; Tue, 21 Feb 2012 11:58:53 -0500
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id q1LGwkak000779
	for <xfs@oss.sgi.com>; Tue, 21 Feb 2012 09:58:46 -0700
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Tue, 21 Feb 2012 10:58:45 -0600
Message-Id: <20120221165845.23253.658.sendpatchset@chandra-lucid.austin.ibm.com>
In-Reply-To: <20120221165833.23253.38042.sendpatchset@chandra-lucid.austin.ibm.com>
References: <20120221165833.23253.38042.sendpatchset@chandra-lucid.austin.ibm.com>
Subject: [PATCH 2/4] xfstests: Add a require_seppquota function
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

>From 6076480613e3034eab9758903c093a0b24048658 Mon Sep 17 00:00:00 2001
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Wed, 8 Feb 2012 10:04:49 -0600
Subject: [PATCH 2/3] Add a require_seppquota function in preparation for testing
 simultaneous use of pquota and gquota in a filesystem

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 common.quota |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/common.quota b/common.quota
index 9736306..16344ea 100644
--- a/common.quota
+++ b/common.quota
@@ -87,6 +87,15 @@ _require_nobody()
     [ $? -ne 0 ] && _notrun "group file does not contain nobody/nogroup."
 }
 
+#
+# checks to see if mkfs supports separate pquota
+#
+_require_seppquota()
+{
+    mkfs.xfs -o test 2>&1 | grep seppquota > /dev/null
+    [ $? -ne 0 ] && _notrun "mkfs does not support separate pquota."
+}
+
 # create a file as a specific user (uid)
 # takes filename, id, type (u/g/p), blocksize, blockcount
 #
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
