Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B8D477CB8
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 06:53:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 401B6AC002
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 04:53:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mSWIad3wFX2WOZsT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 31 May 2016 04:53:20 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v22 20/22] vfs: Add richacl permission checking
Date: Tue, 31 May 2016 13:50:52 +0200
Message-Id: <1464695454-18557-21-git-send-email-agruenba@redhat.com>
In-Reply-To: <1464695454-18557-1-git-send-email-agruenba@redhat.com>
References: <1464695454-18557-1-git-send-email-agruenba@redhat.com>
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
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

Hook the richacl permission checking function into the vfs.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/namei.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 52 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 234f911..8780e7d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -34,6 +34,7 @@
 #include <linux/device_cgroup.h>
 #include <linux/fs_struct.h>
 #include <linux/posix_acl.h>
+#include <linux/richacl.h>
 #include <linux/hash.h>
 #include <linux/bitops.h>
 #include <asm/uaccess.h>
@@ -256,7 +257,43 @@ void putname(struct filename *name)
 		__putname(name);
 }
 
-static int check_acl(struct inode *inode, int mask)
+static int check_richacl(struct inode *inode, int mask)
+{
+#ifdef CONFIG_FS_RICHACL
+	if (mask & MAY_NOT_BLOCK) {
+		struct base_acl *base_acl;
+
+		base_acl = rcu_dereference(inode->i_acl);
+		if (!base_acl)
+			goto no_acl;
+		/* no ->get_richacl() calls in RCU mode... */
+		if (is_uncached_acl(base_acl))
+			return -ECHILD;
+		return richacl_permission(inode, richacl(base_acl),
+					  mask & ~MAY_NOT_BLOCK);
+	} else {
+		struct richacl *acl;
+
+		acl = get_richacl(inode);
+		if (IS_ERR(acl))
+			return PTR_ERR(acl);
+		if (acl) {
+			int error = richacl_permission(inode, acl, mask);
+			richacl_put(acl);
+			return error;
+		}
+	}
+no_acl:
+#endif
+	if (mask & (MAY_DELETE_SELF | MAY_TAKE_OWNERSHIP |
+		    MAY_CHMOD | MAY_SET_TIMES)) {
+		/* File permission bits cannot grant this. */
+		return -EACCES;
+	}
+	return -EAGAIN;
+}
+
+static int check_posix_acl(struct inode *inode, int mask)
 {
 #ifdef CONFIG_FS_POSIX_ACL
 	if (mask & MAY_NOT_BLOCK) {
@@ -294,11 +331,24 @@ static int acl_permission_check(struct inode *inode, int mask)
 {
 	unsigned int mode = inode->i_mode;
 
+	/*
+	 * With POSIX ACLs, the (mode & S_IRWXU) bits exactly match the owner
+	 * permissions, and we can skip checking posix acls for the owner.
+	 * With richacls, the owner may be granted fewer permissions than the
+	 * mode bits seem to suggest (for example, append but not write), and
+	 * we always need to check the richacl.
+	 */
+
+	if (IS_RICHACL(inode)) {
+		int error = check_richacl(inode, mask);
+		if (error != -EAGAIN)
+			return error;
+	}
 	if (likely(uid_eq(current_fsuid(), inode->i_uid)))
 		mode >>= 6;
 	else {
 		if (IS_POSIXACL(inode) && (mode & S_IRWXG)) {
-			int error = check_acl(inode, mask);
+			int error = check_posix_acl(inode, mask);
 			if (error != -EAGAIN)
 				return error;
 		}
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
