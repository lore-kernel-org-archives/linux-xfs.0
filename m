Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE914C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 00:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8AC061409
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 00:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234508AbhDUAXF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 20:23:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234290AbhDUAXE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Apr 2021 20:23:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67F8D6024A;
        Wed, 21 Apr 2021 00:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618964552;
        bh=KajFsytasK456heMGUSkMWpLjo2xi2tcLdic2FyZPuk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Dc/aMKY99O1Hl8mynk66mKTNidY8lQLkp/3FdTkbtyfihohDebWBqizaB8my1o20S
         HPVbMCazh58FQzmf/6hbuE6lthvCSFoPbEiVSB5CO3vXIfgt3KyylRCVntdfiUzBYp
         EEQa2KemjYsMVAdK+mxCojSc40s2MCTMirIIBK5pQdslP6lzuAt4WxbMJY04pq1Gb1
         c3YW4XwFQLzzeViY/ur1NrGYRjLfZuF/RpVWC/0J1NXQeWXJinGumUd0MzlXwKb2qS
         mXjgJ93YLex6foX6pEy9IIAHxntb/K674nUu/uX4rU3ppaEF/06Axm4Mk+zowN2KI2
         4wY3xIRInEpJw==
Subject: [PATCH 2/2] common/dmthin: make this work with external log devices
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 20 Apr 2021 17:22:31 -0700
Message-ID: <161896455168.776190.4208955976933964610.stgit@magnolia>
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

Provide a mkfs helper to format the dm thin device when external devices
are in use, and fix the dmthin mount helper to support them.  This fixes
regressions in generic/347 and generic/500 when external logs are in
use.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/dmthin     |    9 ++++++++-
 tests/generic/347 |    2 +-
 tests/generic/500 |    2 +-
 3 files changed, 10 insertions(+), 3 deletions(-)


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

