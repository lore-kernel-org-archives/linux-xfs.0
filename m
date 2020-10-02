Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9FC0C4363D
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 04:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B420520874
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 04:49:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jNxfH7T4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbgJBEt2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Oct 2020 00:49:28 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:40754 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbgJBEt2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Oct 2020 00:49:28 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0924huh4089875
        for <linux-xfs@vger.kernel.org>; Fri, 2 Oct 2020 04:49:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=V9UZzP6O75qjr/YyE7xCQuInZYWNtnUdQyGrAC1HVrQ=;
 b=jNxfH7T4Yp/gFeFIvNTntTmWz6PV3zww5bRQxPNuuSEoNhcPFGVc5/nBUwMUde1TVdpF
 lyQfxi1J3LZscA5ZTgCvNAV5m4VdiGyH1VvjwsY+Swr4Z37IHB0/xXfcufQCizY8HVK5
 +oG6HOlP7pgJgHO0nxwCJrhpa/g3volIr9rvnJhntqhMtnGPrrhX3fCgz/8KeY2uEJUU
 UNorDiHNXZpPz9Zz3dWlaD4OPXuf0pJ7xDSwgzfMkOk7jV8GhBClMxSlYF5aYbwcRn0A
 hD+S0eCTE8jQaLtwEmDS8bmMobvyHKCjbay9eNcQ/h1b4yreZHXpOfFdgZrRLfZOAc98 BA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 33wupg0651-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 02 Oct 2020 04:49:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0924isiL008569
        for <linux-xfs@vger.kernel.org>; Fri, 2 Oct 2020 04:49:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 33tfdx1r2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 02 Oct 2020 04:49:26 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0924nPQ6008768
        for <linux-xfs@vger.kernel.org>; Fri, 2 Oct 2020 04:49:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 01 Oct 2020 21:49:25 -0700
Subject: [PATCH 1/2] xfs: limit entries returned when counting fsmap records
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 01 Oct 2020 21:49:24 -0700
Message-ID: <160161416467.1967459.10753396346204946090.stgit@magnolia>
In-Reply-To: <160161415855.1967459.13623226657245838117.stgit@magnolia>
References: <160161415855.1967459.13623226657245838117.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020035
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 clxscore=1015
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020035
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If userspace asked fsmap to count the number of entries, we cannot
return more than UINT_MAX entries because fmh_entries is u32.
Therefore, stop counting if we hit this limit or else we will waste time
to return truncated results.

Fixes: e89c041338ed ("xfs: implement the GETFSMAP ioctl")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_fsmap.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 4eebcec4aae6..aa36e7daf82c 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -256,6 +256,9 @@ xfs_getfsmap_helper(
 
 	/* Are we just counting mappings? */
 	if (info->head->fmh_count == 0) {
+		if (info->head->fmh_entries == UINT_MAX)
+			return -ECANCELED;
+
 		if (rec_daddr > info->next_daddr)
 			info->head->fmh_entries++;
 

