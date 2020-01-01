Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3762BC2D0DD
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A340206EE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:23:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fpOeRus5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgAABXi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:23:38 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:56270 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727183AbgAABXi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:23:38 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011Naed099300;
        Wed, 1 Jan 2020 01:23:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=d6YyR+3/SyAQbnIVj5SflHJt9L+mbL1eEhcpgPYOIr8=;
 b=fpOeRus5WejAsCxnKJo1YLdy/+TWcjG3Xqontm8rdnHqztxQbyEun9N4Iak3ZDyoMYCf
 QwNzB2fk01D0Nz1OhwIBPQIfLXt0XLXXnMmaCqL6StjeKcOdmmInawIJZF7dHU3oNGKe
 NaOKiBfnPJuavpIhnvYo7jpndR5Q4tojOQky1GKGLNQmlLOv775BaTytGardaqtVrZ66
 LDtX666d/g24W5jOmp59WKaTlwwfwjnTHq73hNu04v8z2U7HRlWev8HbmpM+lxqnc9EQ
 pq2gBCHAjyT56x2zTk8k45GYkXtMvyxgRWKmKKK3/q3zGgevw4NJRsXK+/dNAMwEMGAN RQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:23:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011NYQk030298;
        Wed, 1 Jan 2020 01:23:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2x8gueg9n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:23:34 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011N45u017118;
        Wed, 1 Jan 2020 01:23:04 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:23:04 -0800
Subject: [PATCH 3/4] debian: permit compat level 9 dh builds
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:23:01 -0800
Message-ID: <157784178177.1372453.9672761082907118417.stgit@magnolia>
In-Reply-To: <157784176039.1372453.10128269126585047352.stgit@magnolia>
References: <157784176039.1372453.10128269126585047352.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Retain compatibility with existing dh level 9 build systems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debian/rules |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)


diff --git a/debian/rules b/debian/rules
index a79db896..1dd1f524 100755
--- a/debian/rules
+++ b/debian/rules
@@ -1,5 +1,7 @@
 #!/usr/bin/make -f
 
+.PHONY: dpkg_config
+
 export DH_VERBOSE=1
 
 ifneq (,$(filter parallel=%,$(DEB_BUILD_OPTIONS)))
@@ -7,6 +9,9 @@ ifneq (,$(filter parallel=%,$(DEB_BUILD_OPTIONS)))
     PMAKEFLAGS += -j$(NUMJOBS)
 endif
 
+DH_VERSION := $(shell dpkg-query -W -f '$${Version}' debhelper)
+USE_DH9 ?= $(shell if dpkg --compare-versions $(DH_VERSION) lt 11 ; then echo yes ; fi)
+
 package = xfsprogs
 develop = xfslibs-dev
 bootpkg = xfsprogs-udeb
@@ -33,11 +38,18 @@ checkdir = test -f debian/rules
 build: build-arch build-indep
 build-arch: built
 build-indep: built
-built: dibuild config
+built: dpkg_config dibuild config
 	@echo "== dpkg-buildpackage: build" 1>&2
 	$(MAKE) $(PMAKEFLAGS) default
 	touch built
 
+dpkg_config:
+ifeq ($(USE_DH9),yes)
+	mv debian/compat debian/compat.save
+	echo 9 > debian/compat
+endif
+	@true
+
 config: .census
 .census:
 	@echo "== dpkg-buildpackage: configure" 1>&2
@@ -93,7 +105,9 @@ binary-arch: checkroot built
 	dh_compress
 	dh_fixperms
 	dh_makeshlibs
+ifneq ($(USE_DH9),yes)
 	dh_installsystemd -p xfsprogs --no-enable --no-start --no-restart-after-upgrade --no-stop-on-upgrade
+endif
 	dh_installdeb
 	dh_shlibdeps
 	dh_gencontrol

