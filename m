Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49638 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751831AbeGDEvf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jul 2018 00:51:35 -0400
Subject: [PATCH 7/7] misc: filter out quota regeneration messages
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 03 Jul 2018 21:51:31 -0700
Message-ID: <153067989145.28393.919913817035657015.stgit@magnolia>
In-Reply-To: <153067984748.28393.1595618163831671652.stgit@magnolia>
References: <153067984748.28393.1595618163831671652.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Filter out quota regeneration messages from xfs_repair when we check the
filesystem, because the xfs tests that encode xfs_repair output in the
golden output will fail when quotas are enabled and the xfs_repair quota
messages appear.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/repair |    1 +
 1 file changed, 1 insertion(+)


diff --git a/common/repair b/common/repair
index 6bbaffbe..c94939c9 100644
--- a/common/repair
+++ b/common/repair
@@ -81,6 +81,7 @@ s/(superblock) (\d+)/\1 AGNO/;
 s/(AG \#)(\d+)/\1AGNO/;
 s/(reset bad sb for ag) (\d+)/\1 AGNO/;
 s/(unknown block state, ag )(\d+)(, block )(\d+)/\1AGNO\3AGBNO/;
+/^Note - quota info will be regenerated on next quota mount.$/ && next;
 	print;'
 }
 

