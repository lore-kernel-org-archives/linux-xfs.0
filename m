Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8592C48BE5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 23:10:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A921A60FDB
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 23:10:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhFUXNF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Jun 2021 19:13:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231246AbhFUXNF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Jun 2021 19:13:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A49E061042;
        Mon, 21 Jun 2021 23:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624317050;
        bh=j1QIAiCE+FD29sBmZuDMQ5N/OGckrJP81XxwkXsQ8p0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Euqc9gV/HGF93+nMH/gbTy3TJjjk5cAjTus/BiocyDseEp5I7jXRQJC5HfMUWoFlo
         yAbcLPtwnWU62xULAb4RY3CFfWYuArP5fas5RRmK6en1/B1B4c13O21NFeZhS73rQA
         /CrO6gOzZnkGvS/hSaVJc0H0YUv1RMOe4QYiy7pW5GZi/ZE7vQd9Aohv2i5WXjrqIa
         ZAXCc6U+67tZwnHNuWNvOli54Z5KRvvjDDc2pGmR6OE9YgCvwTfF7oVysoycLIGNfA
         8CTgDQm4gRuNKmdVuiL9wRxp842dkjIw5jPWHbpHJDF1c/CGiOee3vxx6h+/r2yOEA
         geYuwLFn2Phow==
Subject: [PATCH 08/13] fstests: convert nextid to use automatic group
 generation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Eric Biggers <ebiggers@google.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, amir73il@gmail.com,
        ebiggers@kernel.org
Date:   Mon, 21 Jun 2021 16:10:50 -0700
Message-ID: <162431705041.4090790.3664142527610163884.stgit@locust>
In-Reply-To: <162431700639.4090790.11684371602638166127.stgit@locust>
References: <162431700639.4090790.11684371602638166127.stgit@locust>
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
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
---
 tools/nextid |    1 -
 tools/nextid |   31 +++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 1 deletion(-)
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
index 00000000..9507de29
--- /dev/null
+++ b/tools/nextid
@@ -0,0 +1,31 @@
+#!/bin/bash
+
+# Compute the next available test id in a given test directory.
+
+if [ $# != 1 ] || [ "$1" = "--help" ] || [ ! -d "tests/$1/" ]; then
+	echo "Usage: $0 test_dir"
+	exit 1
+fi
+
+. ./common/test_names
+
+i=0
+eof=1
+
+while read found other_junk;
+do
+	i=$((i+1))
+	id=`printf "%03d" $i`
+	if [ "$id" != "$found" ]; then
+		eof=0
+		break
+	fi
+done < <(cd "tests/$1/" ; ../../tools/mkgroupfile | \
+	 grep "^$VALID_TEST_NAME\>" | tr - ' ')
+
+if [ $eof -eq 1 ]; then
+   i=$((i+1))
+   id=`printf "%03d" $i`
+fi
+
+echo "$1/$id"

