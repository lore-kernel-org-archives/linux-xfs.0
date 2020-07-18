Return-Path: <SRS0=IYU2=A5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 861A2C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jul 2020 04:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A03A207FB
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jul 2020 04:33:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TwXBaVUx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgGREdy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Jul 2020 00:33:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59266 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgGREdy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Jul 2020 00:33:54 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06I4T23Y055849
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=i3BGPdhNjPnIo8qd/+b85HFd/Ida22VjTcgVmCagA+w=;
 b=TwXBaVUxKWbscpjmIVaPRLHKyQJiJepq8nC5eduGTTsW0SxsYIUQ7+kuJ30vws0qsswR
 sQaqXCBuXNfh9yBgK9ul0mD9jaqTU8FCS/VDZr+hqgZegm/jB4RRiaU10JKLgBqnrFM8
 ia/cX7rCn5quZOm18FRPhbHzquRbpHwAb2zCEzmRQdKK1Fj8TvR7INO1yE4RhwXBzEOL
 1QD3px7f6nPiTeLm0e6asOL9rh+fSIoB0PlQFQtvQb5+svgZ+uZHmyuXJz4zIgHfNIVx
 cOeRZN9jJfIW9LoPoO5M6YFE7ZLsqCny9LlXAray5yy5Fuse+O0S7/SUL450vD7SxzbR Xw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 32brgr05ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06I4XnXA058276
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 32br1n3nf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:52 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06I4XpvQ003327
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:51 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Jul 2020 21:33:50 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v11 01/26] xfs: random buffer write failure errortag
Date:   Fri, 17 Jul 2020 21:33:17 -0700
Message-Id: <20200718043342.6432-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200718043342.6432-1-allison.henderson@oracle.com>
References: <20200718043342.6432-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 suspectscore=1 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007180030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=1 adultscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007180030
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

Source kernel commit: 7376d74547344598008d00419eae0caa5f50f4f0

Introduce an error tag to randomly fail async buffer writes. This is
primarily to facilitate testing of the XFS error configuration
mechanism.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 io/inject.c           | 1 +
 libxfs/xfs_errortag.h | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/io/inject.c b/io/inject.c
index 4191c84..352d27c 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -54,6 +54,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_FORCE_SCRUB_REPAIR,	"force_repair" },
 		{ XFS_ERRTAG_FORCE_SUMMARY_RECALC,	"bad_summary" },
 		{ XFS_ERRTAG_IUNLINK_FALLBACK,		"iunlink_fallback" },
+		{ XFS_ERRTAG_BUF_IOERROR,		"buf_ioerror" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 79e6c4f..2486dab 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -55,7 +55,8 @@
 #define XFS_ERRTAG_FORCE_SCRUB_REPAIR			32
 #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
 #define XFS_ERRTAG_IUNLINK_FALLBACK			34
-#define XFS_ERRTAG_MAX					35
+#define XFS_ERRTAG_BUF_IOERROR				35
+#define XFS_ERRTAG_MAX					36
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -95,5 +96,6 @@
 #define XFS_RANDOM_FORCE_SCRUB_REPAIR			1
 #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
 #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
+#define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
 
 #endif /* __XFS_ERRORTAG_H_ */
-- 
2.7.4

