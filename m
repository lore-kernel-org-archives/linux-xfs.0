Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4705C4360C
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA07D21D80
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:34:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HsNWPysM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbfIYVet (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:34:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37606 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727512AbfIYVet (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:34:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYW1b058043;
        Wed, 25 Sep 2019 21:34:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=644Kk538U0mbrNn/NLXdmPbgup4TC8eba8m9M9rR6x4=;
 b=HsNWPysMs3otmkLjsI8DXLeBA/MJ7s8fqpe6Jb2cy/8amG4uMnjym5XYaFvwLfD7/6uK
 1fgdLa4Az7gqh5LIQJAWTRZHueQV8qy/pfGCD07Y28HL5h3T79DQRcshfpsmpXM3OQR8
 QoQYK76YdtUDgSYlja0dCdyt0jdWhl1O+8myU5dwpCkrz1rH0DUJ2NLNkw51lYfBBr6O
 3U5dyniuYZUd7TyXIV4N4EuYIXkFdnqaXu/xzQPYN5sUQ+5wpuCefiTsC3z2+pEDOcmU
 vRaS0Fzqsha8m9OhNFQcjgya4kxvaDusrzrF5LrW6SuAttIPBRpvUWvfdBRjq5enX46L ng== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2v5b9tyh1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:34:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYQZw097675;
        Wed, 25 Sep 2019 21:34:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2v82qakqwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:34:34 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLXM2Q014403;
        Wed, 25 Sep 2019 21:33:22 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:33:21 -0700
Subject: [PATCH 4/4] xfs_scrub: batch inumbers calls during fscounters
 calculation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Date:   Wed, 25 Sep 2019 14:33:20 -0700
Message-ID: <156944720050.297551.11989510278130886367.stgit@magnolia>
In-Reply-To: <156944717403.297551.9871784842549394192.stgit@magnolia>
References: <156944717403.297551.9871784842549394192.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Improve the efficiency of the phase 7 inode counts by batching requests,
now that we have per-AG inumbers wrappers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
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

