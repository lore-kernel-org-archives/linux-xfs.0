Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25ADAC433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 00:22:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E353561422
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 00:22:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234453AbhDUAXA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 20:23:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233807AbhDUAW6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Apr 2021 20:22:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A86A61409;
        Wed, 21 Apr 2021 00:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618964546;
        bh=r2JXMhLH80qAv/p2rjfAvWUg1KmO6GNEtxviSZ7yBmM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Xr6hyHFF1YEMBbR61N1oJqC4QXvxwC16OmA/0bm+t6ZE97njb0zyyST8xPRZ0qvLv
         /iZ0hg8bNv4y/GI7/gOwjQUXGwmGx8jgLv481MPDL0zdoQFf+uT3MoeFINhoNU61eW
         LrXNCaNTsEutFr8UvvIpZvnKExnG8R8oez3VF4q+SCPfq6wFXblWeyEk3i6F76G7Ul
         8U74VvE9WK/FJHKFJIJrVioMEX8BNa4HhPJut0Z8hqm6SvB/QrSA/Ao3z4d7ToMF75
         VTZWzWEohNlUcF8aOPDS/RUuaH1PDW6wTiahHvvvigbK8zwwV9HSt7hBPVZSLf2jeX
         MKCueYGtVyjMw==
Subject: [PATCH 1/2] generic/223: make sure all files get created on the data
 device
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 20 Apr 2021 17:22:25 -0700
Message-ID: <161896454559.776190.1857804198421552259.stgit@magnolia>
In-Reply-To: <161896453944.776190.2831340458112794975.stgit@magnolia>
References: <161896453944.776190.2831340458112794975.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test formats filesystems with various stripe alignments, then
checks that data file allocations are actually aligned to those stripe
geometries.  If this test is run on an XFS filesystem with a realtime
volume and RTINHERIT is set on the root dir, the test will fail because
all new files will be created as realtime files, and realtime
allocations are not subject to data device stripe alignments.  Fix this
by clearing rtinherit on the root dir.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/223 |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/tests/generic/223 b/tests/generic/223
index 1f85efe5..f6393293 100755
--- a/tests/generic/223
+++ b/tests/generic/223
@@ -43,6 +43,11 @@ for SUNIT_K in 8 16 32 64 128; do
 	_scratch_mkfs_geom $SUNIT_BYTES 4 $BLOCKSIZE >> $seqres.full 2>&1
 	_scratch_mount
 
+	# This test checks for stripe alignments of space allocations on the
+	# filesystem.  Make sure all files get created on the main device,
+	# which for XFS means no rt files.
+	test "$FSTYP" = "xfs" && $XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
+
 	for SIZE_MULT in 1 2 8 64 256; do
 		let SIZE=$SIZE_MULT*$SUNIT_BYTES
 

