Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44DFAC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:23:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1698120718
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:23:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NhAOPSln"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbgAABXb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:23:31 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:60708 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727168AbgAABXb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:23:31 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011FsnS113342;
        Wed, 1 Jan 2020 01:23:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Go8/TBV2ER2b0ITDFnR9fE7TWZNyr3kqwZAIema6ORg=;
 b=NhAOPSlnNYw/vBRUJCkX7AsGtW/XCipMd3L/Hvo64PFamIi6UzcgLBIC1R7Q4OGqK/Vw
 djUZL87NeWnrMQ/ylTSPzRQYvPgYbXD0P2CvjuQIux1k4rIGFcKYHz1LP20UkmueGGdS
 +IA0Tx70HsmUD/Xb+kCJLuWkycN/fh5URMi8wY5iJMyHbDH0DSn71kJUDyZ3LZh4jkyj
 5YkOGU5N+5kKaCuhvY1tGnjF+ByX1CEOhzCCoZqqK1hcNmfv1MC849JG/S1lGDqlBhvh
 LFARPhnT++clCFhXcM/Yohsn+wEOYoJepAOwkIIAirZD48iG27+B3mIZ1qeCMp8Vd7EH KQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2x5xftk2tw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:23:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011NSai012926;
        Wed, 1 Jan 2020 01:23:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2x8bsrg89t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:23:27 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011NAIW004246;
        Wed, 1 Jan 2020 01:23:10 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:23:10 -0800
Subject: [PATCH 4/4] xfs_scrub_all: failure reporting for the xfs_scrub_all
 job
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:23:07 -0800
Message-ID: <157784178791.1372453.1791394612520677285.stgit@magnolia>
In-Reply-To: <157784176039.1372453.10128269126585047352.stgit@magnolia>
References: <157784176039.1372453.10128269126585047352.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=9 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=9 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a failure reporting service for when xfs_scrub_all fails.  This
is probably a debug-only patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/Makefile                      |    3 ++-
 scrub/xfs_scrub_all_fail            |   24 ++++++++++++++++++++++++
 scrub/xfs_scrub_all_fail.service.in |   11 +++++++++++
 3 files changed, 37 insertions(+), 1 deletion(-)
 create mode 100755 scrub/xfs_scrub_all_fail
 create mode 100644 scrub/xfs_scrub_all_fail.service.in


diff --git a/scrub/Makefile b/scrub/Makefile
index 47c887eb..50d16121 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -18,7 +18,7 @@ XFS_SCRUB_ALL_PROG = xfs_scrub_all
 XFS_SCRUB_ARGS = -b -n
 ifeq ($(HAVE_SYSTEMD),yes)
 INSTALL_SCRUB += install-systemd
-SYSTEMD_SERVICES = xfs_scrub@.service xfs_scrub_all.service xfs_scrub_all.timer xfs_scrub_fail@.service
+SYSTEMD_SERVICES = xfs_scrub@.service xfs_scrub_all.service xfs_scrub_all.timer xfs_scrub_fail@.service xfs_scrub_all_fail.service
 OPTIONAL_TARGETS += $(SYSTEMD_SERVICES)
 endif
 ifeq ($(HAVE_CROND),yes)
@@ -133,6 +133,7 @@ install-systemd: default $(SYSTEMD_SERVICES)
 	$(INSTALL) -m 644 $(SYSTEMD_SERVICES) $(SYSTEMD_SYSTEM_UNIT_DIR)
 	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/$(PKG_NAME)
 	$(INSTALL) -m 755 xfs_scrub_fail $(PKG_LIB_DIR)/$(PKG_NAME)
+	$(INSTALL) -m 755 xfs_scrub_all_fail $(PKG_LIB_DIR)/$(PKG_NAME)
 
 install-crond: default $(CRONTABS)
 	$(INSTALL) -m 755 -d $(CROND_DIR)
diff --git a/scrub/xfs_scrub_all_fail b/scrub/xfs_scrub_all_fail
new file mode 100755
index 00000000..8391abc8
--- /dev/null
+++ b/scrub/xfs_scrub_all_fail
@@ -0,0 +1,24 @@
+#!/bin/bash
+
+# Email logs of failed xfs_scrub_all unit runs
+
+mailer=/usr/sbin/sendmail
+recipient="$1"
+test -z "${recipient}" && exit 0
+hostname="$(hostname -f 2>/dev/null)"
+test -z "${hostname}" && hostname="${HOSTNAME}"
+if [ ! -x "${mailer}" ]; then
+	echo "${mailer}: Mailer program not found."
+	exit 1
+fi
+
+(cat << ENDL
+To: $1
+From: <xfs_scrub_all@${hostname}>
+Subject: xfs_scrub_all failure on ${mntpoint}
+
+So sorry, the automatic xfs_scrub_all on ${hostname} failed.
+
+A log of what happened follows:
+ENDL
+systemctl status --full --lines 4294967295 "xfs_scrub_all") | "${mailer}" -t -i
diff --git a/scrub/xfs_scrub_all_fail.service.in b/scrub/xfs_scrub_all_fail.service.in
new file mode 100644
index 00000000..2d85db28
--- /dev/null
+++ b/scrub/xfs_scrub_all_fail.service.in
@@ -0,0 +1,11 @@
+[Unit]
+Description=Online XFS Metadata Check for All Filesystems Failure Reporting for %I
+Documentation=man:xfs_scrub_all(8)
+
+[Service]
+Type=oneshot
+Environment=EMAIL_ADDR=root
+ExecStart=@pkg_lib_dir@/@pkg_name@/xfs_scrub_all_fail "${EMAIL_ADDR}"
+User=mail
+Group=mail
+SupplementaryGroups=systemd-journal

