Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D549C07E9C
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 00:21:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74E6761CB3
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 00:21:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhGGAXw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jul 2021 20:23:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229873AbhGGAXw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Jul 2021 20:23:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C027761CAC;
        Wed,  7 Jul 2021 00:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625617272;
        bh=LgYaZN4M2MNTfb/b/VqXPJGc/4nMrpa9oSJ5ivd44/c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pqX2RzXK6OlQcUx8pokSWw90s8F23HyjeKR0a3l/+knGqXlbfV5dyjlQx8xOFc/cz
         o5gnWE8tqHIKWCi6qPMhKwVUqU7xvBSAMnFLVkpTGA4c9f5+MFcdpbdWH3ybcHH53r
         STlc+rZ5ouWb7DECArOFs2R3a5jMovUJcxGkDkQgefZSfLk6+PCxqB4wsLah27yLee
         dynbNkXLWq4BOzRi+L+lm6xnln9uFewT4RyCC8xastOIky8PkxJYZpinFDyqLUPtJb
         FYhtL/Iop9KtGeaP5xob2oH6XGErHTNxAFr+5Fw+X1SGCIVbXCqezq33gPg7pJsUzK
         5Dv19+j0K03ow==
Subject: [PATCH 1/8] xfs/172: disable test when file writes don't use delayed
 allocation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 06 Jul 2021 17:21:12 -0700
Message-ID: <162561727244.543423.13321546742830675478.stgit@locust>
In-Reply-To: <162561726690.543423.15033740972304281407.stgit@locust>
References: <162561726690.543423.15033740972304281407.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test tries to exploit an interaction between delayed allocation and
writeback on full filesystems to see if it can trip up the filestreams
allocator.  The behaviors do not present if the filesystem allocates
space at write time, so disable it under these scenarios.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/172 |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/172 b/tests/xfs/172
index 0d1b441e..c0495305 100755
--- a/tests/xfs/172
+++ b/tests/xfs/172
@@ -16,9 +16,37 @@ _begin_fstest rw filestreams
 
 # real QA test starts here
 _supported_fs xfs
-
+_require_command "$FILEFRAG_PROG" filefrag
 _require_scratch
 
+# The first _test_streams call sets up the filestreams allocator to fail and
+# then checks that it actually failed.  It does this by creating a very small
+# filesystem, writing a lot of data in parallel to separate streams, and then
+# flushes the dirty data, also in parallel.  To trip the allocator, the test
+# relies on writeback combining adjacent dirty ranges into large allocation
+# requests which eventually bleed across AGs.  This happens either because the
+# big writes are slow enough that filestreams contexts expire between
+# allocation requests, or because the AGs are so full at allocation time that
+# the bmapi allocator decides to scan for a less full AG.  Either way, stream
+# directories share AGs, which is what the test considers a success.
+#
+# However, this only happens if writes use the delayed allocation code paths.
+# If the kernel allocates small amounts of space at the time of each write()
+# call, the successive small allocations never trip the bmapi allocator's
+# rescan thresholds and will keep pushing out the expiration time, with the
+# result that the filestreams allocator succeeds in maintaining the streams.
+# The test considers this a failure.
+#
+# Make sure that a regular buffered write produces delalloc reservations.
+# This effectively disables the test for files with extent size hints or DAX
+# mode set.
+_scratch_mkfs > $seqres.full
+_scratch_mount
+$XFS_IO_PROG -f -c 'pwrite 0 64k' $SCRATCH_MNT/testy &> /dev/null
+$FILEFRAG_PROG -v $SCRATCH_MNT/testy 2>&1 | grep -q delalloc || \
+	_notrun "test requires delayed allocation buffered writes"
+_scratch_unmount
+
 _check_filestreams_support || _notrun "filestreams not available"
 
 # test reaper works by setting timeout low. Expected to fail

