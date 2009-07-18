Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6IMGqsj176598 for <xfs@oss.sgi.com>; Sat, 18 Jul 2009 17:16:54 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B9D86137E08F
	for <xfs@oss.sgi.com>; Sat, 18 Jul 2009 15:17:33 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ma5KXcZy2R7t0acd for
	<xfs@oss.sgi.com>; Sat, 18 Jul 2009 15:17:33 -0700 (PDT)
Message-Id: <20090718221732.034903000@bombadil.infradead.org>
Date: Sat, 18 Jul 2009 18:14:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/9] xfs: avoid memory allocation under m_peraglock in growfs
	code
References: <20090718221452.594956000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-lockdep-growfs
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: sage@newdream.net

Allocate the memory for the larger m_perag array before taking the
per-AG lock as the per-AG lock can be taken under the i_lock which
can be taken from reclaim context.

Reported by the new reclaim context tracing in lockdep.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/xfs_fsops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_fsops.c	2009-07-10 13:05:24.798364926 +0200
+++ linux-2.6/fs/xfs/xfs_fsops.c	2009-07-10 13:16:00.827394975 +0200
@@ -167,17 +167,25 @@ xfs_growfs_data_private(
 	new = nb - mp->m_sb.sb_dblocks;
 	oagcount = mp->m_sb.sb_agcount;
 	if (nagcount > oagcount) {
+		void *new_perag, *old_perag;
+
 		xfs_filestream_flush(mp);
+
+		new_perag = kmem_zalloc(sizeof(xfs_perag_t) * nagcount,
+					KM_MAYFAIL);
+		if (!new_perag)
+			return XFS_ERROR(ENOMEM);
+
 		down_write(&mp->m_peraglock);
-		mp->m_perag = kmem_realloc(mp->m_perag,
-			sizeof(xfs_perag_t) * nagcount,
-			sizeof(xfs_perag_t) * oagcount,
-			KM_SLEEP);
-		memset(&mp->m_perag[oagcount], 0,
-			(nagcount - oagcount) * sizeof(xfs_perag_t));
+		memcpy(new_perag, mp->m_perag, sizeof(xfs_perag_t) * oagcount);
+		old_perag = mp->m_perag;
+		mp->m_perag = new_perag;
+
 		mp->m_flags |= XFS_MOUNT_32BITINODES;
 		nagimax = xfs_initialize_perag(mp, nagcount);
 		up_write(&mp->m_peraglock);
+
+		kmem_free(old_perag);
 	}
 	tp = xfs_trans_alloc(mp, XFS_TRANS_GROWFS);
 	tp->t_flags |= XFS_TRANS_RESERVE;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
