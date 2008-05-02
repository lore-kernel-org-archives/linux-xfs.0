Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 May 2008 19:08:39 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4228JgW020381
	for <xfs@oss.sgi.com>; Thu, 1 May 2008 19:08:19 -0700
From: xaiki@sgi.com
Subject: [PATCH] Use xfs_d_alloc_anon for DM rdwr using handle code.
Date: Fri,  2 May 2008 11:55:39 +1000
Message-Id: <1209693339-4861-3-git-send-email-xaiki@sgi.com>
In-Reply-To: <1209693339-4861-2-git-send-email-xaiki@sgi.com>
References: <20080501070244.GH108924158@sgi.com>
 <1209693339-4861-1-git-send-email-xaiki@sgi.com>
 <1209693339-4861-2-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com
Cc: xfs@oss.sgi.com, Niv Sardi <xaiki@debian.org>, Niv Sardi <xaiki@sgi.com>

From: Niv Sardi <xaiki@debian.org>

When doing invisible IO through the DMAPI we only require a handle, but
that doesn't give us a file descriptor that we require, before we used
to call d_alloc_annon() that created an annonymous disconnected but
hashed dentry, from which we extracted the file descriptor, if no one
else uses the dentry, the dput on fclose should unhash the dentry and
(if not used) tear appart the dentry, and call into xfs_inactive where
we will send the DESTROY EVENT. The issue was, that in some cases (as
the dentry was hashed) another thread could use the same dentry
inibiting the unhash on the first dput, and hence leaving that dentry on
the unused list for ever (or untill caches are dropped).

This uses the cuted down d_alloc_annon xfs implementation so that the dentry
is never hashed.

Signed-off-by: Niv Sardi <xaiki@sgi.com>
---
 fs/xfs/dmapi/xfs_dm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/dmapi/xfs_dm.c b/fs/xfs/dmapi/xfs_dm.c
index c4f57a9..5aa00a9 100644
--- a/fs/xfs/dmapi/xfs_dm.c
+++ b/fs/xfs/dmapi/xfs_dm.c
@@ -1126,7 +1126,7 @@ xfs_dm_rdwr(
 
 	igrab(inode);
 
-	dentry = d_alloc_anon(inode);
+	dentry = xfs_d_alloc_anon(inode);
 	if (dentry == NULL) {
 		iput(inode);
 		return ENOMEM;
-- 
1.5.5.1
