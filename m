Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3EAC97F4E
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 17:54:32 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1CAFD304067
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 15:54:31 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id eh3ZIQ3jGkD1RVyl for
	<xfs@oss.sgi.com>; Mon, 18 Feb 2013 15:54:31 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1INsUq2002335
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 18:54:30 -0500
Received: from bfoster.bfoster (dhcp-189-135.bos.redhat.com [10.16.189.135])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r1INsUE6025980
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 18:54:30 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: increase prealloc size to double that of the previous
	extent
Date: Mon, 18 Feb 2013 18:57:07 -0500
Message-Id: <1361231827-58766-1-git-send-email-bfoster@redhat.com>
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

The updated speculative preallocation algorithm becomes less
effective in situations with a high number of concurrent,
sequential writers. In running 32 sequential writers on a system
with 32GB RAM, preallocs become fixed at a value of around 128MB.
Update the heuristic to base the size of the prealloc on double
the size of the preceding extent. This preserves the original
aggressive speculative preallocation behavior at a slight cost of
increasing the size of preallocated data regions following holes of
sparse files.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
Hi all,

This is based on Dave's suggestion on IRC to address the high concurrent
writer defeating speculative preallocation problem. This addresses the reported
problem and generally preserves the prealloc limiting within sparse files:

xfs_io -f -c "pwrite 0 31m" \
	  -c "pwrite 33m 1m" \
	  -c "pwrite 128m 1m" \
	  -c "fiemap -v" /mnt/file
wrote 32505856/32505856 bytes at offset 0
31 MiB, 7936 ops; 0.0000 sec (1.082 GiB/sec and 283621.0286 ops/sec)
wrote 1048576/1048576 bytes at offset 34603008
1 MiB, 256 ops; 0.0000 sec (626.174 MiB/sec and 160300.5636 ops/sec)
wrote 1048576/1048576 bytes at offset 134217728
1 MiB, 256 ops; 0.0000 sec (624.220 MiB/sec and 159800.2497 ops/sec)
/mnt/file:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..65407]:      232..65639       65408   0x0
   1: [65408..67583]:  hole              2176
   2: [67584..71551]:  67816..71783      3968   0x0
   3: [71552..262143]: hole             190592
   4: [262144..266111]: 71784..75751      3968   0x1

Brian

 fs/xfs/xfs_iomap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 912d83d..45a382d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -362,7 +362,7 @@ xfs_iomap_eof_prealloc_initial_size(
 	if (imap[0].br_startblock == HOLESTARTBLOCK)
 		return 0;
 	if (imap[0].br_blockcount <= (MAXEXTLEN >> 1))
-		return imap[0].br_blockcount;
+		return imap[0].br_blockcount << 1;
 	return XFS_B_TO_FSB(mp, offset);
 }
 
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
