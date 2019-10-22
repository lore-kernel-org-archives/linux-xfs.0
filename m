Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64AE4CA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:48:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 355E720B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:48:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KyBohv8y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732436AbfJVSs3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:48:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50838 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729696AbfJVSs3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:48:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiPhj091085;
        Tue, 22 Oct 2019 18:48:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=XjBTGtH7HhP8Px6M6CMjaigpS5S0b3mD+VjOI9Kpbl4=;
 b=KyBohv8yCCanghmFdW+mte0M/gbwkOTO6Yu0FayQ9/pL8I0sYVa3eFCc6VdhkvkgZx7P
 D3VdRFoHRTWQrVk3oDL5q/3MRmO23b3XHuVywOsJulMnoUuGb1VTdFBAV5UVg4Ju9DX/
 uchwHbE+reimFGupckmXQyDHL5stlgIzJxZLoaTNTE3Y9PVzwdERjadWvjiv8l84OsMv
 v1VvQTSa7Ksln0gQ0HI8qt02P7ahc6LEQKe4li6eNkFk7+SslDwqru3Im9HBX0J0WYDc
 CVYx8/aBS644+472k8hLPes1XWizdYQkWO9oEA2xnG62I3YFLdwzLS65poQrsmX787yN Ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vqteprr51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:48:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiONG064374;
        Tue, 22 Oct 2019 18:48:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vt2hdkdrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:48:27 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9MImQ1m029796;
        Tue, 22 Oct 2019 18:48:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 18:48:26 +0000
Subject: [PATCH 3/4] libxfs: remove libxfs_physmem
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:48:23 -0700
Message-ID: <157177010343.1460186.15100646078363671205.stgit@magnolia>
In-Reply-To: <157177008495.1460186.12329293699422541895.stgit@magnolia>
References: <157177008495.1460186.12329293699422541895.stgit@magnolia>
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

Remove this thin wrapper too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/libxfs.h    |    3 ---
 libxfs/init.c       |    6 ------
 repair/xfs_repair.c |    2 +-
 3 files changed, 1 insertion(+), 10 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index 405572ee..0cc0820b 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -160,9 +160,6 @@ extern void cmn_err(int, char *, ...);
 enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 #endif
 
-
-extern unsigned long	libxfs_physmem(void);	/* in kilobytes */
-
 #include "xfs_ialloc.h"
 
 #include "xfs_attr_leaf.h"
diff --git a/libxfs/init.c b/libxfs/init.c
index 9e762435..537b73bd 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -852,9 +852,3 @@ libxfs_report(FILE *fp)
 	c = asctime(localtime(&t));
 	fprintf(fp, "%s", c);
 }
-
-unsigned long
-libxfs_physmem(void)
-{
-	return platform_physmem();
-}
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 7e810ef4..df65b6c5 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -852,7 +852,7 @@ main(int argc, char **argv)
 					(mp->m_sb.sb_dblocks >> (10 + 1)) +
 					50000;	/* rough estimate of 50MB overhead */
 		max_mem = max_mem_specified ? max_mem_specified * 1024 :
-						libxfs_physmem() * 3 / 4;
+					      platform_physmem() * 3 / 4;
 
 		if (getrlimit(RLIMIT_AS, &rlim) != -1 &&
 					rlim.rlim_cur != RLIM_INFINITY) {

