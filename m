Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3F2AC433E3
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 21:46:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1B9F206F4
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 21:46:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IdXF7U6m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgGNVqj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 17:46:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36814 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGNVqj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 17:46:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ELaud4091227;
        Tue, 14 Jul 2020 21:46:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=h8yLZZMrxAGjX3kep21CU6Q3X1VLT9D89StavPyRjPY=;
 b=IdXF7U6mM2vHmv/jxMNDoM7DdT4NeZ93ndF48FRLoada5U5S1Q8Wx1NrCQSHluWWDIM9
 UeubEF6DRf2Juft9DgcBYt8f/ubh9e2dTXF6xgyfPTkccSjfAcQotIXmLL/dFcqDJ2kh
 uG8+OT3qNCXLxlYi7pCdY2ErgLy70d0OlwrPmx0wxYAqWkOPOUTU57tE0yYGbaHMOSux
 Vd/8kqseTO6hDTMmeCtqMh/GOzXBtRhbsGh8Tsz+9ueBhvDnxLglHqNdqQLUy0SRaC3q
 t2NVmBScMF8JMzIaCVkaxU71Jlyy92ea/AsTHFSD4DpoMJRyyfsMZaI6xD1nIMAI92dJ cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32762nfv8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 21:46:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ELhcgF182951;
        Tue, 14 Jul 2020 21:46:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 327q6t48au-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 21:46:36 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06ELkakg025341;
        Tue, 14 Jul 2020 21:46:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 14:46:35 -0700
Subject: [PATCH 4/4] xfs_repair: skip mount time quotacheck if our quotacheck
 was ok
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 14 Jul 2020 14:46:34 -0700
Message-ID: <159476319479.3156699.12134117203484512536.stgit@magnolia>
In-Reply-To: <159476316511.3156699.17998319555266568403.stgit@magnolia>
References: <159476316511.3156699.17998319555266568403.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxlogscore=972 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=962 lowpriorityscore=0
 bulkscore=0 suspectscore=0 phishscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If we verified that the incore quota counts match the ondisk quota
contents, we can leave the CHKD flags set so that the next mount doesn't
have to repeat the quotacheck.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/quotacheck.c |   10 ++++++++++
 repair/quotacheck.h |    1 +
 repair/xfs_repair.c |    2 +-
 3 files changed, 12 insertions(+), 1 deletion(-)


diff --git a/repair/quotacheck.c b/repair/quotacheck.c
index 481a1289..0df1f2be 100644
--- a/repair/quotacheck.c
+++ b/repair/quotacheck.c
@@ -24,6 +24,16 @@ void quotacheck_skip(void)
  */
 static uint16_t chkd_flags;
 
+/*
+ * Return CHKD flags for the quota types that we checked.  If we encountered
+ * any errors at all, return zero.
+ */
+uint16_t
+quotacheck_results(void)
+{
+	return chkd_flags;
+}
+
 /* Global incore dquot tree */
 struct qc_dquots {
 	pthread_mutex_t		lock;
diff --git a/repair/quotacheck.h b/repair/quotacheck.h
index 08e11d17..d745696f 100644
--- a/repair/quotacheck.h
+++ b/repair/quotacheck.h
@@ -9,6 +9,7 @@
 void quotacheck_skip(void);
 void quotacheck_adjust(struct xfs_mount *mp, xfs_ino_t ino);
 void quotacheck_verify(struct xfs_mount *mp, unsigned int type);
+uint16_t quotacheck_results(void);
 int quotacheck_setup(struct xfs_mount *mp);
 void quotacheck_teardown(void);
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index a787da4c..d687edea 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1106,7 +1106,7 @@ _("Warning:  project quota information would be cleared.\n"
 
 	dsb = sbp->b_addr;
 
-	if (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD) {
+	if ((mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD) != quotacheck_results()) {
 		do_warn(_("Note - quota info will be regenerated on next "
 			"quota mount.\n"));
 		dsb->sb_qflags &= cpu_to_be16(~(XFS_UQUOTA_CHKD |

