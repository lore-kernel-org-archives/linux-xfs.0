Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39359 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750730AbdF3EMn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Jun 2017 00:12:43 -0400
Date: Thu, 29 Jun 2017 21:12:39 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 10/8] common/rc: test that the xfs_io scrub/repair commands
 actually work
Message-ID: <20170630041239.GE5871@birch.djwong.org>
References: <149808222258.8924.1682057078986741098.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149808222258.8924.1682057078986741098.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

When we call _require_xfs_io_command for the scrub ioctl, we have to
actually try calling the ioctl to make sure that the ioctl is present on
the running kernel.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/common/rc b/common/rc
index 0062f6f..a3addad 100644
--- a/common/rc
+++ b/common/rc
@@ -2186,6 +2186,11 @@ _require_xfs_io_command()
 		echo $testio | egrep -q "invalid option" && \
 			_notrun "xfs_io $command support is missing"
 		;;
+	"scrub"|"repair")
+		testio=`$XFS_IO_PROG -x -c "$command dummy 0" $TEST_DIR 2>&1`
+		echo $testio | egrep -q "Inappropriate ioctl" && \
+			_notrun "xfs_io $command support is missing"
+		;;
 	"utimes" )
 		testio=`$XFS_IO_PROG -f -c "utimes" 0 0 0 0 $testfile 2>&1`
 		;;
