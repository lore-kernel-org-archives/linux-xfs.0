Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 675F9C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:35:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E00320809
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:35:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HFtLRP/z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407110AbgJZXfw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:35:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37466 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407107AbgJZXfw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:35:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPunu158448;
        Mon, 26 Oct 2020 23:35:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Rl//5LkZj4CZq8MLMo//Fp+MMP6Gy30JtK81YYwNn30=;
 b=HFtLRP/zOgwfqICrzOPXSs4LwYPx+Cign6wmLwZJ0ZqjKJlolR36v3xzynoTgGkuFWAF
 wbtYavhSS7rFKspr6wBTUX+4T0hZxNAd41L7dMZO1de6KEKmIJjzitdvn58AQasXegUn
 UpAgO43oO/czYNfLjiMnXqYtdBCjI7MFw2MbcqzFYj7DyrmdWh6lQ8ctyhU7arqHwwk7
 Hr+TIUSc0re+jMZ32bCzD8rN+Tydv8omdvsRksSYCd6WfhhM/0tP/oThlqCkb1xyyy+U
 nd4z3/zPTBMrUzAgZb/0tTpzdw06u5GlU7jMx2mzbbTp7wWmo6HYZ+dDPJ1zgsYk98EK Pg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34cc7kq8mv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:35:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQEfG032501;
        Mon, 26 Oct 2020 23:35:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34cx1q2c3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:35:46 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNZjEE006094;
        Mon, 26 Oct 2020 23:35:45 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:35:45 -0700
Subject: [PATCH 15/26] xfs: redefine xfs_ictimestamp_t
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, Gao Xiang <hsiangkao@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:35:44 -0700
Message-ID: <160375534433.881414.13405550882427665693.stgit@magnolia>
In-Reply-To: <160375524618.881414.16347303401529121282.stgit@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: 30e05599219f3c15bd5f24190af0e33cdb4a00e5

Redefine xfs_ictimestamp_t as a uint64_t typedef in preparation for the
bigtime functionality.  Preserve the legacy structure format so that we
can let the compiler take care of the masking and shifting.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_log_format.h |    7 +++++--
 logprint/log_misc.c     |   19 +++++++++++++++----
 2 files changed, 20 insertions(+), 6 deletions(-)


diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index e3400c9c71cd..8bd00da6d2a4 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -368,10 +368,13 @@ static inline int xfs_ilog_fdata(int w)
  * directly mirrors the xfs_dinode structure as it must contain all the same
  * information.
  */
-typedef struct xfs_ictimestamp {
+typedef uint64_t xfs_ictimestamp_t;
+
+/* Legacy timestamp encoding format. */
+struct xfs_legacy_ictimestamp {
 	int32_t		t_sec;		/* timestamp seconds */
 	int32_t		t_nsec;		/* timestamp nanoseconds */
-} xfs_ictimestamp_t;
+};
 
 /*
  * Define the format of the inode core that is logged. This structure must be
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index a747cbd360af..47976cdf328a 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -435,6 +435,16 @@ xlog_print_trans_qoff(char **ptr, uint len)
     }
 }	/* xlog_print_trans_qoff */
 
+static inline time64_t
+xlog_extract_dinode_ts(
+	const xfs_ictimestamp_t		its)
+{
+	struct xfs_legacy_ictimestamp	*lits;
+
+	lits = (struct xfs_legacy_ictimestamp *)&its;
+	return (time64_t)lits->t_sec;
+}
+
 void
 xlog_print_dinode_ts(
 	struct xfs_log_dinode	*ldip,
@@ -443,12 +453,13 @@ xlog_print_dinode_ts(
 	const char		*fmt;
 
 	if (compact)
-		fmt = _("atime 0x%x mtime 0x%x ctime 0x%x\n");
+		fmt = _("atime 0x%llx mtime 0x%llx ctime 0x%llx\n");
 	else
-		fmt = _("		atime:%d  mtime:%d  ctime:%d\n");
+		fmt = _("		atime:%lld  mtime:%lld  ctime:%lld\n");
 
-	printf(fmt, ldip->di_atime.t_sec, ldip->di_mtime.t_sec,
-			ldip->di_ctime.t_sec);
+	printf(fmt, xlog_extract_dinode_ts(ldip->di_atime),
+		    xlog_extract_dinode_ts(ldip->di_mtime),
+		    xlog_extract_dinode_ts(ldip->di_ctime));
 }
 
 static void

