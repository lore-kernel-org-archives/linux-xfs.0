Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CE0CC48BE8
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 20:59:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2272260241
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 20:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234771AbhFNVBT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Jun 2021 17:01:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234749AbhFNVBT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Jun 2021 17:01:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20289601FC;
        Mon, 14 Jun 2021 20:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623704356;
        bh=FEL8XTixjkY2A3w2oxrbvmQcJhPYYl1h4R1vdJeateo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=td45/oogispMr87ks2ljTKRI5RdOiqj1khE/fGYVHhjOYWFVQgJWjShKtBpzsiaKD
         7KgdExZq+puKz1/FONbpvAJXcZfhNQ8YHJMAfFmK/KSrSoyrBqfrDExP814KDVOzzW
         rbV7Jlp+aMZthXz+w7NWFpy6rYehSEKm/FavdA7QvGEqBNVs88zEEXw8SpRPf54hAW
         PHaKxjuE2UEuOc55er2a+A4cK7kc6YYEsE4XVk4OMEFcJ0UG6wOxdu+4qQ6LOGiXWl
         J0QkxNOOCzB3Ufd9YNrbw0PuM1zQXkBe0jEhFbWI3ONN3rgSfSFp+nDPIyPyMiDces
         O1+X7aOT8h6Wg==
Subject: [PATCH 03/13] fstests: refactor test boilerplate code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
Date:   Mon, 14 Jun 2021 13:59:15 -0700
Message-ID: <162370435585.3800603.509157515145342966.stgit@locust>
In-Reply-To: <162370433910.3800603.9623820748404628250.stgit@locust>
References: <162370433910.3800603.9623820748404628250.stgit@locust>
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
---
 common/preamble |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 new             |   33 ++++++++++++---------------------
 2 files changed, 61 insertions(+), 21 deletions(-)
 create mode 100644 common/preamble


diff --git a/common/preamble b/common/preamble
new file mode 100644
index 00000000..eafce487
--- /dev/null
+++ b/common/preamble
@@ -0,0 +1,49 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+
+# Boilerplate fstests functionality
+
+# Standard cleanup function.  Individual tests should override this.
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
+# Initialize the global seq, seqres, here, tmp, and status variables to their
+# defaults.  Group memberships are the only arguments to this helper.
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
 

