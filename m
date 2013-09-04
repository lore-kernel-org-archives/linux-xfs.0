Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4FB7029E0E
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 17:21:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D5911AC003
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 15:21:34 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	DIxAdvom6iXU0OJm for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 15:21:33 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VHLDA-0007dS-T0
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:05 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VHLDA-0003vp-IR
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 52/55] xfs: btree block LSN escaping to disk uninitialised
Date: Thu,  5 Sep 2013 08:05:56 +1000
Message-Id: <1378332359-14737-53-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-1-git-send-email-david@fromorbit.com>
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
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
 libxfs/xfs_btree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 3ac3330..0099926 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -921,6 +921,7 @@ xfs_btree_init_block_int(
 			buf->bb_u.l.bb_owner = cpu_to_be64(owner);
 			uuid_copy(&buf->bb_u.l.bb_uuid, &mp->m_sb.sb_uuid);
 			buf->bb_u.l.bb_pad = 0;
+			buf->bb_u.l.bb_lsn = 0;
 		}
 	} else {
 		/* owner is a 32 bit value on short blocks */
@@ -932,6 +933,7 @@ xfs_btree_init_block_int(
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
