Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3NegVa067667 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:42 -0600
Message-Id: <20121203144310.655641267@sgi.com>
Date: Mon, 03 Dec 2012 17:42:28 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 20/36] xfs: Use preallocation for inodes with extsz
	hints
References: <20121203144208.143464631@sgi.com>
Content-Disposition: inline; filename=080
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
To: stable@vger.kernel.org
Cc: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Upstream commit: aff3a9edb7080f69f07fe76a8bd089b3dfa4cb5d

xfstest 229 exposes a problem with buffered IO, delayed allocation
and extent size hints. That is when we do delayed allocation during
buffered IO, we reserve space for the extent size hint alignment and
allocate the physical space to align the extent, but we do not zero
the regions of the extent that aren't written by the write(2)
syscall. The result is that we expose stale data in unwritten
regions of the extent size hints.

There are two ways to fix this. The first is to detect that we are
doing unaligned writes, check if there is already a mapping or data
over the extent size hint range, and if not zero the page cache
first before then doing the real write. This can be very expensive
for large extent size hints, especially if the subsequent writes
fill then entire extent size before the data is written to disk.

The second, and simpler way, is simply to turn off delayed
allocation when the extent size hint is set and use preallocation
instead. This results in unwritten extents being laid down on disk
and so only the written portions will be converted. This matches the
behaviour for direct IO, and will also work for the real time
device. The disadvantage of this approach is that for small extent
size hints we can get file fragmentation, but in general extent size
hints are fairly large (e.g. stripe width sized) so this isn't a big
deal.

Implement the second approach as it is simple and effective.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_aops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -1187,7 +1187,7 @@ __xfs_get_blocks(
 	    (!nimaps ||
 	     (imap.br_startblock == HOLESTARTBLOCK ||
 	      imap.br_startblock == DELAYSTARTBLOCK))) {
-		if (direct) {
+		if (direct || xfs_get_extsz_hint(ip)) {
 			/*
 			 * Drop the ilock in preparation for starting the block
 			 * allocation transaction.  It will be retaken


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
