Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 792D3C38147
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 00:55:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjARAzz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Jan 2023 19:55:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbjARAzL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2023 19:55:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B1C530CA;
        Tue, 17 Jan 2023 16:43:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1525B81A85;
        Wed, 18 Jan 2023 00:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58871C433D2;
        Wed, 18 Jan 2023 00:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674002565;
        bh=nuQWmBjgfsOLI56ZOT417vwv86d4VyIVOLPSiBtr8/g=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=m2rV3p0Ll1O3Gf2ijjDZzrUjfqfPa5jRtSKhQuzfUF2MSdoq4offxbaPHmQQYPf7h
         4e6RJ32q4ppyqnyRiA1pceBEnOaoMB6EO9gBkaL++EFmmQra9oH+MsscTex/YX/Uk+
         UGhapA0V33x0vBEJeP5oAW6niouARsB4PEeMzUbcxqlJaN0Zv7ync+UynMkHcplhgj
         zYyNLycr0rwSFitHjexb0LNSxQ9IUKzurKU1AArDIzOHOgnuyJtXrO+vLqwduZlhPe
         seY/bZ+f7xXSscj0fbM9lM8OxPCrMDB2CRvzTParLZhLpcn70rzPjMw/uXXv9Ayrog
         AcI5C+ngSuuXg==
Date:   Tue, 17 Jan 2023 16:42:44 -0800
Subject: [PATCH 3/3] xfs/182: fix spurious direct write failure
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        yangx.jy@fujitsu.com
Message-ID: <167400102485.1914858.8399289411855614483.stgit@magnolia>
In-Reply-To: <167400102444.1914858.13132645140135239531.stgit@magnolia>
References: <167400102444.1914858.13132645140135239531.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test has some weird behavior that causes regressions when fsdax and
reflink are enabled.  The goal of this test is to set a cow extent size
hint, perform some random directio writes, perform a directio rewrite of
the entire file, and make sure that the file content (and extent count)
are sane afterwards.

Most of the time, the random directio writes will never touch the
8388609th byte, though if they do randomly select that EOF block, they'd
end up extending the file by $real_blksz bytes and causing spurious test
failures.

Then, the rewrite does this:

pwrite -S 0x63 -b $real_blksz 0 $((filesize + 1))

Note that we previously set filesize=8388608, which means that we're
asking for a series of direct writes that fill the first 8388608 bytes
with 'c'.  The last write in the series becomes a single byte direct
write.  For regular file access mode, this last write will fail with
EINVAL, since block devices do not support byte granularity writes and
XFS does not fall back to the pagecache for unaligned direct wites.
Hence we never wrote the 8388609th byte of the file.

However, fsdax *does* allow byte-granularity direct writes, which means
that the single-byte write succeeds.  There is no EINVAL return code,
and the 8388609th byte of the file is now 'c' instead of 'a'.  As a
result, the md5 of file2 is different.

Since fsdax+reflink is the newcomer, amend the direct writes in this
test so that they always end at the 8388608th byte, since we were never
really testing that last byte anyway.  This makes the test behavior
consistent across both access modes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/182     |    4 ++--
 tests/xfs/182.out |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/182 b/tests/xfs/182
index ec3f7dc026..696b933e60 100755
--- a/tests/xfs/182
+++ b/tests/xfs/182
@@ -55,9 +55,9 @@ md5sum $testdir/file2 | _filter_scratch
 
 echo "CoW and unmount"
 $XFS_IO_PROG -f -c "cowextsize" $testdir/file2 >> $seqres.full
-$XFS_IO_PROG -d -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $((filesize + 1))" \
+$XFS_IO_PROG -d -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $filesize" \
 	$testdir/file2 2>&1 >> $seqres.full | _filter_xfs_io_error
-$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $real_blksz 0 $((filesize + 1))" \
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $real_blksz 0 $filesize" \
 	$testdir/file2 2>&1 >> $seqres.full | _filter_xfs_io_error
 _scratch_cycle_mount
 
diff --git a/tests/xfs/182.out b/tests/xfs/182.out
index 41384437ad..8821bcd5bd 100644
--- a/tests/xfs/182.out
+++ b/tests/xfs/182.out
@@ -5,7 +5,6 @@ Compare files
 2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-182/file1
 2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-182/file2
 CoW and unmount
-pwrite: Invalid argument
 Compare files
 2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-182/file1
 c6ba35da9f73ced20d7781a448cc11d4  SCRATCH_MNT/test-182/file2

