Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 50F787FA1
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:23:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3BC23304053
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 07:23:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BHR5Sf1Wai5t87p1 for
	<xfs@oss.sgi.com>; Thu, 10 Apr 2014 07:23:23 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3AENM6x023759
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 10:23:22 -0400
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] xfstests: Fix generic/022 output file
Date: Thu, 10 Apr 2014 16:23:17 +0200
Message-Id: <1397139797-9650-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>

In commit 21723cdb I've accidentally changed header in the output file
to a wrong number. It should be 022, fix it.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 tests/generic/022.out | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/022.out b/tests/generic/022.out
index 96c2d33..fbffa59 100644
--- a/tests/generic/022.out
+++ b/tests/generic/022.out
@@ -1,4 +1,4 @@
-QA output created by 009
+QA output created by 022
 	1. into a hole
 f4f35d60b3cc18aaa6d8d92f0cd3708a
 	2. into allocated space
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
