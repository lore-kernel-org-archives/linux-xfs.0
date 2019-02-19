Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:44598 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbfBSScu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Feb 2019 13:32:50 -0500
Date: Tue, 19 Feb 2019 10:32:38 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs/450: require working falloc command
Message-ID: <20190219183238.GI6477@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

This test needs to check for working falloc command before using it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/450 |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/xfs/450 b/tests/xfs/450
index 15b73877..615aded7 100755
--- a/tests/xfs/450
+++ b/tests/xfs/450
@@ -32,6 +32,7 @@ rm -f $seqres.full
 # real QA test starts here
 _supported_os Linux
 _supported_fs xfs
+_require_xfs_io_command "falloc"
 _require_test_program "punch-alternating"
 _require_xfs_scratch_rmapbt
 
