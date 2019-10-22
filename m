Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A743CA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DC6B20B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:47:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LEKFsYWW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732517AbfJVSrf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:47:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49656 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731007AbfJVSre (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:47:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiQNB091102;
        Tue, 22 Oct 2019 18:47:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=gBPBxWojgsELHAL1PtFFV8snxwUf3kD1CdC9FG51/+U=;
 b=LEKFsYWWMP23Y/uMTux7GpJIFGKy3LQ54PlWjyUFQEe98CUOxb4Jj9pTgiL9+eycpA7B
 T6nuBOrm/z0tMAGYBAcfTpmdZKB4N5Ap90l330Bhufz04Boe5ZKazydx6HlEzQ2Y8fBk
 RBHGi5o1rmKuNQ1P5e+cm23T8JDOUTz+L3Mw4KjaMtTrDvlNDSwtvKIEEmXa85xQgrWR
 I01HixFnNP+SBS3b6rOoKHqiIieKqLzQ1teidOt32qJJAeuVIDIrUWyLsPtwoFD58e+d
 plfF9CaIcHW49tWe7AXeSgL72Fq1DSeM2NIeK0mhoZM80ZOBsrcG9wVV2YHvzF8tkI6V bQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2vqteprqxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:47:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhN7S125161;
        Tue, 22 Oct 2019 18:47:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vsx239pbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:47:31 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9MIlUol029344;
        Tue, 22 Oct 2019 18:47:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:47:30 -0700
Subject: [PATCH 4/9] xfs_scrub: better reporting of metadata media errors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:47:29 -0700
Message-ID: <157177004966.1459098.7876853401067821445.stgit@magnolia>
In-Reply-To: <157177002473.1459098.11320398367215468164.stgit@magnolia>
References: <157177002473.1459098.11320398367215468164.stgit@magnolia>
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

When we report bad metadata, we inexplicably report the physical address
in units of sectors, whereas for file data we report file offsets in
units of bytes.  Fix the metadata reporting units to match the file data
units (i.e. bytes) and skip the printf for all other cases.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/xfs_scrub.8 |    4 ++++
 scrub/phase6.c       |   12 +++++-------
 2 files changed, 9 insertions(+), 7 deletions(-)


diff --git a/man/man8/xfs_scrub.8 b/man/man8/xfs_scrub.8
index 18948a4e..e881ae76 100644
--- a/man/man8/xfs_scrub.8
+++ b/man/man8/xfs_scrub.8
@@ -101,6 +101,10 @@ Read all file data extents to look for disk errors.
 will issue O_DIRECT reads to the block device directly.
 If the block device is a SCSI disk, it will instead issue READ VERIFY commands
 directly to the disk.
+If media errors are found, the error report will include the disk offset, in
+bytes.
+If the media errors affect a file, the report will also include the inode
+number and file offset, in bytes.
 These actions will confirm that all file data blocks can be read from storage.
 .SH OPTIMIZATIONS
 Optimizations supported by this program include, but are not limited to:
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 5aeef1cb..1c4a2107 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -368,7 +368,7 @@ xfs_check_rmap_error_report(
 	void			*arg)
 {
 	const char		*type;
-	char			buf[32];
+	char			buf[DESCR_BUFSZ];
 	uint64_t		err_physical = *(uint64_t *)arg;
 	uint64_t		err_off;
 
@@ -377,14 +377,12 @@ xfs_check_rmap_error_report(
 	else
 		err_off = 0;
 
-	snprintf(buf, 32, _("disk offset %"PRIu64),
-			(uint64_t)BTOBB(map->fmr_physical + err_off));
-
+	/* Report special owners */
 	if (map->fmr_flags & FMR_OF_SPECIAL_OWNER) {
+		snprintf(buf, DESCR_BUFSZ, _("disk offset %"PRIu64),
+				(uint64_t)map->fmr_physical + err_off);
 		type = xfs_decode_special_owner(map->fmr_owner);
-		str_error(ctx, buf,
-_("%s failed read verification."),
-				type);
+		str_error(ctx, buf, _("media error in %s."), type);
 	}
 
 	/*

