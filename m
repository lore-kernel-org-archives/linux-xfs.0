Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41329 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751285AbdA1Ria (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 28 Jan 2017 12:38:30 -0500
Subject: [PATCH 3/3] xfs/030: ignore lost rmapbt blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 28 Jan 2017 09:38:25 -0800
Message-ID: <148562510529.30594.2372809333277654802.stgit@birch.djwong.org>
In-Reply-To: <148562509264.30594.7506967863745489318.stgit@birch.djwong.org>
References: <148562509264.30594.7506967863745489318.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we destroy the AG0 headers, we also lose track of the rmapbt
blocks, which causes xfs_repair to complain about their unconnectedness.
Filter out the error message from the output.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/030 |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/030 b/tests/xfs/030
index 5c99d9e..15f41ed 100755
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -60,7 +60,8 @@ _check_ag()
 			    -e '/^bad agbno AGBNO for finobt/d' \
 			    -e '/^bad agbno AGBNO for rmapbt/d' \
 			    -e '/^bad agbno AGBNO for refcntbt/d' \
-			    -e '/^Missing reverse-mapping record.*/d'
+			    -e '/^Missing reverse-mapping record.*/d' \
+			    -e '/^unknown block state, ag 0, block.*/d'
 	done
 }
 

