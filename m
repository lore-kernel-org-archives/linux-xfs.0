Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 31B567F5A
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 07:51:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A16E1AC004
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 05:51:29 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lEzArWUWhsdHi0QO (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Dec 2015 05:51:25 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id E65C63B712
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 13:51:24 +0000 (UTC)
Received: from schleppi.home.com (vpn1-6-147.ams2.redhat.com [10.36.6.147])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tBMDpH2K030386
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 08:51:23 -0500
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 3/6] fsx: Report number of successful operations
Date: Tue, 22 Dec 2015 14:51:09 +0100
Message-Id: <1450792272-7402-4-git-send-email-agruenba@redhat.com>
In-Reply-To: <1450792272-7402-1-git-send-email-agruenba@redhat.com>
References: <1450792272-7402-1-git-send-email-agruenba@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Report the number of successful operations at the end of an fsx run.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 ltp/fsx.c             |  2 +-
 tests/generic/127.out | 12 ++++++------
 tests/generic/231.out | 12 ++++++------
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 16d74c0..0f4c49e 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -1881,7 +1881,7 @@ main(int argc, char **argv)
 		prterr("close");
 		report_failure(99);
 	}
-	prt("All operations completed A-OK!\n");
+	prt("All %lu operations completed A-OK!\n", testcalls);
 
 	exit(0);
 	return 0;
diff --git a/tests/generic/127.out b/tests/generic/127.out
index 120c20a..9459dc8 100644
--- a/tests/generic/127.out
+++ b/tests/generic/127.out
@@ -1,13 +1,13 @@
 QA output created by 127
 === FSX Light Mode, No Memory Mapping ===
-All operations completed A-OK!
+All 100000 operations completed A-OK!
 === FSX Light Mode, Memory Mapping ===
-All operations completed A-OK!
+All 100000 operations completed A-OK!
 === FSX Standard Mode, No Memory Mapping ===
-All operations completed A-OK!
+All 100000 operations completed A-OK!
 === FSX Standard Mode, Memory Mapping ===
-All operations completed A-OK!
+All 100000 operations completed A-OK!
 === FSX Standard Mode, No Memory Mapping ===
-All operations completed A-OK!
+All 100000 operations completed A-OK!
 === FSX Standard Mode, Memory Mapping ===
-All operations completed A-OK!
+All 100000 operations completed A-OK!
diff --git a/tests/generic/231.out b/tests/generic/231.out
index ef264a9..8707b26 100644
--- a/tests/generic/231.out
+++ b/tests/generic/231.out
@@ -1,16 +1,16 @@
 QA output created by 231
 === FSX Standard Mode, Memory Mapping, 1 Tasks ===
-All operations completed A-OK!
+All 20000 operations completed A-OK!
 Comparing user usage
 Comparing group usage
 === FSX Standard Mode, Memory Mapping, 4 Tasks ===
-All operations completed A-OK!
-All operations completed A-OK!
-All operations completed A-OK!
-All operations completed A-OK!
+All 20000 operations completed A-OK!
+All 20000 operations completed A-OK!
+All 20000 operations completed A-OK!
+All 20000 operations completed A-OK!
 Comparing user usage
 Comparing group usage
 === FSX Standard Mode, Memory Mapping, 1 Tasks ===
-All operations completed A-OK!
+All 20000 operations completed A-OK!
 Comparing user usage
 Comparing group usage
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
