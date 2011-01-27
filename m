Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0R3roLM184616 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 21:53:50 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 832482922D3
	for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 19:56:13 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	F5GHQo0UyDTnvknW for <xfs@oss.sgi.com>;
	Wed, 26 Jan 2011 19:56:13 -0800 (PST)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PiIxi-0008FL-37
	for xfs@oss.sgi.com; Thu, 27 Jan 2011 14:55:58 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PiIvF-0004TC-Gk
	for xfs@oss.sgi.com; Thu, 27 Jan 2011 14:53:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/8] xfs: prevent extsize alignment from exceeding maximum
	extent size
Date: Thu, 27 Jan 2011 14:53:18 +1100
Message-Id: <1296100401-17135-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1296100401-17135-1-git-send-email-david@fromorbit.com>
References: <1296100401-17135-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

When doing delayed allocation, if the allocation size is for a
maximally sized extent, extent size alignment can push it over this
limit. This results in an assert failure in xfs_bmbt_set_allf() as
the extent length is too large to find in the extent record.

Fix this by ensuring that we allow for space that extent size
alignment requires (up to 2 * (extsize -1) blocks as we have to
handle both head and tail alignment) when limiting the maximum size
of the extent.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/xfs_bmap.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index f3a3768..3e9c278 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -4487,6 +4487,16 @@ xfs_bmapi(
 				/* Figure out the extent size, adjust alen */
 				extsz = xfs_get_extsz_hint(ip);
 				if (extsz) {
+					/*
+					 * make sure we don't exceed a single
+					 * extent length when we align the
+					 * extent by reducing length we are
+					 * going to allocate by the maximum
+					 * amount extent size aligment may
+					 * require.
+					 */
+					alen = XFS_FILBLKS_MIN(len,
+						   MAXEXTLEN - (2 * extsz - 1));
 					error = xfs_bmap_extsize_align(mp,
 							&got, &prev, extsz,
 							rt, eof,
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
