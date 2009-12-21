Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBLC13ih036290 for <xfs@oss.sgi.com>; Mon, 21 Dec 2009 06:01:03 -0600
Message-ID: <4B2F6407.4060805@gmail.com>
Date: Mon, 21 Dec 2009 20:03:19 +0800
From: Liuwenyi <qingshenlwy@gmail.com>
MIME-Version: 1.0
Subject: [PATCHv2 12/12]posix_acl: Add the check items
Reply-To: qingshenlwy@gmail.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: aelder@sgi.com, xfs-masters@oss.sgi.com, hch@lst.de, viro@zeniv.linux.org.uk, sandeen@sandeen.net, joel.becker@oracle.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, strongzgy@gmail.com, onlyflyer@gmail.com

move the ACL validation check in to fs/posix_acl.c.
Including nullpointer check and PTR_ERR check.

---
Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
Cc: Alex Elder <aelder@sgi.com>
Cc: xfs-masters@oss.sgi.com
Cc :Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Sandeen <sandeen@sandeen.net>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org

---
diff --git a/fs/xfs/linux-2.6/xfs_acl.c b/fs/xfs/linux-2.6/xfs_acl.c
index 2512125..3de2533 100644
--- a/fs/xfs/linux-2.6/xfs_acl.c
+++ b/fs/xfs/linux-2.6/xfs_acl.c
@@ -392,17 +392,6 @@ xfs_xattr_acl_set(struct dentry *dentry, const char
*name,
goto set_acl;

acl = posix_acl_from_xattr(value, size);
- if (!acl) {
- /*
- * acl_set_file(3) may request that we set default ACLs with
- * zero length -- defend (gracefully) against that here.
- */
- goto out;
- }
- if (IS_ERR(acl)) {
- error = PTR_ERR(acl);
- goto out;
- }

error = posix_acl_valid(acl);
if (error)

-- 
Best Regards,
Liuwenyi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
