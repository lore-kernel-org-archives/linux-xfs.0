Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B38C47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:51:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2777E218AC
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:51:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ocVFuI+w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731145AbfJIQvt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 12:51:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48696 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730490AbfJIQvt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 12:51:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99GjeDF026619
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:51:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=huokKDzjlnWN600dYv1Bzes61RmlCko7M00qcAoevIM=;
 b=ocVFuI+w9CSarE1q28M+T1P247+Ap8vN8AFMpbo+7ezFWoH1Of4c8tx8tcgr7+wSpwSx
 v0pukSyTdVgmXezlV4Tl6XaVUPgyAFsUoNz9qcfmXbc5u4hsiJIIjxlUgRADeB2Ighp2
 mJahQ7eNabLPZ/EcDqJ3ld6DN5e/uBt5JqT0V/xUfcZmjeSIHU9krkqLRxO8hb4kMns5
 W82c1gtKKfgK8tuRI2hS0uIHFHXpNNWRXfOZc4cu+vEDfTV+P79H1aNdD1cKbt2JUZhx
 YbsmZJnueNLBKRXGIe9P8O/gGyCpem1lG+PDrQ0SlOBAcGSlSAxZPeZWNV1CpEXwm5t6 Ug== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vektrns2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:51:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99Giahd144663
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:49:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2vh8k146yq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:49:47 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x99GnkH8021854
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:49:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 09:49:46 -0700
Subject: [PATCH 2/2] xfs: always rescan allegedly healthy per-ag metadata
 after repair
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 09 Oct 2019 09:49:45 -0700
Message-ID: <157063978533.2913625.15756257326965494318.stgit@magnolia>
In-Reply-To: <157063977277.2913625.2221058732448775822.stgit@magnolia>
References: <157063977277.2913625.2221058732448775822.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910090147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910090147
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
index b2f602811e9d..4865b2180e22 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -220,6 +220,16 @@ xchk_ag_btree_healthy_enough(
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

