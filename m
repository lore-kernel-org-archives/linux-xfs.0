Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7FBA67F6A
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 10:08:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 745868F8081
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 08:08:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id i1ZwzfLRVdXSVKHW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Jul 2014 08:08:12 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: fix rounding error of fiemap length parameter
Date: Tue, 15 Jul 2014 11:08:06 -0400
Message-Id: <1405436886-61287-1-git-send-email-bfoster@redhat.com>
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
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>

The offset and length parameters are converted from bytes to basic
blocks by xfs_vn_fiemap(). The BTOBB() converter rounds the value up to
the nearest basic block. This leads to unexpected behavior when
unaligned offsets are provided to FIEMAP.

Fix the conversions of byte values to block values to cover the provided
offsets. Round down the start offset to the nearest basic block.
Calculate the end offset based on the provided values, round up and
calculate length based on the start block offset.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reported-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---

Here's another pass at this. I think this is consistent with what ext4
does...

Brian

 fs/xfs/xfs_iops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d75621a..7212949 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1055,12 +1055,12 @@ xfs_vn_fiemap(
 		return error;
 
 	/* Set up bmap header for xfs internal routine */
-	bm.bmv_offset = BTOBB(start);
+	bm.bmv_offset = BTOBBT(start);
 	/* Special case for whole file */
 	if (length == FIEMAP_MAX_OFFSET)
 		bm.bmv_length = -1LL;
 	else
-		bm.bmv_length = BTOBB(length);
+		bm.bmv_length = BTOBB(start + length) - bm.bmv_offset;
 
 	/* We add one because in getbmap world count includes the header */
 	bm.bmv_count = !fieinfo->fi_extents_max ? MAXEXTNUM :
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
