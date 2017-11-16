Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49179 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933234AbdKPBXD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2017 20:23:03 -0500
Subject: [PATCH 5/5] xfs/122: don't check xfs_iext_cursor
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 15 Nov 2017 17:22:50 -0800
Message-ID: <151079537016.25590.3421772833264696226.stgit@magnolia>
In-Reply-To: <151079533937.25590.1037061486182471724.stgit@magnolia>
References: <151079533937.25590.1037061486182471724.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't size-check the incore extent map cursor; it's not a disk structure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/122 b/tests/xfs/122
index f39ceba..671a77b 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -187,6 +187,7 @@ xfs_trans_t
 xfs_dirent_t
 xfs_fsop_getparents_handlereq_t
 xfs_dinode_core_t
+struct xfs_iext_cursor
 EOF
 
 echo 'int main(int argc, char *argv[]) {' >>$cprog

