Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 371E07CA2
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 17:31:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EE33E304059
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 15:31:43 -0700 (PDT)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24]) by
	cuda.sgi.com with ESMTP id QV0RQ62BC2FmQFDu for
	<xfs@oss.sgi.com>; Thu, 14 Jul 2016 15:30:43 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/2] dax: some small updates to dax.txt documentation
Date: Thu, 14 Jul 2016 15:40:48 -0600
Message-Id: <20160714214049.20075-1-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, xfs@oss.sgi.com, linux-nvdimm@lists.01.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>

These are originally from Matthew Wilcox and were part of his huge
"mm,fs,dax: Change ->pmd_fault to ->huge_fault" patch that was part of PUD
support.

I'm breaking these small changes out as they stand on their own and add
useful information to Documentation/filesystems/dax.txt.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 Documentation/filesystems/dax.txt | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/dax.txt b/Documentation/filesystems/dax.txt
index ce4587d..0c16a22 100644
--- a/Documentation/filesystems/dax.txt
+++ b/Documentation/filesystems/dax.txt
@@ -49,6 +49,7 @@ These block devices may be used for inspiration:
 - axonram: Axon DDR2 device driver
 - brd: RAM backed block device driver
 - dcssblk: s390 dcss block device driver
+- pmem: NVDIMM persistent memory driver
 
 
 Implementation Tips for Filesystem Writers
@@ -75,8 +76,9 @@ calls to get_block() (for example by a page-fault racing with a read()
 or a write()) work correctly.
 
 These filesystems may be used for inspiration:
-- ext2: the second extended filesystem, see Documentation/filesystems/ext2.txt
-- ext4: the fourth extended filesystem, see Documentation/filesystems/ext4.txt
+- ext2: see Documentation/filesystems/ext2.txt
+- ext4: see Documentation/filesystems/ext4.txt
+- xfs:  see Documentation/filesystems/xfs.txt
 
 
 Handling Media Errors
-- 
2.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
