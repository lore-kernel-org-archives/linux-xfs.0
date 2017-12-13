Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50120 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750745AbdLMX2M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 18:28:12 -0500
Date: Wed, 13 Dec 2017 15:28:05 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 8/8] xfs/068: fix clonerange problems in file/dir count
 output
Message-ID: <20171213232805.GI6896@magnolia>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
 <151314505158.18893.11894289091110903029.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151314505158.18893.11894289091110903029.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In this test we use a fixed sequence of operations in fsstress to create
some number of files and dirs and then exercise xfsdump/xfsrestore on
them.  Since clonerange/deduperange are not supported on all xfs
configurations, detect if they're in fsstress and disable them so that
we always execute exactly the same sequence of operations no matter how
the filesystem is configured.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/068 |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tests/xfs/068 b/tests/xfs/068
index 7151e28..f95a539 100755
--- a/tests/xfs/068
+++ b/tests/xfs/068
@@ -43,6 +43,14 @@ trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
 _supported_fs xfs
 _supported_os Linux
 
+# Remove fsstress commands that aren't supported on all xfs configs
+if $FSSTRESS_PROG | grep -q clonerange; then
+	FSSTRESS_AVOID="-f clonerange=0 $FSSTRESS_AVOID"
+fi
+if $FSSTRESS_PROG | grep -q deduperange; then
+	FSSTRESS_AVOID="-f deduperange=0 $FSSTRESS_AVOID"
+fi
+
 _create_dumpdir_stress_num 4096
 _do_dump_restore
 
