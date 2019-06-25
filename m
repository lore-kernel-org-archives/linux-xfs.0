Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42028 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730665AbfFYDCy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 23:02:54 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5P2xQku183579
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:02:53 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t9brt1ha7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:02:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5P31NIk163426
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:02:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2tat7bys0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:02:52 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5P32qae016179
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:02:52 GMT
Subject: [PATCH 3/5] xfs: refactor attr scrub memory allocation function
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 24 Jun 2019 20:02:51 -0700
Message-ID: <156143177110.2221192.12144130344450670626.stgit@magnolia>
In-Reply-To: <156143175282.2221192.3546713622107331271.stgit@magnolia>
References: <156143175282.2221192.3546713622107331271.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the code that allocates memory buffers for the extended attribute
scrub code into a separate function so we can reduce memory allocations
in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/attr.c |   33 ++++++++++++++++++++++++---------
 fs/xfs/scrub/attr.h |    2 ++
 2 files changed, 26 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index fd16eb3fa003..c20b6da1db84 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -31,26 +31,41 @@
 #include <linux/posix_acl_xattr.h>
 #include <linux/xattr.h>
 
-/* Set us up to scrub an inode's extended attributes. */
+/* Allocate enough memory to hold an attr value and attr block bitmaps. */
 int
-xchk_setup_xattr(
+xchk_setup_xattr_buf(
 	struct xfs_scrub	*sc,
-	struct xfs_inode	*ip)
+	size_t			value_size)
 {
 	size_t			sz;
 
 	/*
-	 * Allocate the buffer without the inode lock held.  We need enough
-	 * space to read every xattr value in the file or enough space to
-	 * hold three copies of the xattr free space bitmap.  (Not both at
-	 * the same time.)
+	 * We need enough space to read an xattr value from the file or enough
+	 * space to hold three copies of the xattr free space bitmap.  We don't
+	 * need the buffer space for both purposes at the same time.
 	 */
-	sz = max_t(size_t, XATTR_SIZE_MAX, 3 * sizeof(long) *
-			BITS_TO_LONGS(sc->mp->m_attr_geo->blksize));
+	sz = 3 * sizeof(long) * BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
+	sz = max_t(size_t, sz, value_size);
+
 	sc->buf = kmem_zalloc_large(sz, KM_SLEEP);
 	if (!sc->buf)
 		return -ENOMEM;
 
+	return 0;
+}
+
+/* Set us up to scrub an inode's extended attributes. */
+int
+xchk_setup_xattr(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip)
+{
+	int			error;
+
+	error = xchk_setup_xattr_buf(sc, XATTR_SIZE_MAX);
+	if (error)
+		return error;
+
 	return xchk_setup_inode_contents(sc, ip, 0);
 }
 
diff --git a/fs/xfs/scrub/attr.h b/fs/xfs/scrub/attr.h
index baa92f34f790..919adff24447 100644
--- a/fs/xfs/scrub/attr.h
+++ b/fs/xfs/scrub/attr.h
@@ -62,4 +62,6 @@ xchk_xattr_dstmap(
 			BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
 }
 
+int xchk_setup_xattr_buf(struct xfs_scrub *sc, size_t value_size);
+
 #endif	/* __XFS_SCRUB_ATTR_H__ */
