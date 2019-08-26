Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD74FC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:20:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D9FC20850
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:20:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Wd1LsaLR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbfHZVUi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:20:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41622 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbfHZVUi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:20:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLDm4u188899;
        Mon, 26 Aug 2019 21:20:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=S938/f7oyuQoZK5M1wR606Roa95XTkfyG7XdW8yYkvY=;
 b=Wd1LsaLRH9NvbR1pgx6FcDqeKzcJ2ua7vGJu5jKsfpOH8Dams+O2divFh7fUVBuU6coz
 uZK6FeaJbT6Al7rd6zmvWUG2/0U6kBffrsRow9GUwhwypPpgTIgV5AKX8ecdwiz/9Wa2
 CjAfpFp8jgULuRB6+4zBtjuLW4LNkw8kBFe8F3uzP45AbrzbnmqLbrjM3iZ8NJHBD+9F
 whwykjOTRMmV0tuEK1jZjDs9week8x6m/WFdVGwe1aru7WEbi49gRGHVWBYv+HPMXPpg
 G86R0FoT52+tiWeXULUe+porDM3Ci+X3DPQbxOgWfGNuWJ60ZFuEPEKJu4yOqIN57/5W fg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2ujwvqc4ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:20:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLITR3025214;
        Mon, 26 Aug 2019 21:20:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2umj1tjvuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:20:34 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QLKXr6029872;
        Mon, 26 Aug 2019 21:20:33 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:20:33 -0700
Subject: [PATCH 2/4] xfs_spaceman: remove unnecessary test in openfile()
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:20:32 -0700
Message-ID: <156685443266.2839773.7040997802535169869.stgit@magnolia>
In-Reply-To: <156685442011.2839773.2684103942714886186.stgit@magnolia>
References: <156685442011.2839773.2684103942714886186.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=993
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs_spaceman always records fs_path information for an open file because
spaceman requires running on XFS and it always passes a non-null fs_path
to openfile.  Therefore, openfile doesn't need the fs_path null check.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 spaceman/file.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)


diff --git a/spaceman/file.c b/spaceman/file.c
index 1264bdae..5665da7d 100644
--- a/spaceman/file.c
+++ b/spaceman/file.c
@@ -68,16 +68,15 @@ _("%s: Not on a mounted XFS filesystem.\n"),
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
 

