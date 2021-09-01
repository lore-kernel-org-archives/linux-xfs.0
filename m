Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3804DC43214
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 00:11:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2167E61057
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 00:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242787AbhIAAMS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 20:12:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242522AbhIAAMR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Aug 2021 20:12:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0AC96102A;
        Wed,  1 Sep 2021 00:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630455082;
        bh=6Ov4bLYuAh/RP6YaacHWpKtDapBtk/H0nrw9N9TgA4s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tqm3uiY4XdG20G7aUgH6vlCliu8YCy3ukjIkhzQRg375k1UTfmp2dgjk25f82krB9
         bMNa1+ohpOhwuvbKBvvfWxE5U8U38a+5QDH8e09vIAFYiyhTIe31FCn4iqpVOuUVYB
         foW24RNP1ik3frpIAOPBwdrLE1H7pXtdjRGUkbZfp18GyYIB0bWqYfsbA2m7RRNuH9
         jF152TsA0Qg7vtdGWuEEBIkatO32I08bHLRzirGqGkjTSQQbtg0Hhk2M5zNOkVaLsz
         cHdyaPCEu4oKUsSCy5Oi5oYwUwNjhriQW3bHBKkNxjMXqlXLPLRyA9CH2yMlK/U/1Q
         X+pZ9MBzj3Rwg==
Subject: [PATCH 2/2] generic/643: fix weird problems on 64k-page arm systems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 31 Aug 2021 17:11:21 -0700
Message-ID: <163045508165.769821.10102236634811320096.stgit@magnolia>
In-Reply-To: <163045507051.769821.5924414818977330640.stgit@magnolia>
References: <163045507051.769821.5924414818977330640.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

I noticed the following regression on an arm64 system with 64k pages:

--- generic/643.out
+++ generic/643.out.bad
@@ -1,2 +1,3 @@
 QA output created by 643
+swapon added 960 pages, expected 896
 Silence is golden

Evidently mkswap writes the swapfile header advertising one memory page
less than the size of the file, and on some architectures the kernel
can sometimes grab one page less than what's advertised.  This variance
is weird but tolerable; we simply don't want to see the page count
doubling when the file size doubles.

While we're at it, include the commit id of the fix in the commit
message.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/643     |   33 ++++++++++++++++++++++-----------
 tests/generic/643.out |    2 +-
 2 files changed, 23 insertions(+), 12 deletions(-)


diff --git a/tests/generic/643 b/tests/generic/643
index 2bb9d220..7a1d3ec7 100755
--- a/tests/generic/643
+++ b/tests/generic/643
@@ -4,8 +4,10 @@
 #
 # FS QA Test No. 643
 #
-# Regression test for "mm/swap: consider max pages in iomap_swapfile_add_extent"
-
+# Regression test for commit:
+#
+# 36ca7943ac18 ("mm/swap: consider max pages in iomap_swapfile_add_extent")
+#
 # Xu Yu found that the iomap swapfile activation code failed to constrain
 # itself to activating however many swap pages that the mm asked us for.  This
 # is an deviation in behavior from the classic swapfile code.  It also leads to
@@ -22,6 +24,8 @@ _cleanup()
 	test -n "$swapfile" && swapoff $swapfile &> /dev/null
 }
 
+. ./common/filter
+
 # real QA test starts here
 _supported_fs generic
 _require_scratch_swapfile
@@ -34,29 +38,36 @@ _scratch_mount >> $seqres.full
 swapfile=$SCRATCH_MNT/386spart.par
 _format_swapfile $swapfile 1m >> $seqres.full
 
-swapfile_pages() {
+page_size=$(getconf PAGE_SIZE)
+
+swapfile_blocks() {
 	local swapfile="$1"
 
 	grep "$swapfile" /proc/swaps | awk '{print $3}'
 }
 
 _swapon_file $swapfile
-before_pages=$(swapfile_pages "$swapfile")
+before_blocks=$(swapfile_blocks "$swapfile")
 swapoff $swapfile
 
 # Extend the length of the swapfile but do not rewrite the header.
-# The subsequent swapon should set up 1MB worth of pages, not 2MB.
+# The subsequent swapon should set up 1MB worth of blocks, not 2MB.
 $XFS_IO_PROG -f -c 'pwrite 1m 1m' $swapfile >> $seqres.full
 
 _swapon_file $swapfile
-after_pages=$(swapfile_pages "$swapfile")
+after_blocks=$(swapfile_blocks "$swapfile")
 swapoff $swapfile
 
-# Both swapon attempts should have found the same number of pages.
-test "$before_pages" -eq "$after_pages" || \
-	echo "swapon added $after_pages pages, expected $before_pages"
+# Both swapon attempts should have found approximately the same number of
+# blocks.  Unfortunately, mkswap and the kernel are a little odd -- the number
+# of pages that mkswap writes into the swapfile header is one page less than
+# the file size, and then the kernel itself doesn't always grab all the pages
+# advertised in the header.  Hence we let the number of swap pages increase by
+# two pages.  I'm looking at you, Mr. 64k pages on arm64...
+page_variance=$(( page_size / 512 ))
+_within_tolerance "swap blocks" $after_blocks $before_blocks 0 $page_variance -v
+
+echo "pagesize: $page_size; before: $before_blocks; after: $after_blocks" >> $seqres.full
 
-# success, all done
-echo Silence is golden
 status=0
 exit
diff --git a/tests/generic/643.out b/tests/generic/643.out
index 32f1c629..1b14d66e 100644
--- a/tests/generic/643.out
+++ b/tests/generic/643.out
@@ -1,2 +1,2 @@
 QA output created by 643
-Silence is golden
+swap blocks is in range

