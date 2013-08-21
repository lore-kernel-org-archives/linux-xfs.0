Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0AE448000
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 11:03:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EC2488F8037
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 09:03:39 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id vb9C7PbcdfF5OmBd (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 21 Aug 2013 09:03:38 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id CBCB07C042D
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 10:03:37 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] xfstests: btrfs/003: stat the dev we're removing to make sure
	its' really gone
Date: Wed, 21 Aug 2013 12:03:35 -0400
Message-ID: <1377101015-3070-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

I've been periodically failing btrfs/003 because my box sometimes takes a little
longer to unregister the device when we remove it and so the output from btrfs
dev show doesn't match what we are wanting since it still sees the device.  To
fix this just stat and sleep if we still see the device node and only continue
once udev or whatever actually removes the device node so that we don't get
random failures.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/btrfs/003 |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tests/btrfs/003 b/tests/btrfs/003
index 5c88651..dba1a32 100755
--- a/tests/btrfs/003
+++ b/tests/btrfs/003
@@ -145,6 +145,12 @@ _test_replace()
 	_devmgt_remove ${DEVHTL}
 	dev_removed=1
 
+	stat $ds >> $seqres.full 2>&1
+	while [ $? -eq 0 ]; do
+		sleep 1
+		stat $ds >> $seqres.full 2>&1
+	done
+
 	$BTRFS_UTIL_PROG fi show $SCRATCH_DEV | grep "Some devices missing" >> $seqres.full || _fail \
 							"btrfs did not report device missing"
 
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
