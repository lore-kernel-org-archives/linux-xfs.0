Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 01 Jun 2008 22:40:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m525eJcR010012
	for <xfs@oss.sgi.com>; Sun, 1 Jun 2008 22:40:20 -0700
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id PAA23428 for <xfs@oss.sgi.com>; Mon, 2 Jun 2008 15:41:11 +1000
Date: Mon, 02 Jun 2008 15:42:55 +1000
Subject: REVIEW: Zero uninitialised xfs_da_args structure in xfs_dir2.c
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Message-ID: <op.ub3wttk53jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

In particular, this patch fixes a problem in the xfs_dir2_remove and
xfs_dir2_replace paths which internally can call a lookup function
which will use args->cmpresult which is uninitialised.

--

Index: 2.6.x-xfs/fs/xfs/xfs_dir2.c
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfs_dir2.c
+++ 2.6.x-xfs/fs/xfs/xfs_dir2.c
@@ -213,6 +213,7 @@ xfs_dir_createname(
  	if ((rval = xfs_dir_ino_validate(tp->t_mountp, inum)))
  		return rval;
  	XFS_STATS_INC(xs_dir_create);
+	memset(&args, 0, sizeof(xfs_da_args_t));

  	args.name = name->name;
  	args.namelen = name->len;
@@ -297,7 +298,6 @@ xfs_dir_lookup(
  	args.op_flags = XFS_DA_OP_OKNOENT;
  	if (ci_name)
  		args.op_flags |= XFS_DA_OP_CILOOKUP;
-	args.cmpresult = XFS_CMP_DIFFERENT;

  	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
  		rval = xfs_dir2_sf_lookup(&args);
@@ -342,6 +342,7 @@ xfs_dir_removename(

  	ASSERT((dp->i_d.di_mode & S_IFMT) == S_IFDIR);
  	XFS_STATS_INC(xs_dir_remove);
+	memset(&args, 0, sizeof(xfs_da_args_t));

  	args.name = name->name;
  	args.namelen = name->len;
@@ -353,7 +354,6 @@ xfs_dir_removename(
  	args.total = total;
  	args.whichfork = XFS_DATA_FORK;
  	args.trans = tp;
-	args.op_flags = 0;

  	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
  		rval = xfs_dir2_sf_removename(&args);
@@ -425,6 +425,7 @@ xfs_dir_replace(

  	if ((rval = xfs_dir_ino_validate(tp->t_mountp, inum)))
  		return rval;
+	memset(&args, 0, sizeof(xfs_da_args_t));

  	args.name = name->name;
  	args.namelen = name->len;
@@ -436,7 +437,6 @@ xfs_dir_replace(
  	args.total = total;
  	args.whichfork = XFS_DATA_FORK;
  	args.trans = tp;
-	args.op_flags = 0;

  	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
  		rval = xfs_dir2_sf_replace(&args);
