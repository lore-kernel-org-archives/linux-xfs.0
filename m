Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 870A8C48BE5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 23:11:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BC1761164
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 23:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbhFUXNd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Jun 2021 19:13:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229940AbhFUXNd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Jun 2021 19:13:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B20560FDB;
        Mon, 21 Jun 2021 23:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624317078;
        bh=RBgGjR8MqmSWxCz2laOBal2KjAL98OKmL2um+YiU6Sw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XBKMy4VXA5KhWMo+RwSUdBkOn0jKi+myWyRIEM6SpEUUE2QfFLzuLNe+jnoF94xeI
         ikryqWLWDnzSKvwz+nvTDm1Nw1vDPIDnnLPFwI9kB7K7ZOQZtEEUBEZ3cBpeETvAgL
         ZJSLzFGOhhnj5VMEj6gUj+HvEHGvHEoEpi247nAbSwydNqjEWUqm7P8nlutHjIHau2
         NsI/IYlR2gTuvv48PcCMc+lgCLbEOGi7kNxd7FEJBt9FeqYmsYj9+8ylVcKccqYwUK
         Tz4ho3c10N/VtNOXNo2YbFG/rJwm0QX3mm3ggaLIP1ZsGClMKP/MHjAJ5MU62mktxE
         nS/iosUrE0nCg==
Subject: [PATCH 13/13] misc: update documentation to reflect auto-generated
 group files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
Date:   Mon, 21 Jun 2021 16:11:17 -0700
Message-ID: <162431707787.4090790.4406716516462715301.stgit@locust>
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

Update the documentation to outline the new requirements for test files
so that we can generate group files during build.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 README |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)


diff --git a/README b/README
index 048491a6..18f7a6bc 100644
--- a/README
+++ b/README
@@ -140,7 +140,8 @@ Running tests:
     - ./check '*/001' '*/002' '*/003'
     - ./check '*/06?'
     - Groups of tests maybe ran by: ./check -g [group(s)]
-      See the 'group' file for details on groups
+      See the tests/*/group.list files after building xfstests to learn about
+      each test's group memberships.
     - If you want to run all tests regardless of what group they are in
       (including dangerous tests), use the "all" group: ./check -g all
     - To randomize test order: ./check -r [test(s)]
@@ -174,8 +175,8 @@ Test script environment:
 
     When developing a new test script keep the following things in
     mind.  All of the environment variables and shell procedures are
-    available to the script once the "common/rc" file has been
-    sourced.
+    available to the script once the "common/preamble" file has been
+    sourced and the "_begin_fstest" function has been called.
 
      1. The tests are run from an arbitrary directory.  If you want to
 	do operations on an XFS filesystem (good idea, eh?), then do
@@ -249,6 +250,22 @@ Test script environment:
 	  in the ./new script. It can contain only alphanumeric characters
 	  and dash. Note the "NNN-" part is added automatically.
 
+     6. Test group membership: Each test can be associated with any number
+	of groups for convenient selection of subsets of tests.  Group names
+	can be any sequence of non-whitespace characters.  Test authors
+	associate a test with groups by passing the names of those groups as
+	arguments to the _begin_fstest function.  For example, the code:
+
+	_begin_fstest auto quick subvol snapshot
+
+	associates the current test with the "auto", "quick", "subvol", and
+	"snapshot" groups.  It is not necessary to specify the "all" group
+	in the list because that group is computed at run time.
+
+	The build process scans test files for _begin_fstest invocations and
+	compiles the group list from that information.  In other words, test
+	files must call _begin_fstest or they will not be run.
+
 Verified output:
 
     Each test script has a name, e.g. 007, and an associated

