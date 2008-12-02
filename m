Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB2GCp9u032767 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 10:12:51 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 42586164F30E
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 08:12:51 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 1MgvsIWN3eIkbK84 for
	<xfs@oss.sgi.com>; Tue, 02 Dec 2008 08:12:51 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L7Xlz-0007U7-HS
	for xfs@oss.sgi.com; Tue, 02 Dec 2008 16:06:51 +0000
Message-Id: <20081202160651.426074000@bombadil.infradead.org>
References: <20081202160430.775774000@bombadil.infradead.org>
Date: Tue, 02 Dec 2008 11:04:43 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 13/22] remove unused m_inode_quiesce member from struct
	xfs_mount
Content-Disposition: inline; filename=xfs-kill-m_inode_quiesce
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

(First sent on July 23rd)


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-master/fs/xfs/xfs_mount.h
===================================================================
--- xfs-master.orig/fs/xfs/xfs_mount.h	2008-12-01 19:27:15.000000000 +0100
+++ xfs-master/fs/xfs/xfs_mount.h	2008-12-01 19:27:59.000000000 +0100
@@ -302,7 +302,6 @@ typedef struct xfs_mount {
 	int			m_attr_magicpct;/* 37% of the blocksize */
 	int			m_dir_magicpct;	/* 37% of the dir blocksize */
 	__uint8_t		m_mk_sharedro;	/* mark shared ro on unmount */
-	__uint8_t		m_inode_quiesce;/* call quiesce on new inodes. */
 	__uint8_t		m_sectbb_log;	/* sectlog - BBSHIFT */
 	const struct xfs_nameops *m_dirnameops;	/* vector of dir name ops */
 	int			m_dirblksize;	/* directory block sz--bytes */

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
