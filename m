Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77466C47257
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56B602074A
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lUn5kHeT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbgD3WrJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:47:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43676 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727027AbgD3WrJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:47:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMgqDS128228
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=EgohZvcFnhyV76yoltaa5bD231Ba1Fj2lCW8gC1wSKI=;
 b=lUn5kHeTATq4v8BieHkO4NkvOlDtXt1EKwthS42oIpXC5gWugQUC5kiftF6RCUorCPXf
 wxqwJADr2NTKS5+hIuFWXZns9kKM7JqGBJyRI4jxPaypaPlw0MdW71is8roSEQ0qHPbb
 iBp8NGzCAV7xQj3a3xk0CjNloNw3avEA4Wx5+mfwjihbJen/h96hiQJSkTyn/WX7L68k
 p4G69x/z8tKAdhHt8hakaLoj9Hw3MeYpgbDMOSJsfIQHyiiuGbBoRIGF6ZqluhCUagat
 RW7x3PVCl9vo6OdjeSSR+HDr1uRy/wd67UInG5erZ2JmY/jNxqT1kkHivKOpX6tgtUJz Ag== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30r7f3g22r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMgD9N141464
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30qtg23dp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:06 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03UMl68q012793
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:06 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 15:47:05 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 03/43] xfsprogs: remove the name == NULL check from xfs_attr_args_init
Date:   Thu, 30 Apr 2020 15:46:20 -0700
Message-Id: <20200430224700.4183-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430224700.4183-1-allison.henderson@oracle.com>
References: <20200430224700.4183-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 impostorscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

All callers provide a valid name pointer, remove the redundant check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 6c56428..b7c46c0 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -65,10 +65,6 @@ xfs_attr_args_init(
 	size_t			namelen,
 	int			flags)
 {
-
-	if (!name)
-		return -EINVAL;
-
 	memset(args, 0, sizeof(*args));
 	args->geo = dp->i_mount->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
-- 
2.7.4

