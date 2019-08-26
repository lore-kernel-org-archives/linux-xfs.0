Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22BA8C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 18:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECA57206BA
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 18:38:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="psxkvsB0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732515AbfHZSi0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 14:38:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39594 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727687AbfHZSi0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 14:38:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QIXvWd046915
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 18:38:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=BdUZ1jA6Y/9xb9TRgbT5yXqkXPlmaj8uNbX0wKiR580=;
 b=psxkvsB0yuwbXl1BzAwhb9eI76uuRxUEm3+DlaIdOX43M7rHM7Z9Qp88u7FOLMc3vxjI
 2zQBBRiDxxLg0TG4xgdgz/a2cNN9YcAFpCIh2PAWsPXfqBmzkIFafRoVRt7FkpToDps0
 P62otz3quTnG95Hl45y7GnkFAgXInDxcngyFvz9zTEDY9wOqAtdWmhbctdXKKLY62yW7
 s08TrlKNqtz2+Eo6OK0guCBFkyV8kVvFYacgfqWWztAGyzwEDun0G7/IdgpfH1YAXFHF
 +VD4ldlpnvTmQK4Ra9a/qM4TvpaZUoTyJs2+eeiR+nyu5VdX6l5+UQttGySx6yIINWkq 3w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2ujwvqb7gq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 18:38:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QIXmMm078916
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 18:36:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2umhu7r1es-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 18:36:24 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QIaNvJ028171
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 18:36:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 11:36:23 -0700
Date:   Mon, 26 Aug 2019 11:36:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: don't return _QUERY_ABORT from xfs_rmap_has_other_keys
Message-ID: <20190826183622.GP1037350@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260178
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260178
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The xfs_rmap_has_other_keys helper aborts the iteration as soon as it
has an answer.  Don't let this abort leak out to callers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index e6aeb390b2fb..819693ef852c 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2540,8 +2540,11 @@ xfs_rmap_has_other_keys(
 
 	error = xfs_rmap_query_range(cur, &low, &high,
 			xfs_rmap_has_other_keys_helper, &rks);
+	if (error < 0)
+		return error;
+
 	*has_rmap = rks.has_rmap;
-	return error;
+	return 0;
 }
 
 const struct xfs_owner_info XFS_RMAP_OINFO_SKIP_UPDATE = {
