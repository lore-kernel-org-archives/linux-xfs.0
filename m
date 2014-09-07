Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7491B7F4E
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 07:26:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6282F8F8054
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 05:26:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AD9bRXLCsSXVKGZH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 07 Sep 2014 05:26:02 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s87CQ1a3009154
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Sun, 7 Sep 2014 08:26:01 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s87CQ11i030642
	for <xfs@oss.sgi.com>; Sun, 7 Sep 2014 08:26:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 4/4] xfs: only writeback and truncate pages for the freed range
Date: Sun,  7 Sep 2014 08:26:00 -0400
Message-Id: <1410092760-3451-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1410092760-3451-1-git-send-email-bfoster@redhat.com>
References: <1410092760-3451-1-git-send-email-bfoster@redhat.com>
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

xfs_free_file_space() only affects the range of the file for which space
is being freed. It currently writes and truncates the page cache from
the start offset of the free to EOF.

Modify xfs_free_file_space() to write back and truncate page cache of
just the range being freed.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index eae763f..809ae7d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1205,6 +1205,7 @@ xfs_free_file_space(
 	xfs_bmap_free_t		free_list;
 	xfs_bmbt_irec_t		imap;
 	xfs_off_t		ioffset;
+	xfs_off_t		iendoffset;
 	xfs_extlen_t		mod=0;
 	xfs_mount_t		*mp;
 	int			nimap;
@@ -1233,12 +1234,13 @@ xfs_free_file_space(
 	inode_dio_wait(VFS_I(ip));
 
 	rounding = max_t(xfs_off_t, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
-	ioffset = offset & ~(rounding - 1);
-	error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
-					      ioffset, -1);
+	ioffset = round_down(offset, rounding);
+	iendoffset = round_up(offset + len, rounding) - 1;
+	error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping, ioffset,
+					     iendoffset);
 	if (error)
 		goto out;
-	truncate_pagecache_range(VFS_I(ip), ioffset, -1);
+	truncate_pagecache_range(VFS_I(ip), ioffset, iendoffset);
 
 	/*
 	 * Need to zero the stuff we're not freeing, on disk.
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
