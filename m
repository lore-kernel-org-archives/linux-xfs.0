Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6D4257CBF
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 16:16:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5C7E930404E
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 14:16:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id iqLfELEHrQbwPyjC for
	<xfs@oss.sgi.com>; Tue, 27 Aug 2013 14:16:12 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7RLGCv7004721
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 17:16:12 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r7RLGBHk019081
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 17:16:12 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: check correct status variable for xfs_inobt_get_rec()
	call
Date: Tue, 27 Aug 2013 17:15:45 -0400
Message-Id: <1377638145-18800-1-git-send-email-bfoster@redhat.com>
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

The call to xfs_inobt_get_rec() in xfs_dialloc_ag() passes 'j' as
the output status variable. The immediately following
XFS_WANT_CORRUPTED_GOTO() checks the value of 'i,' which is from
the previous lookup call and has already been checked. Fix the
corruption check to use 'j.'

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_ialloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 6bee95d..ccf2fb1 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -729,7 +729,7 @@ xfs_dialloc_ag(
 		error = xfs_inobt_get_rec(cur, &rec, &j);
 		if (error)
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(j == 1, error0);
 
 		if (rec.ir_freecount > 0) {
 			/*
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
