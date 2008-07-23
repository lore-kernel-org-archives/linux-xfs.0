Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 07:26:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NEQNTZ013417
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 07:26:23 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 285D2319A37
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 07:27:32 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id hAEfvcF27SoLHv6x for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 07:27:32 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6NERMNg023000
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 16:27:23 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6NERMRG022998
	for xfs@oss.sgi.com; Wed, 23 Jul 2008 16:27:22 +0200
Date: Wed, 23 Jul 2008 16:27:22 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove unused m_inode_quiesce member from struct xfs_mount
Message-ID: <20080723142720.GB22859@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2008-07-23 15:07:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2008-07-23 15:07:51.000000000 +0200
@@ -313,8 +313,6 @@ typedef struct xfs_mount {
 	int			m_attr_magicpct;/* 37% of the blocksize */
 	int			m_dir_magicpct;	/* 37% of the dir blocksize */
 	__uint8_t		m_mk_sharedro;	/* mark shared ro on unmount */
-	__uint8_t		m_inode_quiesce;/* call quiesce on new inodes.
-						   field governed by m_ilock */
 	__uint8_t		m_sectbb_log;	/* sectlog - BBSHIFT */
 	const struct xfs_nameops *m_dirnameops;	/* vector of dir name ops */
 	int			m_dirblksize;	/* directory block sz--bytes */
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2008-07-23 15:07:25.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2008-07-23 15:07:38.000000000 +0200
@@ -6377,8 +6377,8 @@ xfsidbg_xmount(xfs_mount_t *mp)
 	kdb_printf("dalign %d swidth %d sinoalign %d attr_magicpct %d dir_magicpct %d\n",
 		mp->m_dalign, mp->m_swidth, mp->m_sinoalign,
 		mp->m_attr_magicpct, mp->m_dir_magicpct);
-	kdb_printf("mk_sharedro %d inode_quiesce %d sectbb_log %d\n",
-		mp->m_mk_sharedro, mp->m_inode_quiesce, mp->m_sectbb_log);
+	kdb_printf("mk_sharedro %d sectbb_log %d\n",
+		mp->m_mk_sharedro, mp->m_sectbb_log);
 	kdb_printf("dirblkfsbs %d\n", mp->m_dirblkfsbs);
 	kdb_printf("dirblksize %d dirdatablk 0x%Lx dirleafblk 0x%Lx dirfreeblk 0x%Lx\n",
 		mp->m_dirblksize,
