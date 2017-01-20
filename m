Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29342 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753222AbdATU0U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jan 2017 15:26:20 -0500
Subject: [PATCH 4/5] xfs_repair: zero shared_vn
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 20 Jan 2017 12:25:41 -0800
Message-ID: <148494394162.5256.166843220095123974.stgit@birch.djwong.org>
In-Reply-To: <148494391629.5256.3328772079712970611.stgit@birch.djwong.org>
References: <148494391629.5256.3328772079712970611.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Since shared_vn always has to be zero, zero it at the end of repair.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/xfs_repair.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 622d569..ecfa6b4 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1050,6 +1050,9 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
 			be32_to_cpu(dsb->sb_unit), be32_to_cpu(dsb->sb_width));
 	}
 
+	/* shared_vn is always zero. */
+	dsb->sb_shared_vn = 0;
+
 	libxfs_writebuf(sbp, 0);
 
 	/*

