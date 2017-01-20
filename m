Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17833 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752234AbdATWx2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jan 2017 17:53:28 -0500
Date: Fri, 20 Jan 2017 14:52:51 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 4/5] xfs_repair: zero shared_vn
Message-ID: <20170120225251.GH12985@birch.djwong.org>
References: <148494391629.5256.3328772079712970611.stgit@birch.djwong.org>
 <148494394162.5256.166843220095123974.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148494394162.5256.166843220095123974.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

Since shared_vn always has to be zero, zero it at the end of repair.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: reset shared_vn in phase 1 and tell the user about it, per sandeen
---
 repair/phase1.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/repair/phase1.c b/repair/phase1.c
index 126d0b3..ee5d3d7 100644
--- a/repair/phase1.c
+++ b/repair/phase1.c
@@ -138,6 +138,17 @@ _("Cannot disable lazy-counters on V5 fs\n"));
 		}
 	}
 
+	/* shared_vn should be zero */
+	if (sb->sb_shared_vn) {
+		if (!no_modify)  {
+			do_warn(_("resetting shared_vn to zero\n"));
+			sb->sb_shared_vn = 0;
+			primary_sb_modified = 1;
+		} else  {
+			do_warn(_("would reset shared_vn to zero\n"));
+		}
+	}
+
 	if (primary_sb_modified)  {
 		if (!no_modify)  {
 			do_warn(_("writing modified primary superblock\n"));
