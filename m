Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 55C6D7CA0
	for <xfs@oss.sgi.com>; Tue,  5 Apr 2016 01:06:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C9E75AC002
	for <xfs@oss.sgi.com>; Mon,  4 Apr 2016 23:06:33 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	7TJG3PDqGvMDs1MG for <xfs@oss.sgi.com>;
	Mon, 04 Apr 2016 23:06:31 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1anK7T-000151-Qi
	for xfs@oss.sgi.com; Tue, 05 Apr 2016 16:05:43 +1000
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1anK6z-0003aW-F3
	for xfs@oss.sgi.com; Tue, 05 Apr 2016 16:05:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/4] xfs: Don't wrap growfs AGFL indexes
Date: Tue,  5 Apr 2016 16:05:07 +1000
Message-Id: <1459836310-12619-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1459836310-12619-1-git-send-email-david@fromorbit.com>
References: <1459836310-12619-1-git-send-email-david@fromorbit.com>
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

Commit 96f859d ("libxfs: pack the agfl header structure so
XFS_AGFL_SIZE is correct") allowed the freelist to use the empty
slot at the end of the freelist on 64 bit systems that was not
being used due to sizeof() rounding up the structure size.

This has caused versions of xfs_repair prior to 4.5.0 (which also
has the fix) to report this as a corruption once the filesystem has
been grown. Older kernels can also have problems (seen from a whacky
container/vm management environment) mounting filesystems grown on a
system with a newer kernel than the vm/container it is deployed on.

To avoid this problem, change the initial free list indexes not to
wrap across the end of the AGFL, hence avoiding the initialisation
of agf_fllast to the last index in the AGFL.

cc: <stable@vger.kernel.org> # 4.4-4.5
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_fsops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index ee3aaa0a..ca0d3eb 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -243,8 +243,8 @@ xfs_growfs_data_private(
 		agf->agf_roots[XFS_BTNUM_CNTi] = cpu_to_be32(XFS_CNT_BLOCK(mp));
 		agf->agf_levels[XFS_BTNUM_BNOi] = cpu_to_be32(1);
 		agf->agf_levels[XFS_BTNUM_CNTi] = cpu_to_be32(1);
-		agf->agf_flfirst = 0;
-		agf->agf_fllast = cpu_to_be32(XFS_AGFL_SIZE(mp) - 1);
+		agf->agf_flfirst = cpu_to_be32(1);
+		agf->agf_fllast = 0;
 		agf->agf_flcount = 0;
 		tmpsize = agsize - XFS_PREALLOC_BLOCKS(mp);
 		agf->agf_freeblks = cpu_to_be32(tmpsize);
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
