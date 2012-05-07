Return-Path: <xfs-bounces@oss.sgi.com>
Received: from nfs10.americas.sgi.com (nfs10.americas.sgi.com [128.162.245.67])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q47KSDZ2156282 for <xfs@oss.sgi.com>; Mon, 7 May 2012 15:28:13 -0500
Message-Id: <20120507204247.435680916@nfs10.americas.sgi.com>
Date: Mon, 07 May 2012 15:42:26 -0500
From: bpm@sgi.com
Subject: [patch 4/5] [PATCH 5/3] xfs: limit specualtive delalloc to maxioffset
References: <20120507204222.921092617@nfs10.americas.sgi.com>
Content-Disposition: inline;
	filename=xfs-limit-specualtive-delalloc-to-maxioffset.patch
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
To: xfs-dev@sgi.com, xfs@oss.sgi.com
Cc: Dave Chinner <dchinner@redhat.com>


From: Dave Chinner <dchinner@redhat.com>

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
---
 fs/xfs/xfs_iomap.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 303c03a..4a08ea3 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -412,6 +412,15 @@ retry:
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
 	error = xfs_bmapi_delay(ip, offset_fsb, last_fsb - offset_fsb,
 				imap, &nimaps, XFS_BMAPI_ENTIRE);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
