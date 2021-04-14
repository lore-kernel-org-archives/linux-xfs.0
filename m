Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0663FC43460
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 01:05:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E22F5613CE
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 01:05:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348965AbhDNBFl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Apr 2021 21:05:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348955AbhDNBFl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Apr 2021 21:05:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFF00613BD;
        Wed, 14 Apr 2021 01:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618362320;
        bh=g5hpyrx0j8qmL9uXoi8Kt2ksDIykdu4GIn/sovXBWJ8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VB5RL7ug828ZNo/2DrzRzuFUOOuo7YGLPyH90QTCegVIrGp3VoUrEXApeDqsKqj4D
         RVTz4QU/f6yHMHsfKWe5iuNBNYSSDJsfwvJyrfgMHd6fm5M5k7LnYFcLL7XXtYgj5l
         ZBd6roGFJ6wdTkVZeU4T1ZLJ6YLH18tb5rRo1d9pDiq8t0GLdsPll7ncXcdDV8sjwH
         DCzUluOJYObIHhqazr7gSYi5FYw9xpQBwDhJ6ODdtN1yBBbPqp0D2OSiohdPZ+apo1
         sESzkT+NiUgpKWT2a5NzmLS8Po3R/97nDHao0h+u/DTdv/7GnYbXrJV7pRAc4fqJSM
         VbAj0dc/wpDpA==
Subject: [PATCH 8/9] generic/{094,225}: skip test when the xfs rt extent size
 is larger than 1 fsb
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 13 Apr 2021 18:05:20 -0700
Message-ID: <161836232004.2754991.941115577343319256.stgit@magnolia>
In-Reply-To: <161836227000.2754991.9697150788054520169.stgit@magnolia>
References: <161836227000.2754991.9697150788054520169.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

These two tests call various fallocate modes on a file and compare the
FIEMAP output to some golden output.  Unfortunately, the golden output
doesn't take into account the possibility that (on XFS) the files could be
created on a realtime volume with a large rt extent size set.

Under such a configuration, fpunch operations that are aligned to the fs
block size but not the rt extent size simply result in those blocks
being set to unwritten status.  Unfortunately, the test expects holes
and fails.  Therefore, detect the situation and skip the tests.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc         |   10 ++++++++++
 tests/generic/094 |    5 +++++
 tests/generic/225 |    5 +++++
 3 files changed, 20 insertions(+)


diff --git a/common/rc b/common/rc
index bb54df56..b5e930de 100644
--- a/common/rc
+++ b/common/rc
@@ -4062,6 +4062,16 @@ _get_block_size()
 	stat -f -c %S $1
 }
 
+# Require that the fundamental allocation unit of a file is the same as the
+# filesystem block size.
+_require_file_block_size_equals_fs_block_size()
+{
+	local file_alloc_unit="$(_get_file_block_size $1)"
+	local fs_block_size="$(_get_block_size $1)"
+	test "$file_alloc_unit" != "$fs_block_size" && \
+		_notrun "File allocation unit is larger than a filesystem block"
+}
+
 get_page_size()
 {
 	echo $(getconf PAGE_SIZE)
diff --git a/tests/generic/094 b/tests/generic/094
index d371e951..8c292473 100755
--- a/tests/generic/094
+++ b/tests/generic/094
@@ -40,6 +40,11 @@ fiemapfile=$SCRATCH_MNT/$seq.fiemap
 
 _require_test_program "fiemap-tester"
 
+# FIEMAP test doesn't like finding unwritten blocks after it punches out
+# a partial rt extent.
+test "$FSTYP" = "xfs" && \
+	_require_file_block_size_equals_fs_block_size $fiemapfile
+
 seed=`date +%s`
 
 echo "using seed $seed" >> $seqres.full
diff --git a/tests/generic/225 b/tests/generic/225
index 1228a256..fac688df 100755
--- a/tests/generic/225
+++ b/tests/generic/225
@@ -40,6 +40,11 @@ fiemaplog=$SCRATCH_MNT/$seq.log
 
 _require_test_program "fiemap-tester"
 
+# FIEMAP test doesn't like finding unwritten blocks after it punches out
+# a partial rt extent.
+test "$FSTYP" = "xfs" && \
+	_require_file_block_size_equals_fs_block_size $fiemapfile
+
 seed=`date +%s`
 
 echo "using seed $seed" >> $fiemaplog

