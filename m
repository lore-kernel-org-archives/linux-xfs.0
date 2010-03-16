Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2G7rX2F139219 for <xfs@oss.sgi.com>; Tue, 16 Mar 2010 02:53:34 -0500
Date: Tue, 16 Mar 2010 23:53:50 +0800
From: wzt.wzt@gmail.com
Subject: [PATCH] xfs: Fix integer overflow in fs/xfs/linux-2.6/xfs_ioctl*.c
Message-ID: <20100316155350.GB18579@localhost.localdomain>
Mime-Version: 1.0
Content-Disposition: inline
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
To: linux-kernel@vger.kernel.org
Cc: xfs-masters@oss.sgi.com, aelder@sgi.com, xfs@oss.sgi.com

STATIC int
xfs_compat_attrmulti_by_handle(
        struct file                             *parfilp,
        void                                    __user *arg)
{
...
        if (copy_from_user(&am_hreq, arg,
                           sizeof(compat_xfs_fsop_attrmulti_handlereq_t)))
                return -XFS_ERROR(EFAULT);
...
        error = E2BIG;
        /* Not check the am_hreq.opcount max value from userspace, 
        m_hreq.opcount * sizeof(compat_xfs_attr_multiop_t) can make
        integer overflow, and the if condition can be bypass. Though,
        it can not make security problem, but fix it maybe better. */
        size = am_hreq.opcount * sizeof(compat_xfs_attr_multiop_t);
        if (!size || size > 16 * PAGE_SIZE)
                goto out_dput;
...
}

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 fs/xfs/linux-2.6/xfs_ioctl.c   |    4 ++++
 fs/xfs/linux-2.6/xfs_ioctl32.c |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
index 4ea1ee1..b05b3b7 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -526,6 +526,10 @@ xfs_attrmulti_by_handle(
 	if (copy_from_user(&am_hreq, arg, sizeof(xfs_fsop_attrmulti_handlereq_t)))
 		return -XFS_ERROR(EFAULT);
 
+	/* overflow check */
+	if (am_hreq.opcount >= INT_MAX / sizeof(xfs_attr_multiop_t))
+		return -ENOMEM;
+
 	dentry = xfs_handlereq_to_dentry(parfilp, &am_hreq.hreq);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
diff --git a/fs/xfs/linux-2.6/xfs_ioctl32.c b/fs/xfs/linux-2.6/xfs_ioctl32.c
index 0bf6d61..7b8673e 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -419,6 +419,10 @@ xfs_compat_attrmulti_by_handle(
 			   sizeof(compat_xfs_fsop_attrmulti_handlereq_t)))
 		return -XFS_ERROR(EFAULT);
 
+	/* overflow check */
+	if (am_hreq.opcount >= INT_MAX / sizeof(compat_xfs_attr_multiop_t))
+		return -ENOMEM;
+
 	dentry = xfs_compat_handlereq_to_dentry(parfilp, &am_hreq.hreq);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
-- 
1.6.5.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
