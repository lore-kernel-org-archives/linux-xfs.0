Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 948767CA3
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 18:47:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 698AC304039
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 16:47:20 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id erOgMHZSfOK8RvRX (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2016 16:47:18 -0700 (PDT)
Subject: [PATCH 09/17] common/dmerror: fix mount option issues
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 21 Jul 2016 16:47:13 -0700
Message-ID: <146914483353.11762.14647880235199676753.stgit@birch.djwong.org>
In-Reply-To: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
References: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Calling _mount doesn't work when we want to add mount options
such as realtime devices.  Since it's just a normal scratch device
mount except for the source device, just call _scratch_mount with
SCRATCH_DEV set to the dmerror device.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/dmerror |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)


diff --git a/common/dmerror b/common/dmerror
index 5ad9994..22b9ea9 100644
--- a/common/dmerror
+++ b/common/dmerror
@@ -41,14 +41,9 @@ _dmerror_init()
 	DMERROR_TABLE="0 $blk_dev_size error $dm_backing_dev 0"
 }
 
-_dmerror_mount_options()
-{
-	echo `_common_dev_mount_options $*` $DMERROR_DEV $SCRATCH_MNT
-}
-
 _dmerror_mount()
 {
-	_mount -t $FSTYP `_dmerror_mount_options $*`
+	SCRATCH_DEV=$DMERROR_DEV _scratch_mount $*
 }
 
 _dmerror_unmount()

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
