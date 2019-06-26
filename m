Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50024 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfFZUrI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 16:47:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKhrv8012166
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:47:07 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t9brtcn0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:47:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKjSwP069370
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:47:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2tat7d1h7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:47:06 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5QKl5vJ017765
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:47:05 GMT
Subject: [PATCH 5/6] xfs: only allocate memory for scrubbing attributes when
 we need it
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 26 Jun 2019 13:47:04 -0700
Message-ID: <156158202408.495944.3341471232105593997.stgit@magnolia>
In-Reply-To: <156158199378.495944.4088787757066517679.stgit@magnolia>
References: <156158199378.495944.4088787757066517679.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In examining a flame graph of time spent running xfs_scrub on various
filesystems, I noticed that we spent nearly 7% of the total runtime on
allocating a zeroed 65k buffer for every SCRUB_TYPE_XATTR invocation.
We do this even if none of the attribute values were anywhere near 64k
in size, even if there were no attribute blocks to check space on, and
even if it just turns out there are no attributes at all.

Therefore, rearrange the xattr buffer setup code to support reallocating
with a bigger buffer and redistribute the callers of that function so
that we only allocate memory just prior to needing it, and only allocate
as much as we need.  If we can't get memory with the ILOCK held we'll
bail out with EDEADLOCK which will allocate the maximum memory.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/attr.c |   67 ++++++++++++++++++++++++++++++++++++++++++++-------
 fs/xfs/scrub/attr.h |    6 ++++-
 2 files changed, 63 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index c20b6da1db84..09081d8ab34b 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -31,13 +31,19 @@
 #include <linux/posix_acl_xattr.h>
 #include <linux/xattr.h>
 
-/* Allocate enough memory to hold an attr value and attr block bitmaps. */
+/*
+ * Allocate enough memory to hold an attr value and attr block bitmaps,
+ * reallocating the buffer if necessary.  Buffer contents are not preserved
+ * across a reallocation.
+ */
 int
 xchk_setup_xattr_buf(
 	struct xfs_scrub	*sc,
-	size_t			value_size)
+	size_t			value_size,
+	xfs_km_flags_t		flags)
 {
 	size_t			sz;
+	struct xchk_xattr_buf	*ab = sc->buf;
 
 	/*
 	 * We need enough space to read an xattr value from the file or enough
@@ -47,10 +53,23 @@ xchk_setup_xattr_buf(
 	sz = 3 * sizeof(long) * BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
 	sz = max_t(size_t, sz, value_size);
 
-	sc->buf = kmem_zalloc_large(sz, KM_SLEEP);
-	if (!sc->buf)
+	/*
+	 * If there's already a buffer, figure out if we need to reallocate it
+	 * to accomdate a larger size.
+	 */
+	if (ab) {
+		if (sz <= ab->sz)
+			return 0;
+		kmem_free(ab);
+		sc->buf = NULL;
+	}
+
+	ab = kmem_zalloc_large(sizeof(*ab) + sz, flags);
+	if (!ab)
 		return -ENOMEM;
 
+	ab->sz = sz;
+	sc->buf = ab;
 	return 0;
 }
 
@@ -62,9 +81,16 @@ xchk_setup_xattr(
 {
 	int			error;
 
-	error = xchk_setup_xattr_buf(sc, XATTR_SIZE_MAX);
-	if (error)
-		return error;
+	/*
+	 * We failed to get memory while checking attrs, so this time try to
+	 * get all the memory we're ever going to need.  Allocate the buffer
+	 * without the inode lock held, which means we can sleep.
+	 */
+	if (sc->flags & XCHK_TRY_HARDER) {
+		error = xchk_setup_xattr_buf(sc, XATTR_SIZE_MAX, KM_SLEEP);
+		if (error)
+			return error;
+	}
 
 	return xchk_setup_inode_contents(sc, ip, 0);
 }
@@ -115,6 +141,19 @@ xchk_xattr_listent(
 		return;
 	}
 
+	/*
+	 * Try to allocate enough memory to extrat the attr value.  If that
+	 * doesn't work, we overload the seen_enough variable to convey
+	 * the error message back to the main scrub function.
+	 */
+	error = xchk_setup_xattr_buf(sx->sc, valuelen, KM_MAYFAIL);
+	if (error == -ENOMEM)
+		error = -EDEADLOCK;
+	if (error) {
+		context->seen_enough = error;
+		return;
+	}
+
 	args.flags = ATTR_KERNOTIME;
 	if (flags & XFS_ATTR_ROOT)
 		args.flags |= ATTR_ROOT;
@@ -128,7 +167,7 @@ xchk_xattr_listent(
 	args.hashval = xfs_da_hashname(args.name, args.namelen);
 	args.trans = context->tp;
 	args.value = xchk_xattr_valuebuf(sx->sc);
-	args.valuelen = XATTR_SIZE_MAX;
+	args.valuelen = valuelen;
 
 	error = xfs_attr_get_ilocked(context->dp, &args);
 	if (error == -EEXIST)
@@ -281,16 +320,26 @@ xchk_xattr_block(
 	struct xfs_attr_leafblock	*leaf = bp->b_addr;
 	struct xfs_attr_leaf_entry	*ent;
 	struct xfs_attr_leaf_entry	*entries;
-	unsigned long			*usedmap = xchk_xattr_usedmap(ds->sc);
+	unsigned long			*usedmap;
 	char				*buf_end;
 	size_t				off;
 	__u32				last_hashval = 0;
 	unsigned int			usedbytes = 0;
 	unsigned int			hdrsize;
 	int				i;
+	int				error;
 
 	if (*last_checked == blk->blkno)
 		return 0;
+
+	/* Allocate memory for block usage checking. */
+	error = xchk_setup_xattr_buf(ds->sc, 0, KM_MAYFAIL);
+	if (error == -ENOMEM)
+		return -EDEADLOCK;
+	if (error)
+		return error;
+	usedmap = xchk_xattr_usedmap(ds->sc);
+
 	*last_checked = blk->blkno;
 	bitmap_zero(usedmap, mp->m_attr_geo->blksize);
 
diff --git a/fs/xfs/scrub/attr.h b/fs/xfs/scrub/attr.h
index 27e879aeaafc..13a1d2e8424d 100644
--- a/fs/xfs/scrub/attr.h
+++ b/fs/xfs/scrub/attr.h
@@ -10,6 +10,9 @@
  * Temporary storage for online scrub and repair of extended attributes.
  */
 struct xchk_xattr_buf {
+	/* Size of @buf, in bytes. */
+	size_t			sz;
+
 	/*
 	 * Memory buffer -- either used for extracting attr values while
 	 * walking the attributes; or for computing attr block bitmaps when
@@ -62,6 +65,7 @@ xchk_xattr_dstmap(
 			BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
 }
 
-int xchk_setup_xattr_buf(struct xfs_scrub *sc, size_t value_size);
+int xchk_setup_xattr_buf(struct xfs_scrub *sc, size_t value_size,
+		xfs_km_flags_t flags);
 
 #endif	/* __XFS_SCRUB_ATTR_H__ */
