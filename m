Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4549CC43140
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:39:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 421A5206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:39:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UN6TTvnu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392103AbfIFDjY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:39:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38392 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392104AbfIFDjY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:39:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863dM7n108644;
        Fri, 6 Sep 2019 03:39:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=rzTlZzfpq3322fRMTaFPFb0G9ApAMzqkOoXZnyxTmds=;
 b=UN6TTvnu6ogkSADaaZFRxj1vKD9EvIm60zPuHH5CN7HPkTe9iU17AHQ72BJeWP63/wb3
 dWdDsGgN2TSBbNs36w233aMauMAR0abAKaW1/DvfI0p7uBG0wJA8OMo+vUnEBNb0iao2
 0ofEjjcLAlJNwTZ/kBlWNToUOwoKIaKK7Xthi5ZHmHrMCocKCgbIQmLcqzSrttIzfsIt
 ESMkpQ0oKF3toej0sfH0VvK09IKGfZevyBA49pm6uHemEwTKUm27GYs8syIIyNAwpWw8
 6owaYoUJ/CCWXPJSKIFQeoa4tj9yadCTOly81ajjYIZcLH3U+imJbdj2ZQFi1lboO5ea Og== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2uuf5f839w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:39:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863dHKJ112774;
        Fri, 6 Sep 2019 03:39:21 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2uud7p2sma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:39:21 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x863dLcd006168;
        Fri, 6 Sep 2019 03:39:21 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:39:20 -0700
Subject: [PATCH 04/11] xfs_scrub: improve reporting of file metadata media
 errors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:39:20 -0700
Message-ID: <156774116044.2645432.13242297185306235262.stgit@magnolia>
In-Reply-To: <156774113533.2645432.14942831726168941966.stgit@magnolia>
References: <156774113533.2645432.14942831726168941966.stgit@magnolia>
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

