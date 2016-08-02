Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 09EB37CA4
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 22:57:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7FFE6AC001
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 20:56:59 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id HoYRnjQXuLC2fIIo (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 01 Aug 2016 20:56:57 -0700 (PDT)
Date: Mon, 1 Aug 2016 20:56:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: in _attrlist_by_handle, copy the cursor back to userspace
Message-ID: <20160802035651.GB8593@birch.djwong.org>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com
Cc: xfs@oss.sgi.com

When we're iterating inode xattrs by handle, we have to copy the
cursor back to userspace so that a subsequent invocation actually
retrieves subsequent contents.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 2ef22db..30e69f5 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -390,6 +390,7 @@ xfs_attrlist_by_handle(
 {
 	int			error = -ENOMEM;
 	attrlist_cursor_kern_t	*cursor;
+	struct xfs_fsop_attrlist_handlereq __user	*p = arg;
 	xfs_fsop_attrlist_handlereq_t al_hreq;
 	struct dentry		*dentry;
 	char			*kbuf;
@@ -422,6 +423,11 @@ xfs_attrlist_by_handle(
 	if (error)
 		goto out_kfree;
 
+	if (copy_to_user(&p->pos, cursor, sizeof(attrlist_cursor_kern_t))) {
+		error = -EFAULT;
+		goto out_kfree;
+	}
+
 	if (copy_to_user(al_hreq.buffer, kbuf, al_hreq.buflen))
 		error = -EFAULT;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
