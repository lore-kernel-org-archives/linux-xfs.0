Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8A62C7CF5
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:29:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0B009AC002
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:29:47 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id JMHPBd935JaEAM0p (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:29:46 -0700 (PDT)
Subject: [PATCH 13/13] xfs/122: check the ag reservation counter ioctl
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:29:43 -0700
Message-ID: <147216778333.32641.6694229942234239492.stgit@birch.djwong.org>
In-Reply-To: <147216769914.32641.55434969009554013.stgit@birch.djwong.org>
References: <147216769914.32641.55434969009554013.stgit@birch.djwong.org>
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
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122.out |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index cd909e6..ae84283 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -81,6 +81,7 @@ sizeof(struct xfs_dsymlink_hdr) = 56
 sizeof(struct xfs_extent_data) = 24
 sizeof(struct xfs_extent_data_info) = 32
 sizeof(struct xfs_fs_eofblocks) = 128
+sizeof(struct xfs_fsop_ag_resblks) = 32
 sizeof(struct xfs_icreate_log) = 28
 sizeof(struct xfs_log_dinode) = 176
 sizeof(struct xfs_map_extent) = 32

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
