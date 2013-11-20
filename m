Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2EC1229DF9
	for <xfs@oss.sgi.com>; Wed, 20 Nov 2013 11:54:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 16F5C304032
	for <xfs@oss.sgi.com>; Wed, 20 Nov 2013 09:54:34 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XBkdTACE8iaTSS4T for
	<xfs@oss.sgi.com>; Wed, 20 Nov 2013 09:54:33 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rAKHsWjO010356
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 20 Nov 2013 12:54:32 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id rAKHsWFZ002698
	for <xfs@oss.sgi.com>; Wed, 20 Nov 2013 12:54:32 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfstests: use correct size value in generic/273
Date: Wed, 20 Nov 2013 12:54:30 -0500
Message-Id: <1384970070-58732-1-git-send-email-bfoster@redhat.com>
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

generic/273 factors the "space available" output from df into the
calculation for the size of the origin data set. Recent commit

  bfdd1e72b358 xfstests: added -P option to $DF_PROG

... converted the use of 'df' to $DF_PROG. This implicitly adds the
-T parameter to add the fs type column, shifts the available space
column over by one and unintentionally causes 273 to look at "used
space" and create too small of a data set for a useful test.
Realign to the to the available space value.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 tests/generic/273 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/273 b/tests/generic/273
index 63bbf9b..2d54493 100755
--- a/tests/generic/273
+++ b/tests/generic/273
@@ -68,7 +68,7 @@ _file_create()
 
 	cd $SCRATCH_MNT/origin
 
-	_disksize=`$DF_PROG --block-size=1 $SCRATCH_DEV | awk -v sd=$SCRATCH_DEV 'BEGIN{c=0}{for(i=1;i<=NF;++i){a[c]=$i;++c}}END{for(entry in a){if(a[entry] ~ sd){print a[entry + 3]; break}}}'`
+	_disksize=`$DF_PROG --block-size=1 $SCRATCH_DEV | awk -v sd=$SCRATCH_DEV 'BEGIN{c=0}{for(i=1;i<=NF;++i){a[c]=$i;++c}}END{for(entry in a){if(a[entry] ~ sd){print a[entry + 4]; break}}}'`
 	_disksize=$(($_disksize / 3))
 	_num=$(($_disksize / $count / $threads / 4096))
 	_count=$count
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
