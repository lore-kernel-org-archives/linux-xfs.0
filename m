Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A71D27F4E
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 05:12:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 87DF18F8068
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 03:12:55 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Fuysgd7q9eCqpPl5 for <xfs@oss.sgi.com>;
	Fri, 21 Mar 2014 03:12:53 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] xfs: don't map ranges that span EOF for direct IO
Date: Fri, 21 Mar 2014 21:11:50 +1100
Message-Id: <1395396710-3824-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1395396710-3824-1-git-send-email-david@fromorbit.com>
References: <1395396710-3824-1-git-send-email-david@fromorbit.com>
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
Cc: Viro@disappointment.disaster, viro@ZenIV.linux.org.uk, Al@disappointment.disaster

From: Dave Chinner <dchinner@redhat.com>

Al Viro tracked down the problem that has caused generic/263 to fail
on XFS since the test was introduced. If is caused by
xfs_get_blocks() mapping a single extent that spans EOF without
marking it as buffer-new() so that the direct Io code does not zero
the tail of the block at the new EOF. This is a long standing bug
that has been around for many, many years.

Because xfs_get_blocks() starts the map before EOF, it can't set
buffer_new(), because that causes he direct Io code to also zero
unaligned sectors at the head of the IO. This would overwrite valid
data with zeros, and hence we cannot validly return a single extent
that spans EOF to direct IO.

Fix this by detecting a mapping that spans EOF and truncate it down
to EOF. This results in the the direct IO code doing the right thing
for unaligned data blocks before EOF, and then returning to get
another mapping for the region beyond EOF which XFS treats correctly
by setting buffer_new() on it. This makes direct Io behave correctly
w.r.t. tail block zeroing beyond EOF, and fsx is happy about that.

Again, thanks to Al Viro for finding what I couldn't.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 8bbd8ba..d5702f0 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1344,6 +1344,14 @@ __xfs_get_blocks(
 	/*
 	 * If this is O_DIRECT or the mpage code calling tell them how large
 	 * the mapping is, so that we can avoid repeated get_blocks calls.
+	 *
+	 * If the mapping spans EOF, then we have to break the mapping up as the
+	 * mapping for blocks beyond EOF must be marked new so that sub block
+	 * regions can be correctly zeroed. We can't do this for mappings within
+	 * EOF unless the mapping was just allocated or is unwritten, otherwise
+	 * the callers would overwrite existing data with zeros. Hence we have
+	 * to split the mapping into a range up to and including EOF, and a
+	 * second mapping for beyond EOF.
 	 */
 	if (direct || size > (1 << inode->i_blkbits)) {
 		xfs_off_t		mapping_size;
@@ -1354,6 +1362,12 @@ __xfs_get_blocks(
 		ASSERT(mapping_size > 0);
 		if (mapping_size > size)
 			mapping_size = size;
+		if (offset < i_size_read(inode) &&
+		    offset + mapping_size >= i_size_read(inode)) {
+			/* limit mapping to block that spans EOF */
+			mapping_size = roundup(i_size_read(inode) - offset,
+					       1 << inode->i_blkbits);
+		}
 		if (mapping_size > LONG_MAX)
 			mapping_size = LONG_MAX;
 
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
