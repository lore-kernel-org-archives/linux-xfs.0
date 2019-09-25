Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D195FC432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:36:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A23AE21D81
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:36:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J+JTKJOl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbfIYVgh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:36:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45202 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfIYVgh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:36:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYO9t009867;
        Wed, 25 Sep 2019 21:36:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=rzTlZzfpq3322fRMTaFPFb0G9ApAMzqkOoXZnyxTmds=;
 b=J+JTKJOlFctKcvL6BhwMu37liZltQn4gcM0CtMLRjfbPW5iJQyu/ChjVOtdq9cA+3b+/
 9s+vMzGopRgdb6GCUFPcFABwKHLtQa5Mbhx/Bl8fcrS6V6DHNTrdi8MXvCyMCx8dFJ/P
 SmtxaVAdtzAVUcKQ5ibJXpY42zfI6szmtdC9fx/NAqTV5eTx0h9e0GBXtBgCWhjJi2b1
 daXGYEiHXIIooTwTEoWH7fheHiY46oOwuyQjCbmG+4cIhEaRKjhFRhHMLsBLLzM40HjD
 QZheflQFVLzNQEXuaVEGZYc7gwDVfvDNmDuZUiCYFWNitDNXo53sUfA00CdJduuS4ZSB 8A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2v5btq7hw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:36:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYTEN078949;
        Wed, 25 Sep 2019 21:36:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2v82tkrjpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:36:34 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLaX6G015516;
        Wed, 25 Sep 2019 21:36:33 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:36:33 -0700
Subject: [PATCH 04/11] xfs_scrub: improve reporting of file metadata media
 errors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:36:32 -0700
Message-ID: <156944739208.300131.5955900694911585741.stgit@magnolia>
In-Reply-To: <156944736739.300131.5717633994765951730.stgit@magnolia>
References: <156944736739.300131.5717633994765951730.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Report media errors that map to data and attr fork extent maps.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase6.c |   11 +++++++++++
 1 file changed, 11 insertions(+)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index 310ab36c..1013ba6d 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -385,6 +385,17 @@ xfs_check_rmap_error_report(
 		str_error(ctx, buf, _("media error in %s."), type);
 	}
 
+	/* Report extent maps */
+	if (map->fmr_flags & FMR_OF_EXTENT_MAP) {
+		bool		attr = (map->fmr_flags & FMR_OF_ATTR_FORK);
+
+		scrub_render_ino_suffix(ctx, buf, DESCR_BUFSZ,
+				map->fmr_owner, 0, " %s",
+				attr ? _("extended attribute") :
+				       _("file data"));
+		str_error(ctx, buf, _("media error in extent map"));
+	}
+
 	/*
 	 * XXX: If we had a getparent() call we could report IO errors
 	 * efficiently.  Until then, we'll have to scan the dir tree

