Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2CDDD29DF9
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 09:23:12 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B60E4AC002
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 07:23:11 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pyQz4f1UPpDFtT8R (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Jan 2016 07:23:10 -0800 (PST)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v17 10/22] posix_acl: Unexport acl_by_type and make it static
Date: Mon, 11 Jan 2016 16:21:41 +0100
Message-Id: <1452525713-11348-11-git-send-email-agruenba@redhat.com>
In-Reply-To: <1452525713-11348-1-git-send-email-agruenba@redhat.com>
References: <1452525713-11348-1-git-send-email-agruenba@redhat.com>
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
To: Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>

acl_by_type(inode, type) returns a pointer to either inode->i_acl or
inode->i_default_acl depending on type.  This is useful in
fs/posix_acl.c, but should never have been visible outside that file.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/posix_acl.c            | 3 +--
 include/linux/posix_acl.h | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 711dd51..55f2445 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -21,7 +21,7 @@
 #include <linux/export.h>
 #include <linux/user_namespace.h>
 
-struct posix_acl **acl_by_type(struct inode *inode, int type)
+static struct posix_acl **acl_by_type(struct inode *inode, int type)
 {
 	switch (type) {
 	case ACL_TYPE_ACCESS:
@@ -32,7 +32,6 @@ struct posix_acl **acl_by_type(struct inode *inode, int type)
 		BUG();
 	}
 }
-EXPORT_SYMBOL(acl_by_type);
 
 struct posix_acl *get_cached_acl(struct inode *inode, int type)
 {
diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index 3e96a6a..5b5a80c 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -99,7 +99,6 @@ extern int posix_acl_create(struct inode *, umode_t *, struct posix_acl **,
 extern int simple_set_acl(struct inode *, struct posix_acl *, int);
 extern int simple_acl_create(struct inode *, struct inode *);
 
-struct posix_acl **acl_by_type(struct inode *inode, int type);
 struct posix_acl *get_cached_acl(struct inode *inode, int type);
 struct posix_acl *get_cached_acl_rcu(struct inode *inode, int type);
 void set_cached_acl(struct inode *inode, int type, struct posix_acl *acl);
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
