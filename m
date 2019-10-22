Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D93DCA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:46:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BCDB21872
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:46:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GncmmzCj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731806AbfJVSq5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:46:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48812 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731007AbfJVSq5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:46:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiVUA091164;
        Tue, 22 Oct 2019 18:46:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=vsT6G618SuzF9cSf6PK44JKA2R3k4lG5jK72FL3svXg=;
 b=GncmmzCj6ZogjtopTv13kPKbdw5yp4ig3TcgxxFqlxlVPeC6HZB+21RvJPcBs/G3CBWi
 zOhRcFUFe8yc4NzBB9JLKaZVozTatcch2MZpje47+SCKD4XQd4XIOMgg8KTepfrd6KJj
 xKC6OG/Vmhu6x7AYYImam6GlYxaHPm37TubILpYVjfKmJjvobBerAwWO6dtzlmgXXaNC
 tQ33fxZ0wogL8hdyBcEQEW0Y/FihjQZcK/TzXe6jcPG25ErnmajTXlnjT3gP0p7bSf13
 vPYW0uvkLJsUhPPG+AZvruM/U9letz573mQCRAo3ShjVAcO37Oj/XNjuR+inllG84Mom /w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vqteprqsk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:46:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiOvL064426;
        Tue, 22 Oct 2019 18:46:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vt2hdk9h2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:46:54 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MIkp4L002120;
        Tue, 22 Oct 2019 18:46:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:46:51 -0700
Subject: [PATCH 3/5] xfs_scrub: report repair activities on stdout,
 not stderr
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:46:50 -0700
Message-ID: <157177001031.1458930.10794386697707805480.stgit@magnolia>
In-Reply-To: <157176999124.1458930.5678023201951458107.stgit@magnolia>
References: <157176999124.1458930.5678023201951458107.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=985
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

Reduce the severity of reports about successful metadata repairs.  We
fixed the problem, so there's no action necessary on the part of the
system admin.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/common.c |    2 +-
 scrub/common.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/scrub/common.c b/scrub/common.c
index b41f443d..7632a8d8 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -48,7 +48,7 @@ static struct {
 } err_levels[] = {
 	[S_ERROR]  = { .string = "Error",	.loglevel = LOG_ERR },
 	[S_WARN]   = { .string = "Warning",	.loglevel = LOG_WARNING },
-	[S_REPAIR] = { .string = "Repaired",	.loglevel = LOG_WARNING },
+	[S_REPAIR] = { .string = "Repaired",	.loglevel = LOG_INFO },
 	[S_INFO]   = { .string = "Info",	.loglevel = LOG_INFO },
 	[S_PREEN]  = { .string = "Optimized",	.loglevel = LOG_INFO }
 };
diff --git a/scrub/common.h b/scrub/common.h
index 9a37e9ed..ef4cf439 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -18,8 +18,8 @@ bool xfs_scrub_excessive_errors(struct scrub_ctx *ctx);
 enum error_level {
 	S_ERROR	= 0,
 	S_WARN,
-	S_REPAIR,
 	S_INFO,
+	S_REPAIR,
 	S_PREEN,
 };
 

