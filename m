Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F0BFC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 708AE206BB
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:43:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UYlT4yOK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392174AbfIFDnB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:43:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56604 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388694AbfIFDnA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:43:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863dGK7113013;
        Fri, 6 Sep 2019 03:42:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Di6CP+d4LzEeEJQ5r/vRlPPRUuvAUntCoseynlrwjiE=;
 b=UYlT4yOKY2W4GCCsB3A4WZxHz3aiQKXkcCxeYMxqHaPdA0b2LnmKEAWsTd8OFCzjPb1j
 v6h6e8OBCvW0ss214M1pWIlsDNATLonD3a06723rhFuAHxF6KEe0pffSqVR6HJJYJjSr
 cHpccVaMdJvGl5ulx4ZC5d0WD++xZVVBHQOjH2TgBpYmqM5h9F+9RaC0rtlP8O2Urqql
 G/dR2OnFoae1kuC26nlx002r41U3jwvGuTtdh0WQvUbZjDbNbuNlkRKxgH+jV0nTU9MN
 aJHJ2Uly99qaoqI75odYVlJX7wiiyd8txicoMfBZrlbhbhi5iNvxdQ7+oJPwoytTRfY8 MA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2uufr080g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:42:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863cmVI001867;
        Fri, 6 Sep 2019 03:40:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2utpmc77un-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:40:47 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x863ekKi017016;
        Fri, 6 Sep 2019 03:40:46 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:40:46 -0700
Subject: [PATCH 2/3] xfs_scrub: perform media scans of entire devices
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:40:45 -0700
Message-ID: <156774124577.2646704.15341474642686239741.stgit@magnolia>
In-Reply-To: <156774123336.2646704.1827381294403838403.stgit@magnolia>
References: <156774123336.2646704.1827381294403838403.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060040
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a new feature to xfs_scrub where specifying multiple -x will cause
it to perform a media scan of the entire disk, not just the file data
areas.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/xfs_scrub.8 |    3 +++
 scrub/phase6.c       |   60 ++++++++++++++++++++++++++++++++++++++++++++++----
 scrub/phase7.c       |    5 ++++
 scrub/xfs_scrub.c    |    4 ++-
 scrub/xfs_scrub.h    |    1 +
 5 files changed, 66 insertions(+), 7 deletions(-)


diff --git a/man/man8/xfs_scrub.8 b/man/man8/xfs_scrub.8
index 18948a4e..872a088c 100644
--- a/man/man8/xfs_scrub.8
+++ b/man/man8/xfs_scrub.8
@@ -97,6 +97,9 @@ Prints the version number and exits.
 .TP
 .B \-x
 Read all file data extents to look for disk errors.
+If this option is given more than once, scrub all disk contents.
+If this option is given more than twice, report errors even if they have not
+yet caused data loss.
 .B xfs_scrub
 will issue O_DIRECT reads to the block device directly.
 If the block device is a SCSI disk, it will instead issue READ VERIFY commands
