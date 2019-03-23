Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:32804 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbfCWAiV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Mar 2019 20:38:21 -0400
Date: Fri, 22 Mar 2019 17:38:13 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] ext4: prohibit fstrim in norecovery mode
Message-ID: <20190323003813.GR1183@magnolia>
References: <20190323003532.GB1180@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190323003532.GB1180@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: Eryu Guan <guaneryu@gmail.com>, fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

The ext4 fstrim implementation uses the block bitmaps to find free space
that can be discarded.  If we haven't replayed the journal, the bitmaps
will be stale and we absolutely *cannot* use stale metadata to zap the
underlying storage.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/ioctl.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 3c4f8bb59f8a..bab3da4f1e0d 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1000,6 +1000,13 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (!blk_queue_discard(q))
 			return -EOPNOTSUPP;
 
+		/*
+		 * We haven't replayed the journal, so we cannot use our
+		 * block-bitmap-guided storage zapping commands.
+		 */
+		if (test_opt(sb, NOLOAD) && ext4_has_feature_journal(sb))
+			return -EROFS;
+
 		if (copy_from_user(&range, (struct fstrim_range __user *)arg,
 		    sizeof(range)))
 			return -EFAULT;
