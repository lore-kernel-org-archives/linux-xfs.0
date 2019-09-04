Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B0EBC3A5A9
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 07:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EDD32339D
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 07:30:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c5HXFiuD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbfIDHai (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 03:30:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46050 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfIDHai (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 03:30:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x847Siwg186755;
        Wed, 4 Sep 2019 07:30:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=/gJiIeRY7VD9Ct2BDIJT0fl/mKte2U7tISATnQLZMI0=;
 b=c5HXFiuDqbWxM+iuOGc8IJ2ToCZUsqW35AAq48c2Q8eZSQsD2S8cc8UwW+BKO2uqd/rr
 U1PXKnDg214fA3OswOevc3W/a9RyWWTjgnZe0hQh5S0UmDaUar+PqO0TW6Gptti6KP92
 flvb0Ue8HNU0yL+MCQokm7yYw5+ExT7lg2+I6/dZKH6v2QQe+0tbuEg8eAY0Sjt4g506
 WPaXqJ01Q+gEEm+iY+H6SxUXcVPx49ohMRrBrE8OPLeLzCenD26yM4c4NA83yMt7er8x
 stLKkRt3YGHnYcCgmMSLgLKzE2YXIjhY/riDpf9mNbbAtLl2YRM2N1ZCcQAm4KKyZ4/S Kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ut8v8r0vd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 07:30:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844XGQb027509;
        Wed, 4 Sep 2019 04:34:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ut1hmttrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:34:52 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x844YpXO029710;
        Wed, 4 Sep 2019 04:34:51 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:34:51 -0700
Subject: [PATCH 1/8] xfsprogs: update spdx tags in LICENSES/
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 03 Sep 2019 21:34:50 -0700
Message-ID: <156757169025.1836891.13790414291298262575.stgit@magnolia>
In-Reply-To: <156757168368.1836891.15043200811666785244.stgit@magnolia>
References: <156757168368.1836891.15043200811666785244.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909040047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909040078
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Update the GPL related SPDX tags in LICENSES to reflect the SPDX 3.0
tagging formats.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 LICENSES/GPL-2.0 |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/LICENSES/GPL-2.0 b/LICENSES/GPL-2.0
index b8db91d3..ff0812fd 100644
--- a/LICENSES/GPL-2.0
+++ b/LICENSES/GPL-2.0
@@ -1,5 +1,7 @@
 Valid-License-Identifier: GPL-2.0
+Valid-License-Identifier: GPL-2.0-only
 Valid-License-Identifier: GPL-2.0+
+Valid-License-Identifier: GPL-2.0-or-later
 SPDX-URL: https://spdx.org/licenses/GPL-2.0.html
 Usage-Guide:
   To use this license in source code, put one of the following SPDX
@@ -7,8 +9,12 @@ Usage-Guide:
   guidelines in the licensing rules documentation.
   For 'GNU General Public License (GPL) version 2 only' use:
     SPDX-License-Identifier: GPL-2.0
+  or
+    SPDX-License-Identifier: GPL-2.0-only
   For 'GNU General Public License (GPL) version 2 or any later version' use:
     SPDX-License-Identifier: GPL-2.0+
+  or
+    SPDX-License-Identifier: GPL-2.0-or-later
 License-Text:
 
 		    GNU GENERAL PUBLIC LICENSE

