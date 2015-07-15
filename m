Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CC5007F6C
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2015 03:16:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A5887304051
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2015 01:16:18 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id F5UAgSA9WFc56VZl (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 Jul 2015 01:16:16 -0700 (PDT)
From: Jan Kara <jack@suse.com>
Subject: [PATCH] xfs: Fix uninitialized return value in
	xfs_alloc_fix_freelist()
Date: Wed, 15 Jul 2015 10:16:08 +0200
Message-Id: <1436948168-25051-1-git-send-email-jack@suse.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, Jan Kara <jack@suse.com>

xfs_alloc_fix_freelist() can sometimes jump to out_agbp_relse without
ever setting value of 'error' variable which is then returned. This can
happen e.g. when pag->pagf_init is set but AG is for metadata and we
want to allocate user data.

Fix the problem by initializing 'error' to 0, which is the desired
return value when we decide to skip this group.

CC: xfs@oss.sgi.com
Coverity-id: 1309714
Signed-off-by: Jan Kara <jack@suse.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index f9e9ffe6fb46..7f8f2a0d4567 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1937,7 +1937,7 @@ xfs_alloc_fix_freelist(
 	struct xfs_alloc_arg	targs;	/* local allocation arguments */
 	xfs_agblock_t		bno;	/* freelist block */
 	xfs_extlen_t		need;	/* total blocks needed in freelist */
-	int			error;
+	int			error = 0;
 
 	if (!pag->pagf_init) {
 		error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
