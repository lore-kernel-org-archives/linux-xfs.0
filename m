Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EF8D87F5A
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 02:18:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C55668F8037
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 00:18:09 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bksSGSdGsd3Vlc1Q (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Feb 2016 00:18:08 -0800 (PST)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v18 10/22] posix_acl: Unexport acl_by_type and make it static
Date: Mon, 29 Feb 2016 09:17:15 +0100
Message-Id: <1456733847-17982-11-git-send-email-agruenba@redhat.com>
In-Reply-To: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
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
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

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
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
