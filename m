Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3NefTA067661 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:42 -0600
Message-Id: <20121203144310.552816763@sgi.com>
Date: Mon, 03 Dec 2012 17:42:27 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 19/36] xfs: limit specualtive delalloc to maxioffset
References: <20121203144208.143464631@sgi.com>
Content-Disposition: inline; filename=079
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
To: stable@vger.kernel.org
Cc: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Upstream commit: 3ed9116e8a3e9c0870b2076340b3da9b8f900f3b

Speculative delayed allocation beyond EOF near the maximum supported
file offset can result in creating delalloc extents beyond
mp->m_maxioffset (8EB). These can never be trimmed during
xfs_free_eof_blocks() because they are beyond mp->m_maxioffset, and
that results in assert failures in xfs_fs_destroy_inode() due to
delalloc blocks still being present. xfstests 071 exposes this
problem.

Limit speculative delalloc to mp->m_maxioffset to avoid this
problem.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_iomap.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: b/fs/xfs/xfs_iomap.c
===================================================================
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -417,6 +417,15 @@ retry:
 			return error;
 	}
 
+	/*
+	 * Make sure preallocation does not create extents beyond the range we
+	 * actually support in this filesystem.
+	 */
+	if (last_fsb > XFS_B_TO_FSB(mp, mp->m_maxioffset))
+		last_fsb = XFS_B_TO_FSB(mp, mp->m_maxioffset);
+
+	ASSERT(last_fsb > offset_fsb);
+
 	nimaps = XFS_WRITE_IMAPS;
 	firstblock = NULLFSBLOCK;
 	error = xfs_bmapi(NULL, ip, offset_fsb,


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
