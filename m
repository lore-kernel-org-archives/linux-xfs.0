Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E30687FCE
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 15:29:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 809D7AC001
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 13:29:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4WrTAFmWdovAjFb2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Aug 2014 13:29:40 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s7TKTeJg016533
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 16:29:40 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s7TKTdsY025621
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 16:29:40 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 4/4] xfs: remove file writeback and eofblocks trim from
	collapse range
Date: Fri, 29 Aug 2014 16:29:38 -0400
Message-Id: <1409344178-44817-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1409344178-44817-1-git-send-email-bfoster@redhat.com>
References: <1409344178-44817-1-git-send-email-bfoster@redhat.com>
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

The full writeback and eofblocks trim operations executed prior to
collapse range are temporary hacks to avoid problems in the extent shift
implementation. The writeback prevents the in-core extent count from
changing due to extent conversions in parts of the file prior to the
collapse target. The eofblocks trim prevents collapse failure due to
attempts to look up delalloc extents on disk for bmapbt mappings.

The full writeback is no longer necessary because the extent shift is
now file offset based. Each time the ilock is dropped and reacquired, we
look up the current extent index based on the file offset where the
previous shift left off. The eofblocks trim is no longer required
because the extent shift mechanism knows how to shift delalloc extents.

Remove the writeback and eofblocks trim from xfs_collapse_file_space().

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 1e96d77..c9d16bd 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1470,26 +1470,6 @@ xfs_collapse_file_space(
 	next_fsb = XFS_B_TO_FSB(mp, offset + len);
 	shift_fsb = XFS_B_TO_FSB(mp, len);
 
-	/*
-	 * Writeback the entire file and force remove any post-eof blocks. The
-	 * writeback prevents changes to the extent list via concurrent
-	 * writeback and the eofblocks trim prevents the extent shift algorithm
-	 * from running into a post-eof delalloc extent.
-	 *
-	 * XXX: This is a temporary fix until the extent shift loop below is
-	 * converted to use offsets and lookups within the ILOCK rather than
-	 * carrying around the index into the extent list for the next
-	 * iteration.
-	 */
-	error = filemap_write_and_wait(VFS_I(ip)->i_mapping);
-	if (error)
-		return error;
-	if (xfs_can_free_eofblocks(ip, true)) {
-		error = xfs_free_eofblocks(mp, ip, false);
-		if (error)
-			return error;
-	}
-
 	error = xfs_free_file_space(ip, offset, len);
 	if (error)
 		return error;
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
