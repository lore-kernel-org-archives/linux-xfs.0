Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A339CC4707F
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 01:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CD4A6142B
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 01:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhEZBsw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 21:48:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229978AbhEZBsv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 May 2021 21:48:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4168661090;
        Wed, 26 May 2021 01:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621993641;
        bh=khHFOakyVAycf+dzTmFEyfVyWAUYUtbw+YMeiqeiJ9w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TfGx4Cz+VxTJamueH8Hl0QEaGd+2ECrNquB2HMchgB7lA6ar3IiPyta+P73DzFdSP
         fd/NUMJJoI3Ts85AgmJeb1IQNa44vBa+A5GIRhMIntVwmSxMtBjWVidjpwA7X8bx5T
         o5SAZ5NCq1phKAJwcZ0TNIqf24+w2sWoc3WZe3e8m/+07SEX0VZau5YC1P542+kzPZ
         e/3MUZdUW0teWvmpVgfxvemrJ5BHFObq6sCUGOjoG3aHKeYy+yVaKjxaQz0ovyNyS5
         1nA+dIGO9CkqhD68qhI0ohkCMtFozDdOMsIH4C7qyks2TDhOpaanTPTqL+3ptkxJBr
         UGNiJD5XOoB3g==
Subject: [PATCH 07/10] fstests: convert nextid to use automatic group
 generation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 25 May 2021 18:47:21 -0700
Message-ID: <162199364100.3744214.14784708959397955973.stgit@locust>
In-Reply-To: <162199360248.3744214.17042613373014687643.stgit@locust>
References: <162199360248.3744214.17042613373014687643.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert the nextid script to use the automatic group file generation to
figure out the next available test id.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tools/nextid |    1 -
 tools/nextid |   39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 1 deletion(-)
 delete mode 120000 tools/nextid
 create mode 100755 tools/nextid


diff --git a/tools/nextid b/tools/nextid
deleted file mode 120000
index 5c31d602..00000000
--- a/tools/nextid
+++ /dev/null
@@ -1 +0,0 @@
-sort-group
\ No newline at end of file
diff --git a/tools/nextid b/tools/nextid
new file mode 100755
index 00000000..a65348e8
--- /dev/null
+++ b/tools/nextid
@@ -0,0 +1,39 @@
+#!/bin/bash
+
+# Compute the next available test id in a given test directory.
+
+if [ -z "$1" ] || [ "$1" = "--help" ] || [ -n "$2" ] || [ ! -d "tests/$1/" ]; then
+	echo "Usage: $0 test_dir"
+	exit 1
+fi
+
+. ./common/test_names
+
+line=0
+i=0
+eof=1
+
+while read found other_junk;
+do
+	line=$((line+1))
+	if [ -z "$found" ] || [ "$found" == "#" ]; then
+		continue
+	elif ! echo "$found" | grep -q "^$VALID_TEST_NAME$"; then
+		# this one is for tests not named by a number
+		continue
+	fi
+	i=$((i+1))
+	id=`printf "%03d" $i`
+	if [ "$id" != "$found" ]; then
+		eof=0
+		break
+	fi
+done < <(cd "tests/$1/" ; ../../tools/mkgroupfile | tr - ' ')
+
+if [ $eof -eq 1 ]; then
+   line=$((line+1))
+   i=$((i+1))
+   id=`printf "%03d" $i`
+fi
+
+echo "$1/$id"

