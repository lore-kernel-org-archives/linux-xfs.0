Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C31DB7F37
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 09:43:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AF8888F8050
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 07:43:35 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id sdonHKVqd1XfxcAT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 09 Sep 2015 07:43:34 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 17D9567
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 14:43:34 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: add missing ilock around dio write last extent alignment
Date: Wed,  9 Sep 2015 10:43:32 -0400
Message-Id: <1441809812-60175-1-git-send-email-bfoster@redhat.com>
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
Cc: David Jeffery <djeffery@redhat.com>

The iomap codepath (via get_blocks()) acquires and release the inode
lock in the case of a direct write that requires block allocation. This
is because xfs_iomap_write_direct() allocates a transaction, which means
the ilock must be dropped and reacquired after the transaction is
allocated and reserved.

xfs_iomap_write_direct() invokes xfs_iomap_eof_align_last_fsb() before
the transaction is created and thus before the ilock is reacquired. This
can lead to calls to xfs_iread_extents() and reads of the in-core extent
list without any synchronization (via xfs_bmap_eof() and
xfs_bmap_last_extent()). xfs_iread_extents() assert fails if the ilock
is not held, but this is not currently seen in practice as the current
callers had already invoked xfs_bmapi_read().

What has been seen in practice are reports of crashes down in the
xfs_bmap_eof() codepath on direct writes due to seemingly bogus pointer
references from xfs_iext_get_ext(). While an explicit reproducer is not
currently available to confirm the cause of the problem, crash analysis
and code inspection from David Jeffrey had identified the insufficient
locking.

xfs_iomap_eof_align_last_fsb() is called from other contexts with the
inode lock already held. __xfs_get_blocks() acquires and drops the ilock
with variable flags. Therefore, take the simple approach to cycle ilock
around the last extent alignment call from xfs_iomap_write_direct().

Reported-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iomap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 1f86033..4d7534e 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -142,7 +142,9 @@ xfs_iomap_write_direct(
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	last_fsb = XFS_B_TO_FSB(mp, ((xfs_ufsize_t)(offset + count)));
 	if ((offset + count) > XFS_ISIZE(ip)) {
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		error = xfs_iomap_eof_align_last_fsb(mp, ip, extsz, &last_fsb);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		if (error)
 			return error;
 	} else {
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
