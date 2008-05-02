Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 May 2008 19:08:43 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4228LpH020401
	for <xfs@oss.sgi.com>; Thu, 1 May 2008 19:08:21 -0700
From: xaiki@sgi.com
Subject: [PATCH] Don't use hashed dentries when doing open_by_handle
Date: Fri,  2 May 2008 11:55:38 +1000
Message-Id: <1209693339-4861-2-git-send-email-xaiki@sgi.com>
In-Reply-To: <1209693339-4861-1-git-send-email-xaiki@sgi.com>
References: <20080501070244.GH108924158@sgi.com>
 <1209693339-4861-1-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com
Cc: xfs@oss.sgi.com, Niv Sardi <xaiki@debian.org>, Niv Sardi <xaiki@sgi.com>

From: Niv Sardi <xaiki@debian.org>

Open by handle only require a handle, but that doesn't give us a file descriptor
that we require for any IO, before we used to call d_alloc_annon() that created
an annonymous disconnected but hashed dentry, from which we extracted the file
descriptor, if no one  else uses the dentry, the dput on fclose should unhash
the dentry and (if not used) tear it appart,

A repported issue is the DMAPI code was, that in some cases (as the dentry was
hashed) another thread could use the same dentry inibiting the unhash on the
first dput, and hence leaving that dentry on the unused list for ever (or untill
caches are dropped).

This cuts down d_alloc_annon to a subset that will only give us an anon
dentry, and NOT hash it.

Signed-off-by: Niv Sardi <xaiki@sgi.com>
---
 fs/xfs/linux-2.6/xfs_ioctl.c |    2 +-
 fs/xfs/linux-2.6/xfs_iops.c  |   17 +++++++++++++++++
 2 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
index 4c82a05..66ed268 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -311,7 +311,7 @@ xfs_open_by_handle(
 		return new_fd;
 	}
 
-	dentry = d_alloc_anon(inode);
+	dentry = xfs_d_alloc_anon(inode);
 	if (dentry == NULL) {
 		iput(inode);
 		put_unused_fd(new_fd);
diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index cc4abd3..cf5e83f 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -190,6 +190,23 @@ xfs_ichgtime_fast(
 		mark_inode_dirty_sync(inode);
 }
 
+struct dentry *
+xfs_d_alloc_anon(struct inode *inode)
+{
+	static const struct qstr anonstring = { .name = ""};
+	struct dentry	*res;
+
+	res = d_alloc(NULL, &anonstring);
+	if (!res)
+		return NULL;
+
+	/* attach a disconnected dentry */
+	res->d_sb = inode->i_sb;
+	res->d_parent = res;
+	res->d_inode = inode;
+
+	return res;
+}
 
 /*
  * Pull the link count and size up from the xfs inode to the linux inode
-- 
1.5.5.1
