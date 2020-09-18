Return-Path: <SRS0=2mLC=C3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B462C43465
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 02:57:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 156E12395B
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 02:57:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uyuqOYWk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729727AbgIRC5H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:57:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44650 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727805AbgIRCGm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 22:06:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08I24vjq150578;
        Fri, 18 Sep 2020 02:06:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=4oNDzWHHTzDq0UDJgFvG58EhjBvcDBCxyJDSncT430w=;
 b=uyuqOYWkU92YDdDUn8aSVssUDfPRgEs5elCdwGXxBWdgkG9UDe6gmGqQsuXhh/qS6XT7
 8V7+zbxMMtRoj5Cy40hCAH+zKGu10HqT3rFkYnvT2pieCdlfBmJX24FxN8+r+yNTC3qr
 oJ9WrvoZIOp4AUUm4wVTePFfN3OcqxpWiOV8kYSZucZ7tBRKylDS5wn5PIJ7KKcueLAM
 PTP99V0bzvBHQXRTwmpkPAX4M4Q6E4cJSXE7Xo/5f/OpOlhY7/AeXvfbZAkpeDAKkzk0
 nE+WoK6MOBYDY07kw9yeXBibBGEFV/S7zJ7eBZQa767aq/1lZsXAxjJN69R6t2PReqIu bw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33gp9mmgtr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Sep 2020 02:06:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08I24pGB167147;
        Fri, 18 Sep 2020 02:06:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33megag08e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 02:06:39 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08I26cMF019804;
        Fri, 18 Sep 2020 02:06:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Sep 2020 02:06:38 +0000
Date:   Thu, 17 Sep 2020 19:06:37 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v2 24/24] check: try reloading modules
Message-ID: <20200918020637.GH7954@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009180019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=3 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009180018
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Optionally reload the module between each test to try to pinpoint slab
cache errors and whatnot.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: use "fs-$FSTYP" for the module name
---
 README |    3 +++
 check  |    9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/README b/README
index d0e23fcd..4af331b4 100644
--- a/README
+++ b/README
@@ -106,6 +106,9 @@ Preparing system for tests:
              - set USE_KMEMLEAK=yes to scan for memory leaks in the kernel
                after every test, if the kernel supports kmemleak.
              - set KEEP_DMESG=yes to keep dmesg log after test
+             - Set TEST_FS_MODULE_RELOAD=1 to unload the module and reload
+               it between test invocations.  This assumes that the name of
+               the module is the same as FSTYP.
 
         - or add a case to the switch in common/config assigning
           these variables based on the hostname of your test
diff --git a/check b/check
index 6a353399..6002233a 100755
--- a/check
+++ b/check
@@ -834,6 +834,15 @@ function run_section()
 			_check_dmesg || err=true
 		fi
 
+		# Reload the module after each test to check for leaks or
+		# other problems.
+		if [ -n "${TEST_FS_MODULE_RELOAD}" ]; then
+			_test_unmount 2> /dev/null
+			_scratch_unmount 2> /dev/null
+			modprobe -r fs-$FSTYP
+			modprobe fs-$FSTYP
+		fi
+
 		# Scan for memory leaks after every test so that associating
 		# a leak to a particular test will be as accurate as possible.
 		_check_kmemleak || err=true
