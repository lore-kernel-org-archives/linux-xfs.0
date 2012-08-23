Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N54Usl135775 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:04:31 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	qogUOk1zedi833W9 for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:05:16 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PbU-0003JO-NC
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:12 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PbK-0003hx-Jv
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 079/102] xfs: limit specualtive delalloc to maxioffset
Date: Thu, 23 Aug 2012 15:02:37 +1000
Message-Id: <1345698180-13612-80-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 29e2d85..121309f 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -418,6 +418,15 @@ retry:
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
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