diff --git a/scrub/phase6.c b/scrub/phase6.c
index c50fb8fb..7bfb856a 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -167,7 +167,9 @@ report_data_loss(
 	int				ret;
 
 	/* Only report errors for real extents. */
-	if (bmap->bm_flags & (BMV_OF_PREALLOC | BMV_OF_DELALLOC))
+	if (scrub_data < 3 && (bmap->bm_flags & BMV_OF_PREALLOC))
+		return true;
+	if (bmap->bm_flags & BMV_OF_DELALLOC)
 		return true;
 
 	if (fsx->fsx_xflags & FS_XFLAG_REALTIME)
@@ -355,7 +357,7 @@ ioerr_fsmap_report(
 	uint64_t		err_off;
 
 	/* Don't care about unwritten extents. */
-	if (map->fmr_flags & FMR_OF_PREALLOC)
+	if (scrub_data < 3 && (map->fmr_flags & FMR_OF_PREALLOC))
 		return true;
 
 	if (err_physical > map->fmr_physical)
@@ -602,6 +604,49 @@ clean_pool(
 	return ret;
 }
 
+/* Schedule an entire disk for read verification. */
+static int
+verify_entire_disk(
+	struct read_verify_pool		*rvp,
+	struct disk			*disk,
+	struct media_verify_state	*vs)
+{
+	return read_verify_schedule_io(rvp, 0, disk->d_size, vs);
+}
+
+/* Scan every part of every disk. */
+static bool
+verify_all_disks(
+	struct scrub_ctx		*ctx,
+	struct media_verify_state	*vs)
+{
+	int				ret;
+
+	ret = verify_entire_disk(vs->rvp_data, ctx->datadev, vs);
+	if (ret) {
+		str_liberror(ctx, ret, _("scheduling datadev verify"));
+		return false;
+	}
+
+	if (ctx->logdev) {
+		ret = verify_entire_disk(vs->rvp_log, ctx->logdev, vs);
+		if (ret) {
+			str_liberror(ctx, ret, _("scheduling logdev verify"));
+			return false;
+		}
+	}
+
+	if (ctx->rtdev) {
+		ret = verify_entire_disk(vs->rvp_realtime, ctx->rtdev, vs);
+		if (ret) {
+			str_liberror(ctx, ret, _("scheduling rtdev verify"));
+			return false;
+		}
+	}
+
+	return true;
+}
+
 /*
  * Read verify all the file data blocks in a filesystem.  Since XFS doesn't
  * do data checksums, we trust that the underlying storage will pass back
@@ -657,7 +702,11 @@ xfs_scan_blocks(
 			goto out_logpool;
 		}
 	}
-	moveon = xfs_scan_all_spacemaps(ctx, xfs_check_rmap, &vs);
+
+	if (scrub_data > 1)
+		moveon = verify_all_disks(ctx, &vs);
+	else
+		moveon = xfs_scan_all_spacemaps(ctx, xfs_check_rmap, &vs);
 	if (!moveon)
 		goto out_rtpool;
 
@@ -729,8 +778,9 @@ xfs_estimate_verify_work(
 	if (!moveon)
 		return moveon;
 
-	*items = cvt_off_fsb_to_b(&ctx->mnt,
-			(d_blocks - d_bfree) + (r_blocks - r_bfree));
+	*items = cvt_off_fsb_to_b(&ctx->mnt, d_blocks + r_blocks);
+	if (scrub_data == 1)
+		*items -= cvt_off_fsb_to_b(&ctx->mnt, d_bfree + r_bfree);
 	*nr_threads = disk_heads(ctx->datadev);
 	*rshift = 20;
 	return moveon;
diff --git a/scrub/phase7.c b/scrub/phase7.c
index bc959f5b..570ceb3f 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -255,6 +255,11 @@ _("%.*f%s inodes counted; %.*f%s inodes checked.\n"),
 		double		b1, b2;
 		char		*b1u, *b2u;
 
+		if (scrub_data > 1) {
+			used_data = cvt_off_fsb_to_b(&ctx->mnt, d_blocks);
+			used_rt = cvt_off_fsb_to_b(&ctx->mnt, r_blocks);
+		}
+
 		b1 = auto_space_units(used_data + used_rt, &b1u);
 		b2 = auto_space_units(ctx->bytes_checked, &b2u);
 		fprintf(stdout,
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 2d554340..46876522 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -139,7 +139,7 @@ unsigned int			force_nr_threads;
 bool				verbose;
 
 /* Should we scrub the data blocks? */
-static bool			scrub_data;
+int				scrub_data;
 
 /* Size of a memory page. */
 long				page_size;
@@ -666,7 +666,7 @@ main(
 			fflush(stdout);
 			return SCRUB_RET_SUCCESS;
 		case 'x':
-			scrub_data = true;
+			scrub_data++;
 			break;
 		case '?':
 			/* fall through */
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 54876acb..6558bad7 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -21,6 +21,7 @@ extern bool			want_fstrim;
 extern bool			stderr_isatty;
 extern bool			stdout_isatty;
 extern bool			is_service;
+extern int			scrub_data;
 
 enum scrub_mode {
 	SCRUB_MODE_DRY_RUN,

