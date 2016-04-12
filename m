Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DEB127CA4
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 15:48:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 60A5EAC006
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 13:48:11 -0700 (PDT)
Received: from g1t5425.austin.hp.com (g1t5425.austin.hp.com [15.216.225.55])
	by cuda.sgi.com with ESMTP id joAgQZfhE2B3LFQ1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2016 13:48:10 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v2 3/5] xfs: call dax_get_unmapped_area() for DAX pmd mappings
Date: Tue, 12 Apr 2016 14:39:30 -0600
Message-Id: <1460493572-31667-2-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1460493572-31667-1-git-send-email-toshi.kani@hpe.com>
References: <1460493572-31667-1-git-send-email-toshi.kani@hpe.com>
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
To: akpm@linux-foundation.org, dan.j.williams@intel.com
Cc: Toshi Kani <toshi.kani@hpe.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>

To support DAX pmd mappings with unmodified applications,
filesystems need to align an mmap address by the pmd size.

Call dax_get_unmapped_area() from f_op->get_unmapped_area.

Note, there is no change in behavior for a non-DAX file.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: <xfs@oss.sgi.com>
---
 fs/xfs/xfs_file.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 569938a..51c554b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1708,6 +1708,9 @@ const struct file_operations xfs_file_operations = {
 	.open		= xfs_file_open,
 	.release	= xfs_file_release,
 	.fsync		= xfs_file_fsync,
+#ifdef CONFIG_FS_DAX
+	.get_unmapped_area = dax_get_unmapped_area,
+#endif
 	.fallocate	= xfs_file_fallocate,
 };
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
