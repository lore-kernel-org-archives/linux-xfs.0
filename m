Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 551E229E09
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 23:58:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B8C0AAC006
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 21:58:23 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 04WIN8UyhCGTZNVL (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 21:58:22 -0700 (PDT)
Subject: [PATCH 29/58] xfs: disable XFS_IOC_SWAPEXT when rmap btree is enabled
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 21:58:19 -0700
Message-ID: <20151007045819.30457.61857.stgit@birch.djwong.org>
In-Reply-To: <20151007045443.30457.47038.stgit@birch.djwong.org>
References: <20151007045443.30457.47038.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

>From : Dave Chinner <dchinner@redhat.com>

Swapping extents between two inodes requires the owner to be updated
in the rmap tree for all the extents that are swapped. This code
does not yet exist, so switch off the XFS_IOC_SWAPEXT ioctl until
support has been implemented. This will nee dto be done before the
rmap btree code can have the experimental tag removed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_util.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 8b2e505..f41a6f7 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1685,6 +1685,19 @@ xfs_swap_extents(
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
