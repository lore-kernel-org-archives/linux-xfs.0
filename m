Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 87F807F4E
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2014 09:31:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 67A68304051
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2014 07:31:46 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 2glU5nAjrXJlGkc2 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 Oct 2014 07:31:43 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] xfs: Check error during inode btree iteration in
	xfs_bulkstat()
Date: Tue, 21 Oct 2014 16:31:32 +0200
Message-Id: <1413901892-17117-1-git-send-email-jack@suse.cz>
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
Cc: Jan Kara <jack@suse.cz>

xfs_bulkstat() doesn't check error return from xfs_btree_increment(). In
case of specific fs corruption that could result in xfs_bulkstat()
entering an infinite loop because we would be looping over the same
chunk over and over again. Fix the problem by checking the return value
and terminating the loop properly.

Coverity-id: 1231338
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_itable.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index f1deb961a296..66d5c619517d 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -474,6 +474,10 @@ xfs_bulkstat(
 			 */
 			agino = r.ir_startino + XFS_INODES_PER_CHUNK;
 			error = xfs_btree_increment(cur, 0, &tmp);
+			if (error) {
+				end_of_ag = 1;
+				break;
+			}
 			cond_resched();
 		}
 		/*
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
