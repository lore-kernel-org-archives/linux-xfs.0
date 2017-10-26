Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51107 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751236AbdJZWPa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 18:15:30 -0400
Subject: [PATCH 05/10] xfs_repair: clear DAX flag from non-file inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 26 Oct 2017 15:15:25 -0700
Message-ID: <150905612541.28563.17883126104053106652.stgit@magnolia>
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

The DAX flag should only be set for files and directories.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/repair/dinode.c b/repair/dinode.c
index e7de6d4..e62ec33 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2510,6 +2510,18 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 			flags2 &= XFS_DIFLAG2_ANY;
 		}
 
+		if (flags2 & XFS_DIFLAG2_DAX) {
+			/* must be a file or dir */
+			if (di_mode && !(S_ISREG(di_mode) || S_ISDIR(di_mode))) {
+				if (!uncertain) {
+					do_warn(
+	_("DAX flag set on special inode %" PRIu64 "\n"),
+						lino);
+				}
+				flags2 &= ~XFS_DIFLAG2_DAX;
+			}
+		}
+
 		if ((flags2 & XFS_DIFLAG2_REFLINK) &&
 		    !xfs_sb_version_hasreflink(&mp->m_sb)) {
 			if (!uncertain) {

