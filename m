Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45660 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726649AbeJJWW6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Oct 2018 18:22:58 -0400
Date: Wed, 10 Oct 2018 08:00:13 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 01/25] xfs: add a per-xfs trace_printk macro
Message-ID: <20181010150013.GP28243@magnolia>
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
 <153913024554.32295.8692450593333636905.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153913024554.32295.8692450593333636905.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com
Cc: sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a "xfs_tprintk" macro so that developers can use trace_printk to
print out arbitrary debugging information with the XFS device name
attached to the trace output.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_error.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 246d3e989c6c..5caa8bdf6c38 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -76,6 +76,11 @@ extern int xfs_errortag_set(struct xfs_mount *mp, unsigned int error_tag,
 		unsigned int tag_value);
 extern int xfs_errortag_add(struct xfs_mount *mp, unsigned int error_tag);
 extern int xfs_errortag_clearall(struct xfs_mount *mp);
+
+/* trace printk version of xfs_err and friends */
+#define xfs_tprintk(mp, fmt, args...) \
+	trace_printk("dev %d:%d " fmt, MAJOR((mp)->m_super->s_dev), \
+			MINOR((mp)->m_super->s_dev), ##args)
 #else
 #define xfs_errortag_init(mp)			(0)
 #define xfs_errortag_del(mp)
@@ -83,6 +88,7 @@ extern int xfs_errortag_clearall(struct xfs_mount *mp);
 #define xfs_errortag_set(mp, tag, val)		(ENOSYS)
 #define xfs_errortag_add(mp, tag)		(ENOSYS)
 #define xfs_errortag_clearall(mp)		(ENOSYS)
+#define xfs_tprintk(mp, fmt, args...)		do { } while (0)
 #endif /* DEBUG */
 
 /*
