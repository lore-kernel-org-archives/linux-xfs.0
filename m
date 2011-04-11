Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3BLjqjC113619 for <xfs@oss.sgi.com>; Mon, 11 Apr 2011 16:45:52 -0500
Subject: [PATCH] xfs_destroy_workqueues() should not be tagged with __exit
From: Alex Elder <aelder@sgi.com>
Date: Mon, 11 Apr 2011 16:48:19 -0500
Message-ID: <1302558499.2580.96.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: torvalds <torvalds@linux-foundation.org>
Cc: akpm <akpm@linux-foundation.org>, "Luck, Tony" <tony.luck@intel.com>, linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Linus, please apply the following patch, which fixes
a problem with ia64 builds that is present in the XFS
pull request I sent you this morning.  Thank you.

					-Alex

-------- Forwarded Message --------
From: Luck, Tony <tony.luck@intel.com>
To: xfs-masters@oss.sgi.com
Cc: hch@lst.de, dchinner@redhat.com, aelder@sgi.com
Subject: [PATCH] xfs_destroy_workqueues() should not be tagged with
__exit
Date: Mon, 11 Apr 2011 12:06:12 -0700

ia64 throws away .exit sections for the built-in CONFIG case, so routines
that are used in other circumstances should not be tagged as __exit.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>

---

Should be applied after (or merged into) Dave Chinner's patch
	xfs: convert the xfsaild threads to a workqueue
which appeared as commit 0bf6a5bd4b55b466964ead6fa566d8f346a828ee in
next-20110411

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 67d5b2c..b38e58d 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1741,7 +1741,7 @@ out:
 	return -ENOMEM;
 }
 
-STATIC void __exit
+STATIC void
 xfs_destroy_workqueues(void)
 {
 	destroy_workqueue(xfs_ail_wq);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
