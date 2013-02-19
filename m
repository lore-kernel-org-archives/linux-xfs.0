Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D72197F4C
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 09:22:10 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A6ABF30405F
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 07:22:07 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id p0hdjxUxIS3uTDD1 for
	<xfs@oss.sgi.com>; Tue, 19 Feb 2013 07:22:07 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1JFM6om007912
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 10:22:06 -0500
Received: from bfoster.bfoster (dhcp-189-135.bos.redhat.com [10.16.189.135])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r1JFM5rc030918
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 10:22:06 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2] xfs: increase prealloc size to double that of the previous
	extent
Date: Tue, 19 Feb 2013 10:24:41 -0500
Message-Id: <1361287481-9649-1-git-send-email-bfoster@redhat.com>
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

The updated speculative preallocation algorithm for handling sparse
files can becomes less effective in situations with a high number of
concurrent, sequential writers. The number of writers and amount of
available RAM affect the writeback bandwidth slicing algorithm,
which in turn affects the block allocation pattern of XFS. For
example, running 32 sequential writers on a system with 32GB RAM,
preallocs become fixed at a value of around 128MB (instead of
steadily increasing to the 8GB maximum as sequential writes
proceed).

Update the speculative prealloc heuristic to base the size of the
next prealloc on double the size of the preceding extent. This
preserves the original aggressive speculative preallocation
behavior and continues to accomodate sparse files at a slight cost
of increasing the size of preallocated data regions following holes
of sparse files.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
Hi,

v2 just updates the commit log description to reflect that the characteristics
of the hardware and workload can affect the allocation pattern and observed
behavior.

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
