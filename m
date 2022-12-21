Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE550C3DA6E
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Dec 2022 00:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiLUAVq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Dec 2022 19:21:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLUAVq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2022 19:21:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF5C5FD8;
        Tue, 20 Dec 2022 16:21:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD494B81AD1;
        Wed, 21 Dec 2022 00:21:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76006C433EF;
        Wed, 21 Dec 2022 00:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671582102;
        bh=Ht3i0Ak9yJey4FDSRHIRkBDOcwutasr7IhhhDHAwd8Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Mo7GvVBPmJQBcL7dYg9je1z01mtpBrm/2JKnV2Urie64NKhsZ1oC1H0W84pg15Pha
         QsrBiTlajk7jyCHEaJ9azkmT1KNb5No9tEOa9S4FThmJ6EUEnRgLjY4HWqEb4HiEuL
         33qSVNNXRUv7RPo7jg8BEld4ucl5dXx9yUUV026do5nb9c/AWjoN4EGuD0rn81uUzy
         26WD/AofQp4n05pKuk8bvKnW6U/SK3zUjHS9oLV9s7+YBXTTtX80pA+Gu1okJMbjgP
         isRJK22+vesVnNGOxsqYJOn2mAuVx9Cq2WyQkq4I6ImEb1WBqA3/CZiDGPropuuAEX
         Nw7qPc08ZLMxg==
Subject: [PATCH 1/1] xfs/122: fix EFI/EFD log format structure size after flex
 array conversion
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 20 Dec 2022 16:21:42 -0800
Message-ID: <167158210207.235360.12388823078640206103.stgit@magnolia>
In-Reply-To: <167158209640.235360.13061162358544554094.stgit@magnolia>
References: <167158209640.235360.13061162358544554094.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Adjust this test since made EFI/EFD log item format structs proper flex
arrays instead of array[1].

This adjustment was made to the kernel source tree as part of a project
to make the use of flex arrays more consistent throughout the kernel.
Converting array[1] and array[0] to array[] also avoids bugs in various
compiler ports that mishandle the array size computation.  Prior to the
introduction of xfs_ondisk.h, these miscomputations resulted in kernels
that would silently write out filesystem structures that would then not
be recognized by more mainstream systems (e.g.  x86).

OFC nearly all those reports about buggy compilers are for tiny
architectures that XFS doesn't work well on anyways, so in practice it
hasn't created any user problems (AFAIK).

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc         |   15 +++++++++++++++
 tests/xfs/122     |    5 +++++
 tests/xfs/122.out |    8 ++++----
 3 files changed, 24 insertions(+), 4 deletions(-)


diff --git a/common/rc b/common/rc
index 8060c03b7d..67bd74dc89 100644
--- a/common/rc
+++ b/common/rc
@@ -1502,6 +1502,21 @@ _fixed_by_kernel_commit()
 	_fixed_by_git_commit kernel $*
 }
 
+_wants_git_commit()
+{
+	local pkg=$1
+	shift
+
+	echo "This test wants $pkg fix:" >> $seqres.hints
+	echo "      $*" >> $seqres.hints
+	echo >> $seqres.hints
+}
+
+_wants_kernel_commit()
+{
+	_wants_git_commit kernel $*
+}
+
 _check_if_dev_already_mounted()
 {
 	local dev=$1
diff --git a/tests/xfs/122 b/tests/xfs/122
index 91083d6036..e616f1987d 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -17,6 +17,11 @@ _begin_fstest other auto quick clone realtime
 _supported_fs xfs
 _require_command "$INDENT_PROG" indent
 
+# Starting in Linux 6.1, the EFI log formats were adjusted away from using
+# single-element arrays as flex arrays.
+_wants_kernel_commit 03a7485cd701 \
+	"xfs: fix memcpy fortify errors in EFI log format copying"
+
 # filter out known changes to xfs type sizes
 _type_size_filter()
 {
diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index a56cbee84f..95e53c5081 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -161,10 +161,10 @@ sizeof(xfs_disk_dquot_t) = 104
 sizeof(xfs_dq_logformat_t) = 24
 sizeof(xfs_dqblk_t) = 136
 sizeof(xfs_dsb_t) = 264
-sizeof(xfs_efd_log_format_32_t) = 28
-sizeof(xfs_efd_log_format_64_t) = 32
-sizeof(xfs_efi_log_format_32_t) = 28
-sizeof(xfs_efi_log_format_64_t) = 32
+sizeof(xfs_efd_log_format_32_t) = 16
+sizeof(xfs_efd_log_format_64_t) = 16
+sizeof(xfs_efi_log_format_32_t) = 16
+sizeof(xfs_efi_log_format_64_t) = 16
 sizeof(xfs_error_injection_t) = 8
 sizeof(xfs_exntfmt_t) = 4
 sizeof(xfs_exntst_t) = 4

