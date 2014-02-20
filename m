Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3274A7FA6
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 23:55:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B16E0AC003
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 21:55:46 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	xGjXs9n6JSrVjHkj for <xfs@oss.sgi.com>;
	Wed, 19 Feb 2014 21:55:41 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1WGMbV-00057G-PK
	for xfs@oss.sgi.com; Thu, 20 Feb 2014 16:55:25 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WGMbV-0001CD-OK
	for xfs@oss.sgi.com; Thu, 20 Feb 2014 16:55:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] libxfs: contiguous buffers are not discontigous
Date: Thu, 20 Feb 2014 16:55:21 +1100
Message-Id: <1392875722-4390-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1392875722-4390-1-git-send-email-david@fromorbit.com>
References: <1392875722-4390-1-git-send-email-david@fromorbit.com>
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

When discontiguous directory buffer support was fixed in xfs_repair,
(dd9093d xfs_repair: fix discontiguous directory block support)
it changed to using libxfs_getbuf_map() to support mapping
discontiguous blocks, and the prefetch code special cased such
discontiguous buffers.

The issue is that libxfs_getbuf_map() marks all buffers, even
contiguous ones - as LIBXFS_B_DISCONTIG, and so the prefetch code
was treating every buffer as discontiguous. This causes the prefetch
code to completely bypass the large IO optimisations for dense areas
of metadata. Because there was no obvious change in performance or
IO patterns, this wasn't noticed during performance testing.

However, this change mysteriously fixed a regression in xfs/033 in
the v3.2.0-alpha release, and this change in behaviour was
discovered as part of triaging why it "fixed" the regression.
Anyway, restoring the large IO prefetch optimisation results
a reapiron a 10 million inode filesystem dropping from 197s to 173s,
and the peak IOPS rate in phase 3 dropping from 25,000 to roughly
2,000 by trading off a bandwidth increase of roughly 100% (i.e.
200MB/s to 400MB/s). Phase 4 saw similar changes in IO profile and
speed increases.

This, however, re-introduces the regression in xfs/033, which will
now be fixed in a separate patch.

Reported-by: Eric Sandeen <esandeen@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/rdwr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index ac7739f..78a9b37 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -590,6 +590,10 @@ libxfs_getbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map,
 	struct xfs_bufkey key = {0};
 	int i;
 
+	if (nmaps == 1)
+		return libxfs_getbuf_flags(btp, map[0].bm_bn, map[0].bm_len,
+					   flags);
+
 	key.buftarg = btp;
 	key.blkno = map[0].bm_bn;
 	for (i = 0; i < nmaps; i++) {
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
