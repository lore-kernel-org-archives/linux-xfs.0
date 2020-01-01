Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0452BC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8A94206EE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:24:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QG8zdFVo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgAABYJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:24:09 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59770 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727183AbgAABYJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:24:09 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011O7hc097544;
        Wed, 1 Jan 2020 01:24:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=dVxrB9y/Bn3Vg46k86csOlgfGeUJBm9UGgtmUKemPhc=;
 b=QG8zdFVork9i/wB9zmPV64CwRKqKs7HxVdOZlRO9ibJ+8JtnsKQ1ojhRvEHLa/ycewIX
 S+XTBDPRNLBBSeNmrMa11ebtGirV7+YcaX8Llb9A5qbyssFH5OZU8fIH0KzA1QCZEFM6
 bxw9unl2Nn5EjW9+HZLSd6xabYlEX1d5hW7I4tU9iQgTaFaIcx/xVEOaWsS0d0GrPsdS
 5kfbx6e6fT62pnlb9/Og4a8FrNriE154AQmJffQgUr5FQHBbtlTk6yBoWy7ZGHjPIDaw
 +39gC+fIGK2RihpBRIJ6mKsQng/0xGFG3fxWdvTfMb1qYg0EQQfQO0DPq64k5nPS74pu NA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjy9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:24:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011O4xg190950;
        Wed, 1 Jan 2020 01:24:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2x8gj91e8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:24:05 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011Mo8P001677;
        Wed, 1 Jan 2020 01:22:50 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:22:50 -0800
Subject: [PATCH 1/4] misc: support building flatpak images
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:22:47 -0800
Message-ID: <157784176718.1372453.6932244685934321782.stgit@magnolia>
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
 definitions=main-2001010011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Poke the system until it supports building flatpaks.  Maybe.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 bootstrap  |   12 ++++++++++++
 flatpak.sh |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+)
 create mode 100755 bootstrap
 create mode 100755 flatpak.sh


diff --git a/bootstrap b/bootstrap
new file mode 100755
index 00000000..d403cf58
--- /dev/null
+++ b/bootstrap
@@ -0,0 +1,12 @@
+#!/bin/bash -x
+
+libtoolize
+automake --add-missing
+aclocal -I m4
+autoconf
+make configure
+libtoolize
+automake --add-missing
+aclocal -I m4
+autoconf
+make configure
diff --git a/flatpak.sh b/flatpak.sh
new file mode 100755
index 00000000..a1ec916e
--- /dev/null
+++ b/flatpak.sh
@@ -0,0 +1,55 @@
+#!/bin/bash -xe
+
+if [ "$1" = "--help" ]; then
+	echo "Usage: $0 [branch] [build]"
+	echo "Build xfsprogs flatpak from the given branch."
+fi
+
+branch="$1"
+test -z "${branch}" && branch=master
+build="$2"
+test -z "${build}" && build=release
+
+if [ "${build}" = "debug" ]; then
+	config_opts=', "--disable-lto"'
+fi
+
+cat > flatpak.ini << ENDL
+[Application]
+name=org.xfs.progs
+runtime=org.freedesktop.Platform/$(uname -m)/18.08
+
+[Context]
+devices=all;
+ENDL
+
+cat > org.xfs.progs.json << ENDL
+{
+    "app-id": "org.xfs.progs",
+    "runtime": "org.freedesktop.Platform",
+    "runtime-version": "18.08",
+    "sdk": "org.freedesktop.Sdk",
+    "command": "/app/sbin/xfs_repair",
+    "metadata": "flatpak.ini",
+    "modules": [
+        {
+            "name": "xfsprogs",
+            "buildsystem": "autotools",
+            "config-opts": ["--enable-shared=no" ${config_opts} ],
+            "sources": [
+                {
+                    "type": "git",
+                    "path": "${PWD}/",
+                    "branch": "${branch}"
+                }
+            ]
+        }
+    ]
+}
+ENDL
+
+flatpak-builder --repo=repo build-dir org.xfs.progs.json --force-clean
+flatpak build-bundle repo xfsprogs.flatpak org.xfs.progs
+echo build done, run:
+echo flatpak install xfsprogs.flatpak
+echo flatpak run org.xfs.progs

