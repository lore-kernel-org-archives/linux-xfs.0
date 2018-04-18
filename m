Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47264 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753144AbeDRCr7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:47:59 -0400
Subject: [PATCH 11/11] xfs_repair: don't assert on bad '.' entry in
 no-modify mode
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:47:40 -0700
Message-ID: <152401966025.13319.16584599904269469257.stgit@magnolia>
In-Reply-To: <152401958920.13319.10756339531174871801.stgit@magnolia>
References: <152401958920.13319.10756339531174871801.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

During phase 3, we check the '.' entry of a directory inode and (in
modify mode) zap it if the name isn't valid.  During phase 6, we assert
that the '.' entry now reflects the correct name.  In no-modify mode
this is incorrect because we didn't actually fix anything, so repair
asserts and crashes.

Found by fuzzing bu[0].namelen = 4 in xfs/387 and running xfs_repair -n.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase6.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 2005e40..e65fc4a 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1884,7 +1884,8 @@ longform_dir2_entry_check_data(
 		 * of when directory is moved to orphanage.
 		 */
 		if (ip->i_ino == inum)  {
-			ASSERT(dep->name[0] == '.' && dep->namelen == 1);
+			ASSERT(no_modify ||
+			       (dep->name[0] == '.' && dep->namelen == 1));
 			add_inode_ref(current_irec, current_ino_offset);
 			if (da_bno != 0 ||
 			    dep != M_DIROPS(mp)->data_entry_p(d)) {

