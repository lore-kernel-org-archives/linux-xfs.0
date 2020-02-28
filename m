Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E83CBC3F2D2
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9D092084E
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:36:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bbQCpSud"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgB1XgN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:36:13 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40238 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgB1XgN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 18:36:13 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNY78m029179;
        Fri, 28 Feb 2020 23:36:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=i4bb170AANAWX5QMeDNj0vNpYMKM9RVBruTeMIFEBrw=;
 b=bbQCpSudXqmDC7L2XDD4NcTEjp9uHcuWYeVrUQkjSsuJQmBbHxIsM+HVe0omcRReaUxT
 lAy0bi+thQ74ybxCR6uIlI5eehIVO9znMTDBj25EEaRmllSGS16uFyIQ5sVZ0wUma7gj
 A905E0en2ZZ/77s0Si+I0+sQxM/i5FfbvPd/up8KpWzCe9zbOku45j4EpyWZJ4mS6k5F
 wC1/i8z657CjCklbC+C9weejiY+IhNZxXZ/lRy+af53kuStgEm05f9398ipUv3z37o+m
 SOZWwpyUgWni458bHuRRnvSQnwxl1YEZEg+kEeN7VdppRkmJzGxNb6PLmkk4LM7SootI 3g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2ydct3nt0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:36:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNWmt4097748;
        Fri, 28 Feb 2020 23:36:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2ydcsgefy4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:36:07 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01SNa7QX012329;
        Fri, 28 Feb 2020 23:36:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 15:36:06 -0800
Subject: [PATCH 6/7] xfs_repair: check that metadata updates have been
 committed
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>
Date:   Fri, 28 Feb 2020 15:36:05 -0800
Message-ID: <158293296528.1548526.15883438061985494121.stgit@magnolia>
In-Reply-To: <158293292760.1548526.16432706349096704475.stgit@magnolia>
References: <158293292760.1548526.16432706349096704475.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure that any metadata that we repaired or regenerated has been
written to disk.  If that fails, exit with 1 to signal that there are
still errors in the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 repair/xfs_repair.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)


diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 2c15125f..6b463534 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -703,6 +703,7 @@ main(int argc, char **argv)
 	struct xfs_sb	psb;
 	int		rval;
 	struct xfs_ino_geometry	*igeo;
+	int		error;
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -1104,7 +1105,13 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
 	 */
 	libxfs_bcache_flush();
 	format_log_max_lsn(mp);
-	libxfs_umount(mp);
+
+	/* Report failure if anything failed to get written to our fs. */
+	error = -libxfs_umount(mp);
+	if (error)
+		do_error(
+	_("File system metadata writeout failed, err=%d.  Re-run xfs_repair."),
+				error);
 
 	libxfs_destroy(&x);
 

