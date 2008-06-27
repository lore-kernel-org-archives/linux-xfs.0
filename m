Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 21:41:54 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5R4foNM007829
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 21:41:50 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: [PATCH] Introduce xfs_trans_bmap_add_attrfork.
References: <1214196150-5427-1-git-send-email-xaiki@sgi.com>
	<1214196150-5427-2-git-send-email-xaiki@sgi.com>
	<1214196150-5427-3-git-send-email-xaiki@sgi.com>
	<1214196150-5427-4-git-send-email-xaiki@sgi.com>
	<20080626092856.GA27069@infradead.org>
Date: Fri, 27 Jun 2008 14:42:17 +1000
In-Reply-To: <20080626092856.GA27069@infradead.org> (Christoph Hellwig's
	message of "Thu, 26 Jun 2008 05:28:56 -0400")
Message-ID: <nccy74r1oba.fsf@sgi.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

--=-=-=


Updated patch attached,
Moved case where there is no transaction back into
xfs_bmap_add_attrfork() and rely on caller to call xfs_trans_roll(),

Christoph Hellwig <hch@infradead.org> writes:
>> +xfs_bmap_add_attrfork(
[...]
> Care to add this below xfs_trans_bmap_add_attrfork?  Also please
> us struct xfs_inode instead of the typedef.

Done,

>> +	if (tpp) {
>> +		ASSERT(*tpp);
>> +		tp = *tpp;
>> +	} else {
[...]
>
> I think it would be much cleaner if all the transaction setup, joining
> etc was done in xfs_bmap_add_attrfork, and xfs_trans_bmap_add_attrfork
> just gets an always non-NULL xfs_trans pointer.  That would mean
> the common code would become just a helper, and
> xfs_trans_bmap_add_attrfork would be a small wrapper including the 
> xfs_trans_roll.  Alternatively the caller could always do the roll.

I think I got it right, but error handeling is a bit weird this way,
looks logically identical.


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0003-Introduce-xfs_trans_bmap_add_attrfork.patch

>From 8409ab9129b788ec9b1c2fb81131f70de0f4bf65 Mon Sep 17 00:00:00 2001
From: Niv Sardi <xaiki@sgi.com>
Date: Thu, 22 May 2008 16:18:00 +1000
Subject: [PATCH] Introduce xfs_trans_bmap_add_attrfork.

That takes a transaction and doesn't require everything to be locked
anymore. This doesn't commit the transaction ! so direct callers,
willing to use xfs_trans_roll() should do it themselves.

Change xfs_bmap_add_attrfork to do the initialization/allocation of
the transaction and commit arround xfs_trans_bmap_add_attrfork.

Signed-off-by: Niv Sardi <xaiki@sgi.com>
---
 fs/xfs/xfs_bmap.c |  100 ++++++++++++++++++++++++++++++++++------------------
 fs/xfs/xfs_bmap.h |    7 ++++
 2 files changed, 72 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 1c0a5a5..d4bd6e7 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -3946,16 +3946,16 @@ xfs_bunmap_trace(
  * Must not be in a transaction, ip must not be locked.
  */
 int						/* error code */
-xfs_bmap_add_attrfork(
-	xfs_inode_t		*ip,		/* incore inode pointer */
+xfs_trans_bmap_add_attrfork(
+	struct xfs_trans	**tpp,		/* transaction pointer */
+	struct xfs_inode	*ip,		/* incore inode pointer */
 	int			size,		/* space new attribute needs */
 	int			rsvd)		/* xact may use reserved blks */
 {
 	xfs_fsblock_t		firstblock;	/* 1st block/ag allocated */
-	xfs_bmap_free_t		flist;		/* freed extent records */
-	xfs_mount_t		*mp;		/* mount structure */
-	xfs_trans_t		*tp;		/* transaction pointer */
-	int			blks;		/* space reservation */
+	struct xfs_bmap_free	flist;		/* freed extent records */
+	struct xfs_mount	*mp;		/* mount structure */
+	struct xfs_trans	*tp;		/* transaction pointer */
 	int			version = 1;	/* superblock attr version */
 	int			committed;	/* xaction was committed */
 	int			logflags;	/* logging flags */
@@ -3967,24 +3967,8 @@ xfs_bmap_add_attrfork(
 
 	mp = ip->i_mount;
 	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
-	tp = xfs_trans_alloc(mp, XFS_TRANS_ADDAFORK);
-	blks = XFS_ADDAFORK_SPACE_RES(mp);
-	if (rsvd)
-		tp->t_flags |= XFS_TRANS_RESERVE;
-	if ((error = xfs_trans_reserve(tp, blks, XFS_ADDAFORK_LOG_RES(mp), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_ADDAFORK_LOG_COUNT)))
-		goto error0;
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	error = XFS_TRANS_RESERVE_QUOTA_NBLKS(mp, tp, ip, blks, 0, rsvd ?
-			XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
-			XFS_QMOPT_RES_REGBLKS);
-	if (error) {
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES);
-		return error;
-	}
-	if (XFS_IFORK_Q(ip))
-		goto error1;
+	ASSERT(*tpp);
+	tp = *tpp;
 	if (ip->i_d.di_aformat != XFS_DINODE_FMT_EXTENTS) {
 		/*
 		 * For inodes coming from pre-6.2 filesystems.
@@ -3992,10 +3976,7 @@ xfs_bmap_add_attrfork(
 		ASSERT(ip->i_d.di_aformat == 0);
 		ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 	}
-	ASSERT(ip->i_d.di_anextents == 0);
-	VN_HOLD(XFS_ITOV(ip));
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
 	switch (ip->i_d.di_format) {
 	case XFS_DINODE_FMT_DEV:
 		ip->i_d.di_forkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
@@ -4015,7 +3996,7 @@ xfs_bmap_add_attrfork(
 	default:
 		ASSERT(0);
 		error = XFS_ERROR(EINVAL);
-		goto error1;
+		goto error0;
 	}
 	ip->i_df.if_ext_max =
 		XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t);
@@ -4046,7 +4027,7 @@ xfs_bmap_add_attrfork(
 	if (logflags)
 		xfs_trans_log_inode(tp, ip, logflags);
 	if (error)
-		goto error2;
+		goto error1;
 	if (!XFS_SB_VERSION_HASATTR(&mp->m_sb) ||
 	   (!XFS_SB_VERSION_HASATTR2(&mp->m_sb) && version == 2)) {
 		__int64_t sbfields = 0;
@@ -4066,14 +4047,63 @@ xfs_bmap_add_attrfork(
 		} else
 			spin_unlock(&mp->m_sb_lock);
 	}
-	if ((error = xfs_bmap_finish(&tp, &flist, &committed)))
-		goto error2;
-	error = xfs_trans_commit(tp, XFS_TRANS_PERM_LOG_RES);
+	error = xfs_bmap_finish(tpp, &flist, &committed);
+	if (error)
+		goto error1;
 	ASSERT(ip->i_df.if_ext_max ==
 	       XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t));
-	return error;
-error2:
+	return 0;
+error1:
 	xfs_bmap_cancel(&flist);
+	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE));
+error0:
+	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
+	ASSERT(ip->i_df.if_ext_max ==
+	       XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t));
+	return error;
+}
+
+int
+xfs_bmap_add_attrfork(
+	struct xfs_inode	*ip,		/* incore inode pointer */
+	int			size,		/* space new attribute needs */
+	int			rsvd)		/* xact may use reserved blks */
+{
+	struct xfs_trans	*tp;		/* transaction pointer */
+	struct xfs_mount	*mp;		/* mount structure */
+	int			blks;		/* space reservation */
+	int			error;		/* error return value */
+
+	mp = ip->i_mount;
+	tp = xfs_trans_alloc(mp, XFS_TRANS_ADDAFORK);
+	blks = XFS_ADDAFORK_SPACE_RES(mp);
+
+	if (rsvd)
+		tp->t_flags |= XFS_TRANS_RESERVE;
+	error = xfs_trans_reserve(tp, blks, XFS_ADDAFORK_LOG_RES(mp), 0,
+				XFS_TRANS_PERM_LOG_RES, XFS_ADDAFORK_LOG_COUNT);
+	if (error)
+		goto error0;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	error = XFS_TRANS_RESERVE_QUOTA_NBLKS(mp, tp, ip, blks, 0, rsvd ?
+			      XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
+			      XFS_QMOPT_RES_REGBLKS);
+	if (error)
+		goto error1;
+
+	if (XFS_IFORK_Q(ip))
+		goto error1;
+
+	ASSERT(ip->i_d.di_anextents == 0);
+	VN_HOLD(XFS_ITOV(ip));
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	error = xfs_trans_bmap_add_attrfork(NULL, ip, size, rsvd);
+	if (error)
+		return error;
+	return xfs_trans_commit(tp, XFS_TRANS_PERM_LOG_RES);
 error1:
 	ASSERT(ismrlocked(&ip->i_lock,MR_UPDATE));
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
index 87224b7..7a21e41 100644
--- a/fs/xfs/xfs_bmap.h
+++ b/fs/xfs/xfs_bmap.h
@@ -166,6 +166,13 @@ xfs_bmap_add_attrfork(
 	int			size,	/* space needed for new attribute */
 	int			rsvd);	/* flag for reserved block allocation */
 
+int					/* error code */
+xfs_trans_bmap_add_attrfork(
+	struct xfs_trans	**tpp,   /* transaction */
+	struct xfs_inode	*ip,	/* incore inode pointer */
+	int			size,	/* space needed for new attribute */
+	int			rsvd);	/* flag for reserved block allocation */
+
 /*
  * Add the extent to the list of extents to be free at transaction end.
  * The list is maintained sorted (by block number).
-- 
1.5.6


--=-=-=


Thanks for this extensive review =)
-- 
Niv Sardi

--=-=-=--
