Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79597C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 02:57:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D53064E5B
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 02:57:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbhBJC5l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 21:57:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:41580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229711AbhBJC5l (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Feb 2021 21:57:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 178FF64E57;
        Wed, 10 Feb 2021 02:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612925808;
        bh=mKLdF+O/j+lZIRBYEjFisyQ5SZBwAAOF9OS7bORd83w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=W4ELMoV3rQPRqWolYHpNiCKmQB5KbGc9tidvVa9kZ1l2/3rINlmg1pN5ZSu4v49Kq
         oo+7hS1Wwod/fz+aa+PVjgEfkzvdg0HgYW5luC3sPtBMJ6RuLkGK8/Syw6UZBnEESV
         ASrwgqnvpSUwyLcausQG0Z9KtD7MHoHheXp4i9ooxA4agvTkOOAN93/C/+Rdu+4aku
         ZzimA2e9gFZLduh120+Svot8oG7Ll1IkZbvLAGl81i+W6N8fl1PpMFEZaPGsFg44Dw
         4THHNGyncOhbB/Dj0PXOX/7q3VXLDsbBGi/rfUQpDbTVdJXrbLgcTe//rlMqyOuaHe
         Phfo6xif+MJSg==
Subject: [PATCH 5/6] check: run tests in exactly the order specified
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 09 Feb 2021 18:56:47 -0800
Message-ID: <161292580772.3504537.14460569826738892955.stgit@magnolia>
In-Reply-To: <161292577956.3504537.3260962158197387248.stgit@magnolia>
References: <161292577956.3504537.3260962158197387248.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Introduce a new --exact-order switch to disable all sorting, filtering
of repeated lines, and shuffling of test order.  The goal of this is to
be able to run tests in a specific order, namely to try to reproduce
test failures that could be the result of a -r(andomize) run getting
lucky.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 check |   36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)


diff --git a/check b/check
index 6f8db858..106ec8e1 100755
--- a/check
+++ b/check
@@ -20,6 +20,7 @@ diff="diff -u"
 showme=false
 have_test_arg=false
 randomize=false
+exact_order=false
 export here=`pwd`
 xfile=""
 subdir_xfile=""
@@ -67,6 +68,7 @@ check options
     -n			show me, do not run tests
     -T			output timestamps
     -r			randomize test order
+    --exact-order	run tests in the exact order specified
     -i <n>		iterate the test list <n> times
     -d			dump test output to stdout
     -b			brief test summary
@@ -249,17 +251,22 @@ _prepare_test_list()
 		trim_test_list $list
 	done
 
-	# sort the list of tests into numeric order
-	if $randomize; then
-		if type shuf >& /dev/null; then
-			sorter="shuf"
+	# sort the list of tests into numeric order unless we're running tests
+	# in the exact order specified
+	if ! $exact_order; then
+		if $randomize; then
+			if type shuf >& /dev/null; then
+				sorter="shuf"
+			else
+				sorter="awk -v seed=$RANDOM -f randomize.awk"
+			fi
 		else
-			sorter="awk -v seed=$RANDOM -f randomize.awk"
+			sorter="cat"
 		fi
+		list=`sort -n $tmp.list | uniq | $sorter`
 	else
-		sorter="cat"
+		list=`cat $tmp.list`
 	fi
-	list=`sort -n $tmp.list | uniq | $sorter`
 	rm -f $tmp.list
 }
 
@@ -304,7 +311,20 @@ while [ $# -gt 0 ]; do
 	-udiff)	diff="$diff -u" ;;
 
 	-n)	showme=true ;;
-        -r)	randomize=true ;;
+	-r)
+		if $exact_order; then
+			echo "Cannot specify -r and --exact-order."
+			exit 1
+		fi
+		randomize=true
+		;;
+	--exact-order)
+		if $randomize; then
+			echo "Cannnot specify --exact-order and -r."
+			exit 1
+		fi
+		exact_order=true
+		;;
 	-i)	iterations=$2; shift ;;
 	-T)	timestamp=true ;;
 	-d)	DUMP_OUTPUT=true ;;

