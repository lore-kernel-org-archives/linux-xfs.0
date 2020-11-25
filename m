Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A33BC56202
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 20:40:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2A85207BC
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 20:40:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fU/NjzLO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730256AbgKYUkM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Nov 2020 15:40:12 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:43474 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730012AbgKYUkM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Nov 2020 15:40:12 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0APKOt4U027985;
        Wed, 25 Nov 2020 20:40:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=v6cGPW2Zdptk9AjfsLkgcblhVyVAhoIFqZ9bWUkVRVw=;
 b=fU/NjzLO2F3rG13G6K70LH43BvFkhfwHVpDRN2Zkm3ME4DllpFpWo9pvjjb6gTg3tuJf
 4carFUvOZULcYpQUqcDNGYf7uZoR0DftENhdz7llmTWycoehiI+cgXG+boh1wTGNmobD
 nYc/vGT1G/eyEihB4/TlEgl8yrejPsilg0RO5H06RAbS2/SEVYHbbHlgy0dZWBj1U6Wl
 kiObd2k0gRuxjX6P9k8eXV1QtcWx1itm/Bplx9YH+TDFSPeEaOmufyoUuGB7mkSqco7u
 c8KWTA6Ren4ZGzD6elgAN5VFNzPwEoNI2BQNvHki+B2Cx6xIHW9tuPYH6kJMO3FHbZN/ AQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 351kwhbbdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 25 Nov 2020 20:40:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0APKPfwW117061;
        Wed, 25 Nov 2020 20:38:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 351kwevgdb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Nov 2020 20:38:10 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0APKc9vC015572;
        Wed, 25 Nov 2020 20:38:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Nov 2020 12:38:09 -0800
Subject: [PATCH 2/5] libxfs: fix weird comment
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Nov 2020 12:38:08 -0800
Message-ID: <160633668822.634603.17791163917116618433.stgit@magnolia>
In-Reply-To: <160633667604.634603.7657982642827987317.stgit@magnolia>
References: <160633667604.634603.7657982642827987317.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9816 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 suspectscore=9 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011250127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9816 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 impostorscore=0
 suspectscore=9 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011250127
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Not sure what happened with this multiline comment, but clean up all the
stars.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/platform_defs.h.in |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index 95e7209a3332..539bdbecf6e0 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -86,9 +86,9 @@ extern int	platform_nproc(void);
 /* Simplified from version in include/linux/overflow.h */
 
 /*
- *  * Compute a*b+c, returning SIZE_MAX on overflow. Internal helper for
- *   * struct_size() below.
- *    */
+ * Compute a*b+c, returning SIZE_MAX on overflow. Internal helper for
+ * struct_size() below.
+ */
 static inline size_t __ab_c_size(size_t a, size_t b, size_t c)
 {
 	return (a * b) + c;

