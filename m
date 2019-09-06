Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D7CAC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29E82206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:36:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M2HOrWG/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732247AbfIFDgP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:36:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49890 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732205AbfIFDgP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:36:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863ZpC7110981;
        Fri, 6 Sep 2019 03:36:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=jEL+5Res38DSS/03MUu9jZ++0IE0BpZwW6w/jf66BgU=;
 b=M2HOrWG/ucpvwTAC3P+drYGi/1rIRlFm9tBMp4Auk2wVK/U3k3cmyr2urpfOycjDLXO9
 xQoRQ4gfHYS+lzFUAJGxB+SE0Z2WgQikPxqINOl3omLGOYZEfXEGgZKZaxBqPnjC0Vnb
 GueOVIdJxo+HAk7fSkoheiAY2KTbWe6g0Uo68qzNouWyyXe/CIUjCJsEiuUu98Ltw/Wh
 WR+aYriFCWyFnyhFTuaUem0oAz7G9rAaqjd0YKjzY4E/olPFGve8WXUfMsdCC45/MnG2
 8m61oGr9qC+qKolYcVn2E49gH00ogEixq1ZF+TU5m76B/poJJjnHaIkfPec1Qlf3Cv09 pA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2uuf4n038q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:36:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863XbFu069233;
        Fri, 6 Sep 2019 03:36:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2utvr4jvbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:36:12 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x863aBAG004563;
        Fri, 6 Sep 2019 03:36:11 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:36:11 -0700
Subject: [PATCH 4/4] xfs_scrub: batch inumbers calls during fscounters
 calculation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:36:11 -0700
Message-ID: <156774097106.2644581.12925257167258478461.stgit@magnolia>
In-Reply-To: <156774093859.2644581.13218735172589605186.stgit@magnolia>
References: <156774093859.2644581.13218735172589605186.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060039
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Improve the efficiency of the phase 7 inode counts by batching requests,
now that we have per-AG inumbers wrappers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/fscounters.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index a2cf8171..ad467e0c 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -43,9 +43,10 @@ xfs_count_inodes_ag(
 {
 	struct xfs_inumbers_req	*ireq;
 	uint64_t		nr = 0;
+	unsigned int		i;
 	int			error;
 
-	ireq = xfrog_inumbers_alloc_req(1, 0);
+	ireq = xfrog_inumbers_alloc_req(64, 0);
 	if (!ireq) {
 		str_info(ctx, descr, _("Insufficient memory; giving up."));
 		return false;
@@ -55,7 +56,8 @@ xfs_count_inodes_ag(
 	while (!(error = xfrog_inumbers(&ctx->mnt, ireq))) {
 		if (ireq->hdr.ocount == 0)
 			break;
-		nr += ireq->inumbers[0].xi_alloccount;
+		for (i = 0; i < ireq->hdr.ocount; i++)
+			nr += ireq->inumbers[i].xi_alloccount;
 	}
 
 	free(ireq);

