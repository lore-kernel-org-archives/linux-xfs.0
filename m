Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3TChNj9121347 for <xfs@oss.sgi.com>; Sun, 29 Apr 2012 07:43:24 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	nQBwXqXySstgFpBD for <xfs@oss.sgi.com>;
	Sun, 29 Apr 2012 05:43:21 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1SOTTD-0000ZU-Hf
	for xfs@oss.sgi.com; Sun, 29 Apr 2012 22:43:19 +1000
Date: Sun, 29 Apr 2012 22:43:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/3] xfs: limit specualtive delalloc to maxioffset
Message-ID: <20120429124319.GT9541@dastard>
References: <1335519922-14371-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1335519922-14371-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


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
