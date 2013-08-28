Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5DCF37F37
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 06:22:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DD152AC010
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 04:22:58 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	u30OmzyYjdzHXBWn for <xfs@oss.sgi.com>;
	Wed, 28 Aug 2013 04:22:57 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VEdpp-0004xZ-Dz
	for xfs@oss.sgi.com; Wed, 28 Aug 2013 21:22:49 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VEdpp-0001i4-DG
	for xfs@oss.sgi.com; Wed, 28 Aug 2013 21:22:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: btree block LSN escaping to disk uninitialised
Date: Wed, 28 Aug 2013 21:22:46 +1000
Message-Id: <1377688967-6480-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1377688967-6480-1-git-send-email-david@fromorbit.com>
References: <1377688967-6480-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

When testing LSN ordering code for v5 superblocks, it was discovered
that the the LSN embedded in the generic btree blocks was
occasionally uninitialised. These values didn't get written to disk
by metadata writeback - they got written by previous transactions in
log recovery.

The issue is here that the when the block is first allocated and
initialised, the LSN field was not initialised - it gets overwritten
before IO is issued on the buffer - but the value that is logged by
transactions that modify the header before it is written to disk
(and initialised) contain garbage. Hence the first recovery of the
buffer will stamp garbage into the LSN field, and that can cause
subsequent transactions to not replay correctly.

The fix is simply to initialise the bb_lsn field to zero when we
initialise the block for the first time.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_btree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index ae106f6..7a2b4da 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -978,6 +978,7 @@ xfs_btree_init_block_int(
 			buf->bb_u.l.bb_owner = cpu_to_be64(owner);
 			uuid_copy(&buf->bb_u.l.bb_uuid, &mp->m_sb.sb_uuid);
 			buf->bb_u.l.bb_pad = 0;
+			buf->bb_u.l.bb_lsn = 0;
 		}
 	} else {
 		/* owner is a 32 bit value on short blocks */
@@ -989,6 +990,7 @@ xfs_btree_init_block_int(
 			buf->bb_u.s.bb_blkno = cpu_to_be64(blkno);
 			buf->bb_u.s.bb_owner = cpu_to_be32(__owner);
 			uuid_copy(&buf->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid);
+			buf->bb_u.s.bb_lsn = 0;
 		}
 	}
 }
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
