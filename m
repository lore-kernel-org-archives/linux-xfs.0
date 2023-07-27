Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1585DC001DC
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 18:53:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjG0Sx3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 14:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbjG0Sx0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 14:53:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B9C2D73;
        Thu, 27 Jul 2023 11:53:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C754F61E90;
        Thu, 27 Jul 2023 18:53:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07537C433C8;
        Thu, 27 Jul 2023 18:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690484003;
        bh=vILr8bDesldAgFkxolpcXHUQ+sNJBqo8OWeAtFL+XKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a26gqoYe5fJUqOPWKF1gTUSeUoaL/1wKP12ZEq8mc/qQ01VUlQLQzdyi4+BaSFYQJ
         lrxBhiGKp1GAvQEo+PDnrpUak8UXYxEXpwIG16KGEUeK0Rm5cGbPp1Vt2BOKeXrtEw
         ihXe24KH29Qsxuz3P1+Q2J+IlJNPXNMVS4EzZCZjC607PvOsGbJYgTvdLn7Lb6bfpN
         dqoQYkMhDFuMa/vPbzeAhFpSmTnCb7qnE1M5RmbbNtxZeqRngSfgMCLphA3tOBRBRJ
         gWe+fkf/XhcsEzcCHDOn+8Mpzx6R0AHkDnfIADkhZmjScjIgI7oTJoxmfv128dJpN3
         Q6QuSmi6Boepg==
From:   Zorro Lang <zlang@kernel.org>
To:     fstests@vger.kernel.org
Cc:     tytso@mit.edu, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: [RFC PATCH 2/2] fstests: support test template
Date:   Fri, 28 Jul 2023 02:53:15 +0800
Message-Id: <20230727185315.530134-3-zlang@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230727185315.530134-1-zlang@kernel.org>
References: <20230727185315.530134-1-zlang@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The fstests has too many big or small testing groups, and it keeps
growing. It's hard for many users to pick up test cases they need.
Likes the smoketest, soak test, random-load test, integrality test
and so on. So most of users might just run "quick" group, or "auto"
group, or "all" directly each time. Besides the group, there're
some global parameters (e.g. *_FACTOR, SOAK_DURATION, etc) too, so
there're many "portfolios" to use them.

So I think fstests can provide a test template, which is bigger than
group, base on group and global parameters, provide reference about
how to do some kinds of tests.

Some users who are familar with fstests have their own wrappers, they
do different kind of tests by fstests according their experience.
They have their different testing templates, some templates might be
helpful and recommended to others. So I'd like to let fstests provide
a template/ directory and a "-t" option to load template. By this
chance, hope more people can share their great test templates to
others. We can record these templates in fstests, then anyone can use
them directly or refer to them to write their wrapper.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 check               |  8 ++++++++
 templates/smoketest | 16 ++++++++++++++++
 2 files changed, 24 insertions(+)
 create mode 100644 templates/smoketest

diff --git a/check b/check
index 89e7e7bf..7100aae4 100755
--- a/check
+++ b/check
@@ -335,6 +335,14 @@ while [ $# -gt 0 ]; do
 		;;
 	-i)	iterations=$2; shift ;;
 	-I) 	iterations=$2; istop=true; shift ;;
+	-t)
+		source templates/$2
+		if [ $? -ne 0 ];then
+			echo "Cannot import the templates/$2"
+			exit 1
+		fi
+		shift
+		;;
 	-T)	timestamp=true ;;
 	-d)	DUMP_OUTPUT=true ;;
 	-b)	brief_test_summary=true;;
diff --git a/templates/smoketest b/templates/smoketest
new file mode 100644
index 00000000..40a0104b
--- /dev/null
+++ b/templates/smoketest
@@ -0,0 +1,16 @@
+##/bin/bash
+# For infrequent filesystem developers who simply want to run a quick test
+# of the most commonly used filesystem functionality, use this command:
+#
+#     ./check -t smoketest <other config options>
+#
+# This template helps fstests to run several tests to exercise the file I/O,
+# metadata, and crash recovery exercisers for four minutes apiece.  This
+# should complete in approximately 20 minutes.
+
+echo "**********************"
+echo "* A Quick Smoke Test *"
+echo "**********************"
+
+[ -z "$SOAK_DURATION" ] && SOAK_DURATION="4m"
+GROUP_LIST="smoketest"
-- 
2.40.1

