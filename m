Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1B2FE7F50
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 08:52:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 098C030406B
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 06:52:00 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OmKR736LIUiYsHHU for
	<xfs@oss.sgi.com>; Thu, 28 Mar 2013 06:52:00 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2SDpxD5024497
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 09:51:59 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfstests: fix common rc file path in new
Date: Thu, 28 Mar 2013 21:51:23 +0800
Message-Id: <1364478683-6752-1-git-send-email-eguan@redhat.com>
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
Cc: Eryu Guan <eguan@redhat.com>

After the re-factor common.rc has been renamed to common/rc, fix the
path in script new, otherwise ./new reports

./new: line 26: ./common.rc: No such file or directory
Building include
Building lib
Building ltp
Building src
Building m4
./new: line 70: BEGIN{printf "%03d\n",+1}: command not found
Next test is
Error: test  already exists!

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
After applying this patch, ./new generates new test starting from 001,
so we have to maintain the seq number manually? Do we need an updated
version of new? eg. takes an argument to specify the test type like

	./new generic

and generates new test based on existing seq number in generic dir.

 new | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/new b/new
index 94638f6..b21e75b 100755
--- a/new
+++ b/new
@@ -23,7 +23,7 @@
 
 # generic initialization
 iam=new
-. ./common.rc
+. ./common/rc
 
 trap "rm -f /tmp/$$.; exit" 0 1 2 3 15
 
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
