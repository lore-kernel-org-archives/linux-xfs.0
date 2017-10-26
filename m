Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28918 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932346AbdJZWPf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 18:15:35 -0400
Subject: [PATCH 06/10] xfs_repair: fix cowextsize field checking and
 repairing
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 26 Oct 2017 15:15:31 -0700
Message-ID: <150905613147.28563.3642613984403228295.stgit@magnolia>
In-Reply-To: <150905608689.28563.9670731739870415773.stgit@magnolia>
References: <150905608689.28563.9670731739870415773.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure that we never leave the filesystem with a zero cowextsize hint
while the cowextsize inode flag is set.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)


diff --git a/repair/dinode.c b/repair/dinode.c
index e62ec33..32cc769 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2694,6 +2694,7 @@ _("Cannot have non-zero CoW extent size %u on non-cowextsize inode %" PRIu64 ",
 					be32_to_cpu(dino->di_cowextsize), lino);
 			if (!no_modify)  {
 				do_warn(_("resetting to zero\n"));
+				dino->di_flags2 &= ~cpu_to_be64(XFS_DIFLAG2_COWEXTSIZE);
 				dino->di_cowextsize = 0;
 				*dirty = 1;
 			} else
@@ -2702,6 +2703,24 @@ _("Cannot have non-zero CoW extent size %u on non-cowextsize inode %" PRIu64 ",
 	}
 
 	/*
+	 * Can't have the COWEXTSIZE flag set with no hint.
+	 */
+	if (dino->di_version >= 3 &&
+	    be32_to_cpu(dino->di_cowextsize) == 0 &&
+	    (be64_to_cpu(dino->di_flags2) & XFS_DIFLAG2_COWEXTSIZE)) {
+		do_warn(
+_("Cannot have CoW extent size of zero on cowextsize inode %" PRIu64 ", "),
+				lino);
+		if (!no_modify)  {
+			do_warn(_("clearing cowextsize flag\n"));
+			dino->di_flags2 &= ~cpu_to_be64(XFS_DIFLAG2_COWEXTSIZE);
+			*dirty = 1;
+		} else {
+			do_warn(_("would clear cowextsize flag\n"));
+		}
+	}
+
+	/*
 	 * general size/consistency checks:
 	 */
 	if (process_check_inode_sizes(mp, dino, lino, type) != 0)

