Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B656C3A5A3
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 04:20:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 016F822CE9
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 04:20:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gk85HT8S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbfH3EUk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 00:20:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37624 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfH3EUk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 00:20:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7U4Ikup103562;
        Fri, 30 Aug 2019 04:20:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=/gJiIeRY7VD9Ct2BDIJT0fl/mKte2U7tISATnQLZMI0=;
 b=Gk85HT8SzQLYRff9b2CYtgMRGp4Vr8BUc32dF44TECBwKJkhFU1jM0pWzj/bLauEixkb
 Ik6nGWuY8EKKC+quVYMTA7xEI9TVpIb2HSXhOF52rRPDuuL4ZWvIorlsTxtVEi7NBOYd
 eEIJTgZA95aImjDmQoC2Hap511RdudNYHITYSJY3f56FRw2XxXrkaabKpmq50EYhMpQM
 LxQsUNSa7fSHYfkJS2zrYHdLxVI0AqwV5x8hzTG70zHEqWfaYgsrAqa8za6TT6v9CrcL
 F4aTmeWF56H/T3sL8P6mNri+yAg0jYrjDWIbEcjClzKVNL/22I+G+oDuO4nQFawjvH44 nQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2upvj7g1a6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 04:20:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7U4IbAQ158383;
        Fri, 30 Aug 2019 04:20:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2uphaukdqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 04:20:36 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7U4KaxD026311;
        Fri, 30 Aug 2019 04:20:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 21:20:35 -0700
Subject: [PATCH 2/9] xfsprogs: update spdx tags in LICENSES/
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 29 Aug 2019 21:20:34 -0700
Message-ID: <156713883483.386621.11761019405847468101.stgit@magnolia>
In-Reply-To: <156713882070.386621.8501281965010809034.stgit@magnolia>
References: <156713882070.386621.8501281965010809034.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300043
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300043
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

