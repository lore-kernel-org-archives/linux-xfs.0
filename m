Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C252ACA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DD6A21872
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:52:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cwD3eVqy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732517AbfJVSwR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:52:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52858 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731740AbfJVSwR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:52:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiAPZ089120;
        Tue, 22 Oct 2019 18:52:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Z8TVZeMAVGY75YHLdDoxrp+YLINPGGwek0VYumRpYf4=;
 b=cwD3eVqyMjKZC6E9OLALkmAYPT4/YhDLzZWMtHUrRvUK7qHyiejLvQSWIvPKQ8siA+d+
 cTXWkrefvyRWkL6hyEEeDjHyxXaUuFYMs3ttTkBZL05/RHs5SE24DqfEkQYqNSvXfPOB
 vM2fWmAvo8Sxw5JEWSMbF123acjEOtdCkVCS5GBzUO8J3tEL4PMWYWbOCEdtf8zh3Hox
 X6+M3v+GC/MA4NL51b+y2o/kf0TX/2DEfaZrr5IBoNykB6+TROeXhw9bUUC97XfgFhDQ
 ds1Fou4b9/CroEIRboXlCtrI2ZA4iKSGWXhVGAw+BUVY7vYIGOFdEkOJRWQLZwYHDBA6 sQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2vqu4qrkt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:52:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhov5148310;
        Tue, 22 Oct 2019 18:50:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vsp4010rs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:50:14 +0000
Received: from abhmp0021.oracle.com (abhmp0021.oracle.com [141.146.116.27])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MIoE2Y027286;
        Tue, 22 Oct 2019 18:50:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 18:50:11 +0000
Subject: [PATCH 2/3] xfs_scrub: perform media scans of entire devices
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Date:   Tue, 22 Oct 2019 11:50:10 -0700
Message-ID: <157177021069.1460684.13385243350591362467.stgit@magnolia>
In-Reply-To: <157177019803.1460684.3524666107607426492.stgit@magnolia>
References: <157177019803.1460684.3524666107607426492.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a new feature to xfs_scrub where specifying multiple -x will cause
it to perform a media scan of the entire disk, not just the file data
areas.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 man/man8/xfs_scrub.8 |    3 +++
 scrub/phase6.c       |   60 ++++++++++++++++++++++++++++++++++++++++++++++----
 scrub/phase7.c       |    5 ++++
 scrub/xfs_scrub.c    |    4 ++-
 scrub/xfs_scrub.h    |    1 +
 5 files changed, 66 insertions(+), 7 deletions(-)


diff --git a/man/man8/xfs_scrub.8 b/man/man8/xfs_scrub.8
index e881ae76..2cdec380 100644
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
index aae6b7d8..9ddddef1 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -188,7 +188,9 @@ report_data_loss(
 	int				ret;
 
 	/* Only report errors for real extents. */
-	if (bmap->bm_flags & (BMV_OF_PREALLOC | BMV_OF_DELALLOC))
+	if (scrub_data < 3 && (bmap->bm_flags & BMV_OF_PREALLOC))
+		return true;
+	if (bmap->bm_flags & BMV_OF_DELALLOC)
 		return true;
 
 	if (fsx->fsx_xflags & FS_XFLAG_REALTIME)
@@ -376,7 +378,7 @@ report_ioerr_fsmap(
 	uint64_t		err_off;
 
 	/* Don't care about unwritten extents. */
-	if (map->fmr_flags & FMR_OF_PREALLOC)
+	if (scrub_data < 3 && (map->fmr_flags & FMR_OF_PREALLOC))
 		return true;
 
 	if (err_physical > map->fmr_physical)
@@ -603,6 +605,49 @@ remember_ioerr(
 		str_liberror(ctx, ret, _("setting bad block bitmap"));
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
@@ -658,7 +703,11 @@ xfs_scan_blocks(
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
 
@@ -730,8 +779,9 @@ xfs_estimate_verify_work(
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
index 9945c7f4..b2e58108 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -139,7 +139,7 @@ unsigned int			force_nr_threads;
 bool				verbose;
 
 /* Should we scrub the data blocks? */
-static bool			scrub_data;
+int				scrub_data;
 
 /* Size of a memory page. */
 long				page_size;
@@ -668,7 +668,7 @@ main(
 			fflush(stdout);
 			return SCRUB_RET_SUCCESS;
 		case 'x':
-			scrub_data = true;
+			scrub_data++;
 			break;
 		case '?':
 			/* fall through */
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 61831c92..ed0e63b8 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -21,6 +21,7 @@ extern bool			want_fstrim;
 extern bool			stderr_isatty;
 extern bool			stdout_isatty;
 extern bool			is_service;
+extern int			scrub_data;
 
 enum scrub_mode {
 	SCRUB_MODE_DRY_RUN,

