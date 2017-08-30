Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20524 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751236AbdH3Wbq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 18:31:46 -0400
Date: Wed, 30 Aug 2017 15:31:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 6/4] common/rc: fix xfs_io scrub command existence test
Message-ID: <20170830223141.GB4754@magnolia>
References: <150406805060.31349.16766271336969357123.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150406805060.31349.16766271336969357123.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

The name of the xfs_io scrub subcommand to test for the existence of the
ioctl has been changed to 'test' from 'dummy', so fix xfstests.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/rc b/common/rc
index b4f0b32..ea58736 100644
--- a/common/rc
+++ b/common/rc
@@ -2203,7 +2203,7 @@ _require_xfs_io_command()
 			_notrun "xfs_io $command support is missing"
 		;;
 	"scrub"|"repair")
-		testio=`$XFS_IO_PROG -x -c "$command dummy 0" $TEST_DIR 2>&1`
+		testio=`$XFS_IO_PROG -x -c "$command test 0" $TEST_DIR 2>&1`
 		echo $testio | egrep -q "Inappropriate ioctl" && \
 			_notrun "xfs_io $command support is missing"
 		;;
