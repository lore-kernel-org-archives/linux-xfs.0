Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2CB6D7F37
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 13:20:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0D895304062
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 11:20:02 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id q7YTKtwPKsGnBfIV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 15 Oct 2015 11:20:01 -0700 (PDT)
Date: Thu, 15 Oct 2015 21:19:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] xfs: fix an error code in xfs_fs_fill_super()
Message-ID: <20151015181951.GD3163@mwanda>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Dave Chinner <david@fromorbit.com>, Bill O'Donnell <billodo@redhat.com>
Cc: kernel-janitors@vger.kernel.org, xfs@oss.sgi.com

If alloc_percpu() fails, we accidentally return PTR_ERR(NULL), which
means success, but we intended to return -ENOMEM.

Fixes: 225e4635580c ('xfs: per-filesystem stats in sysfs')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 368c55a..b2c252c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1477,7 +1477,7 @@ xfs_fs_fill_super(
 	/* Allocate stats memory before we do operations that might use it */
 	mp->m_stats.xs_stats = alloc_percpu(struct xfsstats);
 	if (!mp->m_stats.xs_stats) {
-		error = PTR_ERR(mp->m_stats.xs_stats);
+		error = -ENOMEM;
 		goto out_destroy_counters;
 	}
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
