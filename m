Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 011CEC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:02:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7D0420718
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:02:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nhlgi0uO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbgAABCv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:02:51 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45132 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727142AbgAABCv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:02:51 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00111AdZ086599
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:02:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=ZHncoWEaO2jlHt1tCJnQ8/y/CauZv/81V749Awm5ZBs=;
 b=nhlgi0uOi7jmJS8QbDvfJ74NH04ghZg+7btSfyDM+x6Afh9blC5eufHdmmnIUj7Dij3l
 878d+Y+khlYv6EvoDBuEwAPOB41svZ3TpI1ge4rm4w4dr4lOdqXOf6vUQZYZ4M2HIscS
 SWD0p4mCIUENyIexxhHqRe4xv1Ogf0Q4sn8O8+8VKWQrA+l77Y73SS9JTQGVi91eSUMw
 e1xFV7t/cQMEZISCvEVoMkQ5Zq7vdR2VM4qqI6sslV7P4oaWCMsq2oUv2tyIzz6ljtlh
 Wf3W5fcY68UseHQcRmHf40Q+Wp21HsgQP7skc48fgbFp4gIYjm+tdHYPNJJO5eL8aefj 8g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2x5ypqjw45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:02:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0010x37N154954
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:02:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2x8gj911ne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:02:48 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00112m8j023893
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:02:48 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:02:48 -0800
Subject: [PATCH 1/5] xfs: always rescan allegedly healthy per-ag metadata
 after repair
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:02:46 -0800
Message-ID: <157784056606.1358685.17456868108798576593.stgit@magnolia>
In-Reply-To: <157784055814.1358685.7277201980352188138.stgit@magnolia>
References: <157784055814.1358685.7277201980352188138.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010007
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

After an online repair function runs for a per-AG metadata structure,
sc->sick_mask is supposed to reflect the per-AG metadata that the repair
function fixed.  Our next move is to re-check the metadata to assess
the completeness of our repair, so we don't want the rebuilt structure
to be excluded from the rescan just because the health system previously
logged a problem with the data structure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/health.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 83d27cdf579b..8cff49b3ef60 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -221,6 +221,16 @@ xchk_ag_btree_healthy_enough(
 		return true;
 	}
 
+	/*
+	 * If we just repaired some AG metadata, sc->sick_mask will reflect all
+	 * the per-AG metadata types that were repaired.  Exclude these from
+	 * the filesystem health query because we have not yet updated the
+	 * health status and we want everything to be scanned.
+	 */
+	if ((sc->flags & XREP_ALREADY_FIXED) &&
+	    type_to_health_flag[sc->sm->sm_type].group == XHG_AG)
+		mask &= ~sc->sick_mask;
+
 	if (xfs_ag_has_sickness(pag, mask)) {
 		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XFAIL;
 		return false;

