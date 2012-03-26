Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2QGh78W032702 for <xfs@oss.sgi.com>; Mon, 26 Mar 2012 11:43:07 -0500
From: "Luck, Tony" <tony.luck@intel.com>
Subject: [PATCH] Fix xfs build error on ia64 (mismatch section for
	xfs_qm_exit())
Date: Mon, 26 Mar 2012 09:43:06 -0700
Message-Id: <4f709c9a30285611d@agluck-desktop.sc.intel.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-masters@oss.sgi.com, Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, xfs@oss.sgi.com

ia64 deletes __exit section during the final link stage of vmlinux.
This means that code should not call __exit functions in modules
that can be built in to the kernel.

Building with CONFIG_DEBUG_SECTION_MISMATCH=y we see these build messages:

WARNING: vmlinux.o(.init.text+0x22462): Section mismatch in reference from the function init_xfs_fs() to the function .exit.text:xfs_qm_exit()
The function __init init_xfs_fs() references
a function __exit xfs_qm_exit().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __exit annotation of
xfs_qm_exit() so it may be used outside an exit section.

...

`xfs_qm_exit' referenced in section `.init.text' of fs/built-in.o: defined in discarded section `.exit.text' of fs/built-in.o
make: *** [.tmp_vmlinux1] Error 1

Introduced in commit a05931ceb0160deadbd7798d60d01b17f2d81b09
    xfs: remove the global xfs_Gqm structure

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 4be16a0..1155208 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1065,7 +1065,7 @@ out:
 	return -ENOMEM;
 }
 
-void __exit
+void
 xfs_qm_exit(void)
 {
 	kmem_zone_destroy(xfs_qm_dqtrxzone);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
