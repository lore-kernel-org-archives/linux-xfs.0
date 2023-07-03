Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E653DC30654
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Jul 2023 17:03:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjGCRDm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Jul 2023 13:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjGCRDl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jul 2023 13:03:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B533E59;
        Mon,  3 Jul 2023 10:03:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBB9C60FED;
        Mon,  3 Jul 2023 17:03:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3118CC433C8;
        Mon,  3 Jul 2023 17:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688403819;
        bh=nCuTXmKzLMOvOmtyUPDQWvZxLJF+L2sZ+Ks7LgXGHpE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lqbdVfmSkPNQw4F9dvFwMMPIJOtYQSpcCPhPTi8BFZLoD/tO+ymxPZKyXdB8Hkmr7
         RRN2xD+yBbWhTxpTMaVhBQuhNHMM1lkm9nHdZeRH8i4Q/yOtwVv5tGd97RunbMEim4
         6crcJPBin+GLbxBCB7zGhN45nS9EhKoinutS8XrHaA2l5Z5tS4VP4PD4PYkClrK0IK
         yLgLviF8E4RaYonVrEwMWTkpXf0A0OzR/RKny1srQUvOybbmwPMxOdaSTDlWjjFTHR
         S4c/mv4NJXuro4RggVvVuopnG2HsuJa5kWe131TdCJtvOHzUxQblJ9W9phjL/DK0Uv
         61TiaqSkZZQ+w==
Subject: [PATCH 1/5] xfs/529: fix bogus failure when realtime is configured
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 03 Jul 2023 10:03:38 -0700
Message-ID: <168840381873.1317961.17241883212352752910.stgit@frogsfrogsfrogs>
In-Reply-To: <168840381298.1317961.1436890061506567407.stgit@frogsfrogsfrogs>
References: <168840381298.1317961.1436890061506567407.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If I have a realtime volume configured, this test will sometimes trip
over this:

XFS: Assertion failed: nmaps == 1, file: fs/xfs/xfs_dquot.c, line: 360
Call Trace:
 xfs_dquot_disk_alloc+0x3dc/0x400 [xfs 97e1fa8953d397b1fb9732df4de7fa9070bda501]
 xfs_qm_dqread+0xc9/0x190 [xfs 97e1fa8953d397b1fb9732df4de7fa9070bda501]
 xfs_qm_dqget+0xa8/0x230 [xfs 97e1fa8953d397b1fb9732df4de7fa9070bda501]
 xfs_qm_vop_dqalloc+0x160/0x600 [xfs 97e1fa8953d397b1fb9732df4de7fa9070bda501]
 xfs_setattr_nonsize+0x318/0x520 [xfs 97e1fa8953d397b1fb9732df4de7fa9070bda501]
 notify_change+0x30e/0x490
 chown_common+0x13e/0x1f0
 do_fchownat+0x8d/0xe0
 __x64_sys_fchownat+0x1b/0x20
 do_syscall_64+0x2b/0x80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7fa6985e2cae

The test injects the bmap_alloc_minlen_extent error, which refuses to
allocate file space unless it's exactly minlen long.  However, a
precondition of this injection point is that the free space on the data
device must be sufficiently fragmented that there are small free
extents.

However, if realtime and rtinherit are enabled, the punch-alternating
call will operate on a realtime file, which only serves to write 0x55
patterns into the realtime bitmap.  Hence the test preconditions are not
satisfied, so the test is not serving its purpose.

Fix it by disabling rtinherit=1 on the rootdir so that we actually
fragment the bnobt/cntbt as required.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/529 |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/tests/xfs/529 b/tests/xfs/529
index 83d24da0ac..cd176877f5 100755
--- a/tests/xfs/529
+++ b/tests/xfs/529
@@ -32,6 +32,10 @@ echo "Format and mount fs"
 _scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
 _scratch_mount -o uquota >> $seqres.full
 
+# bmap_alloc_minlen_extent only applies to the datadev space allocator, so
+# we force the filesystem not to use the realtime volume.
+_xfs_force_bdev data $SCRATCH_MNT
+
 bsize=$(_get_file_block_size $SCRATCH_MNT)
 
 echo "* Delalloc to written extent conversion"

