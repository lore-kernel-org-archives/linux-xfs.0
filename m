Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52612 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfA2QR2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Jan 2019 11:17:28 -0500
Subject: [PATCH 2/4] xfs/138: format the scratch device before using it
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 29 Jan 2019 08:17:19 -0800
Message-ID: <154877863906.9277.11927709578869134810.stgit@magnolia>
In-Reply-To: <154877863279.9277.4463697450629081138.stgit@magnolia>
References: <154877863279.9277.4463697450629081138.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Format the scratch device before using it, or else xfs_db will fail,
particularly if the previous test left a corrupt fs behind.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/138 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/138 b/tests/xfs/138
index 36490e6a..41988530 100755
--- a/tests/xfs/138
+++ b/tests/xfs/138
@@ -38,6 +38,7 @@ echo This is file B
 ENDL
 
 echo "Test with -c"
+_scratch_mkfs > $seqres.full 2>&1
 _scratch_xfs_db -c "sb 0" -c "p magicnum" -c "source $tmp.a" -c "p magicnum" | sed -e 's/0x58465342/XFS_MAGIC/g'
 
 echo "Test with interactive"
