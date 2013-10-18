Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8DDA57F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 12:16:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7C97D30406B
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 10:16:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tHLPGrhXRj37635m for
	<xfs@oss.sgi.com>; Fri, 18 Oct 2013 10:16:18 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9IHGIdu032000
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 13:16:18 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r9IHGHY4031060
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 13:16:18 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfstests: use minimum log size in xfs/016
Date: Fri, 18 Oct 2013 13:16:14 -0400
Message-Id: <1382116574-7766-1-git-send-email-bfoster@redhat.com>
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

Test xfs/016 fails to run due to invalid mkfs options. The log size
is reported as too small according to the minimum log size
calculation:

log size 512 blocks too small, minimum size is 853 blocks

Update log_size to the currently specified minimum.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 tests/xfs/016 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/016 b/tests/xfs/016
index 2fc6af2..e52f80c 100755
--- a/tests/xfs/016
+++ b/tests/xfs/016
@@ -181,7 +181,7 @@ _supported_os Linux
 rm -f $seqres.full
 
 # mkfs sizes
-log_size=2097152
+log_size=3493888
 log_size_bb=`expr $log_size / 512`
 
 _require_scratch
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
