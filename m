Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jul 2007 10:19:52 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6FHJkbm032495
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 10:19:49 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l6FHJmNK006948
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 19:19:48 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l6FHJm7V006946
	for xfs@oss.sgi.com; Sun, 15 Jul 2007 19:19:48 +0200
Date: Sun, 15 Jul 2007 19:19:48 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix format string warnings in xfsidbg
Message-ID: <20070715171948.GA6894@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2007-07-15 17:20:00.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2007-07-15 18:17:50.000000000 +0200
@@ -5488,8 +5488,8 @@ xfs_filestreams_trace_entry(ktrace_entry
 
 	case XFS_FSTRM_KTRACE_ORPHAN:
 		ip = ktep->val[4];
-		kdb_printf("gave ag %lld to orphan ip %p ino %llu",
-				(__psint_t)ktep->val[5],
+		kdb_printf("gave ag %ld to orphan ip %p ino %llu",
+				(unsigned long)ktep->val[5],
 				ip, (unsigned long long)ip->i_ino);
 		break;
 	default:
@@ -6686,7 +6686,7 @@ xfsidbg_xmount(xfs_mount_t *mp)
 		mp->m_rtdev_targp ? mp->m_rtdev_targp->bt_dev : 0);
 	kdb_printf("bsize %d agfrotor %d xfs_rotorstep %d agirotor %d\n",
 		mp->m_bsize, mp->m_agfrotor, xfs_rotorstep, mp->m_agirotor);
-	kdb_printf("ihash 0x%p ihsize %ld\n",
+	kdb_printf("ihash 0x%p ihsize %zu\n",
 		mp->m_ihash, mp->m_ihsize);
 	kdb_printf("inodes 0x%p ilock 0x%p ireclaims 0x%x\n",
 		mp->m_inodes, &mp->m_ilock, mp->m_ireclaims);
@@ -6818,7 +6818,7 @@ xfsidbg_xihash(xfs_mount_t *mp)
 
 	kdb_printf("\n");
 
-	kdb_printf("total inodes = %d, average length = %ld, adjusted average = %ld \n",
+	kdb_printf("total inodes = %zu, average length = %zu, adjusted average = %zu\n",
 		total, total / mp->m_ihsize,
 		total / (mp->m_ihsize - numzeros));
 
@@ -7411,24 +7411,32 @@ xfsidbg_xtp(xfs_trans_t *tp)
 		xfs_fmtlsn(&tp->t_commit_lsn));
 	kdb_printf("callback 0x%p callarg 0x%p\n",
 		tp->t_callback, tp->t_callarg);
-	kdb_printf("icount delta %ld ifree delta %ld\n",
-		tp->t_icount_delta, tp->t_ifree_delta);
-	kdb_printf("blocks delta %ld res blocks delta %ld\n",
-		tp->t_fdblocks_delta, tp->t_res_fdblocks_delta);
-	kdb_printf("rt delta %ld res rt delta %ld\n",
-		tp->t_frextents_delta, tp->t_res_frextents_delta);
+	kdb_printf("icount delta %lld ifree delta %lld\n",
+		(long long)tp->t_icount_delta,
+		(long long)tp->t_ifree_delta);
+	kdb_printf("blocks delta %lld res blocks delta %lld\n",
+		(long long)tp->t_fdblocks_delta,
+		(long long)tp->t_res_fdblocks_delta);
+	kdb_printf("rt delta %lld res rt delta %lld\n",
+		(long long)(long long)tp->t_frextents_delta,
+		(long long)tp->t_res_frextents_delta);
 #ifdef DEBUG
-	kdb_printf("ag freeblks delta %ld ag flist delta %ld ag btree delta %ld\n",
-		tp->t_ag_freeblks_delta, tp->t_ag_flist_delta,
-		tp->t_ag_btree_delta);
+	kdb_printf("ag freeblks delta %lld ag flist delta %lld ag btree delta %lld\n",
+		(long long)tp->t_ag_freeblks_delta,
+		(long long)tp->t_ag_flist_delta,
+		(long long)tp->t_ag_btree_delta);
 #endif
-	kdb_printf("dblocks delta %ld agcount delta %ld imaxpct delta %ld\n",
-		tp->t_dblocks_delta, tp->t_agcount_delta, tp->t_imaxpct_delta);
-	kdb_printf("rextsize delta %ld rbmblocks delta %ld\n",
-		tp->t_rextsize_delta, tp->t_rbmblocks_delta);
-	kdb_printf("rblocks delta %ld rextents delta %ld rextslog delta %ld\n",
-		tp->t_rblocks_delta, tp->t_rextents_delta,
-		tp->t_rextslog_delta);
+	kdb_printf("dblocks delta %lld agcount delta %lld imaxpct delta %lld\n",
+		(long long)tp->t_dblocks_delta,
+		(long long)tp->t_agcount_delta,
+		(long long)tp->t_imaxpct_delta);
+	kdb_printf("rextsize delta %lld rbmblocks delta %lld\n",
+		(long long)tp->t_rextsize_delta,
+		(long long)tp->t_rbmblocks_delta);
+	kdb_printf("rblocks delta %lld rextents delta %lld rextslog delta %lld\n",
+		(long long)tp->t_rblocks_delta,
+		(long long)tp->t_rextents_delta,
+		(long long)tp->t_rextslog_delta);
 	kdb_printf("dqinfo 0x%p\n", tp->t_dqinfo);
 	kdb_printf("log items:\n");
 	licp = &tp->t_items;
