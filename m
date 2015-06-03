Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BBDD37FAF
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 01:05:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9D16B8F8089
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 23:05:15 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	GIhzDOU3ZoeiBSVd for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 23:05:12 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Z01nQ-0001Dn-RH
	for xfs@oss.sgi.com; Wed, 03 Jun 2015 16:05:00 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Z01nQ-0002w9-QA
	for xfs@oss.sgi.com; Wed, 03 Jun 2015 16:05:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 19/20] xfs: disable XFS_IOC_SWAPEXT when rmap btree is enabled
Date: Wed,  3 Jun 2015 16:04:56 +1000
Message-Id: <1433311497-10245-20-git-send-email-david@fromorbit.com>
In-Reply-To: <1433311497-10245-1-git-send-email-david@fromorbit.com>
References: <1433311497-10245-1-git-send-email-david@fromorbit.com>
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

Swapping extents between two inodes requires the owner to be updated
in the rmap tree for all the extents that are swapped. This code
does not yet exist, so switch off the XFS_IOC_SWAPEXT ioctl until
support has been implemented. This will nee dto be done before the
rmap btree code can have the experimental tag removed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 5ed272b..b080cea 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1696,6 +1696,19 @@ xfs_swap_extents(
 	__uint64_t	tmp;
 	int		lock_flags;
 
+	/*
+	 * We can't swap extents on rmap btree enabled filesystems yet
+	 * as there is no mechanism to update the owner of extents in
+	 * the rmap tree yet. Hence, for the moment, just reject attempts
+	 * to swap extents with EINVAL after emitting a warning once to remind
+	 * us this needs fixing.
+	 */
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		WARN_ONCE(1,
+	"XFS: XFS_IOC_SWAPEXT not supported on RMAP enabled filesystems\n");
+		return -EINVAL;
+	}
+
 	tempifp = kmem_alloc(sizeof(xfs_ifork_t), KM_MAYFAIL);
 	if (!tempifp) {
 		error = -ENOMEM;
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
