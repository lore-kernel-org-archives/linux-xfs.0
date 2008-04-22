Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Apr 2008 04:00:38 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3MB0G5a029937
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 04:00:19 -0700
Date: Tue, 22 Apr 2008 21:00:52 +1000
From: David Chinner <dgc@sgi.com>
Subject: [PATCH] Don't double count reserved block changes on UP.
Message-ID: <20080422110052.GY103491721@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Don't double count reserved block changes on UP.

On uniprocessor machines, the incore superblock is used for
all in memory accounting of free blocks. in this situation,
changes to the reserved block count are accounted twice;
once directly and once via xfs_mod_incore_sb(). Seeing as
the modification on SMP is done via xfs_mod_incore_sb(),
make this the only update mechanism that UP uses as well.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_fsops.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index d3a0f53..c4f7c93 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -552,11 +552,8 @@ retry:
 			mp->m_resblks += free;
 			mp->m_resblks_avail += free;
 			fdblks_delta = -free;
-			mp->m_sb.sb_fdblocks = XFS_ALLOC_SET_ASIDE(mp);
 		} else {
 			fdblks_delta = -delta;
-			mp->m_sb.sb_fdblocks =
-				lcounter + XFS_ALLOC_SET_ASIDE(mp);
 			mp->m_resblks = request;
 			mp->m_resblks_avail += delta;
 		}
@@ -587,7 +584,6 @@ out:
 		if (error == ENOSPC)
 			goto retry;
 	}
-
 	return 0;
 }
 
