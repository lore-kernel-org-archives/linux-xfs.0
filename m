Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 431177CA4
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:27:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AACFAAC005
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:27:12 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id PHCX28l9Ca57iOTA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:27:10 -0700 (PDT)
Subject: [PATCH 1/7] journaling_log: fix some typos in the section about EFDs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:27:02 -0700
Message-ID: <147216762268.32447.4258135326050076262.stgit@birch.djwong.org>
In-Reply-To: <147216761636.32447.4229640006064129056.stgit@birch.djwong.org>
References: <147216761636.32447.4229640006064129056.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../journaling_log.asciidoc                        |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/design/XFS_Filesystem_Structure/journaling_log.asciidoc b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
index a67fcc2..67d209f 100644
--- a/design/XFS_Filesystem_Structure/journaling_log.asciidoc
+++ b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
@@ -368,7 +368,7 @@ typedef struct xfs_efd_log_format {
 ----
 
 *efd_type*::
-The signature of an EFI operation, 0x1236.  This value is in host-endian order,
+The signature of an EFD operation, 0x1237.  This value is in host-endian order,
 not big-endian like the rest of XFS.
 
 *efd_size*::
@@ -382,9 +382,9 @@ A 64-bit number that binds the corresponding EFI log item to this EFD log item.
 
 *efd_extents*::
 Variable-length array of extents to be freed.  The array length is given by
-+efi_nextents+.  The record type will be either +xfs_extent_64_t+ or
++efd_nextents+.  The record type will be either +xfs_extent_64_t+ or
 +xfs_extent_32_t+; this can be determined from the log item size (+oh_len+) and
-the number of extents (+efi_nextents+).
+the number of extents (+efd_nextents+).
 
 [[Inode_Log_Item]]
 === Inode Updates

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
