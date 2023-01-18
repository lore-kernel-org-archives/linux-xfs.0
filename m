Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C549C00A5A
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 00:56:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjARA4v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Jan 2023 19:56:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjARA4H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2023 19:56:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD31253F9A;
        Tue, 17 Jan 2023 16:43:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A729A6159F;
        Wed, 18 Jan 2023 00:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2E6C433EF;
        Wed, 18 Jan 2023 00:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674002612;
        bh=k9B1yMSPPgwPTCdmLCZKzXMwT/SeamJUv2emMzpV4Bw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Tqco34qTFzx95y7ZnRHxY1LMlovFK0K/n6r8JudkR26uNW9H0qAVrz9avpKhtaM0q
         ZiyLTaB8o5Hnhihtwp+I5sBOcVGRRPge1H6eeXBnIq0JwCRpzUE5kuPB/gRgzgce28
         gQRgkiheslxONrVXddRctMXAeWbM/cHPn2puUmjAQrqi2RQzAz5D1Va8jA/yoZBrXV
         09Pxt0FHpTje0gLLFibye3uTfmdNlK3lx2F0BoX8ZgLFB1X6VTA4HBmKLEWgknZAbm
         unpL182ucBsxT3EyLdL7ycObeQ2ZoneQ79hn0ZgzvPvXxbYaEj6sbWtHEBRL9XwCSi
         MVeIBRxOMa+xQ==
Date:   Tue, 17 Jan 2023 16:43:31 -0800
Subject: [PATCH 3/3] various: test is not appropriate for always_cow mode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167400102786.1914975.17542930173906194035.stgit@magnolia>
In-Reply-To: <167400102747.1914975.6709564559821901777.stgit@magnolia>
References: <167400102747.1914975.6709564559821901777.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When always_cow mode is enabled, thes tests cannot set up the
preconditions for the functionality that they wants to test and should
be skipped.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/392 |   10 ++++++++++
 tests/xfs/326     |   12 ++++++++++++
 tests/xfs/558     |    6 ++++++
 3 files changed, 28 insertions(+)


diff --git a/tests/generic/392 b/tests/generic/392
index ac4014ab0c..c4bb3f4b92 100755
--- a/tests/generic/392
+++ b/tests/generic/392
@@ -28,6 +28,16 @@ _scratch_mkfs >/dev/null 2>&1
 _require_metadata_journaling $SCRATCH_DEV
 _scratch_mount
 
+# This test requires that i_blocks remains unchanged from the start of the
+# check_inode_metadata call until after recovery is complete.  fpunch calls
+# turn into pagecache writes if the arguments are not aligned to the fs
+# blocksize.  If the range being punched is already mapped to a written extent
+# and alwayscow is enabled, i_blocks will increase by the size of the COW
+# staging extent.  This causes stat to report different numbers for %b, which
+# results in a test failure.  Hence do not run this test if XFS is in alwayscow
+# mode.
+test "$FSTYP" = "xfs" && _require_no_xfs_always_cow
+
 testfile=$SCRATCH_MNT/testfile
 
 # check inode metadata after shutdown
diff --git a/tests/xfs/326 b/tests/xfs/326
index 8ab60684bf..ac620fc433 100755
--- a/tests/xfs/326
+++ b/tests/xfs/326
@@ -43,6 +43,18 @@ _scratch_mount >> $seqres.full
 _require_congruent_file_oplen $SCRATCH_MNT $blksz
 $XFS_IO_PROG -c "cowextsize $sz" $SCRATCH_MNT
 
+# This test uses a very large cowextszhint to manipulate the COW fork to
+# contain a large unwritten extent before injecting the error.  The goal is
+# that the write() will succeed, writeback will flush the dirty data to disk,
+# and writeback completion will shut down the filesystem when it tries to
+# remove the staging extent record from the refcount btree.  In other words,
+# this test ensures that XFS always finishes a COW completion it has started.
+#
+# This test isn't compatible with always_cow mode because the hole in the COW
+# fork left by the first write means that writeback tries to allocate a COW
+# staging extent for an unshared extent and trips over the injected error.
+_require_no_xfs_always_cow
+
 echo "Create files"
 _pwrite_byte 0x66 0 $sz $SCRATCH_MNT/file1 >> $seqres.full
 _cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file2
diff --git a/tests/xfs/558 b/tests/xfs/558
index 819faf22bc..9e9b3be867 100755
--- a/tests/xfs/558
+++ b/tests/xfs/558
@@ -114,6 +114,12 @@ _require_xfs_io_error_injection "wb_delay_ms"
 _require_scratch_reflink
 _require_cp_reflink
 
+# This test races writeback of a pure overwrite of a data fork extent against
+# the creation of a speculative COW preallocation.  In alwayscow mode, there
+# are no pure overwrites, which means that a precondition of the test is not
+# satisfied, and this test should be skipped.
+_require_no_xfs_always_cow
+
 _scratch_mkfs >> $seqres.full
 _scratch_mount >> $seqres.full
 

