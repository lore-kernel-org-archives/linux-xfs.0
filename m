Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51379 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934923AbcLURDv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:03:51 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 03/30] ceph: remove the bump of i_version
Date: Wed, 21 Dec 2016 12:03:20 -0500
Message-Id: <1482339827-7882-4-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

Eventually, we'll want to wire it up to use the change attribute that
the cluster tracks instead, but for now this is unneeded.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/ceph/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 398e5328b309..c3406acb36e7 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -796,7 +796,6 @@ static int fill_inode(struct inode *inode, struct page *locked_page,
 
 	/* update inode */
 	ci->i_version = le64_to_cpu(info->version);
-	inode->i_version++;
 	inode->i_rdev = le32_to_cpu(info->rdev);
 	inode->i_blkbits = fls(le32_to_cpu(info->layout.fl_stripe_unit)) - 1;
 
-- 
2.7.4

