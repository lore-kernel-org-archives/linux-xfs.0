Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4F7BCA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A603E20B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:47:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fH9umGsc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730186AbfJVSru (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:47:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47880 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731007AbfJVSru (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:47:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiA7e089122;
        Tue, 22 Oct 2019 18:47:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=GtgFqJzdnU9vhBUZWBkj/2E00CDwW8EvRNGQIYw/h0k=;
 b=fH9umGscKIKdmAssHO0cxA1BJ3QxrL2cM605fBptzmc9Ac7mcVsdNVq/qIVTpHxV8aNg
 hXXJTPH5LhwjKhA0gJ/5pmLuChcZZzu0g1iwORAFGpzT2VpTqGQW6CJweo/w2WSQ71l2
 LV6/QbTS6wcQavQA4TcqUhbvlnCl/ZkbQ/5CfLuhc1TP/Ua+p5p3JAncqgA21BdCnY19
 KmSgc2bRdx4iC4KqTv87V5dxRNVnY7ov3XAz/2wE8+JDYc/1s1oaqrm4gdMMqFED8/jG
 eCGbMxGIamMBphXb/9Va4KhRyvJc8iNfq16X0Z48w/oH0QhnCzbg+rhM9sjUf2kqZePg hA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2vqu4qrjxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:47:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiL0D070448;
        Tue, 22 Oct 2019 18:47:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2vsx2rkef0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:47:37 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MIlbJE025092;
        Tue, 22 Oct 2019 18:47:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:47:36 -0700
Subject: [PATCH 5/9] xfs_scrub: improve reporting of file metadata media
 errors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Date:   Tue, 22 Oct 2019 11:47:35 -0700
Message-ID: <157177005577.1459098.10061603172997741735.stgit@magnolia>
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

Report media errors that map to data and attr fork extent maps.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 scrub/phase6.c |   11 +++++++++++
 1 file changed, 11 insertions(+)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index 1c4a2107..3125bfd5 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -385,6 +385,17 @@ xfs_check_rmap_error_report(
 		str_error(ctx, buf, _("media error in %s."), type);
 	}
 
+	/* Report extent maps */
+	if (map->fmr_flags & FMR_OF_EXTENT_MAP) {
+		bool		attr = (map->fmr_flags & FMR_OF_ATTR_FORK);
+
+		scrub_render_ino_descr(ctx, buf, DESCR_BUFSZ,
+				map->fmr_owner, 0, " %s",
+				attr ? _("extended attribute") :
+				       _("file data"));
+		str_error(ctx, buf, _("media error in extent map"));
+	}
+
 	/*
 	 * XXX: If we had a getparent() call we could report IO errors
 	 * efficiently.  Until then, we'll have to scan the dir tree

