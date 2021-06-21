Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8677FC48BE5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 23:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B0D861042
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 23:10:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhFUXMi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Jun 2021 19:12:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:32790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231303AbhFUXMi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Jun 2021 19:12:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6040460FDB;
        Mon, 21 Jun 2021 23:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624317023;
        bh=svo2yslHV6vLBvNuHy+0po+SdKZ2IoFuEW3kHhvDfM8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bRqrKuKPAjm96MJPfueL6tcKZdRg7+huTR5oV0LKo99mi77dahrcLQ5I44pr1D0jP
         tFIyFbFfnhkI4YZOu8YkdN6lEcg++e29aNbjt8l2PZi1c8ZRnYZnMNZBo2+Usaoe6s
         03lDYBKqjGS0KjXlmTvz4ErLCdGkONc9o9yjZ8v6BPrQbroqso400kvxoUfgT6p1ad
         fnlFyCEcNkNOHLZDQd36OgOrgJwxPsbcwyHWL6LrQN81VVIR/QDFtP5J3RmhvT/sFy
         VvzEhbFd9aCxEHDOVm1oVgsXbRB7zM6/ZKu+MtC+yuHEbohBajcbzAdFb3YB4u6Gyg
         qWbCKbv+Dvurg==
Subject: [PATCH 03/13] fstests: refactor test boilerplate code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Biggers <ebiggers@google.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, amir73il@gmail.com,
        ebiggers@kernel.org
Date:   Mon, 21 Jun 2021 16:10:23 -0700
Message-ID: <162431702312.4090790.12118119463621535575.stgit@locust>
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

Create two new helper functions to deal with boilerplate test code:

A helper function to set the seq and seqnum variables.  We will expand
on this in the next patch so that fstests can autogenerate group files
from now on.

A helper function to register cleanup code that will run if the test
exits or trips over a standard range of signals.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Biggers <ebiggers@google.com>
---
 common/preamble |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 new             |   33 ++++++++++++---------------------
 2 files changed, 67 insertions(+), 21 deletions(-)
 create mode 100644 common/preamble


diff --git a/common/preamble b/common/preamble
new file mode 100644
index 00000000..fba766de
--- /dev/null
+++ b/common/preamble
@@ -0,0 +1,55 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+
+# Boilerplate fstests functionality
+
+# Standard cleanup function.  Individual tests can override this.
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.*
+}
+
+# Install the supplied cleanup code as a signal handler for HUP, INT, QUIT,
+# TERM, or when the test exits.  Extra signals can be specified as subsequent
+# parameters.
+_register_cleanup()
+{
+	local cleanup="$1"
+	shift
+
+	test -n "$cleanup" && cleanup="${cleanup}; "
+	trap "${cleanup}exit \$status" EXIT HUP INT QUIT TERM $*
+}
+
+# Prepare to run a fstest by initializing the required global variables to
+# their defaults, sourcing common functions, registering a cleanup function,
+# and removing the $seqres.full file.
+#
+# The list of group memberships for this test (e.g. auto quick rw) must be
+# passed as arguments to this helper.  It is not necessary to name this test
+# explicitly as a member of the 'all' group.
+_begin_fstest()
+{
+	if [ -n "$seq" ]; then
+		echo "_begin_fstest can only be called once!"
+		exit 1
+	fi
+
+	seq=`basename $0`
+	seqres=$RESULT_DIR/$seq
+	echo "QA output created by $seq"
+
+	here=`pwd`
+	tmp=/tmp/$$
+	status=1	# failure is the default!
+
+	_register_cleanup _cleanup
+
+	. ./common/rc
+
+	# remove previous $seqres.full before test
+	rm -f $seqres.full
+
+}
diff --git a/new b/new
index 357983d9..531fd123 100755
--- a/new
+++ b/new
@@ -153,27 +153,18 @@ cat <<End-of-File >$tdir/$id
 #
 # what am I here for?
 #
-seq=\`basename \$0\`
-seqres=\$RESULT_DIR/\$seq
-echo "QA output created by \$seq"
-
-here=\`pwd\`
-tmp=/tmp/\$\$
-status=1	# failure is the default!
-trap "_cleanup; exit \\\$status" 0 1 2 3 15
-
-_cleanup()
-{
-	cd /
-	rm -f \$tmp.*
-}
-
-# get standard environment, filters and checks
-. ./common/rc
-. ./common/filter
-
-# remove previous \$seqres.full before test
-rm -f \$seqres.full
+. ./common/preamble
+_begin_fstest group list here
+
+# Override the default cleanup function.
+# _cleanup()
+# {
+# 	cd /
+# 	rm -r -f \$tmp.*
+# }
+
+# Import common functions.
+# . ./common/filter
 
 # real QA test starts here
 

