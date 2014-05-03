Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C3AC87F3F
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 10:18:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 52744AC002
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 08:18:04 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id LKO6LmDNK7kJqCGF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 03 May 2014 08:18:02 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WgbhR-0003hz-GH
	for xfs@oss.sgi.com; Sat, 03 May 2014 15:18:01 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/5] xfs: fold xfs_attr_get_int into xfs_attr_get
Date: Sat,  3 May 2014 17:20:12 +0200
Message-Id: <1399130415-5382-3-git-send-email-hch@lst.de>
In-Reply-To: <1399130415-5382-1-git-send-email-hch@lst.de>
References: <1399130415-5382-1-git-send-email-hch@lst.de>
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
To: xfs@oss.sgi.com

This allows doing an unlocked check if an attr for is present at all and
slightly reduce the lock hold time if we actually do an attr get.

Plus various minor style fixes to the new xfs_attr_get.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr.c |   79 ++++++++++++++++++-----------------------------------
 1 file changed, 27 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index eb3ae8f..01f2267 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -106,26 +106,34 @@ xfs_inode_hasattr(
  * Overall external interface routines.
  *========================================================================*/
 
-STATIC int
-xfs_attr_get_int(
+int
+xfs_attr_get(
 	struct xfs_inode	*ip,
-	struct xfs_name		*name,
+	const unsigned char	*name,
 	unsigned char		*value,
 	int			*valuelenp,
 	int			flags)
 {
-	xfs_da_args_t   args;
-	int             error;
+	struct xfs_da_args	args;
+	struct xfs_name		xname;
+	uint			lock_mode;
+	int			error;
+
+	XFS_STATS_INC(xs_attr_get);
+
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+		return EIO;
 
 	if (!xfs_inode_hasattr(ip))
 		return ENOATTR;
 
-	/*
-	 * Fill in the arg structure for this request.
-	 */
-	memset((char *)&args, 0, sizeof(args));
-	args.name = name->name;
-	args.namelen = name->len;
+	error = xfs_attr_name_to_xname(&xname, name);
+	if (error)
+		return error;
+
+	memset(&args, 0, sizeof(args));
+	args.name = xname.name;
+	args.namelen = xname.len;
 	args.value = value;
 	args.valuelen = *valuelenp;
 	args.flags = flags;
@@ -133,52 +141,19 @@ xfs_attr_get_int(
 	args.dp = ip;
 	args.whichfork = XFS_ATTR_FORK;
 
-	/*
-	 * Decide on what work routines to call based on the inode size.
-	 */
-	if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
+	lock_mode = xfs_ilock_attr_map_shared(ip);
+	if (!xfs_inode_hasattr(ip))
+		error = ENOATTR;
+	else if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL)
 		error = xfs_attr_shortform_getvalue(&args);
-	} else if (xfs_bmap_one_block(ip, XFS_ATTR_FORK)) {
+	else if (xfs_bmap_one_block(ip, XFS_ATTR_FORK))
 		error = xfs_attr_leaf_get(&args);
-	} else {
+	else
 		error = xfs_attr_node_get(&args);
-	}
+	xfs_iunlock(ip, lock_mode);
 
-	/*
-	 * Return the number of bytes in the value to the caller.
-	 */
 	*valuelenp = args.valuelen;
-
-	if (error == EEXIST)
-		error = 0;
-	return(error);
-}
-
-int
-xfs_attr_get(
-	xfs_inode_t	*ip,
-	const unsigned char *name,
-	unsigned char	*value,
-	int		*valuelenp,
-	int		flags)
-{
-	int		error;
-	struct xfs_name	xname;
-	uint		lock_mode;
-
-	XFS_STATS_INC(xs_attr_get);
-
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
-		return(EIO);
-
-	error = xfs_attr_name_to_xname(&xname, name);
-	if (error)
-		return error;
-
-	lock_mode = xfs_ilock_attr_map_shared(ip);
-	error = xfs_attr_get_int(ip, &xname, value, valuelenp, flags);
-	xfs_iunlock(ip, lock_mode);
-	return(error);
+	return error == EEXIST ? 0 : error;
 }
 
 /*
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
