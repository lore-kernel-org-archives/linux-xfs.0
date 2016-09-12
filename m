Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 212F27CA1
	for <xfs@oss.sgi.com>; Mon, 12 Sep 2016 07:46:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E5D6A30404E
	for <xfs@oss.sgi.com>; Mon, 12 Sep 2016 05:46:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rl00IVWUPnHWr1Za (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 12 Sep 2016 05:46:07 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_repair: exit with status 2 if log dirtiness is unknown
Message-ID: <4c59d0b7-bf53-ca58-1bcf-b95d1c9c44dc@redhat.com>
Date: Mon, 12 Sep 2016 07:46:05 -0500
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
To: xfs-oss <xfs@oss.sgi.com>, linux-xfs@vger.kernel.org

This new case is mostly like the known dirty log case; the log
is corrupt, dirtiness cannot be determined, and a mount/umount
cycle or an xfs_repair -L is required.

So exit with status 2 here as well.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/phase2.c b/repair/phase2.c
index e21ffa6..5964244 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -79,10 +79,11 @@ zero_log(
 		_("zero_log: cannot find log head/tail (xlog_find_tail=%d)\n"),
 			error);
 		if (!no_modify && !zap_log)
-			do_error(_(
+			do_warn(_(
 "ERROR: The log head and/or tail cannot be discovered. Attempt to mount the\n"
 "filesystem to replay the log or use the -L option to destroy the log and\n"
 "attempt a repair.\n"));
+			exit(2);
 	} else {
 		if (verbose) {
 			do_warn(

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
