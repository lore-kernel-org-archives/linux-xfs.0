Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 64AE17F53
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 10:18:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3E88A30405F
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 08:18:05 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id 4CR2L6CbFArPSykO (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 03 May 2014 08:18:04 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WgbhT-0003i7-4f
	for xfs@oss.sgi.com; Sat, 03 May 2014 15:18:03 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/5] xfs: simplify attr name setup
Date: Sat,  3 May 2014 17:20:14 +0200
Message-Id: <1399130415-5382-5-git-send-email-hch@lst.de>
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

Replace xfs_attr_name_to_xname with a new xfs_attr_args_init helper that
sets up the basic da_args structure without using a temporary xfs_name
structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr.c |   74 +++++++++++++++++++++--------------------------------
 1 file changed, 29 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index a96e27b..1208621 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -77,17 +77,26 @@ STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
 
 
 STATIC int
-xfs_attr_name_to_xname(
-	struct xfs_name	*xname,
-	const unsigned char *aname)
+xfs_attr_args_init(
+	struct xfs_da_args	*args,
+	struct xfs_inode	*dp,
+	const unsigned char	*name,
+	int			flags)
 {
-	if (!aname)
+
+	if (!name)
 		return EINVAL;
-	xname->name = aname;
-	xname->len = strlen((char *)aname);
-	if (xname->len >= MAXNAMELEN)
+
+	memset(args, 0, sizeof(*args));
+	args->whichfork = XFS_ATTR_FORK;
+	args->dp = dp;
+	args->flags = flags;
+	args->name = name;
+	args->namelen = strlen((const char *)name);
+	if (args->namelen >= MAXNAMELEN)
 		return EFAULT;		/* match IRIX behaviour */
 
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
 	return 0;
 }
 
@@ -115,7 +124,6 @@ xfs_attr_get(
 	int			flags)
 {
 	struct xfs_da_args	args;
-	struct xfs_name		xname;
 	uint			lock_mode;
 	int			error;
 
@@ -127,19 +135,12 @@ xfs_attr_get(
 	if (!xfs_inode_hasattr(ip))
 		return ENOATTR;
 
-	error = xfs_attr_name_to_xname(&xname, name);
+	error = xfs_attr_args_init(&args, ip, name, flags);
 	if (error)
 		return error;
 
-	memset(&args, 0, sizeof(args));
-	args.name = xname.name;
-	args.namelen = xname.len;
 	args.value = value;
 	args.valuelen = *valuelenp;
-	args.flags = flags;
-	args.hashval = xfs_da_hashname(args.name, args.namelen);
-	args.dp = ip;
-	args.whichfork = XFS_ATTR_FORK;
 
 	lock_mode = xfs_ilock_attr_map_shared(ip);
 	if (!xfs_inode_hasattr(ip))
@@ -208,7 +209,6 @@ xfs_attr_set(
 	struct xfs_da_args	args;
 	struct xfs_bmap_free	flist;
 	struct xfs_trans_res	tres;
-	struct xfs_name		xname;
 	xfs_fsblock_t		firstblock;
 	int			rsvd = (flags & ATTR_ROOT) != 0;
 	int			error, err2, committed, local;
@@ -218,10 +218,19 @@ xfs_attr_set(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return EIO;
 
-	error = xfs_attr_name_to_xname(&xname, name);
+	error = xfs_attr_args_init(&args, dp, name, flags);
 	if (error)
 		return error;
 
+	args.value = value;
+	args.valuelen = valuelen;
+	args.firstblock = &firstblock;
+	args.flist = &flist;
+	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
+
+	/* Size is now blocks for attribute data */
+	args.total = xfs_attr_calc_size(dp, args.namelen, valuelen, &local);
+
 	error = xfs_qm_dqattach(dp, 0);
 	if (error)
 		return error;
@@ -232,29 +241,13 @@ xfs_attr_set(
 	 */
 	if (XFS_IFORK_Q(dp) == 0) {
 		int sf_size = sizeof(xfs_attr_sf_hdr_t) +
-			      XFS_ATTR_SF_ENTSIZE_BYNAME(xname.len, valuelen);
+			XFS_ATTR_SF_ENTSIZE_BYNAME(args.namelen, valuelen);
 
 		error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
 		if (error)
 			return error;
 	}
 
-	memset(&args, 0, sizeof(args));
-	args.name = xname.name;
-	args.namelen = xname.len;
-	args.value = value;
-	args.valuelen = valuelen;
-	args.flags = flags;
-	args.hashval = xfs_da_hashname(args.name, args.namelen);
-	args.dp = dp;
-	args.firstblock = &firstblock;
-	args.flist = &flist;
-	args.whichfork = XFS_ATTR_FORK;
-	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
-
-	/* Size is now blocks for attribute data */
-	args.total = xfs_attr_calc_size(dp, xname.len, valuelen, &local);
-
 	/*
 	 * Start our first transaction of the day.
 	 *
@@ -425,7 +418,6 @@ xfs_attr_remove(
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_da_args	args;
 	struct xfs_bmap_free	flist;
-	struct xfs_name		xname;
 	xfs_fsblock_t		firstblock;
 	int			error;
 
@@ -437,20 +429,12 @@ xfs_attr_remove(
 	if (!xfs_inode_hasattr(dp))
 		return ENOATTR;
 
-	error = xfs_attr_name_to_xname(&xname, name);
+	error = xfs_attr_args_init(&args, dp, name, flags);
 	if (error)
 		return error;
 
-	memset(&args, 0, sizeof(args));
-	args.name = xname.name;
-	args.namelen = xname.len;
-	args.flags = flags;
-	args.hashval = xfs_da_hashname(args.name, args.namelen);
-	args.dp = dp;
 	args.firstblock = &firstblock;
 	args.flist = &flist;
-	args.total = 0;
-	args.whichfork = XFS_ATTR_FORK;
 
 	/*
 	 * we have no control over the attribute names that userspace passes us
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
