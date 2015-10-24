Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B68147F6B
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 16:16:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8997C8F8040
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 14:16:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CvB30xGVeHUg0EmD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 24 Oct 2015 14:16:15 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 2C063C0B2B75
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 21:16:15 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 1/4] xfs: Validate the length of on-disk ACLs
Date: Sat, 24 Oct 2015 23:16:06 +0200
Message-Id: <1445721369-25679-2-git-send-email-agruenba@redhat.com>
In-Reply-To: <1445721369-25679-1-git-send-email-agruenba@redhat.com>
References: <1445721369-25679-1-git-send-email-agruenba@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com
Cc: Andreas Gruenbacher <agruenba@redhat.com>

In xfs_acl_from_disk, instead of trusting that xfs_acl.acl_cnt is correct,
make sure that the length of the attributes is correct as well.  Also, turn
the aclp parameter into a const pointer.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h |  8 ++++++--
 fs/xfs/xfs_acl.c           | 13 ++++++++-----
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 9590a06..0e62682 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1487,9 +1487,13 @@ struct xfs_acl {
 						sizeof(struct xfs_acl_entry) \
 		: 25)
 
-#define XFS_ACL_MAX_SIZE(mp) \
+#define XFS_ACL_SIZE(cnt) \
 	(sizeof(struct xfs_acl) + \
-		sizeof(struct xfs_acl_entry) * XFS_ACL_MAX_ENTRIES((mp)))
+		sizeof(struct xfs_acl_entry) * cnt)
+
+#define XFS_ACL_MAX_SIZE(mp) \
+	XFS_ACL_SIZE(XFS_ACL_MAX_ENTRIES((mp)))
+
 
 /* On-disk XFS extended attribute names */
 #define SGI_ACL_FILE		"SGI_ACL_FILE"
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 4b64167..763e365 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -37,16 +37,19 @@
 
 STATIC struct posix_acl *
 xfs_acl_from_disk(
-	struct xfs_acl	*aclp,
-	int		max_entries)
+	const struct xfs_acl	*aclp,
+	int			len,
+	int			max_entries)
 {
 	struct posix_acl_entry *acl_e;
 	struct posix_acl *acl;
-	struct xfs_acl_entry *ace;
+	const struct xfs_acl_entry *ace;
 	unsigned int count, i;
 
+	if (len < sizeof(*aclp))
+		return ERR_PTR(-EFSCORRUPTED);
 	count = be32_to_cpu(aclp->acl_cnt);
-	if (count > max_entries)
+	if (count > max_entries || XFS_ACL_SIZE(count) != len)
 		return ERR_PTR(-EFSCORRUPTED);
 
 	acl = posix_acl_alloc(count, GFP_KERNEL);
@@ -163,7 +166,7 @@ xfs_get_acl(struct inode *inode, int type)
 		goto out;
 	}
 
-	acl = xfs_acl_from_disk(xfs_acl, XFS_ACL_MAX_ENTRIES(ip->i_mount));
+	acl = xfs_acl_from_disk(xfs_acl, len, XFS_ACL_MAX_ENTRIES(ip->i_mount));
 	if (IS_ERR(acl))
 		goto out;
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
