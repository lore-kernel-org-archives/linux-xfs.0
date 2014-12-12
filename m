Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 695AB7F3F
	for <xfs@oss.sgi.com>; Fri, 12 Dec 2014 16:37:02 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E7662AC001
	for <xfs@oss.sgi.com>; Fri, 12 Dec 2014 14:36:58 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id atm8LHSNZ0x2w7Cz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 12 Dec 2014 14:36:57 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sBCMauFD032651
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Fri, 12 Dec 2014 17:36:56 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sBCMatWB007600
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 12 Dec 2014 17:36:56 -0500
Message-ID: <548B6E07.8080302@redhat.com>
Date: Fri, 12 Dec 2014 16:36:55 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: remove extra newlines from xfs messages
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
To: xfs-oss <xfs@oss.sgi.com>

xfs_warn() and friends add a newline by default, but some
messages add another one.  

Particularly for the failing write message below, this can
waste a lot of console real estate!

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 3f9bd58..925ead2 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -535,7 +535,7 @@ xfs_buf_item_push(
 	if ((bp->b_flags & XBF_WRITE_FAIL) &&
 	    ___ratelimit(&xfs_buf_write_fail_rl_state, "XFS:")) {
 		xfs_warn(bp->b_target->bt_mount,
-"Detected failing async write on buffer block 0x%llx. Retrying async write.\n",
+"Detected failing async write on buffer block 0x%llx. Retrying async write.",
 			 (long long)bp->b_bn);
 	}
 
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index e408bf5..dc846ce 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2027,7 +2027,7 @@ xlog_print_tic_res(
 		"  total reg   = %u bytes (o/flow = %u bytes)\n"
 		"  ophdrs      = %u (ophdr space = %u bytes)\n"
 		"  ophdr + reg = %u bytes\n"
-		"  num regions = %u\n",
+		"  num regions = %u",
 		((ticket->t_trans_type <= 0 ||
 		  ticket->t_trans_type > XFS_TRANS_TYPE_MAX) ?
 		  "bad-trans-type" : trans_type_str[ticket->t_trans_type-1]),
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 19cbda1..22e6aca 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -685,7 +685,7 @@ xfs_blkdev_get(
 				    mp);
 	if (IS_ERR(*bdevp)) {
 		error = PTR_ERR(*bdevp);
-		xfs_warn(mp, "Invalid device [%s], error=%d\n", name, error);
+		xfs_warn(mp, "Invalid device [%s], error=%d", name, error);
 	}
 
 	return error;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
