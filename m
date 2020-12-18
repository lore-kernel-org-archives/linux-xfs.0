Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EAF4C3526B
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:27:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5110923A82
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:27:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732952AbgLRH0x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Dec 2020 02:26:53 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37728 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732956AbgLRH0x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Dec 2020 02:26:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7KOWo003170
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=Dg2xhcSa8tPr7z9EVSEGJFj6h0oRIxwpJP9tJIRcO0o=;
 b=c6lEeZKulJabCs9XyAittypXevR4yqjJFz1A6Mp0e8LgP+8DUuS51C1SWwSHVWkgGGNp
 OBORySLg0J1OMIHQzqZ7KbrSA9jixnB9y8c8MM1q6ZKp9RN2aBlmrSj8OLq43IX4GKad
 W0Cr1G1cd5dipt6olOEYiGSIAWWLYfT8+NtQd5X9BwyeU/FkO7jgyQYtCqaS68OV4tko
 mmr8dC9kmDslwx6HQbUy7AzITzMYABWgb2EwpPZBqSDIH/Hqb+n1IxPZ2hc76BFigVCq
 Npl8EUV5rW/9/mEOetGvfP4pJjmpTND7wZljxPum5P5RfHiHAyYn6piUnsV96z+/F/jK GQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 35cn9rs188-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7LLYI044529
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 35d7erys85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:11 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BI7QA8m019453
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:10 GMT
Received: from localhost.localdomain (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Dec 2020 23:26:09 -0800
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v14 12/14] xfsprogs: Add delayed attributes error tag
Date:   Fri, 18 Dec 2020 00:25:53 -0700
Message-Id: <20201218072555.16694-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201218072555.16694-1-allison.henderson@oracle.com>
References: <20201218072555.16694-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180052
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Collins <allison.henderson@oracle.com>

This patch adds an error tag that we can use to test delayed attribute
recovery and replay

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/inject.c           | 1 +
 libxfs/xfs_errortag.h | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/io/inject.c b/io/inject.c
index 352d27c..9124c41 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -55,6 +55,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_FORCE_SUMMARY_RECALC,	"bad_summary" },
 		{ XFS_ERRTAG_IUNLINK_FALLBACK,		"iunlink_fallback" },
 		{ XFS_ERRTAG_BUF_IOERROR,		"buf_ioerror" },
+		{ XFS_ERRTAG_DELAYED_ATTR,		"delayed_attr" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 53b305d..cb38cbf 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -56,7 +56,8 @@
 #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
 #define XFS_ERRTAG_IUNLINK_FALLBACK			34
 #define XFS_ERRTAG_BUF_IOERROR				35
-#define XFS_ERRTAG_MAX					36
+#define XFS_ERRTAG_DELAYED_ATTR				36
+#define XFS_ERRTAG_MAX					37
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -97,5 +98,6 @@
 #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
 #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
 #define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
+#define XFS_RANDOM_DELAYED_ATTR				1
 
 #endif /* __XFS_ERRORTAG_H_ */
-- 
2.7.4

