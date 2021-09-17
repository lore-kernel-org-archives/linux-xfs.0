Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44D01C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 00:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2574161209
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 00:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241802AbhIQAlD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 20:41:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241734AbhIQAlC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Sep 2021 20:41:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B567611C8;
        Fri, 17 Sep 2021 00:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631839181;
        bh=0GnJdHf7eT8ILXi6j1Z8brTfx9uePBVLr5qgKSSOCpQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nTuhbOjJkGBvHlAjrpzx1KBC4hsjz8uaQV4Gt5byRrkYIQdUXinq24C7M5NPb5Gr3
         MW3TuTH0ZBzlkH2fEVy60n4JzOQropxd9edwbcgbAw4X54fuKv/DwqvGxG6glutC8T
         fKmResDQKi5tnpp8E2JZIhFZkf4ukJlpmmzso1zhdDXNgsLbtUYgdUgPFqAbrqLeZ1
         tGaAbPgVXKpCl0f//TLUpfU1lVhQsCb9ms6PBNoYdj8+Y04OQHJndY6uITSrpi0dz6
         E7Y/IUk2dOb8u52UwVth4zQ9eTqlMdbKRFvHVsvtpa2dlDdr5Utx5aK7FlYh5ws/F0
         J7FQl0ol1SRqg==
Subject: [PATCH 7/8] tools: add missing license tags to my scripts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Thu, 16 Sep 2021 17:39:41 -0700
Message-ID: <163183918129.952957.5168047119911636649.stgit@magnolia>
In-Reply-To: <163183914290.952957.11558799225344566504.stgit@magnolia>
References: <163183914290.952957.11558799225344566504.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

I forgot to add spdx license tags and copyright statements to some of
the tools that I've contributed to fstests.  Fix this to be explicit.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 tools/mkgroupfile |    4 +++-
 tools/mvtest      |    5 ++++-
 tools/nextid      |    4 +++-
 3 files changed, 10 insertions(+), 3 deletions(-)


diff --git a/tools/mkgroupfile b/tools/mkgroupfile
index e4244507..634ec92c 100755
--- a/tools/mkgroupfile
+++ b/tools/mkgroupfile
@@ -1,5 +1,7 @@
 #!/bin/bash
-
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
 # Generate a group file from the _begin_fstest call in each test.
 
 if [ "$1" = "--help" ]; then
diff --git a/tools/mvtest b/tools/mvtest
index 5088b45f..99b15414 100755
--- a/tools/mvtest
+++ b/tools/mvtest
@@ -1,6 +1,9 @@
 #!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2015 Oracle.  All Rights Reserved.
+#
+# Move a test and update the golden output file.
 
-# Renumber a test
 dir="$(dirname "$0")"
 
 if [ -z "$1" ] || [ "$1" = "--help" ]; then
diff --git a/tools/nextid b/tools/nextid
index 9507de29..9e31718c 100755
--- a/tools/nextid
+++ b/tools/nextid
@@ -1,5 +1,7 @@
 #!/bin/bash
-
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2015 Oracle.  All Rights Reserved.
+#
 # Compute the next available test id in a given test directory.
 
 if [ $# != 1 ] || [ "$1" = "--help" ] || [ ! -d "tests/$1/" ]; then

