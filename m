Return-Path: <SRS0=0TO6=3H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5D57C33CB8
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jan 2020 22:50:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC128246AC
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jan 2020 22:50:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UTRLKEAz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgARWuu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Jan 2020 17:50:50 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40280 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbgARWut (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Jan 2020 17:50:49 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00IMcvjL093542
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=sjB8kNAGJk6BHyvZtAxndkw6MM3g2Hq61lxT7zCh4tQ=;
 b=UTRLKEAzZfeFZpnd4Yyrg7iw0s4+qE6WYqSvlp0lGmXHYRtBi3PpF/lT8KWI8j0otxiU
 Mqxpq/ugpdLksdEVC8FWNhWRi3526tJlEKPumD26HT5ukmkrHuEIh0IL8NzbpSBXmaHW
 fmUjNHjpROtfjOcxChAZW9NbN89Nxu7sRGq0dxSsXTaQ/RI7PcW0N36sJ3VbjEnmMs0c
 syAJe7GbO5euuofZat/LuY2+ZEKqHULMpwKbL+aLi4AZVYSkFM4S8rE8uBrHC1FtW9yL
 m232SAyYg2aTiPqsiEmUNjVF9oE0+21ii/CpnKh9n9Y3cMvrtxKeBslQsYw1iEX/B1MU hg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xkseu24et-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00IMcqMx125849
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2xkr2dattj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:48 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00IMol0b026590
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:47 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 18 Jan 2020 14:50:46 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 11/16] xfs: Check for -ENOATTR or -EEXIST
Date:   Sat, 18 Jan 2020 15:50:30 -0700
Message-Id: <20200118225035.19503-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200118225035.19503-1-allison.henderson@oracle.com>
References: <20200118225035.19503-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9504 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001180185
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9504 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001180185
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Delayed operations cannot return error codes.  So we must check for
these conditions first before starting set or remove operations

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index a2673fe..e9d22c1 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -457,6 +457,14 @@ xfs_attr_set(
 		goto out_trans_cancel;
 
 	xfs_trans_ijoin(args.trans, dp, 0);
+
+	error = xfs_has_attr(&args);
+	if (error == -EEXIST && (name->type & ATTR_CREATE))
+		goto out_trans_cancel;
+
+	if (error == -ENOATTR && (name->type & ATTR_REPLACE))
+		goto out_trans_cancel;
+
 	error = xfs_attr_set_args(&args);
 	if (error)
 		goto out_trans_cancel;
@@ -545,6 +553,10 @@ xfs_attr_remove(
 	 */
 	xfs_trans_ijoin(args.trans, dp, 0);
 
+	error = xfs_has_attr(&args);
+	if (error != -EEXIST)
+		goto out;
+
 	error = xfs_attr_remove_args(&args);
 	if (error)
 		goto out;
-- 
2.7.4

