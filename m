Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD1FCC43461
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9925D20771
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:47:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qHwcbWC3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgIOBrd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 21:47:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52858 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbgIOBrc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 21:47:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1il9R031214;
        Tue, 15 Sep 2020 01:47:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=exqzEGpx9SPcPrNDzxxFjk25EbH87SsgpZs6FKUrq80=;
 b=qHwcbWC3s9V+6EnbYAfHSiYd3snvwZyn+dZ0P9X1Wqv4p/J8gBPpHuxwdT730BMi/uLe
 jgik93DD2CgntJTJZl7EG8f6sAbdfOmp/m6tvJlUO64NHAlbc/1SwmCaG3kVc+q638yw
 xv9hAFgq+3J04JNscDxioasJd54N6aVvnoLfntyt7Lt7ftHACNHDGEMVBB/K8zx2TgpL
 Q+n2XNZuFq933KnRvlbfxgR1Rx+52GZrHl4zeezN2EXaEjcE8Rj9VwTQ6IeBJ4fHync0
 xp8RUZJmK1KV8PoCvmNdlVE19m3ykUaq1e6MA1Nv36k/mKdunLeSSRvoq2WTK+OZbnoE nw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33gp9m1x21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 01:47:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1igik029082;
        Tue, 15 Sep 2020 01:45:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33h88x2ws6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 01:45:30 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08F1jTaK007484;
        Tue, 15 Sep 2020 01:45:29 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 01:45:29 +0000
Subject: [PATCH 24/24] check: try reloading modules
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:45:28 -0700
Message-ID: <160013432812.2923511.2856221820399528798.stgit@magnolia>
In-Reply-To: <160013417420.2923511.6825722200699287884.stgit@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Optionally reload the module between each test to try to pinpoint slab
cache errors and whatnot.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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
index 5ffa8777..29306262 100755
--- a/check
+++ b/check
@@ -810,6 +810,15 @@ function run_section()
 			_check_dmesg || err=true
 		fi
 
+		# Reload the module after each test to check for leaks or
+		# other problems.
+		if [ -n "${TEST_FS_MODULE_RELOAD}" ]; then
+			_test_unmount 2> /dev/null
+			_scratch_unmount 2> /dev/null
+			modprobe -r $FSTYP
+			modprobe $FSTYP
+		fi
+
 		# Scan for memory leaks after every test so that associating
 		# a leak to a particular test will be as accurate as possible.
 		_check_kmemleak || err=true

