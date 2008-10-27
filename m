Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 07:04:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RDmn26027438
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:48:49 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 31C3054B906
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:48:48 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 101qtOsnc6bIwDzZ for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:48:48 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KuSSe-0001gK-L7
	for xfs@oss.sgi.com; Mon, 27 Oct 2008 13:48:48 +0000
Date: Mon, 27 Oct 2008 09:48:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 09/10] remove unused m_inode_quiesce member from struct
	xfs_mount
Message-ID: <20081027134848.GD6440@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-kill-m_inode_quiesce
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

(First sent on July 23rd)


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2008-10-22 09:33:02.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2008-10-22 09:43:34.000000000 +0200
@@ -303,7 +303,6 @@ typedef struct xfs_mount {
 	int			m_attr_magicpct;/* 37% of the blocksize */
 	int			m_dir_magicpct;	/* 37% of the dir blocksize */
 	__uint8_t		m_mk_sharedro;	/* mark shared ro on unmount */
-	__uint8_t		m_inode_quiesce;/* call quiesce on new inodes. */
 	__uint8_t		m_sectbb_log;	/* sectlog - BBSHIFT */
 	const struct xfs_nameops *m_dirnameops;	/* vector of dir name ops */
 	int			m_dirblksize;	/* directory block sz--bytes */
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2008-10-22 09:40:15.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2008-10-22 09:43:08.000000000 +0200
@@ -6523,8 +6523,8 @@ xfsidbg_xmount(xfs_mount_t *mp)
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

-- 
