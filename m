Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p52CPlrA197690 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 07:25:48 -0500
Received: from e4.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A20B1660240
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2011 05:25:46 -0700 (PDT)
Received: from e4.ny.us.ibm.com (e4.ny.us.ibm.com [32.97.182.144]) by
	cuda.sgi.com with ESMTP id oYwJEJwGCfkECbMZ for
	<xfs@oss.sgi.com>; Thu, 02 Jun 2011 05:25:46 -0700 (PDT)
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e4.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p52C4RlA006003
	for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 08:04:27 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p52CPePN092752 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 08:25:40 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p528PRhH019067 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 05:25:28 -0300
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH v6 15/20] evm: add evm_inode_post_init call in xfs
Date: Thu,  2 Jun 2011 08:23:38 -0400
Message-Id: <1307017423-15093-16-git-send-email-zohar@linux.vnet.ibm.com>
In-Reply-To: <1307017423-15093-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1307017423-15093-1-git-send-email-zohar@linux.vnet.ibm.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-security-module@vger.kernel.org
Cc: Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>, Mimi Zohar <zohar@us.ibm.com>, David Safford <safford@watson.ibm.com>, Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>, Alex Elder <aelder@sgi.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, Mimi Zohar <zohar@linux.vnet.ibm.com>

After creating the initial LSM security extended attribute, call
evm_inode_post_init_security() to create the 'security.evm'
extended attribute.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 fs/xfs/linux-2.6/xfs_iops.c |   27 +++++++++++++++++++--------
 1 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index dd21784..01b354d 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -46,6 +46,7 @@
 #include <linux/namei.h>
 #include <linux/posix_acl.h>
 #include <linux/security.h>
+#include <linux/evm.h>
 #include <linux/fiemap.h>
 #include <linux/slab.h>
 
@@ -106,23 +107,33 @@ xfs_init_security(
 	const struct qstr *qstr)
 {
 	struct xfs_inode *ip = XFS_I(inode);
-	size_t		length;
-	void		*value;
-	unsigned char	*name;
+	struct xattr lsm_xattr;
+	struct xattr evm_xattr;
 	int		error;
 
-	error = security_inode_init_security(inode, dir, qstr, (char **)&name,
-					     &value, &length);
+	error = security_inode_init_security(inode, dir, qstr, &lsm_xattr.name,
+					     &lsm_xattr.value,
+					     &lsm_xattr.value_len);
 	if (error) {
 		if (error == -EOPNOTSUPP)
 			return 0;
 		return -error;
 	}
 
-	error = xfs_attr_set(ip, name, value, length, ATTR_SECURE);
+	error = xfs_attr_set(ip, lsm_xattr.name, lsm_xattr.value,
+			     lsm_xattr.value_len, ATTR_SECURE);
+	if (error)
+		goto out;
 
-	kfree(name);
-	kfree(value);
+	error = evm_inode_post_init_security(inode, &lsm_xattr, &evm_xattr);
+	if (error)
+		goto out;
+	error = xfs_attr_set(ip, evm_xattr.name, evm_xattr.value,
+			     evm_xattr.value_len, ATTR_SECURE);
+	kfree(evm_xattr.value);
+out:
+	kfree(lsm_xattr.name);
+	kfree(lsm_xattr.value);
 	return error;
 }
 
-- 
1.7.3.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
