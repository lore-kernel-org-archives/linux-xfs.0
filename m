Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC622C4743D
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 17:20:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADB086135D
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 17:20:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbhFHRW1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Jun 2021 13:22:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233149AbhFHRW0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Jun 2021 13:22:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B1D761351;
        Tue,  8 Jun 2021 17:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623172833;
        bh=iKRFafqnyGEZpNjLy/a63WvSEqBjkH1Mx8Nv3TuncEI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eZ/FyIvoqsMY3sWAUwJtPdKBYjUEuJ5/po/FrY66ib6yfDHXD92/sxTggLDuZzakx
         u9HMSraTFxWm00HQwy5/qdBBirkfT8QbBy2e0jFqssa+v6ESEPp7juHD10SX8EGcPQ
         T0cc/6bRz/qaE7a+lwOiP5P3DgzXDIZxxbsRVzyxhcrgt2TfSYQqXxq/kDHK9REpN3
         5gD4cs9oQHD5zSux3g6QmbdBIt6MdNwkIY9X/bQ8wd1D3e2xY0vjsHs1FCQbxZcfK5
         nSMfN/Pprjc2f8bbc3wAf5hv7XL+Nvx3z1nH7B/7ELURMJedea6WIKm4WNwvcrY4bl
         Y3oH3tEBteMfA==
Subject: [PATCH 13/13] misc: update documentation to reflect auto-generated
 group files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
Date:   Tue, 08 Jun 2021 10:20:33 -0700
Message-ID: <162317283324.653489.9381968524443830077.stgit@locust>
In-Reply-To: <162317276202.653489.13006238543620278716.stgit@locust>
References: <162317276202.653489.13006238543620278716.stgit@locust>
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
---
 README |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)


diff --git a/README b/README
index 048491a6..ab298ca9 100644
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
@@ -249,6 +250,18 @@ Test script environment:
 	  in the ./new script. It can contain only alphanumeric characters
 	  and dash. Note the "NNN-" part is added automatically.
 
+     6. Test group membership: Each test can be associated with any number
+	of groups for convenient selection of subsets of tests.  Test names
+	can be any sequence of non-whitespace characters.  Test authors
+	associate a test with groups by passing the names of those groups as
+	arguments to the _begin_fstest function:
+
+	_begin_fstest auto quick subvol snapshot
+
+	The build process scans test files for _begin_fstest invocations and
+	compiles the group list from that information.  In other words, test
+	files must call _begin_fstest or they will not be run.
+
 Verified output:
 
     Each test script has a name, e.g. 007, and an associated

