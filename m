Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32658 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752000AbdAUAJh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jan 2017 19:09:37 -0500
Date: Fri, 20 Jan 2017 16:09:25 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v3 4/5] xfs_repair: zero shared_vn
Message-ID: <20170121000925.GJ12985@birch.djwong.org>
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

Since shared_vn always has to be zero, zero it at the start of repair.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: reset shared_vn in phase 1 and tell the user about it, per sandeen
v3: more suggestions by sandeen to make the new code more consistent
---
 repair/phase1.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/repair/phase1.c b/repair/phase1.c
index 126d0b3..9799883 100644
--- a/repair/phase1.c
+++ b/repair/phase1.c
@@ -138,6 +138,13 @@ _("Cannot disable lazy-counters on V5 fs\n"));
 		}
 	}
 
+	/* shared_vn should be zero */
+	if (sb->sb_shared_vn) {
+		do_warn(_("resetting shared_vn to zero\n"));
+		sb->sb_shared_vn = 0;
+		primary_sb_modified = 1;
+	}
+
 	if (primary_sb_modified)  {
 		if (!no_modify)  {
 			do_warn(_("writing modified primary superblock\n"));
