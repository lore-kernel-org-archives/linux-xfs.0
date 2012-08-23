Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N54Uoa135774 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:04:31 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	BAbMpKdkwb0hsB8W for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:05:16 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PbU-0003JB-NG
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:12 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PbK-0003i2-L7
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 080/102] xfs: Use preallocation for inodes with extsz hints
Date: Thu, 23 Aug 2012 15:02:38 +1000
Message-Id: <1345698180-13612-81-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index e4acb6b..33abd52 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -1223,7 +1223,7 @@ __xfs_get_blocks(
 	    (!nimaps ||
 	     (imap.br_startblock == HOLESTARTBLOCK ||
 	      imap.br_startblock == DELAYSTARTBLOCK))) {
-		if (direct) {
+		if (direct || xfs_get_extsz_hint(ip)) {
 			/*
 			 * Drop the ilock in preparation for starting the block
 			 * allocation transaction.  It will be retaken
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
