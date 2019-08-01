Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42390 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfHABmu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 21:42:50 -0400
Subject: [PATCH 1/5] xfs/122: ignore inode geometry structure
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 31 Jul 2019 18:42:41 -0700
Message-ID: <156462376150.2945299.17354409699083869260.stgit@magnolia>
In-Reply-To: <156462375516.2945299.16564635037236083118.stgit@magnolia>
References: <156462375516.2945299.16564635037236083118.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Ignore new in-core structure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/122 b/tests/xfs/122
index b66b78a6..89a39a23 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -177,6 +177,7 @@ xfs_dirent_t
 xfs_fsop_getparents_handlereq_t
 xfs_dinode_core_t
 struct xfs_iext_cursor
+struct xfs_ino_geometry
 EOF
 
 echo 'int main(int argc, char *argv[]) {' >>$cprog
