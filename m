Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51874 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751544AbeBBVgc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Feb 2018 16:36:32 -0500
Subject: [PATCH 1/4] mkfs: don't create realtime filesystems with reflink
 enabled
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Feb 2018 13:36:27 -0800
Message-ID: <151760738718.29371.2619485698764869314.stgit@magnolia>
In-Reply-To: <151760738102.29371.13542858379823064383.stgit@magnolia>
References: <151760738102.29371.13542858379823064383.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We don't support reflink on the realtime device, so don't let people
create such things.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 219b209..b20e3d6 100644
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

