Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 898AAC35DEE
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BA1420732
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:11:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l3Sv6KvH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgBYALK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:11:10 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:58408 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbgBYALJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:11:09 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P098G8130149;
        Tue, 25 Feb 2020 00:11:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=cMiXsKkMT0o0lCE7ZleAkrUcQNN4BiQR6xy+skVi++M=;
 b=l3Sv6KvHZN2Ct2HlWOSM9mlfGsQ9X5YVfCqSLNwFa6sypkXPu6WyMhd0y+D6jSzebkBH
 2EA3FIePrXbdQkqhYLJNW0RvQLnnTSqggO/reC7yC+r7M2zy16GkEFSMlqXvEVGj1zud
 HEloFRbTj0BK63z/LgPjcSWOjFNpYjh7wZksaBPjKJe93uOyehzEjgjwNri0SX6b3IV8
 5iYh/CJWQ0x5WA5PKFIHy9LYO4y4jB57Pezmh8iWvN03zmmkrAaEXdWJBU0jV6as0tYk
 /37Mk9tllyhyZDt+ZrGNDMc69zm1Z7+GWiAcBDHxNYM1Pa8N/bqpOKBOQQ4sCTf/S2Wz xA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yavxrjrn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:11:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P087Lv014316;
        Tue, 25 Feb 2020 00:11:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2ybdshxvtt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:11:07 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01P0B6Iu030169;
        Tue, 25 Feb 2020 00:11:06 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:11:06 -0800
Subject: [PATCH 6/7] xfs_repair: check that metadata updates have been
 committed
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 24 Feb 2020 16:11:05 -0800
Message-ID: <158258946575.451075.126426300036283442.stgit@magnolia>
In-Reply-To: <158258942838.451075.5401001111357771398.stgit@magnolia>
References: <158258942838.451075.5401001111357771398.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 suspectscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure that any metadata that we repaired or regenerated has been
written to disk.  If that fails, exit with 1 to signal that there are
still errors in the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/xfs_repair.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index eb1ce546..ccb13f4a 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -703,6 +703,7 @@ main(int argc, char **argv)
 	struct xfs_sb	psb;
 	int		rval;
 	struct xfs_ino_geometry	*igeo;
+	int		error;
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -1104,7 +1105,11 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
 	 */
 	libxfs_bcache_flush();
 	format_log_max_lsn(mp);
-	libxfs_umount(mp);
+
+	/* Report failure if anything failed to get written to our fs. */
+	error = -libxfs_umount(mp);
+	if (error)
+		exit(1);
 
 	if (x.rtdev)
 		libxfs_device_close(x.rtdev);

