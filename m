Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EEE7C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:31:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB11D2063A
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:31:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yPLeu53o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgEIQbm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 12:31:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50154 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727953AbgEIQbm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:31:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GMgTp072385;
        Sat, 9 May 2020 16:31:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=0Qtg7UjJxFWWTPtNUYmwhjV+9UYKWURXZ/RAYms1+QE=;
 b=yPLeu53owU+KaXgaa1jomSo8ymnaf9f+VAdGc6tnCqZ9Vw/KcqQ3G4sgeq7gjR21sCjv
 6MOFULoeD1SaExmy6W/QmaDsqLJSoTfBEkkCeo21AFV2COjk2yANGsafxtxw2BRiVTGU
 pXAlDmbtB2RPNh6jnFKdBDwe//1PoGCqtzXOa8PpG3AOJqcleAu7IyfCFa4hdbQhmEg+
 cuedMuuOQ8TjBf9CJKK7hbmviAU0QTjBx1sE8rP6nhiOsqnHNN+QAP050TMi1DbkgbCg
 OhONeEX2ErKYHdN37YJ+rbxC4z8lHgz4jzwV7iPo3BPNgfVQscuSrIOOOvEO/iwvXLAH Zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30wkxqs6g6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:31:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GTuGp112434;
        Sat, 9 May 2020 16:31:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30wx11cvnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:31:39 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 049GVcHX005052;
        Sat, 9 May 2020 16:31:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 09:31:38 -0700
Subject: [PATCH 16/16] xfs_repair: complain about any nonzero inprogress
 value, not just 1
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sat, 09 May 2020 09:31:38 -0700
Message-ID: <158904189872.982941.14116905127710550275.stgit@magnolia>
In-Reply-To: <158904179213.982941.9666913277909349291.stgit@magnolia>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 suspectscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Complain about the primary superblock having any non-zero sb_inprogress
value, not just 1.  This brings repair's behavior into alignment with
xfs_check and the kernel.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/sb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/repair/sb.c b/repair/sb.c
index 91a36dd3..17ce43cc 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -369,8 +369,7 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 		return(XR_BAD_VERSION);
 
 	/* does sb think mkfs really finished ? */
-
-	if (is_primary_sb && sb->sb_inprogress == 1)
+	if (is_primary_sb && sb->sb_inprogress)
 		return(XR_BAD_INPROGRESS);
 
 	/*

