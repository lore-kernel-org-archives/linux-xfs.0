Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 77D257F47
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 08:13:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 387648F8035
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 06:13:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RpHtNMadoR3EnMsW for
	<xfs@oss.sgi.com>; Fri, 06 Jun 2014 06:13:36 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s56DDZpY020003
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 6 Jun 2014 09:13:35 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s56DDZwP019499
	for <xfs@oss.sgi.com>; Fri, 6 Jun 2014 09:13:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/6] xfs: fix a couple error sequence jumps in xfs_mountfs()
Date: Fri,  6 Jun 2014 09:13:29 -0400
Message-Id: <1402060414-22075-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1402060414-22075-1-git-send-email-bfoster@redhat.com>
References: <1402060414-22075-1-git-send-email-bfoster@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

xfs_mountfs() has a couple failure conditions that do not jump to the
correct labels. Specifically:

- xfs_initialize_perag_data() failure does not deallocate the log even
  though it occurs after log initialization
- xfs_mount_reset_sbqflags() failure returns the error directly rather
  than jump to the error sequence

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_mount.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 3507cd0..8a41aba 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -855,7 +855,7 @@ xfs_mountfs(
 	     !mp->m_sb.sb_inprogress) {
 		error = xfs_initialize_perag_data(mp, sbp->sb_agcount);
 		if (error)
-			goto out_fail_wait;
+			goto out_log_dealloc;;
 	}
 
 	/*
@@ -927,7 +927,7 @@ xfs_mountfs(
 			xfs_notice(mp, "resetting quota flags");
 			error = xfs_mount_reset_sbqflags(mp);
 			if (error)
-				return error;
+				goto out_rtunmount;
 		}
 	}
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
