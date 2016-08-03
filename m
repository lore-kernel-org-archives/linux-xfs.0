Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 864D07CA1
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 17:50:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 49619304048
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 15:50:12 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 5rzvmc0YqAn01Qox (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2016 15:50:10 -0700 (PDT)
Date: Wed, 3 Aug 2016 15:50:04 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 09/17] common/dmerror: fix mount option issues
Message-ID: <20160803225004.GB25565@birch.djwong.org>
References: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
	<146914483353.11762.14647880235199676753.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146914483353.11762.14647880235199676753.stgit@birch.djwong.org>
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
To: david@fromorbit.com, eguan@redhat.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Calling _mount doesn't work when we want to add mount options
such as realtime devices.  Since it's just a normal scratch device
mount except for the source device, just call _scratch_mount with
SCRATCH_DEV set to the dmerror device.

v2: Use the standard _scratch_options for mounting.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/dmerror |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/common/dmerror b/common/dmerror
index 5ad9994..d05c4c8 100644
--- a/common/dmerror
+++ b/common/dmerror
@@ -41,14 +41,10 @@ _dmerror_init()
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
+	_scratch_options mount
+	$MOUNT_PROG -t $FSTYP `_common_dev_mount_options $*` $SCRATCH_OPTIONS \
 }
 
 _dmerror_unmount()

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
