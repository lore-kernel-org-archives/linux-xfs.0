Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 535887F52
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2015 10:05:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 36687304066
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2015 08:05:20 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fNSeKKsl6yOnEDCt (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 30 Oct 2015 08:05:18 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v2 2/5] xfs: Plug memory leak in xfs_attrmulti_attr_set
Date: Fri, 30 Oct 2015 16:05:05 +0100
Message-Id: <1446217508-22157-3-git-send-email-agruenba@redhat.com>
In-Reply-To: <1446217508-22157-1-git-send-email-agruenba@redhat.com>
References: <1446217508-22157-1-git-send-email-agruenba@redhat.com>
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
To: Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com
Cc: Andreas Gruenbacher <agruenba@redhat.com>

When setting attributes via XFS_IOC_ATTRMULTI_BY_HANDLE, the user-space
buffer is copied into a new kernel-space buffer via memdup_user; that
buffer then isn't freed.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/xfs/xfs_ioctl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index ea7d85a..e939c20 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -482,6 +482,7 @@ xfs_attrmulti_attr_set(
 	__uint32_t		flags)
 {
 	unsigned char		*kbuf;
+	int			error;
 
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		return -EPERM;
@@ -492,7 +493,9 @@ xfs_attrmulti_attr_set(
 	if (IS_ERR(kbuf))
 		return PTR_ERR(kbuf);
 
-	return xfs_attr_set(XFS_I(inode), name, kbuf, len, flags);
+	error = xfs_attr_set(XFS_I(inode), name, kbuf, len, flags);
+	kfree(kbuf);
+	return error;
 }
 
 int
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
