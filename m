Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6FBE57CA2
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 11:20:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 41F8D304048
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 09:20:14 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id ShsweVOuIoWeGYOT (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 May 2016 09:20:12 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 5/5] fs: Avoid premature clearing of capabilities
Date: Thu, 26 May 2016 18:20:00 +0200
Message-Id: <1464279600-13009-6-git-send-email-jack@suse.cz>
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

Currently, notify_change() clears capabilities or IMA attributes by
calling security_inode_killpriv() before calling into ->setattr. Thus it
happens before any other permission checks in inode_change_ok() and user
is thus allowed to trigger clearing of capabilities or IMA attributes
for any file he can look up e.g. by calling chown for that file. This is
unexpected and can lead to user DoSing a system.

Fix the problem by calling security_inode_killpriv() at the end of
inode_change_ok() instead of from notify_change(). At that moment we are
sure user has permissions to do the requested change.

References: CVE-2015-1350
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/attr.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index ee758afc1695..8d9698eda636 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -47,7 +47,7 @@ int setattr_prepare(struct dentry *dentry, struct iattr *attr)
 
 	/* If force is set do it anyway. */
 	if (ia_valid & ATTR_FORCE)
-		return 0;
+		goto kill_priv;
 
 	/* Make sure a caller can chown. */
 	if ((ia_valid & ATTR_UID) &&
@@ -80,6 +80,16 @@ int setattr_prepare(struct dentry *dentry, struct iattr *attr)
 			return -EPERM;
 	}
 
+kill_priv:
+	/* User has permission for the change */
+	if (ia_valid & ATTR_KILL_PRIV) {
+		int error;
+
+		error = security_inode_killpriv(dentry);
+		if (error)
+			return error;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL(setattr_prepare);
@@ -220,13 +230,11 @@ int notify_change(struct dentry * dentry, struct iattr * attr, struct inode **de
 	if (!(ia_valid & ATTR_MTIME_SET))
 		attr->ia_mtime = now;
 	if (ia_valid & ATTR_KILL_PRIV) {
-		attr->ia_valid &= ~ATTR_KILL_PRIV;
-		ia_valid &= ~ATTR_KILL_PRIV;
 		error = security_inode_need_killpriv(dentry);
-		if (error > 0)
-			error = security_inode_killpriv(dentry);
-		if (error)
+		if (error < 0)
 			return error;
+		if (error == 0)
+			ia_valid = attr->ia_valid &= ~ATTR_KILL_PRIV;
 	}
 
 	/*
-- 
2.6.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
