Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 402D2C4320A
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 00:12:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2929661056
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 00:12:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243219AbhIAANb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 20:13:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243242AbhIAANb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Aug 2021 20:13:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D0E261008;
        Wed,  1 Sep 2021 00:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630455155;
        bh=5zEHfJY16KIaUJlnHuFtMeQ8taovR8wySqvC4DeuyN8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=f1/NkFb+ex7p2pAEFGhG+cub4S1pgbYUsTX0oF9Twyk/MfjtvXU+OiIHAn5VkKaoe
         JpSsOacx58ZzoM/SRcb8syi6jbk8SQAWPHktackiShxYmcV5kEgxK+8dUw6OB03hYE
         t8pZJpjd14Dg7uwMx6sSb0lxPjAy3A/M3a1e2owAfeDue8u2KLIdEv49+AvSrnQh6E
         +CFYc/Bxk3SQbY6s9BnQhs5DTy2+27+oRMycVVtPG+2SDAqv49PSWrkKOFwqwn1qSd
         lRx/x+1j848FmfCuK+Dhph7TPuRbrZODGOJUoHO1dNQyg7pV8syuIf/hI8IblOi+dK
         mx8eESeS5jXNg==
Subject: [PATCH 1/5] ceph: re-tag copy_file_range as being in the copy_range
 group
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 31 Aug 2021 17:12:35 -0700
Message-ID: <163045515529.771564.6600748735943731783.stgit@magnolia>
In-Reply-To: <163045514980.771564.6282165259140399788.stgit@magnolia>
References: <163045514980.771564.6282165259140399788.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

copy_range is the group name for copy_file_range tests, so reclassify
these tests.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/ceph/001 |    2 +-
 tests/ceph/002 |    2 +-
 tests/ceph/003 |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/tests/ceph/001 b/tests/ceph/001
index aca77168..c00de308 100755
--- a/tests/ceph/001
+++ b/tests/ceph/001
@@ -11,7 +11,7 @@
 # file and 3) the middle of the dst file.
 #
 . ./common/preamble
-_begin_fstest auto quick copy
+_begin_fstest auto quick copy_range
 
 # get standard environment
 . common/filter
diff --git a/tests/ceph/002 b/tests/ceph/002
index 428f23a9..9bc728fd 100755
--- a/tests/ceph/002
+++ b/tests/ceph/002
@@ -20,7 +20,7 @@
 #   linux kernel: 78beb0ff2fec ("ceph: use copy-from2 op in copy_file_range")
 #
 . ./common/preamble
-_begin_fstest auto quick copy
+_begin_fstest auto quick copy_range
 
 # get standard environment
 . common/filter
diff --git a/tests/ceph/003 b/tests/ceph/003
index 9f8c6068..faedb48c 100755
--- a/tests/ceph/003
+++ b/tests/ceph/003
@@ -7,7 +7,7 @@
 # Test copy_file_range with infile = outfile
 #
 . ./common/preamble
-_begin_fstest auto quick copy
+_begin_fstest auto quick copy_range
 
 # get standard environment
 . common/filter

