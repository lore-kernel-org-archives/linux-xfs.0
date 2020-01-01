Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42FCDC2D0DE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:23:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14443206EE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:23:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jWF5fXWH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgAABXa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:23:30 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:60702 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbgAABXa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:23:30 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011EOGD112611;
        Wed, 1 Jan 2020 01:23:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=dHkXvt+K40ARy4AnVJrVfPcjtMFTfCgQgydqdhZiC/I=;
 b=jWF5fXWHmAlPmWNlVxE5DYpQpRj3ylxT0ZqrCIFUGs1lnjD1mRV92bjOYzHQzH9vgzoN
 5NxWGMWC+urybo25BFjBqhLRW6bjlNVbUtJ5QC72faeco+BeL2/piMmJLt5hx/VbcjPw
 2MbWKGF5+9v+vpJ4MMAgSV1I6gZ+cedCBSBqvX/azhYCOdEUG7qNFhnYDxTB+UCDJD1/
 tCieMT7Yv2aJsP/TAyAORHbduT+ZgswtGwkqWVXtORLqPdcnAIjFA5A0LZ1yF6AW/TxX
 ToZQWl/1kwLN19ZpDKExlS4MxZ48YY8RPpQnFvLj7Q76W1hQAhmo45+tKUYRFUKMmgWe 9Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2x5xftk2ts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:23:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011NSol012919;
        Wed, 1 Jan 2020 01:23:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2x8bsrg880-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:23:27 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011MwQV017113;
        Wed, 1 Jan 2020 01:22:58 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:22:58 -0800
Subject: [PATCH 2/4] debian: turn debhelper compat level up to 11
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:22:53 -0800
Message-ID: <157784177377.1372453.1008055450028015778.stgit@magnolia>
In-Reply-To: <157784176039.1372453.10128269126585047352.stgit@magnolia>
References: <157784176039.1372453.10128269126585047352.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=919
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=977 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Upgrade to debhelper level 11 to take advantage of dh_installsystemd,
which greatly simplifies the installation and activation of the scrub
systemd services.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debian/compat |    2 +-
 debian/rules  |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)


diff --git a/debian/compat b/debian/compat
index ec635144..b4de3947 100644
--- a/debian/compat
+++ b/debian/compat
@@ -1 +1 @@
-9
+11
diff --git a/debian/rules b/debian/rules
index e8509fb3..a79db896 100755
--- a/debian/rules
+++ b/debian/rules
@@ -93,6 +93,7 @@ binary-arch: checkroot built
 	dh_compress
 	dh_fixperms
 	dh_makeshlibs
+	dh_installsystemd -p xfsprogs --no-enable --no-start --no-restart-after-upgrade --no-stop-on-upgrade
 	dh_installdeb
 	dh_shlibdeps
 	dh_gencontrol

