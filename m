Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB940C07E9C
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 00:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5A8061CAD
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 00:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhGGAYZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jul 2021 20:24:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229873AbhGGAYZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Jul 2021 20:24:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6BB161C91;
        Wed,  7 Jul 2021 00:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625617305;
        bh=8+V/k9laNcuwuCM0X8S6pZTJufyL0kJq/7Qgp0n2Mec=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WM58MUdJdZIOpjbSD41LaGIkvKwjd0sQ8LYWRZnHprXYiC+rby0i+RntEviEB8NvC
         TIBs6mPvkZEZ9G2qYfgJ/8nZEFAv1iPXadCqy3kpTiJXAjExy8DT5VpM6+owVmC3kR
         it4l+JosXvA4Jtt67t/P2dmNNcif1KTrEANEXadX7LF/Y/y5Uc8mYDJ6JhjtyWycUc
         pb+XF+DT9Zb26D+xxLEu3xOK9fE4MeLN2kKC9O78wav1sROK55lp4C4g06w19CygWr
         tYqwgLT1lVi0a5z/dtsFPo9eMMg9XKDxx6KeymGQFSgMsR9UuXxEHTmAyVWCvYGYKC
         86bCG9NIyVbFw==
Subject: [PATCH 7/8] generic/371: disable speculative preallocation
 regressions on XFS
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 06 Jul 2021 17:21:45 -0700
Message-ID: <162561730547.543423.5029188797370208051.stgit@locust>
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

Once in a very long while, the fallocate calls in this test will fail
due to ENOSPC conditions.  While in theory this test is careful only to
allocate at most 160M of space from a 256M filesystem, there's a twist
on XFS: speculative preallocation.

The first loop in this test is an 80M appending write done in units of
4k.  Once the file size hits 64k, XFS will begin speculatively
preallocating blocks past the end of the file; as the file grows larger,
so will the speculative preallocation.

Since the pwrite/rm loop races with the fallocate/rm loop, it's possible
that the fallocate loop will free that file just before the buffered
write extends the speculative preallocation out to 160MB.  With fs and
log overhead, that doesn't leave enough free space to start the 80MB
fallocate request, which tries to avoid disappointing the caller by
freeing all speculative preallocations.  That fails if the pwriter
thread owns the IOLOCK on $testfile1, so fallocate returns ENOSPC and
the test fails.

The simple solution here is to disable speculative preallocation by
setting an extent size hint if the fs is XFS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/371 |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/tests/generic/371 b/tests/generic/371
index c94fa85e..a2fdaf7b 100755
--- a/tests/generic/371
+++ b/tests/generic/371
@@ -18,10 +18,18 @@ _begin_fstest auto quick enospc prealloc
 _supported_fs generic
 _require_scratch
 _require_xfs_io_command "falloc"
+test "$FSTYP" = "xfs" && _require_xfs_io_command "extsize"
 
 _scratch_mkfs_sized $((256 * 1024 * 1024)) >> $seqres.full 2>&1
 _scratch_mount
 
+# Disable speculative post-EOF preallocation on XFS, which can grow fast enough
+# that a racing fallocate then fails.
+if [ "$FSTYP" = "xfs" ]; then
+	alloc_sz="$(_get_file_block_size $SCRATCH_MNT)"
+	$XFS_IO_PROG -c "extsize $alloc_sz" $SCRATCH_MNT >> $seqres.full
+fi
+
 testfile1=$SCRATCH_MNT/testfile1
 testfile2=$SCRATCH_MNT/testfile2
 

