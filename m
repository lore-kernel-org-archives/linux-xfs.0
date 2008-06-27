Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 21:49:01 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5R4mxZv009115
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 21:48:59 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: [PATCH] Move attr log alloc size calculator to another function.
References: <1214196150-5427-1-git-send-email-xaiki@sgi.com>
	<1214196150-5427-2-git-send-email-xaiki@sgi.com>
	<20080626082438.GB23954@infradead.org>
Date: Fri, 27 Jun 2008 14:49:31 +1000
In-Reply-To: <20080626082438.GB23954@infradead.org> (Christoph Hellwig's
	message of "Thu, 26 Jun 2008 04:24:38 -0400")
Message-ID: <nccprq31nz8.fsf@sgi.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

--=-=-=

Attached updated patch.

Christoph Hellwig <hch@infradead.org> writes:
> On Mon, Jun 23, 2008 at 02:42:27PM +1000, Niv Sardi wrote:
>> From: Niv Sardi <xaiki@debian.org>
>> 
>> We will need that to be able to calculate the size of log we need for
>> a specific attr (for parent pointers in create). We need the local so
>> that we can fail if we run into ENOSPC when trying to alloc blocks

Updated Comments, structs instead of typdefs
 
>> Signed-off-by: Niv Sardi <xaiki@sgi.com>
>> ---
>>  fs/xfs/xfs_attr.c |   78 +++++++++++++++++++++++++++++++---------------------
>>  fs/xfs/xfs_attr.h |    2 +-
>>  2 files changed, 47 insertions(+), 33 deletions(-)
>> 
>> diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
>> index e58f321..0d19e90 100644
>> --- a/fs/xfs/xfs_attr.c
>> +++ b/fs/xfs/xfs_attr.c
>> @@ -185,6 +185,43 @@ xfs_attr_get(
>>  }
>>  
>>  int
>> +xfs_attr_calc_size(
>
> should be marked STATIC,

The whole idea is to be able to use it in xfs_create().

--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0001-Move-attr-log-alloc-size-calculator-to-another-funct.patch

>From 1ca0cbca566944d8d26027d4b877be11b2ebaad0 Mon Sep 17 00:00:00 2001
From: Niv Sardi <xaiki@sgi.com>
Date: Thu, 8 May 2008 16:34:32 +1000
Subject: [PATCH] Move attr log alloc size calculator to another function.

We will need that to be able to calculate the size of log we need for
a specific attr (for Create+EA). The local flag is needed so that we
can fail if we run into ENOSPC when trying to alloc blocks.

Signed-off-by: Niv Sardi <xaiki@sgi.com>
---
 fs/xfs/xfs_attr.c |   80 +++++++++++++++++++++++++++++++---------------------
 fs/xfs/xfs_attr.h |    1 +
 2 files changed, 49 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index e58f321..ca3cabf 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -184,6 +184,46 @@ xfs_attr_get(
 	return(error);
 }
 
+/*
+ * Calculate how many blocks we need for the new attribute,
+ */
+int
+xfs_attr_calc_size(
+	struct xfs_inode *ip,
+	int		namelen,
+	int		valuelen,
+	int		*local)
+{
+	struct xfs_mount *mp = ip->i_mount;
+	int		size;
+	int		nblks;
+
+	/*
+	 * Determine space new attribute will use, and if it would be
+	 * "local" or "remote" (note: local != inline).
+	 */
+	size = xfs_attr_leaf_newentsize(namelen, valuelen,
+					mp->m_sb.sb_blocksize, local);
+
+	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
+	if (*local) {
+		if (size > (mp->m_sb.sb_blocksize >> 1)) {
+			/* Double split possible */
+			nblks *= 2;
+		}
+	} else {
+		/*
+		 * Out of line attribute, cannot double split, but
+		 * make room for the attribute value itself.
+		 */
+		uint	dblocks = XFS_B_TO_FSB(mp, valuelen);
+		nblks += dblocks;
+		nblks += XFS_NEXTENTADD_SPACE_RES(mp, dblocks, XFS_ATTR_FORK);
+	}
+
+	return nblks;
+}
+
 int
 xfs_attr_set_int(xfs_inode_t *dp, const char *name, int namelen,
 		 char *value, int valuelen, int flags)
@@ -192,10 +232,9 @@ xfs_attr_set_int(xfs_inode_t *dp, const char *name, int namelen,
 	xfs_fsblock_t	firstblock;
 	xfs_bmap_free_t flist;
 	int		error, err2, committed;
-	int		local, size;
-	uint		nblks;
 	xfs_mount_t	*mp = dp->i_mount;
 	int             rsvd = (flags & ATTR_ROOT) != 0;
+	int		local;
 
 	/*
 	 * Attach the dquots to the inode.
@@ -232,30 +271,8 @@ xfs_attr_set_int(xfs_inode_t *dp, const char *name, int namelen,
 	args.addname = 1;
 	args.oknoent = 1;
 
-	/*
-	 * Determine space new attribute will use, and if it would be
-	 * "local" or "remote" (note: local != inline).
-	 */
-	size = xfs_attr_leaf_newentsize(namelen, valuelen,
-					mp->m_sb.sb_blocksize, &local);
-
-	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
-	if (local) {
-		if (size > (mp->m_sb.sb_blocksize >> 1)) {
-			/* Double split possible */
-			nblks <<= 1;
-		}
-	} else {
-		uint	dblocks = XFS_B_TO_FSB(mp, valuelen);
-		/* Out of line attribute, cannot double split, but make
-		 * room for the attribute value itself.
-		 */
-		nblks += dblocks;
-		nblks += XFS_NEXTENTADD_SPACE_RES(mp, dblocks, XFS_ATTR_FORK);
-	}
-
 	/* Size is now blocks for attribute data */
-	args.total = nblks;
+	args.total = xfs_attr_calc_size(dp, namelen, valuelen, &local);
 
 	/*
 	 * Start our first transaction of the day.
@@ -277,18 +294,17 @@ xfs_attr_set_int(xfs_inode_t *dp, const char *name, int namelen,
 	if (rsvd)
 		args.trans->t_flags |= XFS_TRANS_RESERVE;
 
-	if ((error = xfs_trans_reserve(args.trans, (uint) nblks,
-				      XFS_ATTRSET_LOG_RES(mp, nblks),
-				      0, XFS_TRANS_PERM_LOG_RES,
-				      XFS_ATTRSET_LOG_COUNT))) {
+	if ((error = xfs_trans_reserve(args.trans, args.total,
+			XFS_ATTRSET_LOG_RES(mp, args.total), 0,
+			XFS_TRANS_PERM_LOG_RES, XFS_ATTRSET_LOG_COUNT))) {
 		xfs_trans_cancel(args.trans, 0);
 		return(error);
 	}
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
 
-	error = XFS_TRANS_RESERVE_QUOTA_NBLKS(mp, args.trans, dp, nblks, 0,
-			 rsvd ? XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
-				XFS_QMOPT_RES_REGBLKS);
+	error = XFS_TRANS_RESERVE_QUOTA_NBLKS(mp, args.trans, dp, args.total, 0,
+				rsvd ? XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
+				       XFS_QMOPT_RES_REGBLKS);
 	if (error) {
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
 		xfs_trans_cancel(args.trans, XFS_TRANS_RELEASE_LOG_RES);
diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
index 786eba3..ea457f5 100644
--- a/fs/xfs/xfs_attr.h
+++ b/fs/xfs/xfs_attr.h
@@ -158,6 +158,7 @@ struct xfs_da_args;
 /*
  * Overall external interface routines.
  */
+int xfs_attr_calc_size(struct xfs_inode *, int, int, int *);
 int xfs_attr_set_int(struct xfs_inode *, const char *, int, char *, int, int);
 int xfs_attr_remove_int(struct xfs_inode *, const char *, int, int);
 int xfs_attr_list_int(struct xfs_attr_list_context *);
-- 
1.5.6


--=-=-=


Cheers,
-- 
Niv Sardi

--=-=-=--
