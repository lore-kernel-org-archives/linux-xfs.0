Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 613D97CA2
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 11:20:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 25E3E304039
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 09:20:12 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id vdzdVPtrC1nXPGpx (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 May 2016 09:20:09 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/5] ceph: Propagate dentry down to inode_change_ok()
Date: Thu, 26 May 2016 18:19:57 +0200
Message-Id: <1464279600-13009-3-git-send-email-jack@suse.cz>
In-Reply-To: <1464279600-13009-1-git-send-email-jack@suse.cz>
References: <1464279600-13009-1-git-send-email-jack@suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

To avoid clearing of capabilities or security related extended
attributes too early, inode_change_ok() will need to take dentry instead
of inode. ceph_setattr() has the dentry easily available but
__ceph_setattr() is also called from ceph_set_acl() where dentry is not
easily available. Luckily that call path does not need inode_change_ok()
to be called anyway. So reorganize functions a bit so that
inode_change_ok() is called only from paths where dentry is available.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ceph/acl.c   |  5 +++++
 fs/ceph/inode.c | 19 +++++++++++--------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
index 013151d50069..a2cedfde75eb 100644
--- a/fs/ceph/acl.c
+++ b/fs/ceph/acl.c
@@ -127,6 +127,11 @@ int ceph_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 			goto out_free;
 	}
 
+	if (ceph_snap(inode) != CEPH_NOSNAP) {
+		ret = -EROFS;
+		goto out_free;
+	}
+
 	if (new_mode != old_mode) {
 		newattrs.ia_mode = new_mode;
 		newattrs.ia_valid = ATTR_MODE;
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index e669cfa9d793..29873cbd6b2b 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1791,13 +1791,6 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr)
 	int inode_dirty_flags = 0;
 	bool lock_snap_rwsem = false;
 
-	if (ceph_snap(inode) != CEPH_NOSNAP)
-		return -EROFS;
-
-	err = inode_change_ok(inode, attr);
-	if (err != 0)
-		return err;
-
 	prealloc_cf = ceph_alloc_cap_flush();
 	if (!prealloc_cf)
 		return -ENOMEM;
@@ -2011,7 +2004,17 @@ out_put:
  */
 int ceph_setattr(struct dentry *dentry, struct iattr *attr)
 {
-	return __ceph_setattr(d_inode(dentry), attr);
+	struct inode *inode = d_inode(dentry);
+	int err;
+
+	if (ceph_snap(inode) != CEPH_NOSNAP)
+		return -EROFS;
+
+	err = inode_change_ok(inode, attr);
+	if (err != 0)
+		return err;
+
+	return __ceph_setattr(inode, attr);
 }
 
 /*
-- 
2.6.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
