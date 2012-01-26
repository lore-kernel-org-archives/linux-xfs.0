Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0QJlvs7014739 for <xfs@oss.sgi.com>; Thu, 26 Jan 2012 13:47:57 -0600
From: bpm@sgi.com
Subject: [PATCH] xfs: fix endian conversion issue in discard code
Date: Thu, 26 Jan 2012 13:47:42 -0600
Message-Id: <1327607262-3500-2-git-send-email-bpm@sgi.com>
In-Reply-To: <1327607262-3500-1-git-send-email-bpm@sgi.com>
References: <1327607262-3500-1-git-send-email-bpm@sgi.com>
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
To: stable@vger.kernel.org, xfs@oss.sgi.com, bpm@sgi.com
Cc: Dave Chinner <dchinner@redhat.com>

From: Dave Chinner <dchinner@redhat.com>

commit b1c770c273a4787069306fc82aab245e9ac72e9d upstream

When finding the longest extent in an AG, we read the value directly
out of the AGF buffer without endian conversion. This will give an
incorrect length, resulting in FITRIM operations potentially not
trimming everything that it should.

Note, for 3.0-stable this has been modified to apply to
fs/xfs/linux-2.6/xfs_discard.c instead of fs/xfs/xfs_discard.c.  -bpm

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_discard.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_discard.c b/fs/xfs/linux-2.6/xfs_discard.c
index 244e797..572494f 100644
--- a/fs/xfs/linux-2.6/xfs_discard.c
+++ b/fs/xfs/linux-2.6/xfs_discard.c
@@ -68,7 +68,7 @@ xfs_trim_extents(
 	 * Look up the longest btree in the AGF and start with it.
 	 */
 	error = xfs_alloc_lookup_le(cur, 0,
-				    XFS_BUF_TO_AGF(agbp)->agf_longest, &i);
+			    be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_longest), &i);
 	if (error)
 		goto out_del_cursor;
 
@@ -84,7 +84,7 @@ xfs_trim_extents(
 		if (error)
 			goto out_del_cursor;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, out_del_cursor);
-		ASSERT(flen <= XFS_BUF_TO_AGF(agbp)->agf_longest);
+		ASSERT(flen <= be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_longest));
 
 		/*
 		 * Too small?  Give up.
-- 
1.7.8.rc4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
