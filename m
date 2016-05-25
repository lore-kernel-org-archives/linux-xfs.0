Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A5FE37CA0
	for <xfs@oss.sgi.com>; Wed, 25 May 2016 14:31:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 79E1F304062
	for <xfs@oss.sgi.com>; Wed, 25 May 2016 12:31:11 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Sj5rCVpnqO1E9pP3 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 May 2016 12:31:10 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 5374A64D1C
	for <xfs@oss.sgi.com>; Wed, 25 May 2016 19:31:09 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-153.bos.redhat.com [10.18.41.153])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u4PJV8nA012931
	for <xfs@oss.sgi.com>; Wed, 25 May 2016 15:31:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: fix broken multi-fsb buffer logging
Date: Wed, 25 May 2016 15:31:07 -0400
Message-Id: <1464204667-10199-1-git-send-email-bfoster@redhat.com>
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

Multi-block buffers are logged based on buffer offset in
xfs_trans_log_buf(). xfs_buf_item_log() ultimately walks each mapping in
the buffer and marks the associated range to be logged in the
xfs_buf_log_format bitmap for that mapping. This code is broken,
however, in that it marks the actual buffer offsets of the associated
range in each bitmap rather than shifting to the byte range for that
particular mapping.

For example, on a 4k fsb fs, buffer offset 4096 refers to the first byte
of the second mapping in the buffer. This means byte 0 of the second log
format bitmap should be tagged as dirty. Instead, the current code marks
byte offset 4096 of the second log format bitmap, which is invalid and
potentially out of range of the mapping.

As a result of this, the log item format code invoked at transaction
commit time is not be able to correctly identify what parts of the
buffer to copy into log vectors. This can lead to NULL log vector
pointer dereferences in CIL push context if the item format code was not
able to locate any dirty ranges at all. This crash has been reproduced
on a 4k FSB filesystem using 16k directory blocks where an unlink
operation happened not to log anything in the first block of the
mapping. The logged offsets were all over 4k, marked as such in the
subsequent log format mappings, and thus left the transaction with an
xfs_log_item that is marked DIRTY but without any logged regions.

Further, even when the logged regions are marked correctly in the buffer
log format bitmaps, the format code doesn't copy the correct ranges of
the buffer into the log. This means that any logged region beyond the
first block of a multi-block buffer is subject to corruption after a
crash and log recovery sequence. This is due to a failure to convert the
mapping bm_len field from basic blocks to bytes in the buffer offset
tracking code in xfs_buf_item_format().

Update xfs_buf_item_log() to convert buffer offsets to segment relative
offsets when logging multi-block buffers. This ensures that the modified
regions of a buffer are logged correctly and avoids the aforementioned
crash. Also update xfs_buf_item_format() to correctly track the source
offset into the buffer for the log vector formatting code. This ensures
that the correct data is copied into the log.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Note that this has only been tested so far in a particular filesystem
environment that reproduces the crash/corruption discussed in the commit
log description. Generic testing still required, posting just to get a
jump on review...

Brian

 fs/xfs/xfs_buf_item.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 3425799..2e95ad0 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -359,7 +359,7 @@ xfs_buf_item_format(
 	for (i = 0; i < bip->bli_format_count; i++) {
 		xfs_buf_item_format_segment(bip, lv, &vecp, offset,
 					    &bip->bli_formats[i]);
-		offset += bp->b_maps[i].bm_len;
+		offset += BBTOB(bp->b_maps[i].bm_len);
 	}
 
 	/*
@@ -915,20 +915,28 @@ xfs_buf_item_log(
 	for (i = 0; i < bip->bli_format_count; i++) {
 		if (start > last)
 			break;
-		end = start + BBTOB(bp->b_maps[i].bm_len);
+		end = start + BBTOB(bp->b_maps[i].bm_len) - 1;
+
+		/* skip to the map that includes the first byte to log */
 		if (first > end) {
 			start += BBTOB(bp->b_maps[i].bm_len);
 			continue;
 		}
+
+		/*
+		 * Trim the range to this segment and mark it in the bitmap.
+		 * Note that we must convert buffer offsets to segment relative
+		 * offsets (e.g., the first byte of each segment is byte 0 of
+		 * that segment).
+		 */
 		if (first < start)
 			first = start;
 		if (end > last)
 			end = last;
-
-		xfs_buf_item_log_segment(first, end,
+		xfs_buf_item_log_segment(first - start, end - start,
 					 &bip->bli_formats[i].blf_data_map[0]);
 
-		start += bp->b_maps[i].bm_len;
+		start += BBTOB(bp->b_maps[i].bm_len);
 	}
 }
 
-- 
2.4.11

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
