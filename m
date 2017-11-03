Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31030 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbdKCE2W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2017 00:28:22 -0400
Date: Thu, 2 Nov 2017 21:28:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 15/14] xfs/020: check that we have enough space to write out
 a huge fs
Message-ID: <20171103042802.GD1233@magnolia>
References: <150957278824.18388.17975162441125293654.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150957278824.18388.17975162441125293654.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure that we have enough free space on the test fs to create a
60t sparse filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/020 |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tests/xfs/020 b/tests/xfs/020
index 120492d..b037369 100755
--- a/tests/xfs/020
+++ b/tests/xfs/020
@@ -49,6 +49,10 @@ _supported_fs xfs
 _supported_os Linux
 _require_test
 
+# Writing a 60t fs requires about 2GB of space, so make sure
+# we have plenty of space to do that.
+_require_fs_space $TEST_DIR 2500000
+
 echo "Silence is golden"
 
 fsfile=$TEST_DIR/fsfile.$seq
