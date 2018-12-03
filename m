Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:60959
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725937AbeLCIee (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 03:34:34 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/11] ovl: allow cross-device copy_file_range calls
Date: Mon,  3 Dec 2018 19:34:16 +1100
Message-Id: <20181203083416.28978-12-david@fromorbit.com>
In-Reply-To: <20181203083416.28978-1-david@fromorbit.com>
References: <20181203083416.28978-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: olga.kornievskaia@gmail.com, linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Restrictions on cross-device copy_file_range() only affect the
vfs_copy_file_range() call to the lower filesystems. They will
handle the copy appropriately, so OVL will never see a EXDEV error
from them. Hence we can remove the EXDEV checks and error handling
from the ovl_copy_file_range() implementation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/overlayfs/file.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 34fb0398d016..146901d204df 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -443,14 +443,6 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 	const struct cred *old_cred;
 	loff_t ret;
 
-	/*
-	 * Temporary. Cross device copy checks should be left to the copy file
-	 * call on the real inodes, but existing behaviour checks the upper
-	 * files only.
-	 */
-	if (file_inode(file_in)->i_sb != file_inode(file_out)->i_sb)
-		return -EXDEV;
-
 	ret = ovl_real_fdget(file_out, &real_out);
 	if (ret)
 		return ret;
@@ -499,7 +491,8 @@ static ssize_t ovl_copy_file_range(struct file *file_in, loff_t pos_in,
 	ret =  ovl_copyfile(file_in, pos_in, file_out, pos_out, len, flags,
 			    OVL_COPY);
 
-	if (ret == -EOPNOTSUPP || ret == -EXDEV)
+	WARN_ON_ONCE(ret == -EXDEV);
+	if (ret == -EOPNOTSUPP)
 		ret = generic_copy_file_range(file_in, pos_in, file_out,
 					pos_out, len, flags);
 	return ret;
-- 
2.19.1
