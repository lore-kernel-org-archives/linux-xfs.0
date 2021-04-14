Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCEBAC433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 01:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3D2B613C0
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 01:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348960AbhDNBFX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Apr 2021 21:05:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348955AbhDNBFX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Apr 2021 21:05:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 898A8613B6;
        Wed, 14 Apr 2021 01:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618362302;
        bh=EjqsZUn2gCOcc/Jzmdc2ETY7tPX+rao/NTlixxlN6D8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ho8GL/D23D9pwqUUQxtqjjewMnU2n+3X7wmHuiLZNzRVmKm0y11E170bJ7540IsX2
         1MtNAKCaE47pHAb3ELDOuT5lzAbKGQtWlRVmIzLgXGpsnVxv9yiza8mXz6ChdApMpW
         B3QuvZ3FejOaqB21cacY0o/AElBJxNkJrQ7lfxEus9xXo2tt3C8AjMbjrN/4wWjjAK
         mqElqFbcEirlQwR6oC39IAcA8IE1iezsfd2EBPW/f3JCdXjzdoPLjKTabzjCINQpbV
         /UC2hFFe10HcO/95PEwL+Adxk1Wab2HJfNx7ywVGdJaj+Afm/leg+v+CMHKGMwI1ak
         B0bgVF9jc0PFg==
Subject: [PATCH 5/9] common/dmthin: make this work with external log devices
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 13 Apr 2021 18:05:01 -0700
Message-ID: <161836230182.2754991.16864806174255630147.stgit@magnolia>
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

Provide a mkfs helper to format the dm thin device when external devices
are in use, and fix the dmthin mount helper to support them.  This fixes
regressions in generic/347 and generic/500 when external logs are in
use.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/dmthin     |    9 ++++++++-
 tests/generic/223 |    3 +++
 tests/generic/347 |    2 +-
 tests/generic/500 |    2 +-
 4 files changed, 13 insertions(+), 3 deletions(-)


diff --git a/common/dmthin b/common/dmthin
index c58c3948..3b1c7d45 100644
--- a/common/dmthin
+++ b/common/dmthin
@@ -218,10 +218,17 @@ _dmthin_set_fail()
 
 _dmthin_mount_options()
 {
-	echo `_common_dev_mount_options $*` $DMTHIN_VOL_DEV $SCRATCH_MNT
+	_scratch_options mount
+	echo `_common_dev_mount_options $*` $SCRATCH_OPTIONS $DMTHIN_VOL_DEV $SCRATCH_MNT
 }
 
 _dmthin_mount()
 {
 	_mount -t $FSTYP `_dmthin_mount_options $*`
 }
+
+_dmthin_mkfs()
+{
+	_scratch_options mkfs
+	_mkfs_dev $SCRATCH_OPTIONS $@ $DMTHIN_VOL_DEV
+}
diff --git a/tests/generic/223 b/tests/generic/223
index 1f85efe5..a5ace82f 100755
--- a/tests/generic/223
+++ b/tests/generic/223
@@ -43,6 +43,9 @@ for SUNIT_K in 8 16 32 64 128; do
 	_scratch_mkfs_geom $SUNIT_BYTES 4 $BLOCKSIZE >> $seqres.full 2>&1
 	_scratch_mount
 
+	# Make sure everything is on the data device
+	$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
+
 	for SIZE_MULT in 1 2 8 64 256; do
 		let SIZE=$SIZE_MULT*$SUNIT_BYTES
 
diff --git a/tests/generic/347 b/tests/generic/347
index cbc5150a..e970ac10 100755
--- a/tests/generic/347
+++ b/tests/generic/347
@@ -31,7 +31,7 @@ _setup_thin()
 {
 	_dmthin_init $BACKING_SIZE $VIRTUAL_SIZE
 	_dmthin_set_queue
-	_mkfs_dev $DMTHIN_VOL_DEV
+	_dmthin_mkfs
 	_dmthin_mount
 }
 
diff --git a/tests/generic/500 b/tests/generic/500
index 085ddbf3..5ab2f78c 100755
--- a/tests/generic/500
+++ b/tests/generic/500
@@ -68,7 +68,7 @@ CLUSTER_SIZE=$((64 * 1024 / 512))		# 64K
 
 _dmthin_init $BACKING_SIZE $VIRTUAL_SIZE $CLUSTER_SIZE 0
 _dmthin_set_fail
-_mkfs_dev $DMTHIN_VOL_DEV
+_dmthin_mkfs
 _dmthin_mount
 
 # There're two bugs at here, one is dm-thin bug, the other is filesystem

