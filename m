Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A85C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:43:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ADE5610E8
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbhIOXog (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:44:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233088AbhIOXof (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:44:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E115A60F25;
        Wed, 15 Sep 2021 23:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631749396;
        bh=Aem0n8k7yKOwaFfh9ieEOEKzi9tgK38YiIxKjHcKQ9I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EBL+kcdy3r+/6okeGFip45zqf6USP6b1kGZQ+ksOs9ZKqkEjSCJQAnd9Nk1yW6Smb
         Q26rtsTpRbweJRaOEi1fj0ZN0CRAx++IRWmcOHpV2WljGTHZ3F+hQGOn7Np8wa21Re
         LLKxhnzxbDHdQVpJiMx7zA5uzzZy99wjJOWFunl3jQyYp3lQKC2NKxr+B8R+iojtRX
         CFnKCjmUFlSRqExkbp7cYXnb0ynqvKfS5DcMFoX9rFZszPBTmik6AGJQsEiKR57KKg
         Is+OvFFwKwhaRJFPB6X3uwD1qlNCi9Fg52LkcPS0XYp1nPbAU9QIvvffJDgmi6/uU8
         WxyOJCSq9N0eg==
Subject: [PATCH 7/9] tools: add missing license tags to my scripts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 15 Sep 2021 16:43:15 -0700
Message-ID: <163174939566.380880.290670167130749389.stgit@magnolia>
In-Reply-To: <163174935747.380880.7635671692624086987.stgit@magnolia>
References: <163174935747.380880.7635671692624086987.stgit@magnolia>
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

