Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5730C3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:38:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D12022DBF
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:38:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Rv9aDbOZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbfIDEiy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:38:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54454 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfIDEiy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:38:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844cZBb028248;
        Wed, 4 Sep 2019 04:38:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=U63Ekk9FpCH/JshdMyTLiKtNBqdA0R0tiq6QmhxALaQ=;
 b=Rv9aDbOZoKkuO7TSLiv64KHkp0B6V1iK8uEvtgLEVu8w9xs1XwRpUIifmKIYYzY5mnJ/
 EGc/W+AhSDaiBA8upSxdEDhKMp0GTZq2F3JRcm3a3jXtc/CItG3jubysbknWQI2TVqqO
 7YEsgyT2FeYQdCamQQSVeSX97VGSA5fl9QFTJn7I5cSbinAOjsOnbrkzbJQCJtbqDbjn
 ZuznARFqJE05Hmc8XJHIraGqO12Gf+1cM0buLn7TcEBzv5VHhEOU99M2KHILkDzaL4s/
 7xoGlGghpw9A+dWdnSH+wJVTd1cB41qSNil0GQZ7PfC0BRvdo5WPdjy/py0GEhEsdtO6 Kw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ut6ds0045-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:38:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844cbBD035878;
        Wed, 4 Sep 2019 04:38:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2usu51c5qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:38:41 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x844cUPx024555;
        Wed, 4 Sep 2019 04:38:30 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:38:30 -0700
Subject: [PATCH 2/4] xfs_spaceman: remove unnecessary test in openfile()
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Date:   Tue, 03 Sep 2019 21:38:29 -0700
Message-ID: <156757190895.1838733.13934156048427058850.stgit@magnolia>
In-Reply-To: <156757189636.1838733.8025635445292375382.stgit@magnolia>
References: <156757189636.1838733.8025635445292375382.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909040048
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909040047
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs_spaceman always records fs_path information for an open file because
spaceman requires running on XFS and it always passes a non-null fs_path
to openfile.  Therefore, openfile doesn't need the fs_path null check.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 spaceman/file.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)


diff --git a/spaceman/file.c b/spaceman/file.c
index 5647ca7d..29b7d9ce 100644
--- a/spaceman/file.c
+++ b/spaceman/file.c
@@ -71,16 +71,15 @@ _("%s: Not on a mounted XFS filesystem.\n"),
 		return -1;
 	}
 
-	if (fs_path) {
-		fsp = fs_table_lookup(path, FS_MOUNT_POINT);
-		if (!fsp) {
-			fprintf(stderr, _("%s: cannot find mount point."),
-				path);
-			close(fd);
-			return -1;
-		}
-		memcpy(fs_path, fsp, sizeof(struct fs_path));
+	fsp = fs_table_lookup(path, FS_MOUNT_POINT);
+	if (!fsp) {
+		fprintf(stderr, _("%s: cannot find mount point."),
+			path);
+		close(fd);
+		return -1;
 	}
+	memcpy(fs_path, fsp, sizeof(struct fs_path));
+
 	return fd;
 }
 

