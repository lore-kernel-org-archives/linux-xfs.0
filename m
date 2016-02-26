Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 367BA7CA4
	for <xfs@oss.sgi.com>; Fri, 26 Feb 2016 13:35:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F408E8F8039
	for <xfs@oss.sgi.com>; Fri, 26 Feb 2016 11:35:10 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id LHEL4OY0x671dBZE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 26 Feb 2016 11:35:06 -0800 (PST)
Date: Fri, 26 Feb 2016 11:34:56 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] mkfs: fix crash when initializing rbmip
Message-ID: <20160226193456.GA27973@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

Initialize rbmip, log the inode, /then/ assign it to the xfs_mount.
Don't try to access rbmip in the xfs_mount before that, or it'll crash.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/proto.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/proto.c b/mkfs/proto.c
index 933924e..d99e965 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -653,7 +653,7 @@ rtinit(
 	mp->m_sb.sb_rbmino = rbmip->i_ino;
 	rbmip->i_d.di_size = mp->m_sb.sb_rbmblocks * mp->m_sb.sb_blocksize;
 	rbmip->i_d.di_flags = XFS_DIFLAG_NEWRTBM;
-	*(__uint64_t *)&VFS_I(mp->m_rbmip)->i_atime = 0;
+	*(__uint64_t *)&VFS_I(rbmip)->i_atime = 0;
 	libxfs_trans_log_inode(tp, rbmip, XFS_ILOG_CORE);
 	libxfs_log_sb(tp);
 	mp->m_rbmip = rbmip;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
