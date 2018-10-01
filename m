Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:35350 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbeJBFZc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Oct 2018 01:25:32 -0400
Date: Mon, 1 Oct 2018 15:45:00 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] vfs: check ->get_link return value
Message-ID: <20181001224500.GE5872@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: viro@ZenIV.linux.org.uk
Cc: xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Teach callers of inode->i_op->get_link in the vfs code to check for a
NULL return value and return an error status instead of blindly
dereferencing the returned NULL pointer.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/namei.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/namei.c b/fs/namei.c
index 0cab6494978c..0744ab981fa0 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4737,6 +4737,8 @@ int vfs_readlink(struct dentry *dentry, char __user *buffer, int buflen)
 		if (IS_ERR(link))
 			return PTR_ERR(link);
 	}
+	if (!link)
+		return -EUCLEAN;
 	res = readlink_copy(buffer, buflen, link);
 	do_delayed_call(&done);
 	return res;
@@ -4763,6 +4765,8 @@ const char *vfs_get_link(struct dentry *dentry, struct delayed_call *done)
 		res = ERR_PTR(security_inode_readlink(dentry));
 		if (!res)
 			res = inode->i_op->get_link(dentry, inode, done);
+		if (!res)
+			return ERR_PTR(-EUCLEAN);
 	}
 	return res;
 }
