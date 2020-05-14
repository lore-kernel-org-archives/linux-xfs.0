Return-Path: <SRS0=gMH0=64=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8728DC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 16:58:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 571D02065F
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 16:58:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vyHykZKw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgENQ6w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 May 2020 12:58:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35086 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgENQ6v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 May 2020 12:58:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EGvLUL165902;
        Thu, 14 May 2020 16:58:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+WTni9KZJ6mlCvT8QcMIRXBlhGjmLacgAiIe/ggkbSk=;
 b=vyHykZKwbDDAVuRWMApqjvxpLgPP0k5svZ/V8VBMOGPsZgttaJHqXDhpQc/QMvpVVjaO
 5IEXqhdHBUNPRr8uMuQLmLNOVmOeyIaB0zR+iWSqTH5DpGpnCKHY51Vdw/hN9tlJyfhR
 5kvmUm9q5XK9OE/wap4saXuqunK2awxnxxt81TbpPWFY21mT6pPNwzEyO3SetDM21e7x
 YESstT/lO0hQdEOQt2ce9FOtkUIsJuCKTEpeKfOYXAQ7DkJwDb2Rv9UFY87f7X8puyva
 sxmqsLsLVXKOeXTq3eIBGui0CiEtvQ6BgDNtREXqe+rizVk/3Xj8bEwrGgw4HaJaSzKW XA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3100xwktnh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 14 May 2020 16:58:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EGs62R026052;
        Thu, 14 May 2020 16:56:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 3100yd18p6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 May 2020 16:56:49 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04EGum7Z002702;
        Thu, 14 May 2020 16:56:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 09:56:48 -0700
Subject: [PATCH 4/4] xfs_repair: skip mount time quotacheck if our quotacheck
 was ok
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 14 May 2020 09:56:46 -0700
Message-ID: <158947540679.2482564.16151977938940466991.stgit@magnolia>
In-Reply-To: <158947538149.2482564.3112804204578429865.stgit@magnolia>
References: <158947538149.2482564.3112804204578429865.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=935 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005140149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=943 clxscore=1015 cotscore=-2147483648
 mlxscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005140150
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
index a9e4f1ba..7a94f465 100644
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
index 6a796742..a82f96f8 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1106,7 +1106,7 @@ _("Warning:  project quota information would be cleared.\n"
 
 	dsb = sbp->b_addr;
 
-	if (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD) {
+	if ((mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD) != quotacheck_results()) {
 		do_warn(_("Note - quota info will be regenerated on next "
 			"quota mount.\n"));
 		dsb->sb_qflags &= cpu_to_be16(~(XFS_UQUOTA_CHKD |

