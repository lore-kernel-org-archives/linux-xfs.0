Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4GEmIRn137201 for <xfs@oss.sgi.com>; Mon, 16 May 2011 09:48:18 -0500
Received: from e3.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 522C415EDC1A
	for <xfs@oss.sgi.com>; Mon, 16 May 2011 07:48:16 -0700 (PDT)
Received: from e3.ny.us.ibm.com (e3.ny.us.ibm.com [32.97.182.143]) by
	cuda.sgi.com with ESMTP id C90uhNGQuRybkQAk for
	<xfs@oss.sgi.com>; Mon, 16 May 2011 07:48:16 -0700 (PDT)
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e3.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4GEQO8Q025574
	for <xfs@oss.sgi.com>; Mon, 16 May 2011 10:26:24 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p4GEm7xK105308 for <xfs@oss.sgi.com>; Mon, 16 May 2011 10:48:09 -0400
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p4G8lrfD017754
	for <xfs@oss.sgi.com>; Mon, 16 May 2011 02:47:54 -0600
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH v5 16/21] evm: add evm_inode_post_init call in xfs
Date: Mon, 16 May 2011 10:45:10 -0400
Message-Id: <1305557115-15652-17-git-send-email-zohar@linux.vnet.ibm.com>
In-Reply-To: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
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
Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>, Mimi Zohar <zohar@us.ibm.com>, David Safford <safford@watson.ibm.com>, Greg KH <greg@kroah.com>, James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, Mimi Zohar <zohar@linux.vnet.ibm.com>

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
