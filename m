Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:46258 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753851AbeEAPjh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 May 2018 11:39:37 -0400
Subject: [PATCH 2/9] xfs/439: repair corrupted filesystem afterwards
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 01 May 2018 08:39:32 -0700
Message-ID: <152518917279.23023.13530280927017959292.stgit@magnolia>
In-Reply-To: <152518916007.23023.4793255395982876953.stgit@magnolia>
References: <152518916007.23023.4793255395982876953.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

After we mess with logsunit and test that we can't mount the fs, repair
the filesystem to make sure that repair can deal with it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/439 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/439 b/tests/xfs/439
index 215c4b90..9d5f6892 100755
--- a/tests/xfs/439
+++ b/tests/xfs/439
@@ -79,6 +79,7 @@ fi
 _check_dmesg _filter_assert_dmesg
 
 echo "Silence is golden"
+_scratch_xfs_repair >> $seqres.full 2>&1
 
 # success, all done
 status=0

