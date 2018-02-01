Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:54968 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932104AbeBAArs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jan 2018 19:47:48 -0500
Date: Wed, 31 Jan 2018 16:47:45 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] mkfs: don't create realtime filesystems with reflink enabled
Message-ID: <20180201004745.GL4849@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

We don't support reflink on the realtime device, so don't let people
create such things.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f527476..07774ed 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2025,6 +2025,13 @@ _("cowextsize not supported without reflink support\n"));
 		usage();
 	}
 
+	if (cli->sb_feat.reflink && cli->xi->rtname) {
+		fprintf(stderr,
+_("reflink not supported with realtime devices\n"));
+		usage();
+		cli->sb_feat.reflink = false;
+	}
+
 	if (cli->sb_feat.rmapbt && cli->xi->rtname) {
 		fprintf(stderr,
 _("rmapbt not supported with realtime devices\n"));
